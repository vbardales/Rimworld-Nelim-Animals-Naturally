# Detecte les colonnes qui ne sont pas des donnees mais des calculs.
#
# Motivation : nuzzleMtbHours s'est revele valoir exactement 12 + 0.6*wildness
# (r2 = 1.000). Une colonne parfaitement predite par une autre ne contient
# aucune information propre, et la prendre pour une valeur de def conduirait
# a rebalancer du vide. On teste chaque colonne numerique contre toutes les
# autres, en lineaire et en log-log.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

function ToNum($s) {
  if ($null -eq $s -or $s -eq '') { return $null }
  $s = "$s".Trim()
  if ($s -match '^(-?[\d.]+)%$') { return [double]$matches[1] }
  $v = 0.0
  if ([double]::TryParse($s, [ref]$v)) { return $v }
  $null
}

function R2($pts) {
  $n = $pts.Count; if ($n -lt 20) { return $null }
  $sx=0.0;$sy=0.0;$sxy=0.0;$sxx=0.0;$syy=0.0
  foreach ($p in $pts) { $sx+=$p.x; $sy+=$p.y; $sxy+=$p.x*$p.y; $sxx+=$p.x*$p.x; $syy+=$p.y*$p.y }
  $den = ($n*$sxx-$sx*$sx)*($n*$syy-$sy*$sy)
  if ($den -le 0) { return $null }
  [math]::Pow(($n*$sxy-$sx*$sy)/[math]::Sqrt($den), 2)
}

$m = Import-Csv (Join-Path $Root 'output\master.csv')
$cols = $m[0].PSObject.Properties.Name | Where-Object { $_ -notin @('defName','src') }

# Ne garder que les colonnes majoritairement numeriques.
$num = @{}
foreach ($c in $cols) {
  $vals = foreach ($r in $m) { ToNum $r.$c }
  $vals = @($vals | Where-Object { $null -ne $_ })
  if ($vals.Count -gt ($m.Count * 0.5)) { $num[$c] = $true }
}

"colonnes numeriques testees : $($num.Keys.Count)"
""
"-- paires suspectes (r2 >= 0.98 : la colonne B est calculee depuis A) --"
$vus = @{}
foreach ($a in $num.Keys) {
  foreach ($b in $num.Keys) {
    if ($a -eq $b) { continue }
    $cle = (@($a,$b) | Sort-Object) -join '|'
    if ($vus[$cle]) { continue }
    $lin = [System.Collections.Generic.List[object]]::new()
    $log = [System.Collections.Generic.List[object]]::new()
    foreach ($r in $m) {
      $x = ToNum $r.$a; $y = ToNum $r.$b
      if ($null -eq $x -or $null -eq $y) { continue }
      $lin.Add([pscustomobject]@{x=$x;y=$y})
      if ($x -gt 0 -and $y -gt 0) { $log.Add([pscustomobject]@{x=[math]::Log($x);y=[math]::Log($y)}) }
    }
    $rl = R2 $lin; $rg = R2 $log
    $best = $rl; $forme = 'lineaire'
    if ($null -ne $rg -and ($null -eq $rl -or $rg -gt $rl)) { $best = $rg; $forme = 'puissance' }
    if ($null -ne $best -and $best -ge 0.98) {
      $vus[$cle] = $true
      "  {0,-16} <-> {1,-16} r2={2:N4}  ({3}, n={4})" -f $a, $b, $best, $forme, $lin.Count
    }
  }
}
