# Mesure ce que le jeu fait actuellement de la vitesse et des temperatures,
# et confronte a la biologie et aux echelles du guide.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}
function Fit($pts, $lbl, $attendu) {
  $p = @($pts | Where-Object { $_.x -gt 0 -and $_.y -gt 0 })
  $n = $p.Count; if ($n -lt 10) { "  {0,-24} n={1} trop peu" -f $lbl,$n; return }
  $sx=0.0;$sy=0.0;$sxy=0.0;$sxx=0.0;$syy=0.0
  foreach($q in $p){ $lx=[math]::Log($q.x); $ly=[math]::Log($q.y)
    $sx+=$lx;$sy+=$ly;$sxy+=$lx*$ly;$sxx+=$lx*$lx;$syy+=$ly*$ly }
  $b=($n*$sxy-$sx*$sy)/($n*$sxx-$sx*$sx); $A=[math]::Exp(($sy-$b*$sx)/$n)
  $r2=[math]::Pow(($n*$sxy-$sx*$sy)/[math]::Sqrt(($n*$sxx-$sx*$sx)*($n*$syy-$sy*$sy)),2)
  "  {0,-24} = {1,6:N2} * masse^{2,6:N3}  r2={3:N3} n={4,3}  [{5}]" -f $lbl,$A,$b,$r2,$n,$attendu
}

$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$ref  = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$iM=@{}; foreach($r in $mast){$iM[$r.defName]=$r}

$pts=@(); $tmin=@()
foreach ($r in $ref) {
  $g = $iM[$r.defName]; if (-not $g) { continue }
  $kg = Num $r.masse_kg; $sp = Num $g.speed
  if ($kg -and $sp) { $pts += [pscustomobject]@{x=$kg; y=$sp} }
}
"=== VITESSE ==="
Fit $pts 'moveSpeed' 'la masse ne devrait PAS predire : c est le mode de locomotion'
""
"  -- vitesse moyenne par clade --"
$parClade = @{}
foreach ($r in $ref) {
  $g = $iM[$r.defName]; if (-not $g) { continue }
  $sp = Num $g.speed; if (-not $sp) { continue }
  if (-not $parClade.ContainsKey($r.clade)) { $parClade[$r.clade] = [System.Collections.Generic.List[double]]::new() }
  $parClade[$r.clade].Add($sp)
}
foreach ($c in ($parClade.Keys | Sort-Object)) {
  $v = @($parClade[$c] | Sort-Object)
  "    {0,-13} n={1,3}  min {2,4:N1}  median {3,4:N1}  max {4,4:N1}" -f $c, $v.Count, $v[0], $v[[int]($v.Count/2)], $v[-1]
}

"`n=== TEMPERATURES ==="
"  -- tempMin par clade : les gros endothermes devraient mieux tenir le froid --"
$parCladeT = @{}
foreach ($r in $ref) {
  $g = $iM[$r.defName]; if (-not $g) { continue }
  $t = Num $g.tempMin; if ($null -eq $t) { continue }
  if (-not $parCladeT.ContainsKey($r.clade)) { $parCladeT[$r.clade] = [System.Collections.Generic.List[double]]::new() }
  $parCladeT[$r.clade].Add($t)
}
foreach ($c in ($parCladeT.Keys | Sort-Object)) {
  $v = @($parCladeT[$c] | Sort-Object)
  "    {0,-13} n={1,3}  min {2,6:N0}  median {3,6:N0}  max {4,6:N0}" -f $c, $v.Count, $v[0], $v[[int]($v.Count/2)], $v[-1]
}

"`n  -- correlation masse / tolerance au froid chez les mammiferes --"
$mm = @()
foreach ($r in $ref) {
  if ($r.clade -ne 'mammifere') { continue }
  $g = $iM[$r.defName]; if (-not $g) { continue }
  $kg = Num $r.masse_kg; $t = Num $g.tempMin
  if ($kg -and $null -ne $t) { $mm += [pscustomobject]@{x=$kg; y=(-$t)} }
}
Fit $mm 'froid tolere (-tempMin)' 'loi de Bergmann : exposant positif attendu'

"`n  -- largeur de plage : combien d animaux ont exactement la meme ? --"
$largeur = @{}
foreach ($r in $ref) {
  $g = $iM[$r.defName]; if (-not $g) { continue }
  $a = Num $g.tempMin; $b = Num $g.tempMax
  if ($null -ne $a -and $null -ne $b) { $k = "$a a $b"; $largeur[$k] = 1 + $largeur[$k] }
}
$largeur.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 8 | ForEach-Object {
  "    {0,-16} {1,4} animaux" -f $_.Key, $_.Value
}
