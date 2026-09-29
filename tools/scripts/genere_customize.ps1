# Genere le fichier de reglages Customize Animals, en FUSIONNANT avec
# l'existant.
#
# Regle, revisee : partout ou une valeur est DERIVEE, la derivation fait
# autorite et remplace l'existant. Virginie a demande une reestimation
# entierement biologique, ou son guide et ses saisies manuelles ne tranchent
# plus. Les proprietes qu'on ne sait pas deriver -- capacites speciales,
# reglages de ponte detailles, definition du materiau tondu -- sont en
# revanche conservees telles quelles : mieux vaut une valeur manuelle qu'une
# valeur inventee.
#
# Ce que Customize Animals permet et que les PatchOperation ne permettent
# pas :
#
#   LifeStageAges avec stades NOMMES. Le patch XML ne pouvait cibler que
#   li[last()], donc uniquement le stade adulte, ce qui interdisait toute
#   BAISSE de l'age adulte : elle serait passee sous le juvenile qui la
#   precede. Bug observe en jeu sur l'echenilleur. Ici on ecrit les deux
#   stades ensemble, et les 139 baisses redeviennent possibles.
#
#   CanCrossBreedWith en clair, sans dependre de l'ordre de chargement ni
#   de la resolution d'heritage des defs.
#
# Le rapport juvenile/adulte vaut 0.20 : c'est la mediane exacte des 51
# paires saisies a la main par Virginie.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$RATIO_JUVENILE = 0.20
$TOL = 0.15
$inv = [System.Globalization.CultureInfo]::InvariantCulture

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [System.Globalization.NumberStyles]::Float, $inv, [ref]$v)) { return $v }
  $null
}
function Fmt([double]$v, [int]$dec) { [math]::Round($v, $dec).ToString($inv) }

# --- on repart du fichier existant, qu'on enrichit ----------------------
$src = Join-Path $Root 'allModConfigs\AllModConfigs\Mod_2587157544_CustomizeAnimals.xml'
$doc = New-Object System.Xml.XmlDocument
$doc.PreserveWhitespace = $false
$doc.Load($src)
$racine = $doc.SelectSingleNode('/SettingsBlock/ModSettings')
if (-not $racine) { throw "structure inattendue : pas de /SettingsBlock/ModSettings" }

$existant = @{}
foreach ($n in $racine.ChildNodes) {
  if ($n.NodeType -eq 'Element' -and $n.Name -ne 'Global') { $existant[$n.Name] = $n }
}
$avant = $existant.Keys.Count

function NoeudAnimal([string]$defName) {
  if ($existant.ContainsKey($defName)) { return $existant[$defName] }
  $n = $doc.CreateElement($defName)
  [void]$racine.AppendChild($n)
  $existant[$defName] = $n
  $n
}
# Ajoute une propriete UNIQUEMENT si elle est absente.
function AjouteSiAbsent([System.Xml.XmlElement]$parent, [string]$nom) {
  foreach ($c in $parent.ChildNodes) { if ($c.NodeType -eq 'Element' -and $c.Name -eq $nom) { return $null } }
  $e = $doc.CreateElement($nom)
  [void]$parent.AppendChild($e)
  $e
}
function Elem([System.Xml.XmlElement]$parent, [string]$nom) {
  foreach ($c in $parent.ChildNodes) { if ($c.NodeType -eq 'Element' -and $c.Name -eq $nom) { return $c } }
  $null
}
function Vale([System.Xml.XmlElement]$parent, [string]$nom) {
  $e = Elem $parent $nom
  if ($e) { $e.InnerText } else { $null }
}
# Remplace une propriete, ou la cree. Reserve aux donnees entierement
# derivees, ou une valeur manuelle partielle serait pire que pas de valeur.
function Remplace([System.Xml.XmlElement]$parent, [string]$nom) {
  $vieux = Elem $parent $nom
  if ($vieux) { [void]$parent.RemoveChild($vieux) }
  $e = $doc.CreateElement($nom)
  [void]$parent.AppendChild($e)
  $e
}
$aberrants = @()

# --- 1. STADES DE VIE : les baisses que le XML ne peut pas faire --------
$cr = Import-Csv (Join-Path $Root 'output\cibles_croissance.csv')
$nStades = 0
foreach ($r in $cr) {
  $act = Num $r.maturite_actuelle_ans
  $cib = Num $r.maturite_cible_ans
  if (-not $act -or -not $cib -or $act -le 0 -or $cib -le 0) { continue }
  # Les hausses sont deja traitees par Croissance.xml, sans risque.
  # On ne prend ici QUE les baisses, impossibles en patch XML.
  if ($cib -ge $act) { continue }
  if ((1 - $cib / $act) -le $TOL) { continue }

  $n = NoeudAnimal $r.defName
  $ls = AjouteSiAbsent $n 'LifeStageAges'
  if (-not $ls) { continue }   # deja regle a la main : on respecte

  $juv = $doc.CreateElement('AnimalJuvenile')
  $mj = $doc.CreateElement('MinAge'); $mj.InnerText = Fmt ($cib * $RATIO_JUVENILE) 3
  [void]$juv.AppendChild($mj); [void]$ls.AppendChild($juv)

  $adu = $doc.CreateElement('AnimalAdult')
  $ma = $doc.CreateElement('MinAge'); $ma.InnerText = Fmt $cib 3
  [void]$adu.AppendChild($ma); [void]$ls.AppendChild($adu)
  $nStades++
}

# --- 2. HYBRIDATION -----------------------------------------------------
$hyb = Import-Csv (Join-Path $Root 'output\hybridation.csv')
$parGroupe = @{}
foreach ($h in $hyb) {
  if (-not $parGroupe.ContainsKey($h.groupe)) { $parGroupe[$h.groupe] = [System.Collections.Generic.List[string]]::new() }
  $parGroupe[$h.groupe].Add($h.defName)
}
$nHyb = 0
foreach ($h in $hyb) {
  # Le sujet est exclu de sa propre liste. Le fichier de Virginie l'incluait
  # sur une douzaine d'animaux, sans doute un artefact de l'interface du mod,
  # mais elle a confirme que c'est inutile : le champ dit avec QUI D'AUTRE
  # l'animal peut se croiser.
  $membres = @($parGroupe[$h.groupe] | Where-Object { $_ -ne $h.defName })
  if (-not $membres.Count) { continue }
  # SECONDE exception a la regle de non-ecrasement, et la derniere.
  #
  # Le croisement vanilla exige des listes SYMETRIQUES : si A liste B mais
  # que B ne liste pas A, rien ne se passe. Or respecter les listes saisies
  # a la main produisait 484 asymetries -- mes groupes generes renvoyaient
  # vers des animaux dont la liste manuelle ne renvoyait pas la reciproque.
  # Une liste asymetrique n'est pas un choix de reglage, c'est une liste
  # inoperante. On regenere donc l'ensemble, symetrique par construction.
  $n = NoeudAnimal $h.defName
  $cb = Remplace $n 'CanCrossBreedWith'
  foreach ($a in ($membres | Sort-Object)) {
    $li = $doc.CreateElement('li'); $li.InnerText = $a; [void]$cb.AppendChild($li)
  }
  $nHyb++
}

# --- 3. VITESSE ET TEMPERATURES ----------------------------------------
# La vitesse est remplacee quand elle s'ecarte de plus de 15% : le jeu la
# laisse deriver jusqu'a l'absurde (une grande aigrette a 50,5 c/s, un
# rhinoceros laineux a 34). Les temperatures ne bougent que d'un degre ou
# plus, la correction etant differentielle et volontairement modeste.
$vt = Import-Csv (Join-Path $Root 'output\cibles_vitesse_temp.csv')
$nVit = 0; $nTemp = 0
foreach ($r in $vt) {
  $n = $null

  $va = Num $r.vitesse_actuelle; $vc = Num $r.vitesse_cible
  if ($va -and $vc -and $va -gt 0 -and [math]::Abs($vc / $va - 1) -gt $TOL) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    $e = AjouteSiAbsent $n 'MoveSpeed'
    if ($e) { $e.InnerText = Fmt $vc 2; $nVit++ }
    else {
      # SEULE exception a la regle "ne jamais ecraser". L'interface de
      # Customize Animals capture la valeur courante du jeu quand on ouvre
      # la fiche d'un animal : une valeur enregistree n'est donc pas
      # forcement un choix. Au-dela de 8 c/s, elle est physiquement
      # impossible -- l'echelle du guide plafonne a 6,5 -- et ne peut pas
      # etre voulue. On corrige, et on le signale nommement.
      $ancien = Num (Vale $n 'MoveSpeed')
      if ($ancien -and $ancien -gt 8) {
        (Elem $n 'MoveSpeed').InnerText = Fmt $vc 2
        $aberrants += "  {0,-24} {1} -> {2}" -f $r.espece, $ancien, (Fmt $vc 2)
        $nVit++
      }
    }
  }

  $fa = Num $r.tempMin_actuel; $fc = Num $r.tempMin_cible
  $ca = Num $r.tempMax_actuel; $cc = Num $r.tempMax_cible
  if ($null -ne $fa -and $null -ne $fc -and [math]::Abs($fc - $fa) -ge 1) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    $e = AjouteSiAbsent $n 'MinTemperature'
    if ($e) { $e.InnerText = Fmt $fc 0; $nTemp++ }
  }
  if ($null -ne $ca -and $null -ne $cc -and [math]::Abs($cc - $ca) -ge 1) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    $e = AjouteSiAbsent $n 'MaxTemperature'
    if ($e) { $e.InnerText = Fmt $cc 0 }
  }
}

# --- 4. CONSEQUENCES DU CHANGEMENT DE TAILLE ---------------------------
# Prix, faim et robustesse derivent de la taille. Comme 337 animaux
# changent de taille, ces trois grandeurs doivent suivre, sinon un fennec
# reduit de 0,55 a 0,265 continue de valoir le prix d'un animal quatre fois
# plus gros.
#
# Propagation DIFFERENTIELLE, avec les exposants du jeu lui-meme, mesures
# sur les 830 animaux :
#     marketValue ~ bodySize^0.819   (r2 = 0.41)
#     hungerRate  ~ bodySize^0.480   (r2 = 0.25)
# On preserve ainsi la tarification relative voulue par les auteurs et on ne
# propage que l'effet de la nouvelle taille.
#
# NOTE : hungerRate^0.48 n'est PAS la loi de Kleiber, qui donnerait
# bodySize^2.25 puisque la masse varie comme le cube de la taille. Corriger
# cela multiplierait par dix la consommation des gros animaux, ce qui merite
# son propre lot et ses propres tests. On se contente ici de la coherence.
#
# MeatAmount et LeatherAmount ne sont volontairement PAS ecrits : RimWorld
# les derive automatiquement de la taille. Les figer romprait ce lien.
$EXP_PRIX = 0.819
$EXP_FAIM = 0.480
$cib = Import-Csv (Join-Path $Root 'output\cibles.csv')
$iMast = @{}; foreach ($r in (Import-Csv (Join-Path $Root 'output\master.csv'))) { $iMast[$r.defName] = $r }
$nPrix = 0; $nFaim = 0
foreach ($r in $cib) {
  $ba = Num $r.bodySize_actuel; $bc = Num $r.bodySize_cible
  if (-not $ba -or -not $bc -or $ba -le 0 -or $bc -le 0) { continue }
  if ([math]::Abs($bc / $ba - 1) -le $TOL) { continue }
  $g = $iMast[$r.defName]; if (-not $g) { continue }
  $ratio = $bc / $ba
  $n = $null

  $prixAct = Num $g.marketValue
  if ($prixAct -and $prixAct -gt 0) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    $e = AjouteSiAbsent $n 'MarketValue'
    if ($e) { $e.InnerText = Fmt ($prixAct * [math]::Pow($ratio, $EXP_PRIX)) 1; $nPrix++ }
  }
}

# --- 4bis. FAIM : propagation, puis inclinaison vers Kleiber ------------
#
# La loi de Kleiber dit que le metabolisme suit masse^0.75, soit
# bodySize^2.25 puisque la masse va comme le cube de la taille. Le jeu est a
# bodySize^0.48, c'est-a-dire masse^0.16.
#
# L'appliquer telle quelle est IMPOSSIBLE : la vache mangerait 197 fois plus
# et l'elephant 209 fois. RimWorld ne modelise pas la nutrition brute, il
# modelise une economie alimentaire volontairement comprimee -- sans quoi
# aucune megafaune ne serait nourrissable. baseHungerRate n'est donc pas un
# taux metabolique, et les confondre serait une erreur de categorie.
#
# On incline plutot la distribution sans deplacer son centre : chaque animal
# est corrige par (taille / taille mediane)^0.5, ce qui laisse l'animal
# median inchange, divise la souris par trois et double l'elephant. L'ecart
# entre les deux extremes est multiplie par huit. L'exposant effectif passe
# de masse^0.16 a masse^0.33 : toujours loin des 0.75 reels, mais jouable.
$DELTA_KLEIBER = 0.5
$tailles = @()
foreach ($r in $cib) {
  $ba = Num $r.bodySize_actuel; $bc = Num $r.bodySize_cible
  $bf = if ($bc -and $ba -and [math]::Abs($bc/$ba - 1) -gt $TOL) { $bc } else { $ba }
  if ($bf -and $bf -gt 0) { $tailles += $bf }
}
$tri = @($tailles | Sort-Object)
$tailleMediane = $tri[[int]($tri.Count / 2)]

foreach ($r in $cib) {
  $ba = Num $r.bodySize_actuel; $bc = Num $r.bodySize_cible
  if (-not $ba -or $ba -le 0) { continue }
  $g = $iMast[$r.defName]; if (-not $g) { continue }
  $faimAct = Num $g.hungerRate
  if (-not $faimAct -or $faimAct -le 0) { continue }

  $bf = if ($bc -and [math]::Abs($bc/$ba - 1) -gt $TOL) { $bc } else { $ba }
  # deux facteurs : la taille a change, et la pente se redresse
  $cible = $faimAct * [math]::Pow($bf / $ba, $EXP_FAIM) * [math]::Pow($bf / $tailleMediane, $DELTA_KLEIBER)
  if ([math]::Abs($cible / $faimAct - 1) -le $TOL) { continue }
  $n = NoeudAnimal $r.defName
  (Remplace $n 'HungerRate').InnerText = Fmt $cible 4
  $nFaim++
}

# --- 5. AGRESSIVITE DE TROUPEAU ----------------------------------------
# CrossAggroWith fait qu'un animal rejoint l'attaque de ses congeneres lors
# d'un evenement de troupeau enrage. C'est exactement la limite du groupe
# d'hybridation : les betes qui se reproduisent ensemble vivent ensemble et
# se defendent ensemble. On reutilise donc les memes composantes.
$nAggro = 0
foreach ($h in $hyb) {
  $autres = @($parGroupe[$h.groupe] | Where-Object { $_ -ne $h.defName })
  if (-not $autres.Count) { continue }
  $n = NoeudAnimal $h.defName
  $ca = Remplace $n 'CrossAggroWith'
  foreach ($a in ($autres | Sort-Object)) {
    $li = $doc.CreateElement('li'); $li.InnerText = $a; [void]$ca.AppendChild($li)
  }
  $nAggro++
}

# --- 6. PLAFOND DE VITESSE UNIVERSEL -----------------------------------
# Les passes precedentes ne couvrent que les animaux dont on connait la
# masse. Restent 29 creatures fictives entre 6,5 et 8,5 c/s, au-dessus du
# plafond de l'echelle du guide. On les ramene sans rien deriver : un
# plafond n'a pas besoin de savoir ce qu'est l'animal.
$nPlafond = 0
foreach ($g in $iMast.Values) {
  $v = Num $g.speed
  if (-not $v -or $v -le 6.5) { continue }
  $n = NoeudAnimal $g.defName
  $e = Elem $n 'MoveSpeed'
  if ($e) { if ((Num $e.InnerText) -gt 6.5) { $e.InnerText = '6.5'; $nPlafond++ } }
  else { (AjouteSiAbsent $n 'MoveSpeed').InnerText = '6.5'; $nPlafond++ }
}

# --- 7. COMPORTEMENT ----------------------------------------------------
# Dressage, enclos, fugue, cajolerie, bat et salete. Ces valeurs sont
# entierement derivees, donc elles REMPLACENT l'existant : Virginie a
# demande une reestimation biologique, ou sa saisie manuelle ne fait plus
# autorite. Seul le bat fait exception, en ajout uniquement, parce qu'un
# auteur de mod peut legitimement rendre porteuse une creature inventee.
$comp = Import-Csv (Join-Path $Root 'output\cibles_comportement.csv')
$nDress=0; $nCap=0; $nMonte=0; $nEnclos=0; $nFugue=0; $nNuzzle=0; $nBat=0; $nFilth=0
foreach ($r in $comp) {
  $n = $null

  if ($r.dressage_cible -and $r.dressage_cible -ne $r.dressage_actuel) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    (Remplace $n 'Trainability').InnerText = $r.dressage_cible; $nDress++
  }
  if ($r.enclos_cible -eq 'True') {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    (Remplace $n 'FenceBlocked').InnerText = 'True'; $nEnclos++
  }
  if ($r.fugue_cible -eq 'null') {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    $e = Remplace $n 'RoamMtbDays'; $e.SetAttribute('IsNull','True'); $nFugue++
  }
  $nz = Num $r.nuzzle_cible
  if (-not $n -and ($nz -or $r.nuzzle_cible -eq '')) { }
  if ($nz) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    (Remplace $n 'NuzzleMtbHours').InnerText = Fmt $nz 0; $nNuzzle++
  }
  if ($r.bat_cible -eq 'True') {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    $e = AjouteSiAbsent $n 'PackAnimal'
    if ($e) { $e.InnerText = 'True'; $nBat++ }
  }
  # Capacites : AjouteSiAbsent, donc rien n'est jamais ecrase. Un animal
  # qui a deja une liste garde la sienne, exotiques comprises.
  if ($r.capacites_cible) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    $st = AjouteSiAbsent $n 'SpecialTrainables'
    if ($st) {
      foreach ($cap in ($r.capacites_cible -split ' ')) {
        if (-not $cap) { continue }
        $li = $doc.CreateElement('li'); $li.InnerText = $cap; [void]$st.AppendChild($li)
      }
      $nCap++
    }
  }
  $mo = Num $r.monte_cible
  if ($mo) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    (Remplace $n 'RidingSpeed').InnerText = Fmt $mo 2; $nMonte++
  }
  $fc = Num $r.filth_cible; $fa = Num $r.filth_actuel
  if ($fc -and $fa -and $fa -gt 0 -and [math]::Abs($fc/$fa - 1) -gt $TOL) {
    if (-not $n) { $n = NoeudAnimal $r.defName }
    (Remplace $n 'FilthRate').InnerText = Fmt $fc 3; $nFilth++
  }
}

# --- ecriture -----------------------------------------------------------
$dest = Join-Path $Root 'ReequilibrageAnimaux/config/Mod_2587157544_CustomizeAnimals.xml'
$reglages = New-Object System.Xml.XmlWriterSettings
$reglages.Indent = $true
$reglages.IndentChars = "`t"
$reglages.Encoding = New-Object System.Text.UTF8Encoding($false)
$w = [System.Xml.XmlWriter]::Create($dest, $reglages)
$doc.Save($w); $w.Close()

"animaux avant           : $avant"
"animaux apres           : $($existant.Keys.Count)"
"stades de vie ajoutes   : $nStades   (les baisses, impossibles en XML)"
"hybridations ajoutees   : $nHyb"
"vitesses corrigees      : $nVit"
"temperatures corrigees  : $nTemp"
"prix propages           : $nPrix"
"faim propagee           : $nFaim"
"agressivite de troupeau : $nAggro"
"dressage                : $nDress"
"enclos forces           : $nEnclos"
"fugues supprimees       : $nFugue"
"cajoleries              : $nNuzzle"
"animaux de bat ajoutes  : $nBat"
"saletes corrigees       : $nFilth"
"vitesses de monte       : $nMonte"
"capacites ajoutees      : $nCap"
if ($aberrants.Count) {
  ""
  "VALEURS ABERRANTES CORRIGEES (seule entorse a la regle de non-ecrasement) :"
  $aberrants | ForEach-Object { $_ }
  ""
} else {
  "aucune valeur existante n'a ete modifiee"
}
"fichier -> ReequilibrageAnimaux/config/Mod_2587157544_CustomizeAnimals.xml"




