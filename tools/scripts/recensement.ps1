# Recense combien d'animaux demandent au moins une edition, et combien de
# champs au total. C'est ce chiffre qui decide entre mod genere et edition
# manuelle.
#
# On applique la logique de corridor : une valeur n'est corrigee que si elle
# sort d'une bande de tolerance autour de la cible. Le vanilla bien regle
# n'est pas touche.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
$V = [char]0x2713
$TOLERANCE = 0.15   # +/- 15% : en deca, on laisse la valeur d'auteur

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
  if ($t -eq '' -or $t -eq '-' -or $t -eq '.') { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$cib  = Import-Csv (Join-Path $Root 'output\cibles.csv')
$iP = @{}; foreach ($r in $prod) { $iP[$r.defName] = $r }
$iC = @{}; foreach ($r in $cib)  { $iC[$r.defName] = $r }

$fiches = @{}   # animaux deja traites a la main : hors perimetre automatique
$edits = foreach ($m in $mast) {
  $d = $m.defName; $p = $iP[$d]; $c = $iC[$d]
  $champs = [System.Collections.Generic.List[string]]::new()

  # --- taille : seulement pour les animaux dont on connait la masse reelle
  if ($c -and $c.geant -ne 'True') {
    $act = Num $c.bodySize_actuel; $cib2 = Num $c.bodySize_cible
    if ($act -and $cib2 -and [math]::Abs($act/$cib2 - 1) -gt $TOLERANCE) { $champs.Add('bodySize') }
  }
  # --- longevite
  if ($c) {
    $act = Num $c.lifespan_actuel; $cib2 = Num $c.lifespan_cible
    if ($act -and $cib2 -and [math]::Abs($act/$cib2 - 1) -gt $TOLERANCE) { $champs.Add('lifespan') }
  }
  # --- R1 : harm >= tame fail
  $h = Num $m.manhunterDmg; $t = Num $m.manhunterTame
  if ($null -ne $h -and $null -ne $t -and $h -lt $t) { $champs.Add('manhunterOnDamage') }
  # --- R2 : dressable -> roaming 0
  $roam = if ($p) { Num $p.roamMtbDays } else { $null }
  if ($m.trainability -in @('Intermediate','Advanced') -and $roam -and $roam -gt 0) { $champs.Add('roamMtbDays') }
  # --- R4 : proie, hors sentinelle 99999
  $bs = Num $m.bodySize; $pr = Num $m.maxPreyBodySize
  if ($m.predator -eq $V -and $bs -and $pr -and $pr -ne 99999 -and $pr -gt $bs) { $champs.Add('maxPreyBodySize') }
  # --- reproduction : mateMtb est plat a 12 pour 83% des animaux
  $mt = Num $m.mateMtb
  if ($null -ne $mt -and $bs -and $mt -eq 12) { $champs.Add('mateMtb') }

  if ($champs.Count -gt 0) {
    [pscustomobject]@{ defName=$d; nb_champs=$champs.Count; champs=($champs -join ' ') }
  }
}

$edits | Export-Csv (Join-Path $Root 'output\recensement.csv') -NoTypeInformation -Encoding UTF8
$total = ($edits | Measure-Object nb_champs -Sum).Sum
"animaux au catalogue          : $($mast.Count)"
"animaux a editer              : $($edits.Count)"
"editions de champs au total   : $total"
""
"-- repartition par nombre de champs a changer --"
$edits | Group-Object nb_champs | Sort-Object {[int]$_.Name} | ForEach-Object {
  "  {0} champ(s) : {1,4} animaux" -f $_.Name, $_.Count
}
""
"-- champs les plus souvent touches --"
$cnt = @{}
foreach ($e in $edits) { foreach ($f in ($e.champs -split ' ')) { $cnt[$f] = 1 + $cnt[$f] } }
$cnt.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object { "  {0,-20} {1,4}" -f $_.Key, $_.Value }
