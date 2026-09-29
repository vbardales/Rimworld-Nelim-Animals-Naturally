# Generateur - fichier de reglages de Some Like It Rotten.
#
# Ce mod ne stocke PAS sa configuration dans des defs : elle vit dans ses
# ModSettings, donc aucun patch XML ne peut l'atteindre. On genere donc
# directement le fichier de reglages, que Virginie deposera dans son dossier
# Config.
#
# Structure lue dans Source/SomeLikeItRotten/SomeLikeItRottenModSettings.cs :
#     Scribe_Values.Look(ref VerboseLogging, "VerboseLogging");
#     Scribe_Collections.Look(ref RottenAnimals, "RottenAnimals", LookMode.Value);
#     Scribe_Collections.Look(ref BoneAnimals,   "BoneAnimals",   LookMode.Value);
#
# Regles d'Algo_animaux.md :
#   ROTTEN oui : charognards, omnivores opportunistes, detritivores
#   OS     oui : carnivores, charognards, omnivores a composante carnee
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
$V = [char]0x2713

# Charognards, omnivores opportunistes et detritivores : ils mangent du pourri.
# Un rapace chasseur, lui, ne touche pas a la charogne -- d'ou l'absence des
# faucons et chouettes ici, conformement aux fiches.
# 'loup' et 'renard' inclus : les canides SAUVAGES charognent abondamment
# (les fiches classent le kit fox en rotten=oui). Les chiens domestiques,
# eux, restent exclus -- leurs noms francais ne contiennent ni l'un ni
# l'autre, et les fiches les donnent explicitement en rotten=non.
$MOTIF_ROTTEN = 'rat\b|rat |souris|raton laveur|opossum|sanglier|cochon|pecari|ours |glouton|blaireau|ratel|hyene|vautour|corbeau|corneille|goeland|crabe|cloporte|blatte|\bver\b|larve|limace|escargot|fourmi|tortue alligator|alligator|crocodile|varan|dragon de komodo|chien viverrin|tanuki|rongeur|campagnol|mulot|marsupial|diable de tasmanie|loup|renard|fennec|chacal|coyote|lycaon|dhole|hermine|belette|furet|putois|martre|fouine|zibeline|vison|pekan|nutria|ragondin|rat musque|taupe|pangolin|tatou|herisson'

# Detritivores vegetaux : ils consomment de la matiere en decomposition mais
# ne touchent pas aux os. Le guide donne le cloporte geant en rotten=oui /
# os=non, c'est le cas d'ecole.
$MOTIF_DETRITIVORE = 'cloporte|\bver\b|larve|limace|escargot|blatte|fourmi|moustique|criquet|papillon|mante|scarab|punaise|\bpou\b|acarien'
# Au-dela de cette taille, un nom de decomposeur designe une creature de mod
# et non un decomposeur : le cloporte geant vanilla fait 0.15, le Boneworm 3.0.
$SEUIL_DETRITIVORE = 0.5

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
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

function Normalise([string]$s) {
  if (-not $s) { return '' }
  $n = $s.Normalize([System.Text.NormalizationForm]::FormD)
  $sb = [System.Text.StringBuilder]::new()
  foreach ($c in $n.ToCharArray()) {
    if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne
        [System.Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($c) }
  }
  ($sb.ToString().ToLower() -replace '[^a-z0-9]','')
}

# --- surcharges issues des fiches ---------------------------------------
# (nom francais) = "rotten,os"
$FICHES = @{
  'guttersow'='1,1'; 'gutterhog'='1,1'; 'groundrunner'='1,1'; 'ursidetaupier'='1,1'
  'kitfox'='1,1'; 'oursnoir'='1,1'; 'opossum'='1,1'; 'ratonlaveur'='1,1'
  'rat'='1,1'; 'souris'='1,1'; 'sourispoison'='1,1'; 'tortuealligator'='1,1'
  'cloportegeant'='1,0'
  'crecerelle'='0,1'; 'chouetteeffraie'='0,1'; 'doberman'='0,1'
  'levrierafghan'='0,1'; 'shibainu'='0,1'
}

$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$ref  = Import-Csv (Join-Path $Root 'reference\masses.csv')
$ana  = Import-Csv (Join-Path $Root 'reference\analogues_fictifs.csv')
$iP=@{}; foreach($r in $prod){$iP[$r.defName]=$r}
$iM=@{}; foreach($r in $mast){$iM[$r.defName]=$r}
$esp=@{}; foreach($r in $ref){$esp[$r.defName]=$r.espece}
foreach($r in $ana){ if(-not $esp[$r.defName]){$esp[$r.defName]=$r.nom} }

$rotten = [System.Collections.Generic.List[string]]::new()
$bones  = [System.Collections.Generic.List[string]]::new()
$rapport = @()

foreach ($m in $mast) {
  $d = $m.defName
  $p = $iP[$d]
  $nom = $esp[$d]; if (-not $nom) { $nom = $d }
  $cle = Normalise $nom

  # La colonne 'herbivore' de 3.csv ne contient pas une coche mais la chaine
  # litterale "He" (462 lignes) ou du vide (380). Tester la coche renvoyait
  # faux partout et faisait ressortir les 835 animaux en carnivores.
  $estHerbivore = $p -and ("$($p.herbivore)".Trim() -ne '')
  $estPredateur = ($m.predator -eq $V)

  # Pourri : charognards et opportunistes seulement.
  $pourri = ($nom.ToLower() -match $MOTIF_ROTTEN)

  # Os : "carnivores, charognards, omnivores a composante carnee" (guide).
  # Le drapeau 'herbivore' de 3.csv signifie "peut manger des plantes", pas
  # "exclusivement herbivore" : cochon, sanglier et blaireau y sont marques
  # herbivores alors qu'ils rongent les os. On ajoute donc les charognards,
  # sauf les detritivores vegetaux -- le cloporte du guide est explicitement
  # rotten=oui / os=non.
  # Un detritivore vegetal ne ronge jamais d'os, quoi que disent les autres
  # criteres : l'exclusion est prioritaire, pas une simple clause de plus.
  #
  # Mais le mot-cle seul ne suffit pas : dans RimWorld, "ver" et "larve"
  # designent des betes, pas des decomposeurs. Boneworm fait 3.0 de taille
  # et 9.5 de degats, et son nom annonce qu'il ronge les os. On exige donc
  # aussi une petite taille -- au-dela, c'est une creature de mod.
  $taille = Num $m.bodySize
  $detritivore = ($nom.ToLower() -match $MOTIF_DETRITIVORE) -and
                 ($null -ne $taille) -and ($taille -lt $SEUIL_DETRITIVORE)
  $os = (-not $detritivore) -and ($estPredateur -or (-not $estHerbivore) -or $pourri)

  $src = 'derive'
  if ($FICHES.ContainsKey($cle)) {
    $parts = $FICHES[$cle] -split ','
    $pourri = ($parts[0] -eq '1'); $os = ($parts[1] -eq '1'); $src = 'fiche'
  }

  if ($pourri) { $rotten.Add($d) }
  if ($os)     { $bones.Add($d) }
  $rapport += [pscustomobject]@{defName=$d;espece=$nom;rotten=$pourri;os=$os;source=$src}
}

$rapport | Export-Csv (Join-Path $Root 'output\alimentation.csv') -NoTypeInformation -Encoding UTF8

# Structure relevee sur le fichier reel de Virginie : les listes sont
# enveloppees dans <ModSettings Class="..."> a l'interieur de <SettingsBlock>.
# Sans cette enveloppe, RimWorld ignore silencieusement le fichier.
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('<?xml version="1.0" encoding="utf-8"?>')
[void]$sb.AppendLine('<SettingsBlock>')
[void]$sb.AppendLine('	<ModSettings Class="SomeLikeItRotten.SomeLikeItRottenModSettings">')
[void]$sb.AppendLine('		<VerboseLogging>False</VerboseLogging>')
[void]$sb.AppendLine('		<RottenAnimals>')
foreach ($x in ($rotten | Sort-Object)) { [void]$sb.AppendLine("			<li>$x</li>") }
[void]$sb.AppendLine('		</RottenAnimals>')
[void]$sb.AppendLine('		<BoneAnimals>')
foreach ($x in ($bones | Sort-Object)) { [void]$sb.AppendLine("			<li>$x</li>") }
[void]$sb.AppendLine('		</BoneAnimals>')
[void]$sb.AppendLine('	</ModSettings>')
[void]$sb.AppendLine('</SettingsBlock>')

$dossier = Join-Path $Root 'ReequilibrageAnimaux/config'
New-Item -ItemType Directory -Force $dossier | Out-Null
# Le nom du fichier reprend la classe Mod, pas la classe ModSettings.
$dest = Join-Path $dossier 'Mod_2503519676_SomeLikeItRottenMod.xml'
[System.IO.File]::WriteAllText($dest, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

"animaux mangeant du pourri : $($rotten.Count)"
"animaux rongeant les os    : $($bones.Count)"
"issus des fiches           : $(@($rapport | Where-Object source -eq 'fiche').Count)"
"fichier -> config\Mod_2503519676_SomeLikeItRottenMod.xml"
