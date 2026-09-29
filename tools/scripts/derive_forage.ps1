# Derive quels animaux fourragent, et quoi.
#
# Animals Forage (Simmin, repris par Mlie) pose deux comps de Vanilla Expanded
# Framework sur un ThingDef d'animal :
#   VEF.AnimalBehaviours.CompProperties_DigWhenHungry    -> champs SCALAIRES
#   VEF.AnimalBehaviours.CompProperties_DigPeriodically  -> champs en LISTE <li>
# Meme noms de champs, arite differente. Se tromper fait echouer la def entiere.
#
# Un seul comp de chaque type par animal : il faut choisir UNE nourriture.
#
# Quantites : le mod d'origine utilise une valeur fixe par ressource, pas une
# valeur proportionnelle a la taille. On garde son echelle pour rester
# coherent avec les 123 animaux qu'il couvre deja.
#
# Les 123 deja couverts sont lus depuis reference/forage_existant.csv et
# JAMAIS repatches : deux comps DigWhenHungry sur le meme animal, c'est le
# second qui est ignore, mais l'intention devient illisible.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

function SansAccent([string]$s) {
  if (-not $s) { return '' }
  $n = $s.Normalize([Text.NormalizationForm]::FormD)
  $sb = [Text.StringBuilder]::new()
  foreach ($c in $n.ToCharArray()) {
    if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne 'NonSpacingMark') { [void]$sb.Append($c) }
  }
  return $sb.ToString().ToLower()
}

# Ordre = priorite. Le plus specifique d'abord : 'panda' avant 'ours',
# sinon le panda geant part en baies. Meme piege que bobtail/canis.
$REGLES = @(
  @{ res='Bamboo';          qte=10; comp='faim';        motif='panda' }
  @{ res='RawFungus';       qte=10; comp='periodique'; sauf='cochon d.inde|porc.epic'; motif='cochon|\bporc\b|sanglier|phacochere|pecari|babiroussa|\btruie\b' }
  @{ res='AEXP_RawFish';    qte=3;  comp='faim';       motif='loutre|phoque|otarie|morse|manchot|pingouin|macareux|cormoran|heron|aigrette|martin.pecheur|balbuzard|pygargue|crocodile|alligator|caiman|gavial|anaconda|vison|pelican|sterne|albatros|\bpecheur' }
  # 'caille' DOIT etre ancre. Sans le \b il attrape "chat ecaille de tortue" et
  # range un chat parmi les insectivores : exactement la collision que
  # clades.ps1 avait deja payee sur le motif de la tortue.
  @{ res='Meat_Megaspider'; qte=10; comp='faim';       sauf='rat.taupe'; motif='herisson|tamanoir|fourmilier|pangolin|tatou|blaireau|\btaupe\b|musaraigne|chauve.souris|ornithorynque|echidne|orycterope|numbat|tamandua|\bpoule\b|\bcoq\b|dindon|\bdinde\b|faisan|\bcaille|pintade|suricate' }
  @{ res='BoneItem';        qte=5;  comp='faim';       motif='vautour|condor|hyene|chacal|corbeau|corneille|\bpie\b|warg|glouton|carcajou|diable de tasmanie|marabout|urubu' }
  @{ res='RawBerries';      qte=10; comp='faim';        motif='\bours\b|ourson|grizzli|kodiak|raton laveur|opossum|\bsinge|macaque|lemurien|chimpanze|gorille|orang.outan|babouin|coati|kinkajou|sapajou|ouistiti|capucin' }
  @{ res='Meat_Rat';        qte=5;  comp='faim';       motif='serpent|cobra|vipere|crotale|python|couleuvre|\bboa\b|belette|hermine|fouine|martre|furet|putois|serval|caracal|lynx|renard|fennec|chouette|hibou|\bbuse\b|faucon|epervier|milan|genette|civette|mangouste' }
)

$master = Import-Csv (Join-Path $Root 'output\master.csv')
$t3     = Import-Csv (Join-Path $Root '3.csv') -WarningAction SilentlyContinue
$clades = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$deja   = Import-Csv (Join-Path $Root 'reference\forage_existant.csv')

$V = [char]0x2713
$idxT3 = @{}; foreach ($r in $t3) { if ($r.H1) { $idxT3[$r.H1] = $r } }
$idxCl = @{}; foreach ($r in $clades) { $idxCl[$r.defName] = $r }
$couvert = @{}; foreach ($r in $deja) { $couvert[$r.defName] = $r.ressource }

$out = New-Object System.Collections.Generic.List[object]
$statSaut = @{ deja=0; sansMotif=0; exclus=0 }

foreach ($m in $master) {
  $d = $m.defName
  if ($couvert.ContainsKey($d)) { $statSaut.deja++; continue }

  $cl  = $idxCl[$d]
  $nom = if ($cl -and $cl.espece) { $cl.espece } else { $d }
  $n   = SansAccent $nom

  $choix = $null
  foreach ($r in $REGLES) {
    if ($n -notmatch $r.motif) { continue }
    if ($r.sauf -and $n -match $r.sauf) { $statSaut.exclus++; continue }
    $choix = $r; break
  }
  if (-not $choix) { $statSaut.sansMotif++; continue }

  # PAS de garde sur le regime alimentaire. Une premiere version rejetait les
  # combinaisons "carne sur herbivore" et "vegetal sur carnivore" en croisant
  # la colonne herbivore de 3.csv avec le drapeau predator de master.csv. Elle
  # ecartait 24 animaux, tous a tort : herisson, blaireau, pangolin, suricate,
  # loutre, heron, cormoran, ours, gorille, opossum. Le drapeau "He" signifie
  # "peut manger des plantes", pas "ne mange que ca" ; et predator ne marque
  # que ceux qui CHASSENT. Le mod d'origine patche lui-meme les herissons et
  # les blaireaux vers les insectes, et les ours vers les baies. Le motif
  # d'espece porte une connaissance plus fine que ces deux booleens : c'est
  # lui qui decide, seul.

  $out.Add([pscustomobject]@{
    defName   = $d
    espece    = $nom
    comp      = $choix.comp
    ressource = $choix.res
    quantite  = $choix.qte
    clade     = if ($cl) { $cl.clade } else { '' }
  })
}

$dest = Join-Path $Root 'output\cibles_forage.csv'
$out | Export-Csv -NoTypeInformation -Encoding UTF8 $dest

"animaux examines        : $($master.Count)"
"deja couverts par le mod: $($statSaut.deja)"
"aucun motif ecologique  : $($statSaut.sansMotif)"
"exclus (collision nom)   : $($statSaut.exclus)"
"RETENUS                 : $($out.Count)   -> output\cibles_forage.csv"
""
"-- par ressource --"
$out | Group-Object ressource | Sort-Object Count -Descending | ForEach-Object {
  "  {0,-18} {1,4}" -f $_.Name, $_.Count
}
