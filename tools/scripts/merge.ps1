# Fusionne les tables sources en une table maitresse unique, clee sur defName.
#
# Sources retenues :
#   animals.csv  stats de base (dps, speed, temp, lifespan, mktval, points...)
#   trait.csv    comportement : nuzzle, enclos, accouplement, dressage, meute
#   cbt2.csv     combat detaille : dps, healthScale, armure, combatPower calcule
#   last.csv     hunger rate, poids ecosysteme
# cbt.csv est ecarte : ses colonnes sont redondantes, et il est cle sur les
# noms affiches localises, dans un ordre different des autres fichiers.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# trait.csv n'a pas de nom sur sa premiere colonne : on impose les en-tetes.
$ENTETES_TRAIT = @('defName','wildness','minHandling','trainability','FenceBlocked',
  'manhunterDmg','manhunterTame','predator','bodySize','maxPreyBodySize',
  'canBePreyOfPredator','petness','nuzzleMtbHours','packAnimal','herdAnimal',
  'wildGroupMin','wildGroupMax','canDoHerdMigration','herdMigrationAllowed','mateMtb')

function Index($rows, $key) {
  $h = @{}; foreach ($r in $rows) { $h[$r.$key] = $r }; $h
}

$animals = Import-Csv (Join-Path $Root 'animals.csv')
$trait   = Import-Csv (Join-Path $Root 'trait.csv') -Header $ENTETES_TRAIT | Select-Object -Skip 1
$cbt2    = Import-Csv (Join-Path $Root 'cbt2.csv')
$last    = Import-Csv (Join-Path $Root 'last.csv')

$iA = Index $animals 'defName'
$iT = Index $trait   'defName'
$iC = Index $cbt2    'animal'
$iL = Index $last    'defName'

# L'union des cles, pour ne perdre aucun animal present dans une seule source.
$cles = [System.Collections.Generic.HashSet[string]]::new()
foreach ($h in @($iA,$iT,$iC,$iL)) { foreach ($k in $h.Keys) { [void]$cles.Add($k) } }

$master = foreach ($k in ($cles | Sort-Object)) {
  $A=$iA[$k]; $T=$iT[$k]; $C=$iC[$k]; $L=$iL[$k]
  [pscustomobject]@{
    defName        = $k
    # --- identite / taille ---
    bodySize       = if ($A) { $A.bodySize } else { $T.bodySize }
    healthScale    = if ($A) { $A.healthScale } else { $C.baseHealthScale }
    # --- metabolisme & vie ---
    hungerRate     = if ($L) { $L.'hunger rate' } else { $A.hunger }
    lifespan       = $A.lifespan
    # --- environnement ---
    speed          = if ($A) { $A.speed } else { $C.moveSpeed }
    tempMin        = $A.tempMin
    tempMax        = $A.tempMax
    # --- combat ---
    dps            = if ($C) { $C.meleeDps } else { $A.dps }
    armor          = $C.averageArmor
    combatPower    = $C.combatPower
    combatPowerCalc= $C.combatPowerCalculated
    predator       = $T.predator
    maxPreyBodySize= $T.maxPreyBodySize
    manhunterDmg   = $T.manhunterDmg
    manhunterTame  = $T.manhunterTame
    # --- domestication & comportement ---
    wildness       = $T.wildness
    trainability   = $T.trainability
    minHandling    = $T.minHandling
    petness        = $T.petness
    nuzzleMtbHours = $T.nuzzleMtbHours
    FenceBlocked   = $T.FenceBlocked
    packAnimal     = $T.packAnimal
    herdAnimal     = $T.herdAnimal
    wildGroupMin   = $T.wildGroupMin
    wildGroupMax   = $T.wildGroupMax
    # --- reproduction ---
    mateMtb        = $T.mateMtb
    # --- economie ---
    marketValue    = $A.mktval
    points         = $A.points
    ecosystemWeight= $L.'ecosystem weight'
    # --- tracabilite des sources ---
    src            = "$(if($A){'A'})$(if($T){'T'})$(if($C){'C'})$(if($L){'L'})"
  }
}

$master | Export-Csv (Join-Path $Root 'output\master.csv') -NoTypeInformation -Encoding UTF8
"table maitresse : $($master.Count) animaux -> output\master.csv"
""
"-- completude des sources par animal --"
$master | Group-Object src | Sort-Object Count -Descending | ForEach-Object { "  {0,-6} {1,4}" -f $_.Name, $_.Count }
