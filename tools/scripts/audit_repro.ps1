# Mesure les lois actuelles de reproduction, avant de proposer les cibles.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

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

function Loi($paires, $lbl, $attendu) {
  $p = @($paires | Where-Object { $_.x -gt 0 -and $_.y -gt 0 })
  $n = $p.Count; if ($n -lt 10) { "  {0,-22} n={1} trop peu" -f $lbl,$n; return }
  $sx=0.0;$sy=0.0;$sxy=0.0;$sxx=0.0;$syy=0.0
  foreach($q in $p){ $lx=[math]::Log($q.x); $ly=[math]::Log($q.y)
    $sx+=$lx;$sy+=$ly;$sxy+=$lx*$ly;$sxx+=$lx*$lx;$syy+=$ly*$ly }
  $b=($n*$sxy-$sx*$sy)/($n*$sxx-$sx*$sx); $A=[math]::Exp(($sy-$b*$sx)/$n)
  $r2=[math]::Pow(($n*$sxy-$sx*$sy)/[math]::Sqrt(($n*$sxx-$sx*$sx)*($n*$syy-$sy*$sy)),2)
  "  {0,-22} = {1,6:N2} * masse^{2,6:N3}   r2={3:N3}  n={4,3}   [biologie : {5}]" -f $lbl,$A,$b,$r2,$n,$attendu
}

$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$quatre = Import-Csv (Join-Path $Root '4.csv') -Header @('defName','gestLitter','offspringRange','gestGroup','growth30','growth60') | Select-Object -Skip 1
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$ref  = Import-Csv (Join-Path $Root 'reference\masses.csv')

$iP=@{}; foreach($r in $prod){$iP[$r.defName]=$r}
$iQ=@{}; foreach($r in $quatre){$iQ[$r.defName]=$r}
$iM=@{}; foreach($r in $mast){$iM[$r.defName]=$r}

$g=@(); $l=@(); $m=@(); $a=@()
foreach ($r in $ref) {
  $kg=Num $r.masse_kg; if(-not $kg){continue}
  $p=$iP[$r.defName]; $q=$iQ[$r.defName]; $x=$iM[$r.defName]
  if($p){
    $v=Num $p.gestationDaysRaw; if($v -and $v -gt 0){ $g += [pscustomobject]@{x=$kg;y=$v} }
    $v=Num $p.litterSizeAvg;    if($v -and $v -gt 0){ $l += [pscustomobject]@{x=$kg;y=$v} }
    $v=Num $p.adultAgeDays;     if($v -and $v -gt 0){ $a += [pscustomobject]@{x=$kg;y=$v} }
  }
  if($x){ $v=Num $x.mateMtb; if($v -and $v -gt 0){ $m += [pscustomobject]@{x=$kg;y=$v} } }
}

"=== ce que fait le jeu aujourd'hui ==="
Loi $g 'gestation (jours)'   'exposant ~ +0.28'
Loi $l 'taille de portee'    'exposant ~ -0.16'
Loi $m 'mateMtb (heures)'    'exposant nettement positif'
Loi $a 'age adulte (jours)'  'exposant ~ +0.20'
