# Determine qui peut se croiser avec qui, sur trois niveaux emboites.
#
# L'interfecondite n'est pas une relation plate : elle se lit a trois
# echelles, et un seul niveau de regroupement les manque toutes sauf une.
#
#   NIVEAU 1 - MEME ESPECE, plusieurs defName.
#     Deux cas indistinguables du point de vue biologique :
#       . homonymes inter-mods : ACPGiraffe et AEXP_Giraffe sont LA MEME
#         girafe, portee par deux bibliotheques differentes ;
#       . races d'une meme espece : toutes les races de chien sont
#         Canis lupus familiaris.
#     Deduction AUTOMATIQUE par egalite du nom d'espece. Aucun risque de
#     faux positif : les noms viennent de notre propre table de reference.
#
#   NIVEAU 2 - MEME GENRE, especes distinctes mais hybridation documentee.
#     Cheval x ane donne le mulet, vache x yak le dzo, lion x tigre le ligre.
#     Regles EXPLICITES, une par genre, car l'hybridation inter-especes est
#     l'exception et doit se justifier au cas par cas.
#
#   NIVEAU 3 - FAMILLES FICTIVES.
#     Les creatures inventees n'ont pas de taxonomie, mais leurs auteurs
#     construisent des familles : Muffalo et ses Mamuffalos. Table explicite,
#     tiree du guide d'Algo_animaux.md.
#
# Les trois niveaux sont ensuite FUSIONNES par composantes connexes : si un
# animal appartient a un groupe d'espece et a un groupe de genre, les deux
# groupes n'en forment plus qu'un. C'est ce qui rattache une race de vache
# dupliquee entre deux mods a l'ensemble des bovines.
#
# Un controle final refuse de produire un fichier si un groupe melange
# plusieurs clades : c'est la signature des collisions de sous-chaines dans
# les noms francais, qui ont deja fait passer un capybara pour un ara et un
# heron garde-boeufs pour un bovin.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# ---------------------------------------------------------------------------
# NIVEAU 2 : genres dont l'hybridation inter-especes est documentee.
# Ordre important, premier motif qui matche l'emporte.
# ---------------------------------------------------------------------------
$REGLES_GENRE = [ordered]@{
  # Noms trompeurs interceptes avant tout le reste. Chacun a ete trouve en
  # croisant groupes et clades, pas en relisant les motifs.
  #   chien de prairie = rongeur ; dhole = Cuon ; lycaon = Lycaon ;
  #   loup a criniere = Chrysocyon ; chien des buissons = Speothos ;
  #   renard gris = Urocyon ; capyb-ARA ; garde-BOEUFS ; F-LAMA-nt ; igu-ANE.
  'AUCUN'      = 'chien de prairie|dhole|lycaon|loup a criniere|chien des buissons|renard gris|renard des savanes|capybara|garde-boeufs|flamant|iguane'

  'nyctereutes'= 'chien viverrin|tanuki'
  # Canis : chiens, loups, coyotes, chacals, dingo. Fusionnes sur decision
  # de Virginie -- le realisme l'emporte sur le cloisonnement de DogsMate.
  # '^bobtail$' et non 'bobtail' : le mot designe un chien (le berger anglais
  # ancien) ET un chat (le bobtail japonais). Comme canis passe avant felis,
  # le chat tombait chez les chiens -- et la liste manuelle qui reliait les
  # deux a ensuite effondre les deux genres, rendant chats et chiens
  # interfeconds. C'est la collision qui a le plus couté a debusquer.
  'canis'      = 'chien|husky|retriever|berger |mastiff|saint-bernard|terre-neuve|dogue|rottweiler|barzoi|akita|malamute|ridgeback|doberman|levrier|boxer|^bobtail$|afghan|bull terrier|chow-chow|caniche|hokkaido|kishu|shikoku|kai\b|vallhund|cocker|corgi|bouledogue|beagle|shiba|teckel|welsh terrier|carlin|jack russell|dalmatien|pitbull|colley|border collie|schnauzer|bouvier|chihuahua|shih tzu|yorkshire|loup|coyote|chacal|dingo'
  'vulpes'     = 'renard|fennec'
  # felis AVANT panthera : "Chat tigre" est un chat domestique, pas un grand
  # felin, et l'ordre inverse le faisait basculer chez les pantheres. Le
  # tigre du Bengale, lui, ne matche aucun motif felis depuis que 'bengal'
  # y est ancre.
  'felis'      = 'chat |bobtail|maine coon|persan|siamois|abyssin|somali|sphynx|munchkin|^norvegien$|british shorthair|bleu russe|scottish fold|ecaille de tortue|^bengal$|chat de pallas'
  'panthera'   = 'lion|tigre|jaguar|leopard de l|panthere|once'
  'equus'      = 'cheval|poney|ane |mustang|palomino|appaloosa|akhal|arabe|connemara|fjord|frison|gypsy|irish|przewalski|^shire$|shetland|pur-sang|quarter horse|paint horse|zebre|quagga'
  'bos'        = 'vache|taureau|angus|ankole|brahmane|brava|brune des alpes|hariana|hereford|highland|holstein|jersiaise|limousine|longhorn|zebu|yak|bison|boeuf'
  'ovis'       = 'mouton|merinos|suffolk|leicester|lincoln|assaf|awassi|jacob|mouflon|argali'
  'capra'      = 'chevre|bouquetin|majorera'
  'camelide'   = 'alpaga|lama|dromadaire|chameau'
  'sus'        = 'cochon berkshire|cochon duroc|cochon domestique|gloucestershire|saddleback|sanglier|pecari'
  'ursus'      = 'ours '
  'rhino'      = 'rhinoceros'
  'elephant'   = 'elephant|mammouth|mastodonte'
  'ara'        = '\bara |ara$|ara bleu|ara rouge|ara militaire|ara catalina|ara arlequin|ara shamrock|ara hyacinthe'
  'anas'       = 'canard|colvert|cayuga|erismature|eider|garrot'
  'galliforme' = 'poule|coq bankiva|faisan|paon'
  'mus'        = 'souris'
  'rattus'     = 'rat brun|rat domestique|rat a bourse|grand rat|rat a criniere'
  'lepus'      = 'lievre'
  'lapin'      = 'lapin'
  'testudo'    = 'tortue d.hermann|tortue leopard|tortue charbonniere|tortue du desert'
}

# ---------------------------------------------------------------------------
# NIVEAU 3 : familles fictives, tirees du guide.
# ---------------------------------------------------------------------------
$FAMILLES_FICTIVES = @{
  'muffalo' = @('Muffalo','Mamuffalo','WYD_MamuffaloLost','WYD_MamuffaloSnow','WYD_MamuffaloWood')
  'thrumbo' = @('Thrumbo','AlphaThrumbo')
  'mus_fictif' = @('Mouse','TYR_Mouse','TYR_MousePoison','Woolly_Mouse','ThorntailMouse')
}

# ---------------------------------------------------------------------------
# Union-find : fusionne les niveaux en composantes connexes.
# ---------------------------------------------------------------------------
$parent = @{}
function Trouve([string]$x) {
  if (-not $parent.ContainsKey($x)) { $parent[$x] = $x; return $x }
  $r = $x
  while ($parent[$r] -ne $r) { $r = $parent[$r] }
  while ($parent[$x] -ne $r) { $suiv = $parent[$x]; $parent[$x] = $r; $x = $suiv }
  $r
}
function Unis([string]$a, [string]$b) {
  $ra = Trouve $a; $rb = Trouve $b
  if ($ra -ne $rb) { $parent[$ra] = $rb }
}

function Normalise([string]$s) {
  if (-not $s) { return '' }
  $n = $s.Normalize([System.Text.NormalizationForm]::FormD)
  $sb = [System.Text.StringBuilder]::new()
  foreach ($ch in $n.ToCharArray()) {
    if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch) -ne
        [System.Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($ch) }
  }
  ($sb.ToString().ToLower() -replace '[^a-z0-9]','')
}

# ---------------------------------------------------------------------------
$ref = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$ana = Import-Csv (Join-Path $Root 'reference\analogues_fictifs.csv')

$espece = @{}; $clade = @{}
foreach ($r in $ref) { $espece[$r.defName] = $r.espece; $clade[$r.defName] = $r.clade }
foreach ($r in $ana) { if (-not $espece.ContainsKey($r.defName)) { $espece[$r.defName] = $r.nom } }

$origine = @{}   # defName -> niveaux qui l'ont rattache

# --- NIVEAU 1 : meme espece --------------------------------------------
$parEspece = @{}
foreach ($d in $espece.Keys) {
  $k = Normalise $espece[$d]
  if (-not $k) { continue }
  if (-not $parEspece.ContainsKey($k)) { $parEspece[$k] = [System.Collections.Generic.List[string]]::new() }
  $parEspece[$k].Add($d)
}
$nEspece = 0
$refuses = @()
foreach ($k in $parEspece.Keys) {
  $membres = $parEspece[$k]
  if ($membres.Count -lt 2) { continue }
  $nEspece++
  for ($i = 1; $i -lt $membres.Count; $i++) { Unis $membres[0] $membres[$i] }
  foreach ($d in $membres) { $origine[$d] = 'espece' }
}

# --- NIVEAU 2 : meme genre ---------------------------------------------
$parGenre = @{}
foreach ($r in $ref) {
  $n = $r.espece.ToLower()
  $g = $null
  foreach ($k in $REGLES_GENRE.Keys) { if ($n -match $REGLES_GENRE[$k]) { $g = $k; break } }
  if (-not $g -or $g -eq 'AUCUN') { continue }
  if (-not $parGenre.ContainsKey($g)) { $parGenre[$g] = [System.Collections.Generic.List[string]]::new() }
  $parGenre[$g].Add($r.defName)
}
foreach ($g in $parGenre.Keys) {
  $membres = $parGenre[$g]
  if ($membres.Count -lt 2) { continue }
  for ($i = 1; $i -lt $membres.Count; $i++) { Unis $membres[0] $membres[$i] }
  foreach ($d in $membres) {
    $origine[$d] = if ($origine[$d]) { "$($origine[$d])+genre" } else { 'genre' }
  }
}

# --- NIVEAU 3 : familles fictives --------------------------------------
foreach ($f in $FAMILLES_FICTIVES.Keys) {
  $membres = @($FAMILLES_FICTIVES[$f] | Where-Object { $espece.ContainsKey($_) })
  if ($membres.Count -lt 2) { continue }
  for ($i = 1; $i -lt $membres.Count; $i++) { Unis $membres[0] $membres[$i] }
  foreach ($d in $membres) {
    $origine[$d] = if ($origine[$d]) { "$($origine[$d])+fictif" } else { 'fictif' }
  }
}

# --- NIVEAU 4 : groupements deja declares par Virginie ------------------
# Ses listes CanCrossBreedWith existantes expriment une intention que la
# taxonomie ne capte pas : un Miraffe est une girafe fictive, les hamsters
# de couleur sont une meme espece. Les ignorer laissait des listes orphelines
# et donc asymetriques -- inoperantes en vanilla. On les fusionne comme un
# niveau de plus, le controle mono-clade servant de garde-fou.
$confCustom = Join-Path $Root 'allModConfigs\AllModConfigs\Mod_2587157544_CustomizeAnimals.xml'
$nUtilisateur = 0
if (Test-Path $confCustom) {
  $cx = [xml](Get-Content $confCustom -Raw)
  foreach ($a in $cx.SettingsBlock.ModSettings.ChildNodes) {
    if ($a.NodeType -ne 'Element' -or $a.Name -eq 'Global') { continue }
    $liste = $null
    foreach ($p in $a.ChildNodes) { if ($p.NodeType -eq 'Element' -and $p.Name -eq 'CanCrossBreedWith') { $liste = $p } }
    if (-not $liste) { continue }
    $membres = @()
    foreach ($li in $liste.ChildNodes) {
      if ($li.NodeType -eq 'Element' -and $espece.ContainsKey($li.InnerText)) { $membres += $li.InnerText }
    }
    if ($espece.ContainsKey($a.Name)) { $membres += $a.Name }
    $membres = @($membres | Sort-Object -Unique)
    if ($membres.Count -lt 2) { continue }

    # GARDE-FOU. Une liste manuelle qui enjambe deux genres deja identifies
    # effondrerait les deux : c'est ainsi que le chat s'est retrouve dans le
    # groupe des canides, capable de se croiser avec les chiens. Le controle
    # mono-clade ne pouvait pas le voir, chats et chiens etant tous deux des
    # mammiferes. On refuse donc toute fusion qui melangerait des genres
    # nommes distincts, et on la signale.
    $genresVises = @{}
    foreach ($d in $membres) {
      foreach ($gk in $parGenre.Keys) { if ($parGenre[$gk] -contains $d) { $genresVises[$gk] = 1 } }
    }
    if ($genresVises.Keys.Count -gt 1) {
      $refuses += "  $($a.Name) : liste manuelle enjambant $(($genresVises.Keys | Sort-Object) -join ' et ')"
      continue
    }
    for ($i = 1; $i -lt $membres.Count; $i++) { Unis $membres[0] $membres[$i] }
    foreach ($d in $membres) {
      $origine[$d] = if ($origine[$d]) { "$($origine[$d])+manuel" } else { 'manuel' }
    }
    $nUtilisateur++
  }
}

if ($refuses.Count) {
  Write-Host "fusions manuelles refusees, elles enjambaient deux genres :" -ForegroundColor Yellow
  $refuses | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}

# --- composantes finales ------------------------------------------------
$composantes = @{}
# Snapshot des cles : Trouve fait de la compression de chemin, donc il ecrit
# dans $parent. Enumerer $parent.Keys directement leve une exception.
foreach ($d in @($parent.Keys)) {
  $r = Trouve $d
  if (-not $composantes.ContainsKey($r)) { $composantes[$r] = [System.Collections.Generic.List[string]]::new() }
  $composantes[$r].Add($d)
}

# Nomme chaque composante par son genre dominant, sinon par son espece.
$nom = @{}
foreach ($r in $composantes.Keys) {
  $membres = $composantes[$r]
  $genres = @{}
  foreach ($d in $membres) {
    foreach ($g in $parGenre.Keys) { if ($parGenre[$g] -contains $d) { $genres[$g] = 1 + $genres[$g] } }
  }
  $nom[$r] = if ($genres.Count) {
    ($genres.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
  } else {
    'esp_' + (Normalise $espece[$membres[0]])
  }
}

# --- CONTROLE : un groupe ne doit jamais melanger deux clades -----------
$erreurs = @()
foreach ($r in $composantes.Keys) {
  $membres = $composantes[$r]
  $freq = @{}
  foreach ($d in $membres) { $c = $clade[$d]; if ($c) { $freq[$c] = 1 + $freq[$c] } }
  if ($freq.Keys.Count -le 1) { continue }
  $dom = ($freq.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
  foreach ($d in $membres) {
    if ($clade[$d] -and $clade[$d] -ne $dom) {
      $erreurs += "  $($nom[$r]) : $d ($($espece[$d])) est un $($clade[$d]) parmi des $dom"
    }
  }
}
if ($erreurs.Count) {
  Write-Host "CONTAMINATION DETECTEE, aucun fichier ecrit :" -ForegroundColor Red
  $erreurs | ForEach-Object { Write-Host $_ -ForegroundColor Red }
  throw "$($erreurs.Count) animal(aux) dans un groupe d'un autre clade"
}

# --- sortie -------------------------------------------------------------
$sortie = foreach ($r in ($composantes.Keys | Sort-Object { $nom[$_] })) {
  foreach ($d in ($composantes[$r] | Sort-Object)) {
    [pscustomobject]@{
      defName = $d
      espece  = $espece[$d]
      groupe  = $nom[$r]
      origine = $(if ($origine[$d]) { $origine[$d] } else { 'genre' })
    }
  }
}
$sortie | Export-Csv (Join-Path $Root 'output\hybridation.csv') -NoTypeInformation -Encoding UTF8

"animaux de reference        : $($espece.Keys.Count)"
"rattaches a un groupe       : $($sortie.Count)"
"groupes                     : $($composantes.Keys.Count)"
"  dont fusions espece seule : $(@($composantes.Keys | Where-Object { $nom[$_] -like 'esp_*' }).Count)"
"controle mono-clade         : OK"
""
$sortie | Group-Object groupe | Sort-Object Count -Descending | ForEach-Object {
  "  {0,-22} {1,3} membres" -f $_.Name, $_.Count
}
