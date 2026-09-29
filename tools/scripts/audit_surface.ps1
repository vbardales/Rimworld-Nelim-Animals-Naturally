# Verifie que l'exposant 0.67 utilise pour ce qui se tond correspond bien a
# une vraie surface corporelle.
#
# Deux choses a etablir, et elles sont independantes :
#
#   1. COHERENCE INTERNE. La taille RimWorld est une longueur : on a etabli
#      bodySize = (masse/70)^(1/3). Une surface va donc comme le carre de
#      cette longueur, soit masse^(2/3) = masse^0.667. L'exposant 0.67 de la
#      tonte doit etre exactement celui-la, sinon les deux lois se
#      contredisent.
#
#   2. FIDELITE AU REEL. La formule de Meeh donne la surface corporelle des
#      mammiferes : S = k * M^(2/3), avec k autour de 0.1 pour des metres
#      carres et des kilogrammes. On la confronte a des surfaces mesurees.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$MEEH_K = 0.1
$EXP_SURFACE = 2.0 / 3.0

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

"=== 1. COHERENCE INTERNE ==="
"  bodySize = (masse/70)^(1/3)   -> une surface va comme bodySize^2"
"  soit masse^{0:N4}" -f (2.0/3.0)
"  exposant utilise pour la tonte : 0.67"
"  ecart : {0:N4}  -> {1}" -f ([math]::Abs(0.67 - 2.0/3.0)), $(if([math]::Abs(0.67-2.0/3.0) -lt 0.005){'les deux lois sont coherentes'}else{'DIVERGENCE'})
""

"=== 2. FIDELITE AU REEL : surfaces mesurees vs formule de Meeh ==="
# Surfaces corporelles publiees, en metres carres.
$mesures = [ordered]@{
  'Souris'          = @(0.02,   0.0045)
  'Rat'             = @(0.35,   0.032)
  'Lapin'           = @(2.0,    0.13)
  'Chat'            = @(4.5,    0.24)
  'Chien moyen'     = @(30.0,   0.96)
  'Mouton'          = @(70.0,   1.60)
  'Humain'          = @(70.0,   1.80)
  'Porc'            = @(150.0,  2.40)
  'Vache'           = @(700.0,  7.20)
  'Cheval'          = @(500.0,  5.50)
  'Elephant'        = @(4000.0, 26.0)
}
"  espece            masse     Meeh    mesure   ecart"
$ecarts = @()
foreach ($k in $mesures.Keys) {
  $m = $mesures[$k][0]; $reel = $mesures[$k][1]
  $meeh = $MEEH_K * [math]::Pow($m, $EXP_SURFACE)
  $e = ($meeh - $reel) / $reel
  $ecarts += [math]::Abs($e)
  "  {0,-16} {1,7:N2} {2,7:N3} {3,7:N3} {4,7:P0}" -f $k, $m, $meeh, $reel, $e
}
$tri = @($ecarts | Sort-Object)
"`n  ecart median : {0:P0}" -f $tri[[int]($tri.Count/2)]

"`n=== 3. CE QUE CA DONNE SUR TES ANIMAUX ==="
$ref = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$temoins = @('Mouse','Rat','ACPDomesticRabbit','Cat','Sheep','MerinoSheep','Pig','Cow','Horse','Elephant','RG_WoollyMammoth')
"  espece                  masse kg   surface m2   bodySize   bodySize^2"
foreach ($d in $temoins) {
  $r = $ref | Where-Object defName -eq $d | Select-Object -First 1
  if (-not $r) { continue }
  $kg = Num $r.masse_kg; if (-not $kg) { continue }
  $s = $MEEH_K * [math]::Pow($kg, $EXP_SURFACE)
  $bs = [math]::Pow($kg / 70.0, 1.0/3.0)
  "  {0,-22} {1,8:N2} {2,12:N3} {3,10:N3} {4,11:N3}" -f $r.espece, $kg, $s, $bs, ($bs*$bs)
}

"`n=== 4. LA LIMITE DE L'EXERCICE ==="
"  La surface est juste, mais le RENDEMENT PAR UNITE DE SURFACE ne l'est pas :"
"  un mouton donne 3,5 kg de toison par an sur 1,6 m2, une vache de meme"
"  surface ne donne rien d'exploitable. C'est un trait d'espece, pas de"
"  geometrie -- d'ou l'ancrage par ressource, qui laisse chaque famille de"
"  materiau sur sa propre echelle."
