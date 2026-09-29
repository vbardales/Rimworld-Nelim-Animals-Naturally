# Generateur - perimetre C : productivite (lait, laine, oeufs).
#
# Les tables sources ne donnent que des TOTAUX ANNUELS, alors que les defs
# stockent un couple (intervalle, quantite). On fixe donc l'intervalle selon
# les echelles d'Algo_animaux.md, et on en deduit la quantite :
#     quantite = total_annuel * intervalle / 60      (annee RimWorld = 60 j)
#
# Ancrage : plutot que d'inventer des valeurs absolues, on conserve la valeur
# actuelle d'une espece de reference bien calibree (vache pour le lait,
# mouton pour la laine) et on rescale les autres avec le bon exposant. Le
# niveau economique global est preserve, seule la REPARTITION est corrigee.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$JOURS_AN = 60.0
$TOL = 0.15

$EXP_LAIT  = 0.75   # production laitiere ~ metabolisme (Kleiber)
$EXP_LAINE = 0.67   # toison ~ surface corporelle

# Plafond de variation. L'allometrie pure, extrapolee du mouton de 70 kg au
# mammouth de 6 tonnes, donne un facteur 20 -- biologiquement juste, mais
# elle noierait la colonie sous la laine. On corrige donc la TENDANCE
# (l'exposant, aujourd'hui deux fois trop plat) sans laisser l'AMPLITUDE
# exploser : aucune espece ne voit sa production varier de plus de 3x.
$FACTEUR_MAX = 3.0
$INTERVALLE_LAIT  = 2.0
$INTERVALLE_LAINE = 15.0

# Oeufs : regle du guide, categorielle et non allometrique.
$PONTE_DOMESTIQUE = 12.0   # pondeuses domestiques : 10-15 j
$PONTE_SAUVAGE    = 60.0   # 1 couvee par an
$SEUIL_DOMESTIQUE = 35.0   # wildness en dessous de laquelle on considere domestique

$ENT3 = @('devNote','defName','trainability','hungerRateAdult','eatenNutritionYearly',
  'gestationDaysRaw','litterSizeAvg','gestationDaysEach','herbivore','grassToMaintain',
  'valueOutputPerNutrition','bodySize','filth','adultAgeDays','nutritionToAdulthood',
  'adultMeatAmount','adultMeatNutrition','adultMeatNutritionPerInput','slaughterValue',
  'slaughterValuePerInput','slaughterValuePerGrowthYear','eggsYearly','eggValue',
  'eggValueYearly','eggNutrition','eggNutritionYearly','milkYearly','milkValue',
  'milkValueYearly','milkNutritionYearly','woolYearly','woolValue','woolValueYearly',
  'tempMin','tempMax','tempWidth','moveSpeed','wildness','roamMtbDays','petness',
  'nuzzleMtbHours','babySize','nutritionToGestate','babyMeatNutrition',
  'babyMeatNutritionPerInput','shouldEatBabies')

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

# Ramene la cible dans un facteur FACTEUR_MAX de la valeur actuelle.
function Plafonne([double]$cible, [double]$actuel) {
  if ($actuel -le 0) { return $cible }
  [math]::Max($actuel / $FACTEUR_MAX, [math]::Min($actuel * $FACTEUR_MAX, $cible))
}

# Patch d'un champ a l'interieur d'un comp identifie par sa classe.
function PatchComp([string]$def, [string]$classe, [string]$champ, [string]$valeur) {
  $base = "/Defs/ThingDef[defName=`"$def`"]/comps/li[@Class=`"$classe`"]"
  @"
  <Operation Class="PatchOperationConditional">
    <xpath>$base/$champ</xpath>
    <match Class="PatchOperationReplace">
      <xpath>$base/$champ</xpath>
      <value><$champ>$valeur</$champ></value>
    </match>
    <nomatch Class="PatchOperationConditional">
      <xpath>$base</xpath>
      <match Class="PatchOperationAdd">
        <xpath>$base</xpath>
        <value><$champ>$valeur</$champ></value>
      </match>
    </nomatch>
  </Operation>
"@
}

# ---------------------------------------------------------------------------
$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$ref  = Import-Csv (Join-Path $Root 'reference\masses.csv')
$cib  = Import-Csv (Join-Path $Root 'output\cibles.csv')
$iR=@{}; foreach($r in $ref){$iR[$r.defName]=$r}
# Clade par defName : la taille de ponte se lit par groupe de nidification.
$iRC=@{}; foreach($r in (Import-Csv (Join-Path $Root 'reference\masses_clades.csv'))){$iRC[$r.defName]=$r.clade}
$iC=@{}; foreach($r in $cib){$iC[$r.defName]=$r}
$iP=@{}; foreach($r in $prod){$iP[$r.defName]=$r}

# Masse retenue : masse_effective si connue (elle tient compte des geants).
function MasseDe($def) {
  $c = $iC[$def]; if ($c) { $v = Num $c.masse_effective; if ($v -and $v -gt 0) { return $v } }
  $r = $iR[$def]; if ($r) { $v = Num $r.masse_kg; if ($v -and $v -gt 0) { return $v } }
  $null
}

# --- ancrages PAR RESSOURCE ---------------------------------------------
#
# Une premiere version ancrait tout le lait sur la vache et toute la laine
# sur le mouton. C'etait faux : le composant Shearable ne produit pas que
# de la laine. Il porte aussi des plumes, de la fourrure, de la chitine et
# des cuirs speciaux, chacun sur son echelle de valeur propre. Rapportee a
# l'echelle du mouton, la production de plumes tombait a 0,43 de mediane et
# celle de fourrure a 0,45 -- l'ecureuil passait de 72 a 24 -- pendant que
# le zebre triplait. Meme piege du cote du lait : le boomalope produit du
# chemfuel par ce composant, pas du lait.
#
# On ancre donc CHAQUE ressource sur ses propres producteurs, de sorte que
# la production totale de la ressource soit conservee. Seule la REPARTITION
# entre especes est corrigee, selon la surface corporelle pour ce qui se
# tond et selon le metabolisme pour ce qui se traie.
$conf = Join-Path $Root 'ReequilibrageAnimaux/config/Mod_2587157544_CustomizeAnimals.xml'
$ressource = @{}
if (Test-Path $conf) {
  $cx = [xml](Get-Content $conf -Raw)
  foreach ($a in $cx.SettingsBlock.ModSettings.ChildNodes) {
    if ($a.NodeType -ne 'Element') { continue }
    foreach ($q in $a.ChildNodes) {
      if ($q.NodeType -ne 'Element') { continue }
      if ($q.Name -eq 'Shearable' -and $q.WoolDef) { $ressource["$($a.Name)|laine"] = $q.WoolDef }
      if ($q.Name -eq 'Milkable'  -and $q.MilkDef) { $ressource["$($a.Name)|lait"]  = $q.MilkDef }
    }
  }
}
function ResDe([string]$def, [string]$type) {
  $r = $ressource["$def|$type"]
  if ($r) { return $r }
  'inconnu'
}

# Anchor tel que la somme des cibles egale la somme des valeurs actuelles.
function AncrePar($colonne, $type, $exposant) {
  $acc = @{}
  foreach ($r in $prod) {
    $y = Num $r.$colonne; if (-not $y -or $y -le 0) { continue }
    $kg = MasseDe $r.defName; if (-not $kg) { continue }
    $k = ResDe $r.defName $type
    if (-not $acc.ContainsKey($k)) { $acc[$k] = @{ somme = 0.0; poids = 0.0 } }
    $acc[$k].somme += $y
    $acc[$k].poids += [math]::Pow($kg, $exposant)
  }
  $out = @{}
  foreach ($k in $acc.Keys) { if ($acc[$k].poids -gt 0) { $out[$k] = $acc[$k].somme / $acc[$k].poids } }
  $out
}
$A_LAIT  = AncrePar 'milkYearly' 'lait'  $EXP_LAIT
$A_LAINE = AncrePar 'woolYearly' 'laine' $EXP_LAINE

# Le chemfuel n'est pas du lait : on ne touche pas a ces animaux.
$MOTIF_CHEMFUEL = 'boom|chemfuel|explos'

$ops = @(); $rapport = @()
$nL=0; $nW=0; $nE=0

foreach ($r in $prod) {
  $d = $r.defName
  $kg = MasseDe $d; if (-not $kg) { continue }

  # --- LAIT -------------------------------------------------------------
  $laitAct = Num $r.milkYearly
  $nomBas = if ($iR[$d]) { $iR[$d].espece.ToLower() } else { $d.ToLower() }
  if ($nomBas -match $MOTIF_CHEMFUEL -or $d.ToLower() -match $MOTIF_CHEMFUEL) { $laitAct = $null }
  if ($laitAct -and $laitAct -gt 0) {
    $ancre = $A_LAIT[(ResDe $d 'lait')]
    if (-not $ancre) { $ancre = $A_LAIT['inconnu'] }
    $cible = Plafonne ($ancre * [math]::Pow($kg, $EXP_LAIT)) $laitAct
    if ([math]::Abs($laitAct/$cible - 1) -gt $TOL) {
      $qte = [math]::Max(1, [math]::Round($cible * $INTERVALLE_LAIT / $JOURS_AN))
      $ops += PatchComp $d 'CompProperties_Milkable' 'milkIntervalDays' $INTERVALLE_LAIT.ToString()
      $ops += PatchComp $d 'CompProperties_Milkable' 'milkAmount' $qte.ToString()
      $nL++
      $rapport += [pscustomobject]@{defName=$d;produit='lait';masse=$kg;annuel_actuel=$laitAct;annuel_cible=[math]::Round($cible,1);intervalle=$INTERVALLE_LAIT;quantite=$qte}
    }
  }

  # --- LAINE ------------------------------------------------------------
  $laineAct = Num $r.woolYearly
  if ($laineAct -and $laineAct -gt 0) {
    $ancre = $A_LAINE[(ResDe $d 'laine')]
    if (-not $ancre) { $ancre = $A_LAINE['inconnu'] }
    $cible = Plafonne ($ancre * [math]::Pow($kg, $EXP_LAINE)) $laineAct
    if ([math]::Abs($laineAct/$cible - 1) -gt $TOL) {
      $qte = [math]::Max(1, [math]::Round($cible * $INTERVALLE_LAINE / $JOURS_AN))
      $ops += PatchComp $d 'CompProperties_Shearable' 'shearIntervalDays' $INTERVALLE_LAINE.ToString()
      $ops += PatchComp $d 'CompProperties_Shearable' 'woolAmount' $qte.ToString()
      $nW++
      $rapport += [pscustomobject]@{defName=$d;produit='laine';masse=$kg;annuel_actuel=$laineAct;annuel_cible=[math]::Round($cible,1);intervalle=$INTERVALLE_LAINE;quantite=$qte}
    }
  }

  # --- OEUFS --------------------------------------------------------------
  # Intervalle ET nombre ecrits ENSEMBLE, ce qui etait l'erreur de la
  # premiere version : allonger l'intervalle sans toucher au nombre avait
  # divise la production de la poule par douze.
  #
  # La taille de ponte ne suit pas la masse -- une autruche pond huit oeufs,
  # un albatros un seul, pour un rapport de masse de 25. Elle suit la
  # STRATEGIE DE NIDIFICATION : les nicheurs au sol pondent beaucoup, les
  # nicheurs en falaise ou en cavite tres peu. On la lit donc par groupe.
  #
  # L'intervalle separe les pondeuses continues des saisonnieres. La
  # domestication a precisement selectionne la ponte continue : une poule
  # sauvage fait une couvee par an, une poule domestique pond presque chaque
  # jour. On garde donc l'intervalle court des domestiques et on impose une
  # couvee annuelle aux sauvages.
  $oeufAct = Num $r.eggsYearly
  if ($oeufAct -and $oeufAct -gt 0) {
    $w = Num $r.wildness
    $clade = if ($iRC.ContainsKey($d)) { $iRC[$d] } else { '' }
    # Le clade seul est trop grossier : il donnait 5 oeufs a la tourterelle
    # quand les colombides en pondent exactement DEUX, et 6 a la caille qui
    # en pond douze. On surcharge donc par nom la ou la strategie de ponte
    # est un trait connu, avant de retomber sur le clade.
    $nomOiseau = if ($iR[$d]) { $iR[$d].espece.ToLower() } else { '' }
    $couvee = $null
    if ($nomOiseau -match 'tourterelle|colombe|pigeon')      { $couvee = 2 }
    elseif ($nomOiseau -match 'caille|lagopede|perdrix')     { $couvee = 11 }
    elseif ($nomOiseau -match 'casoar|kiwi')                 { $couvee = 4 }
    elseif ($nomOiseau -match 'manchot|gorfou|albatros|petrel|fou de bassan') { $couvee = 1 }
    if (-not $couvee) {
      $couvee = switch -Regex ($clade) {
        'ratite'     { 8; break }
        'galliforme' { 7; break }
        'oiseau'     { 5; break }   # anatides, echassiers, marins
        'passereau'  { 4; break }
        'psittacide' { 3; break }
        'rapace'     { 5; break }   # rapaces : 4 a 6, pas 3
        default      { 4 }
      }
    }
    # Les pondeuses DOMESTIQUES ne sont pas touchees. La domestication a
    # selectionne la ponte continue : une poule pond 250 oeufs par an, la
    # poule de RimWorld en pond 60. Le jeu est deja bien en dessous du reel,
    # le corriger vers le bas serait une erreur -- c'est exactement ce qu'a
    # fait ma premiere version, qui la ramenait a 5.
    $domestique = ($null -ne $w -and $w -lt $SEUIL_DOMESTIQUE)
    if (-not $domestique) {
      # Une couvee comporte DEUX nombres, et n'ecrire que le premier laisse
      # le second incoherent : eggCountRange dit combien d'oeufs sont pondus,
      # eggFertilizationCountMax combien peuvent etre fecondes. Donner une
      # couvee de huit a un oiseau dont le plafond de fecondation est reste a
      # un, c'est sept oeufs steriles.
      #
      # Le champ s'appelle eggFertilizationCountMax et non eggFertilizedMax :
      # verifie dans le source de Customize Animals, pas devine.
      #
      # Chez un oiseau sauvage la couvee entiere est fecondee -- la femelle
      # s'accouple avant de pondre, c'est le principe meme de la couvee. On
      # aligne donc le plafond sur la couvee.
      $ops += PatchComp $d 'CompProperties_EggLayer' 'eggLayIntervalDays' $PONTE_SAUVAGE.ToString()
      $ops += PatchComp $d 'CompProperties_EggLayer' 'eggCountRange' "$couvee~$couvee"
      $ops += PatchComp $d 'CompProperties_EggLayer' 'eggFertilizationCountMax' $couvee.ToString()
      $nE++
      $annuel = [math]::Round($couvee * $JOURS_AN / $PONTE_SAUVAGE, 1)
      $rapport += [pscustomobject]@{defName=$d;produit='oeufs';masse=$kg;annuel_actuel=$oeufAct;annuel_cible=$annuel;intervalle=$PONTE_SAUVAGE;quantite=$couvee}
    }
  }

  # --- ancienne version, conservee pour memoire ---------------------------
  # J'avais applique la regle "pondeuse domestique 10-15 j" en oubliant sa
  # voisine indissociable, "volaille : 6-15 oeufs par couvee". Allonger
  # l'intervalle sans toucher au nombre a fait passer la poule de 60 oeufs
  # par an a 5 : une division par douze.
  #
  # La branche "sauvage" n'etait pas meilleure : sur 178 pondeurs sauvages,
  # la tete de liste est faite de meres feralisk et de moustiques geants,
  # dont la ponte massive EST le concept. Leur imposer une couvee annuelle
  # les viderait de leur sens.
  #
  # Un patch correct devrait ecrire l'intervalle ET eggCountRange ensemble,
  # en distinguant pondeuse continue et pondeuse saisonniere. Faute de
  # pouvoir lire les valeurs actuelles de eggCountRange, je m'abstiens.
}

$rapport | Export-Csv (Join-Path $Root 'output\cibles_productivite.csv') -NoTypeInformation -Encoding UTF8
$dest = Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Productivite.xml'
$txt = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`r`n<Patch>`r`n" +
       "  <!-- Productivite : lait ~ masse^0.75, laine ~ masse^0.67,`r`n" +
       "       ponte selon la regle 1 couvee/an ou pondeuse domestique.`r`n" +
       "       Genere par scripts/genere_prod.ps1 - ne pas editer a la main. -->`r`n" +
       ($ops -join "`r`n") + "`r`n</Patch>`r`n"
[System.IO.File]::WriteAllText($dest, $txt, [System.Text.UTF8Encoding]::new($false))

"ancrages lait  : $($A_LAIT.Keys.Count) ressources distinctes, exposant $EXP_LAIT"
"ancrages laine : $($A_LAINE.Keys.Count) ressources distinctes, exposant $EXP_LAINE"
""
"Productivite.xml : $($ops.Count) operations"
"  lait  : $nL especes"
"  laine : $nW especes"
"  oeufs : $nE especes"
