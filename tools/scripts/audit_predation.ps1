# Verifie que la chaine alimentaire tient debout apres rebalancement.
#
# Le controle de coherence dit deja qu'aucun predateur ne chasse plus gros
# que son mode de chasse ne l'autorise. Mais cela ne dit rien de l'ECOLOGIE :
# un predateur dont le plafond de proie descend sous la taille du plus petit
# animal disponible ne peut plus rien chasser, et une proie que plus aucun
# predateur ne peut atteindre sort de la chaine.
#
# Comme les tailles ont change pour 337 animaux, ces deux equilibres ont pu
# se rompre sans qu'aucune valeur ne soit individuellement fausse.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
$V = [char]0x2713

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $x = 0.0; if ([double]::TryParse($t, [ref]$x)) { return $x }
  $null
}

$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$cib  = Import-Csv (Join-Path $Root 'output\cibles.csv')
$ovr  = Import-Csv (Join-Path $Root 'output\overrides_fiches.csv')
$cust = [xml](Get-Content (Join-Path $Root 'ReequilibrageAnimaux/config/Mod_2587157544_CustomizeAnimals.xml') -Raw)
$regles = Get-Content (Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Regles.xml') -Raw

$iC=@{}; foreach($r in $cib){$iC[$r.defName]=$r}
$iO=@{}; foreach($r in $ovr){$iO[$r.defName]=$r}
$csTaille=@{}; $csProie=@{}
foreach ($a in $cust.SettingsBlock.ModSettings.ChildNodes) {
  if ($a.NodeType -ne 'Element') { continue }
  foreach ($p in $a.ChildNodes) {
    if ($p.NodeType -ne 'Element') { continue }
    if ($p.Name -eq 'BodySize') { $csTaille[$a.Name] = Num $p.InnerText }
    if ($p.Name -eq 'MaxPreyBodySize') { $csProie[$a.Name] = Num $p.InnerText }
  }
}
$xmlProie=@{}
foreach ($m in [regex]::Matches($regles, 'defName="([^"]+)"\]/race/maxPreyBodySize</xpath>\s*<value><maxPreyBodySize>([^<]*)<')) {
  $xmlProie[$m.Groups[1].Value] = Num $m.Groups[2].Value
}

# Taille finale : Customize, puis fiche, puis cible, puis valeur d'origine.
function TailleFinale([string]$d, $g) {
  if ($csTaille.ContainsKey($d)) { return $csTaille[$d] }
  $o = $iO[$d]; if ($o) { $x = Num $o.bodySize_fiche; if ($x) { return $x } }
  $c = $iC[$d]
  $act = Num $g.bodySize
  if ($c -and $c.geant -ne 'True') {
    $t = Num $c.bodySize_cible
    if ($t -and $t -gt 0 -and $act -and [math]::Abs($act/$t - 1) -gt 0.15) { return $t }
  }
  $act
}
function ProieFinale([string]$d, $g) {
  if ($csProie.ContainsKey($d)) { return $csProie[$d] }
  if ($xmlProie.ContainsKey($d)) { return $xmlProie[$d] }
  Num $g.maxPreyBodySize
}

$tailles=@{}; $proies=@{}; $predateurs=@()
foreach ($g in $mast) {
  $d = $g.defName
  $t = TailleFinale $d $g
  if ($t -and $t -gt 0) { $tailles[$d] = $t }
  if ($g.predator -eq $V) {
    $p = ProieFinale $d $g
    if ($p) { $proies[$d] = $p; $predateurs += $d }
  }
}

$toutesTailles = @($tailles.Values | Sort-Object)
$plusPetit = $toutesTailles[0]
"animaux avec une taille   : $($tailles.Count)"
"predateurs                : $($predateurs.Count)"
"taille du plus petit      : $plusPetit"
""

# 1. predateurs incapables de chasser quoi que ce soit
$affames = foreach ($d in $predateurs) {
  $p = $proies[$d]; if ($p -eq 99999) { continue }
  $cibles = @($tailles.Keys | Where-Object { $_ -ne $d -and $tailles[$_] -le $p }).Count
  if ($cibles -eq 0) { [pscustomobject]@{defName=$d; taille=$tailles[$d]; proieMax=$p} }
}
"-- predateurs sans aucune proie possible : $(@($affames).Count)"
if (@($affames).Count) { $affames | Format-Table -AutoSize | Out-String }

# 2. proies hors d'atteinte de tout predateur
$plusGrosseProie = ($proies.Values | Where-Object { $_ -ne 99999 } | Measure-Object -Maximum).Maximum
$sansPredateur = @($tailles.Keys | Where-Object { $tailles[$_] -gt $plusGrosseProie })
"-- plafond de proie le plus haut : $plusGrosseProie"
"-- animaux hors d'atteinte de tout predateur : $($sansPredateur.Count)"
if ($sansPredateur.Count -and $sansPredateur.Count -le 20) {
  ($sansPredateur | Sort-Object { -$tailles[$_] } | ForEach-Object { "     {0} ({1})" -f $_, $tailles[$_] })
}

# 3. combien de proies par predateur : la chaine est-elle riche ?
$stats = foreach ($d in $predateurs) {
  $p = $proies[$d]; if ($p -eq 99999) { $p = [double]::MaxValue }
  [pscustomobject]@{ defName=$d; n=@($tailles.Keys | Where-Object { $_ -ne $d -and $tailles[$_] -le $p }).Count }
}
$n = @($stats.n | Sort-Object)
"`n-- proies accessibles par predateur --"
"     mediane {0}   min {1}   max {2}" -f $n[[int]($n.Count/2)], $n[0], $n[-1]
$pauvres = @($stats | Where-Object { $_.n -lt 10 })
"     predateurs avec moins de 10 proies : $($pauvres.Count)"
if ($pauvres.Count -and $pauvres.Count -le 15) {
  $pauvres | Sort-Object n | ForEach-Object { "       {0,-26} {1,3} proies (plafond {2})" -f $_.defName, $_.n, $proies[$_.defName] }
}
