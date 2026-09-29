# Applique les regles strictes d'Algo_animaux.md aux 835 animaux.
#
#   R1  Harm >= Tame fail                    (toujours)
#   R2  Dressage inter/av -> Roaming = 0     (toujours)
#   R4  Max proie <= 1.0 x taille predateur  (toujours)
#
# R3 (nuzzle actif -> reconfort oui) n'est pas verifiable : la colonne
# nuzzle des tables sources est un calcul (12 + 0.6*wildness), pas une donnee.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
$V = [char]0x2713

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

# Le fichier reste en ASCII pur : PowerShell 5.1 lit les .ps1 en ANSI faute
# de BOM, et tout caractere non-ASCII (%, euro, guillemets typographiques)
# casse l'analyse syntaxique. On retire donc tout sauf chiffres, point, signe.
function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -eq '' -or $t -eq '-' -or $t -eq '.') { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$iP = @{}; foreach ($r in $prod) { $iP[$r.defName] = $r }

$viol = foreach ($m in $mast) {
  $p = $iP[$m.defName]
  $harm = Num $m.manhunterDmg; $tame = Num $m.manhunterTame
  $bs   = Num $m.bodySize;     $prey = Num $m.maxPreyBodySize
  $roam = if ($p) { Num $p.roamMtbDays } else { $null }
  $tr   = $m.trainability

  if ($null -ne $harm -and $null -ne $tame -and $harm -lt $tame) {
    [pscustomobject]@{regle='R1 Harm >= TameFail'; defName=$m.defName; detail="harm=$harm% < tame=$tame%"}
  }
  if ($tr -in @('Intermediate','Advanced') -and $null -ne $roam -and $roam -gt 0) {
    [pscustomobject]@{regle='R2 inter/av -> roam 0'; defName=$m.defName; detail="$tr mais roam=$roam j"}
  }
  if ($m.predator -eq $V -and $null -ne $bs -and $null -ne $prey -and $prey -gt $bs) {
    [pscustomobject]@{regle='R4 proie <= taille'; defName=$m.defName; detail="proie=$prey > taille=$bs"}
  }
}

$viol | Export-Csv (Join-Path $Root 'output\violations_regles.csv') -NoTypeInformation -Encoding UTF8
"animaux examines : $($mast.Count)"
"violations totales : $($viol.Count)"
""
$viol | Group-Object regle | Sort-Object Count -Descending | ForEach-Object {
  "  {0,-24} {1,4}" -f $_.Name, $_.Count
}
