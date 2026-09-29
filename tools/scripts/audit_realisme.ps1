# Confronte au reel trois familles de valeurs que le controle de coherence
# ne verifie que STRUCTURELLEMENT : portees, pontes, ages de maturite.
#
# La coherence dit qu'une portee est >= 1 et qu'un juvenile precede un
# adulte. Elle ne dit rien de la justesse : une truie a une portee de 1
# passerait tous les controles. Ce script compare donc a des valeurs
# publiees, comme on l'a fait pour la longevite et la surface corporelle.
#
# Il verifie aussi la coherence du REGIME : un predateur herbivore, un
# herbivore qui ronge les os, un carnivore sans viande. Ces contradictions
# ne se voient pas dans une valeur isolee, seulement en croisant.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
$V = [char]0x2713

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

$ENT3 = @('devNote','defName','trainability','hungerRateAdult','eatenNutritionYearly','gestationDaysRaw','litterSizeAvg','gestationDaysEach','herbivore','grassToMaintain','valueOutputPerNutrition','bodySize','filth','adultAgeDays','nutritionToAdulthood','adultMeatAmount','adultMeatNutrition','adultMeatNutritionPerInput','slaughterValue','slaughterValuePerInput','slaughterValuePerGrowthYear','eggsYearly','eggValue','eggValueYearly','eggNutrition','eggNutritionYearly','milkYearly','milkValue','milkValueYearly','milkNutritionYearly','woolYearly','woolValue','woolValueYearly','tempMin','tempMax','tempWidth','moveSpeed','wildness','roamMtbDays','petness','nuzzleMtbHours','babySize','nutritionToGestate','babyMeatNutrition','babyMeatNutritionPerInput','shouldEatBabies')

$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$repro = Import-Csv (Join-Path $Root 'output\cibles_repro.csv')
$crois = Import-Csv (Join-Path $Root 'output\cibles_croissance.csv')
$pond  = Import-Csv (Join-Path $Root 'output\cibles_productivite.csv') | Where-Object produit -eq 'oeufs'
$alim  = Import-Csv (Join-Path $Root 'output\alimentation.csv')
$iP=@{}; foreach($r in $prod){$iP[$r.defName]=$r}
$iM=@{}; foreach($r in $mast){$iM[$r.defName]=$r}
$iR=@{}; foreach($r in $repro){$iR[$r.defName]=$r}
$iCr=@{}; foreach($r in $crois){$iCr[$r.defName]=$r}
$iPo=@{}; foreach($r in $pond){$iPo[$r.defName]=$r}
$iA=@{}; foreach($r in $alim){$iA[$r.defName]=$r}

function Ecart($cible, $reel) { if ($reel -le 0) { return $null } [math]::Abs($cible - $reel) / $reel }
function Bilan($lignes, $titre) {
  $e = @($lignes | Where-Object { $null -ne $_.ecart } | ForEach-Object { $_.ecart } | Sort-Object)
  if (-not $e.Count) { return }
  "  ecart median : {0:P0}   dans +/-30% : {1}/{2}" -f $e[[int]($e.Count/2)],
    (@($e | Where-Object { $_ -le 0.30 }).Count), $e.Count
}

# ============ 1. PORTEES ============
# Valeurs moyennes publiees.
$PORTEES = [ordered]@{
  Mouse=6; Rat=8; ACPDomesticRabbit=6; Cat=4; LabradorRetriever=5; Pig=10
  Sheep=1.5; Goat=2; Cow=1; Horse=1; Elephant=1; Bear_Grizzly=2; Wolf_Timber=5
  Fox_Red=5; ACPLion=3; Tiger=3; Deer=1; Hare=3; Squirrel=3; ACPFerret=8
}
"=========== 1. TAILLE DE PORTEE ==========="
"espece                    cible   reel   ecart"
$l1 = foreach ($k in $PORTEES.Keys) {
  $r = $iR[$k]; if (-not $r) { continue }
  $c = Num $r.portee_cible; $reel = [double]$PORTEES[$k]
  if (-not $c) { continue }
  $e = Ecart $c $reel
  "{0,-24} {1,6:N1} {2,6} {3,7:P0}" -f $r.espece, $c, $reel, $e
  [pscustomobject]@{ecart=$e}
}
$l1 | Where-Object { $_ -is [string] } | ForEach-Object { $_ }
Bilan $l1 'portees'

# ============ 2. PONTES ============
$PONTES = [ordered]@{
  Ostrich=8; Emu=8; Cassowary=4; Quail=12; Goose=5; Peacock=5
  TYR_GreatEgret=4; Macaw=3; BB_BarnOwl=5; BB_Kestrel=5; Sparrow=4; TurtleDove=2
}
"`n=========== 2. TAILLE DE COUVEE ==========="
"espece                    cible   reel   ecart"
$l2 = foreach ($k in $PONTES.Keys) {
  $p = $iPo[$k]; if (-not $p) { continue }
  $c = Num $p.quantite; $reel = [double]$PONTES[$k]
  if (-not $c) { continue }
  $e = Ecart $c $reel
  "{0,-24} {1,6:N0} {2,6} {3,7:P0}" -f $k, $c, $reel, $e
  [pscustomobject]@{ecart=$e}
}
$l2 | Where-Object { $_ -is [string] } | ForEach-Object { $_ }
Bilan $l2 'pontes'

# ============ 3. AGES DE MATURITE ============
$AGES = [ordered]@{
  Mouse=0.1; Rat=0.2; ACPDomesticRabbit=0.5; Cat=1; LabradorRetriever=1
  Pig=0.7; Sheep=1; Goat=1; Cow=2; Horse=3; Elephant=12; Bear_Grizzly=4
  Wolf_Timber=2; Fox_Red=1; ACPLion=3; Deer=1.5; Chicken=0.5
}
"`n=========== 3. AGE DE MATURITE (annees) ==========="
"espece                    cible   reel   ecart"
$l3 = foreach ($k in $AGES.Keys) {
  $c0 = $iCr[$k]; if (-not $c0) { continue }
  $c = Num $c0.maturite_cible_ans; $reel = [double]$AGES[$k]
  if (-not $c) { continue }
  $e = Ecart $c $reel
  "{0,-24} {1,6:N2} {2,6} {3,7:P0}" -f $c0.espece, $c, $reel, $e
  [pscustomobject]@{ecart=$e}
}
$l3 | Where-Object { $_ -is [string] } | ForEach-Object { $_ }
Bilan $l3 'ages'

# ============ 4. REGIME ALIMENTAIRE ============
"`n=========== 4. COHERENCE DU REGIME ==========="
$contradictions = @()
foreach ($m in $mast) {
  $d = $m.defName
  $p = $iP[$d]; if (-not $p) { continue }
  $a = $iA[$d]
  $herb = ("$($p.herbivore)".Trim() -ne '')
  $pred = ($m.predator -eq $V)
  $os   = ($a -and $a.os -eq 'True')
  $rot  = ($a -and $a.rotten -eq 'True')
  $viande = Num $p.adultMeatAmount

  # un predateur qui ne peut manger que des plantes
  if ($pred -and $herb -and -not $os) {
    $contradictions += [pscustomobject]@{defName=$d; probleme='predateur sans acces a la viande'}
  }
  # un herbivore strict qui ronge les os
  if ($os -and $herb -and -not $pred -and -not $rot) {
    $contradictions += [pscustomobject]@{defName=$d; probleme='herbivore rongeant les os'}
  }
  # un animal sans viande exploitable mais donne comme proie
  if ($viande -ne $null -and $viande -le 0 -and $pred) {
    $contradictions += [pscustomobject]@{defName=$d; probleme='predateur sans viande'}
  }
}
"  animaux examines : $($mast.Count)"
"  contradictions   : $($contradictions.Count)"
if ($contradictions.Count) {
  $contradictions | Group-Object probleme | Sort-Object Count -Descending | ForEach-Object {
    "    {0,-40} {1,4}" -f $_.Name, $_.Count
    ($_.Group | Select-Object -First 5).defName | ForEach-Object { "        $_" }
  }
}

# repartition generale
"`n  -- repartition des regimes --"
$h=0;$c=0;$o=0
foreach ($m in $mast) {
  $p = $iP[$m.defName]; if (-not $p) { continue }
  $herb = ("$($p.herbivore)".Trim() -ne ''); $pred = ($m.predator -eq $V)
  if ($herb -and -not $pred) { $h++ } elseif ($pred -and -not $herb) { $c++ } else { $o++ }
}
"    herbivores stricts : $h"
"    carnivores stricts : $c"
"    omnivores ou autre : $o"
