# Moteur de derivation : masse reelle -> stats RimWorld coherentes.
#
# Principe : une seule ancre physique (la masse en kg), et toutes les stats
# en decoulent par des lois d'echelle propres au clade. Cela garantit la
# coherence *entre* animaux, ce qu'un reglage manuel ne peut pas atteindre.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# Plancher abaisse de 0.10 a 0.04 : les fiches manuelles descendent elles-memes
# a 0.04 (echenilleur) et 0.05 (roselin). Le plancher vanilla du rat etait une
# borne theorique, la pratique etablie est plus basse.
$PLANCHER_BODYSIZE = 0.04
$RATIO_GEANT       = 3.0    # au-dela, on suspecte un gigantisme voulu par l'auteur

# Mods dont le gigantisme EST le concept : tous leurs membres sont proteges,
# quelle que soit leur taille. Sans cette liste, le seuil sur bodySize laissait
# passer les petits membres -- le moustique Nem a 0.23 se faisait ramener a
# 0.04, alors que la mante du meme mod a 3.25 etait protegee. Deux creatures
# du meme mod traitees a l'opposé.
$MODS_GEANTS = @('Nem_')

# Longevite : L = A * masse^b, en annees, directement en esperance de vie
# typique (ce que RimWorld encode dans lifeExpectancy), pas en longevite
# maximale. Chaque loi est calibree sur deux especes reelles connues du
# clade, pas plaquee depuis une formule generique : un perroquet et une
# poule ne suivent pas la meme courbe.
$LOIS_LONGEVITE = @{
  'mammifere'  = @{A= 8.26; b=0.20 }  # ours 300kg -> 26 ans ; elephant -> 43
  'primate'    = @{A=17.50; b=0.157}  # macaque 25 ans -> gorille 40
  'marsupial'  = @{A= 6.30; b=0.20 }
  'chiroptere' = @{A=21.00; b=0.20 }  # exceptionnellement longues pour leur masse
  'monotreme'  = @{A=14.00; b=0.20 }
  'psittacide' = @{A=55.00; b=0.51 }  # perruche 10 ans -> ara 55 ans
  'galliforme' = @{A= 6.00; b=0.20 }  # poule -> 7 ans ; dindon -> 9
  'passereau'  = @{A=22.30; b=0.57 }  # chardonneret 2 ans -> corneille 15
  'rapace'     = @{A=17.90; b=0.248}  # crecerelle 12 ans -> vautour 30
  'ratite'     = @{A= 3.00; b=0.58 }  # emeu 25 ans -> autruche 45
  'oiseau'     = @{A= 7.90; b=0.367}  # anatides, echassiers, marins, colombides
  'tortue'     = @{A=37.90; b=0.249}  # Hermann 80 ans -> Galapagos 150
  'crocodilien'= @{A=25.00; b=0.20 }
  'squamate'   = @{A=18.00; b=0.15 }  # gecko 12 ans -> komodo 35
  'amphibien'  = @{A=10.50; b=0.20 }
  'crustace'   = @{A=10.00; b=0.15 }
  'insecte'    = @{A= 1.00; b=0.00 }  # une saison, quelle que soit la taille
  'arachnide'  = @{A= 2.00; b=0.00 }
}

# Metabolisme : loi de Kleiber, besoin energetique ~ masse^0.75.
# On l'exprime en relatif par rapport a un animal de reference bien calibre,
# ce qui evite de dependre des unites internes de RimWorld.
$KLEIBER = 0.75
$ECTOTHERMES = @('tortue','squamate','crocodilien','amphibien','insecte','arachnide','crustace')
$FACTEUR_ECTOTHERME = 0.10   # un ectotherme mange ~10x moins qu'un endotherme

function Get-BodySizeCible([double]$kg) {
  [math]::Max($PLANCHER_BODYSIZE, [math]::Pow($kg / 70.0, 1.0/3.0))
}

function Get-LongeviteCible([double]$kg, [string]$clade) {
  $loi = $LOIS_LONGEVITE[$clade]
  if (-not $loi) { $loi = $LOIS_LONGEVITE['mammifere'] }
  $loi.A * [math]::Pow($kg, $loi.b)
}

function Get-HungerCible([double]$kg, [string]$clade, [double]$ancreKg, [double]$ancreHunger) {
  $h = $ancreHunger * [math]::Pow($kg / $ancreKg, $KLEIBER)
  if ($ECTOTHERMES -contains $clade) { $h *= $FACTEUR_ECTOTHERME }
  $h
}

# ---------------------------------------------------------------------------
$jeu = Import-Csv (Join-Path $Root 'animals.csv')
$ref = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$idx = @{}; foreach ($x in $jeu) { $idx[$x.defName] = $x }

# Ancre metabolique : le mouton vanilla, 70 kg, bodySize 1.0 exactement juste.
$ancre = $idx['Sheep']
$ancreKg = 70.0
$ancreHunger = [double]$ancre.hunger

$res = foreach ($r in $ref) {
  $g = $idx[$r.defName]; if (-not $g) { continue }
  $bsAct = [double]$g.bodySize; if ($bsAct -le 0) { continue }
  $kg = [double]$r.masse_kg
  $bsCible = Get-BodySizeCible $kg
  $modGeant = $false
  foreach ($pfx in $MODS_GEANTS) { if ($r.defName.StartsWith($pfx)) { $modGeant = $true; break } }
  $geant = $modGeant -or (($bsAct / $bsCible -gt $RATIO_GEANT) -and ($bsAct -ge 0.5))

  # Un geant volontaire garde la taille voulue par l'auteur, mais sa masse
  # effective est recalculee depuis cette taille : il paiera le prix
  # metabolique et vital de son gigantisme.
  $bsRetenu = if ($geant) { $bsAct } else { $bsCible }
  $kgEffectif = if ($geant) { 70.0 * [math]::Pow($bsAct, 3) } else { $kg }

  [pscustomobject]@{
    defName        = $r.defName
    espece         = $r.espece
    clade          = $r.clade
    geant          = $geant
    masse_kg       = $kg
    masse_effective= [math]::Round($kgEffectif, 2)
    bodySize_actuel= $bsAct
    bodySize_cible = [math]::Round($bsRetenu, 3)
    lifespan_actuel= [double]$g.lifespan
    lifespan_cible = [math]::Round((Get-LongeviteCible $kgEffectif $r.clade), 1)
    hunger_actuel  = [double]$g.hunger
    hunger_cible   = [math]::Round((Get-HungerCible $kgEffectif $r.clade $ancreKg $ancreHunger), 4)
  }
}

$res | Export-Csv (Join-Path $Root 'output\cibles.csv') -NoTypeInformation -Encoding UTF8
"$($res.Count) animaux derives -> output\cibles.csv"
"geants volontaires detectes : $(($res | Where-Object geant).Count)"
