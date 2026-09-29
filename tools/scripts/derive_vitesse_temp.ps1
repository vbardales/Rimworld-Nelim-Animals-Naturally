# Derive vitesse de deplacement et plages de temperature.
#
# VITESSE -- la masse ne predit rien (r2 = 0.039 sur 505 animaux), et c'est
# biologiquement normal : un zebre de 350 kg court plus vite qu'une souris
# de 20 g. Ce qui compte est le MODE DE LOCOMOTION. On procede donc comme
# le fait le guide : une echelle par classe, affinee par groupe taxonomique,
# et quelques especes nommees dont la vitesse est leur trait definitoire
# (le guepard n'est pas un felin comme les autres).
#
# TEMPERATURES -- deux composantes independantes :
#   . l'HABITAT donne la plage generale. On le lit d'abord dans le nom
#     (arctique, des sables, tropical), sinon dans la valeur actuelle du
#     jeu, qui encode deja le biome meme si sa physiologie est fausse.
#   . la PHYSIOLOGIE decale le seuil de froid selon la masse. C'est la loi
#     de Bergmann : le rapport surface/volume decroit avec la taille, donc
#     un gros endotherme se refroidit moins vite. Le jeu l'ignore totalement
#     -- exposant mesure -0.005, r2 = 0.000 : une souris et un mammouth
#     supportent le meme froid.
#   Les ectothermes echappent a Bergmann : sans chaleur interne, leur seuil
#   depend de l'environnement, pas de leur gabarit.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# ---------------------------------------------------------------------------
# VITESSE
# ---------------------------------------------------------------------------
$VITESSE_MIN = 1.0; $VITESSE_MAX = 6.5

# Socle par clade, cale sur l'echelle du guide et les medianes observees.
$VITESSE_CLADE = @{
  'tortue'=1.2; 'crustace'=2.2; 'crocodilien'=2.8; 'amphibien'=3.0
  'monotreme'=3.0; 'insecte'=3.0; 'squamate'=3.5; 'arachnide'=4.5
  'galliforme'=4.0; 'oiseau'=4.5; 'marsupial'=4.3; 'primate'=4.3
  'mammifere'=4.6              # l'humain, reference du guide
  'chiroptere'=5.5; 'psittacide'=5.5; 'passereau'=6.0; 'rapace'=6.0; 'ratite'=6.0
}

# Affinage par groupe taxonomique, la ou le clade est trop grossier.
$VITESSE_GROUPE = @{
  'equus'=6.5      # le zebre du guide
  'panthera'=5.8; 'lepus'=5.5; 'lapin'=5.5; 'vulpes'=5.5
  'canis'=5.2      # le shiba du guide est a 5.0
  'felis'=5.0; 'capra'=4.5; 'elephant'=4.8; 'ursus'=4.5; 'rhino'=4.5
  'mus'=4.5; 'rattus'=4.5; 'nyctereutes'=4.5; 'camelide'=4.2
  'sus'=4.0; 'ovis'=3.8; 'bos'=3.5   # le muffalo du guide est a 3.5
}

# Especes dont la vitesse EST le trait definitoire, ou dont la lenteur l'est.
$VITESSE_ESPECE = [ordered]@{
  'guepard'=6.5; 'levrier'=6.3; 'gazelle|antilope|addax|oryx|gemsbok'=6.3
  'autruche|emeu'=6.0; 'lievre'=6.0
  'paresseux'=1.5; 'escargot|limace'=1.0; 'taupe'=2.5; 'pangolin|tatou'=3.0
  'herisson|porc-epic'=3.0; 'hippopotame'=4.0; 'ornithorynque'=3.0
  'manchot|gorfou'=2.8       # excellents nageurs, pietres marcheurs
  'phoque|otarie|morse'=2.5  # idem
}

# ---------------------------------------------------------------------------
# TEMPERATURES
# ---------------------------------------------------------------------------
# Bergmann : seuil de froid = A - B * ln(masse). Cale sur souris +5,
# humain -14, mammouth -25, avant decalage d'habitat.
$BERGMANN_A = -4.3; $BERGMANN_B = 2.38

$ECTOTHERMES = @('tortue','crocodilien','squamate','amphibien','insecte','arachnide','crustace')

# Habitat : decalage sur le seuil de froid, et plafond de chaleur.
$HABITATS = [ordered]@{
  'polaire'   = @{ froid=-25; chaud=20 }
  'boreal'    = @{ froid=-12; chaud=32 }
  'montagne'  = @{ froid=-10; chaud=30 }
  'tempere'   = @{ froid=  0; chaud=38 }
  'aride'     = @{ froid=  2; chaud=50 }
  'tropical'  = @{ froid=  5; chaud=45 }
}

# Plages plausibles par biome, utilisees en ENCADREMENT et non en
# remplacement : une valeur deja dans la bande est conservee telle quelle.
# Ce sont des temperatures de CONFORT au sens de RimWorld, pas des seuils
# letaux -- d'ou des bornes plus larges que l'intuition ne le suggere.
$BANDES_FROID = @{
  'polaire'  = @(-60,-25); 'boreal'  = @(-45,-15); 'montagne' = @(-30, -5)
  'tempere'  = @(-25, -2); 'aride'   = @(-10,  8); 'tropical' = @( -5, 12)
}
$BANDES_CHAUD = @{
  'polaire'  = @( 12, 26); 'boreal'  = @( 24, 36); 'montagne' = @( 26, 38)
  'tempere'  = @( 30, 42); 'aride'   = @( 42, 60); 'tropical' = @( 38, 52)
}

# Habitat lu dans le nom de l'espece.
$HABITAT_NOM = [ordered]@{
  'polaire'  = 'polaire|arctique|des neiges|des glaces|glaciaire|antarctique|manchot|morse|renne|boeuf musque|lagopede|hermine|harfang'
  'boreal'   = 'boreal|taiga|glouton|elan|orignal|caribou|zibeline|martre|lynx|carcajou|wapiti'
  # '\blama\b' et non 'lama' : "f-LAMA-nt" matchait, et le flamant rose
  # se retrouvait en habitat montagnard au lieu de tropical.
  'montagne' = 'des alpes|bouquetin|yak|\blama\b|alpaga|chamois|mouflon|argali|pika|condor|nestor'
  'aride'    = 'desert|des sables|sahara|fennec|dromadaire|chameau|addax|oryx|gerboise|suricate|meerkat|scorpion|gila|thorny|cornu'
  'tropical' = 'tropical|jungle|amazon|equatorial|ara |perroquet|toucan|calao|gorille|chimpanze|bonobo|orang|gibbon|paresseux|tapir|jaguar|okapi|hippopotame|flamant|python|anaconda|iguane|capybara|pangolin|lemur|mandrill|tigre du bengale|elephant|girafe|lion|zebre|gnou|guepard'
}

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}
function Borne([double]$v, [double]$lo, [double]$hi) { [math]::Max($lo, [math]::Min($hi, $v)) }

# Habitat deduit de la valeur actuelle du jeu, quand le nom ne dit rien :
# le biome voulu par l'auteur y est encode, meme si la physiologie est fausse.
function HabitatDepuisFroid([double]$t) {
  if ($t -le -40) { return 'polaire' }
  if ($t -le -20) { return 'boreal' }
  if ($t -le  -8) { return 'montagne' }
  if ($t -lt   4) { return 'tempere' }
  'tropical'
}

# ---------------------------------------------------------------------------
$ref  = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$hyb  = Import-Csv (Join-Path $Root 'output\hybridation.csv')
$iM=@{}; foreach($r in $mast){$iM[$r.defName]=$r}
$iG=@{}; foreach($r in $hyb){$iG[$r.defName]=$r.groupe}

$res = foreach ($r in $ref) {
  $g = $iM[$r.defName]; if (-not $g) { continue }
  $kg = Num $r.masse_kg; if (-not $kg -or $kg -le 0) { continue }
  $nom = $r.espece.ToLower()
  $clade = $r.clade
  $groupe = $iG[$r.defName]

  # --- vitesse : espece, puis groupe, puis clade ---
  $vit = $null
  foreach ($motif in $VITESSE_ESPECE.Keys) { if ($nom -match $motif) { $vit = $VITESSE_ESPECE[$motif]; break } }
  if (-not $vit -and $groupe -and $VITESSE_GROUPE.ContainsKey($groupe)) { $vit = $VITESSE_GROUPE[$groupe] }
  if (-not $vit -and $VITESSE_CLADE.ContainsKey($clade)) { $vit = $VITESSE_CLADE[$clade] }
  if (-not $vit) { $vit = 4.0 }
  $vit = Borne $vit $VITESSE_MIN $VITESSE_MAX

  # --- habitat ---
  # Deux qualites de signal, qui n'autorisent pas la meme correction.
  #   . le NOM est un signal fort : "fennec", "ours polaire", "gecko du
  #     desert" designent sans ambiguite un biome. On peut alors corriger
  #     la plage en ABSOLU, meme contre la valeur du jeu.
  #   . la valeur ACTUELLE est un signal faible et circulaire : elle encode
  #     ce que l'auteur a voulu, mais les valeurs du jeu sont des gabarits
  #     copies-colles. On se limite alors a un ajustement differentiel.
  # Sans cette distinction, le fennec ressortait a -28 degres : un renard du
  # Sahara heritant du gabarit tempere par defaut.
  $hab = $null; $habSure = $false
  foreach ($h in $HABITAT_NOM.Keys) { if ($nom -match $HABITAT_NOM[$h]) { $hab = $h; $habSure = $true; break } }
  $froidAct = Num $g.tempMin
  if (-not $hab) { $hab = if ($null -ne $froidAct) { HabitatDepuisFroid $froidAct } else { 'tempere' } }

  # --- temperatures : correction DIFFERENTIELLE ---
  #
  # Premiere version, abandonnee : elle recalculait la plage entierement
  # depuis l'habitat. Confrontee au guide, elle donnait -50 au mammouth
  # contre -20, et -24 a l'alpaga contre -5 : elle empilait Bergmann sur le
  # decalage d'habitat, donc corrigeait deux fois.
  #
  # Le guide a raison sur le fond : l'habitat domine. Un elephant de 2,5 t
  # souffre des 5 degres parce qu'il est tropical, pas parce qu'il est gros.
  # On conserve donc le biome voulu par les auteurs, deja encode dans les
  # valeurs actuelles, et on n'ajoute que la physiologie qui manque : un
  # ecart de quelques degres selon la masse.
  #
  # Le decalage va dans le meme sens sur les deux bornes : un gros animal
  # tient mieux le froid ET supporte moins bien la chaleur, son rapport
  # surface/volume limitant sa dissipation thermique.
  $estEcto = $ECTOTHERMES -contains $clade
  $chaudAct = Num $g.tempMax
  if ($null -eq $froidAct -or $null -eq $chaudAct) { continue }

  if ($estEcto -and -not $habSure) {
    # Sans chaleur interne produite, la masse ne change rien : on ne touche pas.
    $froid = $froidAct
    $chaud = $chaudAct
  } elseif ($habSure) {
    # Biome certain : on ENCADRE, on ne remplace pas.
    #
    # Une premiere version recalait en absolu sur la bande du biome. Elle
    # faisait regresser les valeurs deja justes : l'ours polaire tombait de
    # -55 a -28 et le lynx boreal de -50 a -13, alors que le jeu avait
    # raison sur ces deux-la. On ne corrige donc que ce qui SORT de la
    # plage plausible, et on laisse le reste tranquille -- meme principe de
    # corridor que partout ailleurs.
    $b = $BANDES_FROID[$hab]
    $froid = Borne ($froidAct + (Borne (-1.2 * [math]::Log($kg / 10.0)) -3 3)) $b[0] $b[1]
    $bc = $BANDES_CHAUD[$hab]
    $chaud = Borne ($chaudAct + (Borne (-1.0 * [math]::Log($kg / 10.0)) -3 3)) $bc[0] $bc[1]
  } else {
    $froid = $froidAct + (Borne (-1.2 * [math]::Log($kg / 10.0)) -5 5)
    $chaud = $chaudAct + (Borne (-1.0 * [math]::Log($kg / 10.0)) -4 4)
  }
  $froid = Borne $froid -80 15
  $chaud = Borne $chaud 15 60
  if ($chaud -lt $froid + 20) { $chaud = $froid + 20 }   # plage jamais absurde

  [pscustomobject]@{
    defName        = $r.defName
    espece         = $r.espece
    clade          = $clade
    masse_kg       = $kg
    habitat        = $hab
    vitesse_actuelle = $g.speed
    vitesse_cible  = [math]::Round($vit, 2)
    tempMin_actuel = $g.tempMin
    tempMin_cible  = [math]::Round($froid, 0)
    tempMax_actuel = $g.tempMax
    tempMax_cible  = [math]::Round($chaud, 0)
  }
}

$res | Export-Csv (Join-Path $Root 'output\cibles_vitesse_temp.csv') -NoTypeInformation -Encoding UTF8
"$($res.Count) animaux derives -> output\cibles_vitesse_temp.csv"
""
"-- repartition par habitat --"
$res | Group-Object habitat | Sort-Object Count -Descending | ForEach-Object { "  {0,-10} {1,4}" -f $_.Name, $_.Count }
