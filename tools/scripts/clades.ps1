# Classe chaque espece de reference dans un clade, a partir du nom francais.
# Le clade determine les lois d'echelle : longevite, metabolisme, thermoregulation.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$regles = [ordered]@{
  # Les primates passent EN PREMIER : "Singe-araignee" matchait 'araignee'
  # et sortait en arachnide, avec la longevite et la vitesse d'une araignee.
  'primate'  = 'gorille|chimpanze|bonobo|orang-outan|macaque|capucin|saimiri|singe|mandrill|babouin|lemur|neandertal'
  # --- ectothermes ---
  # \bver\b et non ver\b : sans la borne de gauche, "retriever" matche.
  'insecte'  = 'blatte|mante|moustique|cloporte|criquet|fourmi|scarab|papillon|guepe|bourdon|punaise|\bpou\b|acarien|larve|\bver\b|limace|escargot'
  'arachnide'= 'araignee|scorpion|megascorpion'
  # 'bernard.l.ermite' et non 'bernard' : sinon le Saint-bernard devient un
  # crustace et herite de sa loi de longevite.
  'crustace' = 'crabe|crevette|bernard.l.ermite'
  # Les reptiles se scindent : une tortue vit 4x plus qu'un lezard de meme masse.
  # L'exclusion du chat ecaille de tortue evite qu'un chat vive 80 ans.
  'tortue'   = '^(?!.*ecaille de tortue).*tortue'
  'crocodilien'='alligator|crocodile'
  'squamate' = 'serpent|cobra|python|anaconda|crotale|mocassin|vipere|couleuvre|lezard|gecko|iguane|varan|dragon de komodo|monstre de gila|diable cornu|thrinaxodon|velociraptor|stegosaure'
  'amphibien'= 'ouaouaron|crapaud|grenouille'
  # --- oiseaux : la longevite varie d'un facteur 10 entre ordres ---
  'psittacide'= 'cacatoes|calopsitte|perruche|perroquet|caique|\bara\b|conure|nestor|eclectus|megaperruche'
  # '\bcaille' et non 'caille' : sinon le chat "ecaille de tortue" devient une
  # caille. Troisieme collision de ce type -- les noms francais composes sont
  # un champ de mines pour la recherche par sous-chaine.
  'galliforme'= 'poule|coq|dindon|talegalle|\bcaille|faisan|paon|lagopede|outarde'
  'passereau' = 'corneille|corbeau|moineau|roselin|chardonneret|diamant mandarin|cardinal|geai|merlebleu|oriole|colibri|irene|echenilleur|carouge|toucan|calao'
  'rapace'    = 'vautour|faucon|effraie|grand-duc|hibou'
  'ratite'    = 'autruche|emeu|casoar|moa\b|phorusrhacide|kiwi|dodo'
  'oiseau'    = 'canard|colvert|garrot|cayuga|eider|erismature|torda|oie\b|cygne|grue|manchot|gorfou|flamant|heron|aigrette|ibis|spatule|cigogne|pelican|cormoran|goeland|pluvier|becasseau|pigeon|tourterelle|colombe|phenix'
  # --- mammiferes, sous-groupes utiles ---
  # Les primates sont declares en tete de table : ils vivent bien plus
  # longtemps que leur masse ne le laisse prevoir, et leur motif doit
  # passer avant celui des arachnides.
  'chiroptere'= 'roussette|chauve-souris'
  'marsupial'= 'kangourou|koala|diable de tasmanie|thylacine|opossum'
  'monotreme'= 'ornithorynque'
}

$m = Import-Csv (Join-Path $Root 'reference\masses.csv')
$out = foreach ($x in $m) {
  $n = $x.espece.ToLower()
  $clade = 'mammifere'
  foreach ($k in $regles.Keys) { if ($n -match $regles[$k]) { $clade = $k; break } }
  $x | Add-Member -NotePropertyName clade -NotePropertyValue $clade -Force -PassThru
}
# Sortie dans un fichier derive, jamais en place : une passe qui echoue en
# cours de route ne doit pas pouvoir detruire la table de reference.
if ($out.Count -ne $m.Count) { throw "classification incomplete : $($out.Count)/$($m.Count)" }
$out | Export-Csv (Join-Path $Root 'reference\masses_clades.csv') -NoTypeInformation -Encoding UTF8

"-- repartition par clade --"
$out | Group-Object clade | Sort-Object Count -Descending | ForEach-Object { "  {0,-10} {1,4}" -f $_.Name, $_.Count }
