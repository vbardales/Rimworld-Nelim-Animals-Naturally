# Derive dressage, enclos, fugue, cajolerie, bat et salete.
#
# Ces cinq grandeurs sont couplees et doivent etre traitees ensemble.
#
# LE NOEUD, enfin denoue. La regle R2 du guide demande "dressage inter/av
# -> roaming 0" tout en gardant le betail en enclos. En vanilla c'est
# inexprimable : roamMtbDays porte les deux sens a la fois, un animal qui
# vagabonde EST un animal d'enclos. Retirer le roaming d'un merinos le
# rendait utile mais le sortait de sa cloture.
#
# Customize Animals expose FenceBlocked separement, et sa documentation
# precise qu'il surcharge le comportement d'enclos deduit du roaming. On
# peut donc enfin avoir les deux : un mouton dressable, sans fugue, et
# toujours retenu par une cloture.
#
# DRESSAGE. Il suit la cognition, pas le gabarit. Les grands singes, les
# canides, les elephants et les psittacides sont au sommet ; les ruminants
# d'elevage, les reptiles et les insectes n'apprennent rien. Le guide donne
# ses propres exemples, qu'on respecte : ara et alpaga en avance, perruche
# et rat en intermediaire, mouton et cerf a rien.
#
# CAJOLERIE. L'echelle du guide est explicite : 48 h pour les tres
# affectueux, 60 h pour les moyens, 72 h pour les legers, rien pour les
# autres. On la lit dans petness, qui mesure precisement l'aptitude a etre
# un animal de compagnie.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# --- dressage par groupe taxonomique, puis par clade --------------------
$DRESSAGE_GROUPE = @{
  'canis'='Advanced'; 'elephant'='Advanced'; 'equus'='Advanced'
  'camelide'='Advanced'      # l'alpaga du guide est en avance
  'ursus'='Advanced'
  'panthera'='Intermediate'; 'felis'='Intermediate'; 'vulpes'='Intermediate'
  'nyctereutes'='Intermediate'; 'rattus'='Intermediate'; 'mus'='Intermediate'
  'sus'='Advanced'          # les suides egalent les canides en apprentissage
  'lepus'='Intermediate'; 'lapin'='Intermediate'
  'bos'='None'; 'ovis'='None'; 'capra'='None'; 'rhino'='None'
  'ara'='Advanced'           # les psittacides parlent et resolvent des problemes
  'anas'='None'; 'galliforme'='None'; 'testudo'='None'
}
$DRESSAGE_CLADE = @{
  'primate'='Advanced'; 'psittacide'='Advanced'
  'chiroptere'='Intermediate'; 'marsupial'='Intermediate'; 'rapace'='Intermediate'
  'passereau'='Intermediate'; 'monotreme'='Intermediate'; 'mammifere'='Intermediate'
  'oiseau'='None'; 'ratite'='None'; 'galliforme'='None'
  'squamate'='None'; 'tortue'='None'; 'crocodilien'='None'; 'amphibien'='None'
  'insecte'='None'; 'arachnide'='None'; 'crustace'='None'
}

# Especes dont la cognition est documentee et s'ecarte de leur clade.
# Aucune valeur ne vient du guide : la reference est la litterature sur
# l'apprentissage animal.
$DRESSAGE_ESPECE = [ordered]@{
  # Les corvides resolvent des problemes a plusieurs etapes et fabriquent
  # des outils : ils n'ont rien d'un passereau ordinaire.
  'corbeau|corneille|geai|pie\b'='Advanced'
  # Les suides egalent les canides sur les tests d'apprentissage.
  'cochon|sanglier|pecari'='Advanced'
  # Aucun cervide ni bovide sauvage ne s'apprivoise : ils fuient, ils
  # n'apprennent pas. Meme chose pour les lagomorphes et les echassiers.
  'cerf|wapiti|\belan\b|orignal|caribou|renne|chevreuil|hydropote|gazelle|antilope|addax|oryx|gemsbok|bongo|gnou|bouquetin|mouflon|argali|bison|boeuf musque|lievre|lapin|flamant|aigrette|heron|ibis|spatule|cigogne'='None'
  # Mustelides et procyonides : manipulateurs, curieux, mais peu obeissants.
  'furet|belette|hermine|putois|martre|fouine|zibeline|vison|raton laveur|coati'='Intermediate'
}

# La cajolerie mesure l'attachement a l'humain, donc la domestication.
# On la lit dans petness, qui est exactement cette mesure, sans table
# d'especes nommees.

# --- animaux de bat : les betes de somme reelles ------------------------
$BAT_GROUPES = @('equus','camelide','bos','elephant')
$BAT_TAILLE_MIN = 0.7

# --- enclos : qui doit rester derriere une cloture ----------------------
# Le betail herbivore, meme devenu dressable. C'est le sens de la surcharge
# que Customize autorise.
$ENCLOS_GROUPES = @('bos','ovis','capra','sus','camelide','equus')

# --- cajolerie : l'echelle du guide, lue dans petness -------------------
function NuzzleDe([double]$petness) {
  if ($petness -ge 0.90) { return 48.0 }
  if ($petness -ge 0.50) { return 60.0 }
  if ($petness -ge 0.20) { return 72.0 }
  $null   # "off" : pas affectueux
}

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}
function Pct($s) { $v = Num $s; if ($null -eq $v) { return $null }; if ("$s" -match '%') { $v / 100.0 } else { $v } }

$ENT3 = @('devNote','defName','trainability','hungerRateAdult','eatenNutritionYearly','gestationDaysRaw','litterSizeAvg','gestationDaysEach','herbivore','grassToMaintain','valueOutputPerNutrition','bodySize','filth','adultAgeDays','nutritionToAdulthood','adultMeatAmount','adultMeatNutrition','adultMeatNutritionPerInput','slaughterValue','slaughterValuePerInput','slaughterValuePerGrowthYear','eggsYearly','eggValue','eggValueYearly','eggNutrition','eggNutritionYearly','milkYearly','milkValue','milkValueYearly','milkNutritionYearly','woolYearly','woolValue','woolValueYearly','tempMin','tempMax','tempWidth','moveSpeed','wildness','roamMtbDays','petness','nuzzleMtbHours','babySize','nutritionToGestate','babyMeatNutrition','babyMeatNutritionPerInput','shouldEatBabies')

$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$ref  = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$hyb  = Import-Csv (Join-Path $Root 'output\hybridation.csv')
$cib  = Import-Csv (Join-Path $Root 'output\cibles.csv')
$iP=@{}; foreach($r in $prod){$iP[$r.defName]=$r}
$iR=@{}; foreach($r in $ref){$iR[$r.defName]=$r}
$iG=@{}; foreach($r in $hyb){$iG[$r.defName]=$r.groupe}
$iC=@{}; foreach($r in $cib){$iC[$r.defName]=$r}
$iVT=@{}; foreach($r in (Import-Csv (Join-Path $Root 'output\cibles_vitesse_temp.csv'))){$iVT[$r.defName]=$r}

# Salete : elle suit la production de dechets, donc le metabolisme.
# On mesure la loi actuelle pour n'en corriger que l'exposant.
$ptsFilth = foreach ($m in $mast) {
  $p = $iP[$m.defName]; if (-not $p) { continue }
  $f = Num $p.filth; $b = Num $m.bodySize
  if ($f -and $b -and $f -gt 0 -and $b -gt 0) { [pscustomobject]@{x=$b; y=$f} }
}
$n = $ptsFilth.Count; $sx=0.0;$sy=0.0;$sxy=0.0;$sxx=0.0
foreach ($q in $ptsFilth) { $lx=[math]::Log($q.x); $ly=[math]::Log($q.y); $sx+=$lx;$sy+=$ly;$sxy+=$lx*$ly;$sxx+=$lx*$lx }
$expFilth = ($n*$sxy-$sx*$sy)/($n*$sxx-$sx*$sx)
$coefFilth = [math]::Exp(($sy - $expFilth*$sx)/$n)

$res = foreach ($m in $mast) {
  $d = $m.defName
  $r = $iR[$d]; $g = $iG[$d]; $p = $iP[$d]; $c = $iC[$d]
  $clade = if ($r) { $r.clade } else { $null }

  # taille finale, celle qui s'appliquera
  $bs = Num $m.bodySize
  if ($c -and $c.geant -ne 'True') {
    $t = Num $c.bodySize_cible
    if ($t -and $bs -and [math]::Abs($bs/$t - 1) -gt 0.15) { $bs = $t }
  }

  # --- dressage : espece nommee, puis groupe, puis clade ---
  $nomBas = if ($r) { $r.espece.ToLower() } else { '' }
  $dress = $null
  foreach ($motif in $DRESSAGE_ESPECE.Keys) { if ($nomBas -match $motif) { $dress = $DRESSAGE_ESPECE[$motif]; break } }
  if (-not $dress -and $g -and $DRESSAGE_GROUPE.ContainsKey($g)) { $dress = $DRESSAGE_GROUPE[$g] }
  elseif (-not $dress -and $clade -and $DRESSAGE_CLADE.ContainsKey($clade)) { $dress = $DRESSAGE_CLADE[$clade] }

  # --- enclos et fugue ---
  # Un animal dressable ne doit plus fuguer (regle R2), mais le betail
  # reste retenu par une cloture grace a la surcharge FenceBlocked.
  $enclos = $null; $fugue = $null
  if ($g -and $ENCLOS_GROUPES -contains $g) { $enclos = $true }
  $dressFinal = if ($dress) { $dress } else { $m.trainability }
  # On ne supprime la fugue que chez ceux qui fuguent REELLEMENT. Ecrire
  # null sur un champ deja nul ne corrige rien et gonfle le fichier de 572
  # entrees pour une trentaine de changements reels.
  $roamAct = if ($p) { Num $p.roamMtbDays } else { $null }
  if ($dressFinal -in @('Intermediate','Advanced') -and $roamAct -and $roamAct -gt 0) { $fugue = 'null' }

  # --- cajolerie ---
  $pet = Pct $m.petness
  $nuz = if ($null -ne $pet) { NuzzleDe $pet } else { $null }

  # --- bat : on n'AJOUTE que, on ne retire jamais ---
  # Ma regle ne reconnait que 56 betes de somme quand le jeu en compte 183.
  # Les 127 autres sont des choix delibres d'auteurs de mods, pas des
  # erreurs : rien ne dit qu'une creature inventee ne puisse pas porter une
  # charge. On se contente donc de completer les manques evidents.
  $bat = $null
  $batActuel = ($m.packAnimal -eq [char]0x2713)
  if (-not $batActuel -and $g -and $BAT_GROUPES -contains $g -and $bs -and $bs -ge $BAT_TAILLE_MIN) { $bat = $true }

  # --- capacites speciales -------------------------------------------
  # On n'en propose QUE pour les animaux reels, jamais pour les creatures
  # fictives : c'est chez elles que vivent les capacites exotiques
  # (rugissement du thrumbo, detonation controlee, rupture de cycle), et
  # la liste etant un remplacement complet, une ecriture maladroite les
  # effacerait. La regle d'ecriture, cote generateur, n'ajoutera de toute
  # facon rien la ou une liste existe deja.
  #
  # Quatre capacites seulement, celles qui sont generiques :
  #   Comfort      un animal qui cajole reconforte -- c'est la regle R3,
  #                verifiee ici par construction plutot que constatee
  #   Forage       les fouisseurs opportunistes qui retournent le sol
  #   AttackTarget un predateur assez dresse pour etre lance sur une cible
  #   Dig          les creuseurs de terriers
  $capacites = [System.Collections.Generic.List[string]]::new()
  $estReel = ($r -and $r.categorie -in @('reel','eteint'))
  if ($estReel) {
    if ($nuz) { $capacites.Add('Comfort') }
    if ($nomBas -match 'cochon|sanglier|pecari|raton laveur|ours |blaireau|ratel|opossum|\brat\b|rat brun|souris|ecureuil|herisson|macaque|babouin|mandrill|capucin|coati|glouton') {
      $capacites.Add('Forage')
    }
    if ($m.predator -eq [char]0x2713 -and $dressFinal -in @('Intermediate','Advanced')) {
      $capacites.Add('AttackTarget')
    }
    if ($nomBas -match 'taupe|rat-taupe|blaireau|tatou|chien de prairie|marmotte|wombat|oryctero|pangolin|lapin|gerboise|suricate') {
      $capacites.Add('Dig')
    }
    # CH_Hiss : le releve du mode dev le porte sur les felins, les herissons
    # et les oies -- exactement les animaux qui sifflent pour intimider sans
    # attaquer. On y ajoute l'opossum, dont le sifflement defensif est tout
    # aussi caracteristique et que le releve oublie.
    # On teste le NOM et non le groupe : le lynx boreal forme son propre
    # groupe d'espece, et se serait vu refuser le sifflement s'il avait
    # fallu appartenir a felis ou panthera.
    if ($nomBas -match 'chat |chat de pallas|lynx|once|lion|tigre|jaguar|leopard|panthere|guepard|serval|caracal|maine coon|persan|siamois|abyssin|somali|sphynx|munchkin|norvegien|british shorthair|bleu russe|scottish fold|bobtail japonais|ecaille de tortue|bengal|herisson|\boie\b|oie |opossum') {
      $capacites.Add('CH_Hiss')
    }
  }

  # --- vitesse de monte ---
  # Multiplicateur applique a la caravane. Les trois valeurs saisies par
  # Virginie sont 1,10, 1,20 et 1,65 : l'echelle tourne donc autour de 1.
  # On la derive de la vitesse de l'animal rapportee a celle d'un humain,
  # et on ne la donne qu'aux montures credibles -- assez grandes pour
  # porter quelqu'un, et d'un groupe qui a servi de monture dans l'histoire.
  $monte = $null
  if ($g -and $BAT_GROUPES -contains $g -and $bs -and $bs -ge 1.2) {
    $v = if ($iVT.ContainsKey($d)) { Num $iVT[$d].vitesse_cible } else { $null }
    if ($v -and $v -gt 0) {
      $monte = [math]::Round([math]::Max(1.0, [math]::Min(1.8, $v / 4.6)), 2)
    }
  }

  # --- salete : meme niveau global, exposant corrige vers le metabolisme ---
  $filthAct = if ($p) { Num $p.filth } else { $null }
  $filthCible = $null
  if ($filthAct -and $bs -and $bs -gt 0) {
    $filthCible = [math]::Round($coefFilth * [math]::Pow($bs, 0.75), 3)
  }

  [pscustomobject]@{
    defName=$d; espece=$(if($r){$r.espece}else{''}); groupe=$g; clade=$clade
    bodySize=$bs
    dressage_actuel=$m.trainability; dressage_cible=$dress
    enclos_cible=$enclos; fugue_cible=$fugue
    petness=$pet; nuzzle_cible=$nuz
    bat_actuel=$(if($m.packAnimal -eq [char]0x2713){'oui'}else{'non'}); bat_cible=$bat
    monte_cible=$monte
    capacites_cible=($capacites -join ' ')
    filth_actuel=$filthAct; filth_cible=$filthCible
  }
}

$res | Export-Csv (Join-Path $Root 'output\cibles_comportement.csv') -NoTypeInformation -Encoding UTF8
"$($res.Count) animaux derives -> output\cibles_comportement.csv"
"salete actuelle : {0:N3} * bodySize^{1:N3}  -> corrigee vers ^0.75 (metabolisme)" -f $coefFilth, $expFilth
""
"-- dressage cible --"
$res | Group-Object dressage_cible | Sort-Object Count -Descending | ForEach-Object { "  {0,-14} {1,4}" -f $(if($_.Name){$_.Name}else{'(inchange)'}), $_.Count }
"-- changements de dressage : $(@($res | Where-Object { $_.dressage_cible -and $_.dressage_cible -ne $_.dressage_actuel }).Count)"
"-- enclos force        : $(@($res | Where-Object { $_.enclos_cible }).Count)"
"-- fugue supprimee     : $(@($res | Where-Object { $_.fugue_cible }).Count)"
"-- cajolerie active    : $(@($res | Where-Object { $_.nuzzle_cible }).Count)"
"-- animaux de bat      : $(@($res | Where-Object { $_.bat_cible }).Count)  (actuellement $(@($res | Where-Object { $_.bat_actuel -eq 'oui' }).Count))"
