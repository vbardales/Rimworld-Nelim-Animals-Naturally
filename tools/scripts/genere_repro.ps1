# Generateur - perimetre C : reproduction.
#
# Point cle : une annee RimWorld fait 60 jours, pas 365. Toute duree reelle
# exprimee en jours doit donc etre comprimee du facteur 60/365 = 0.1644 pour
# rester coherente avec la longevite, qui elle est exprimee en annees.
# Sans cette conversion, un elephant gestant 645 jours reels passerait
# 10 annees de jeu enceinte.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$JOURS_PAR_AN_RW = 60.0
$COMPRESSION     = $JOURS_PAR_AN_RW / 365.0
$TOL             = 0.15

# --- gestation ---------------------------------------------------------
# Loi biologique : 60.8 * masse^0.284 jours reels (souris 20 j, vache 283 j,
# elephant 645 j), soit 10.0 * masse^0.284 une fois comprimee a l'annee de
# 60 jours.
#
# EXPOSANT VOLONTAIREMENT REDUIT DE MOITIE (0.284 -> 0.142), sur decision de
# Virginie. L'exposant biologique divisait par dix le rendement de l'elevage
# bovin -- exact, mais injouable. La moitie preserve la hierarchie r/K en
# ramenant la vache de 0.9 a 2.4 veaux par an.
#
# Le coefficient reste a 10.0 : la compression pivote donc autour du bas du
# spectre, ou les valeurs actuelles sont deja correctes (la souris reste a
# ~5.7 jours), et ne mord que sur les gros animaux.
$GEST_A = 10.0; $GEST_B = 0.142
$GEST_MIN = 1.5; $GEST_MAX = 120.0

# --- taille de portee --------------------------------------------------
# Reel : 3.77 * masse^-0.16 (souris 7, chat 3, vache 1, elephant 1).
$PORTEE_A = 3.77; $PORTEE_B = -0.16
$PORTEE_MIN = 1.0; $PORTEE_MAX = 12.0

# La masse seule ne predit PAS la taille de portee : un cochon de 150 kg fait
# 10 petits, un ane de meme masse en fait 1. La strategie reproductive est un
# trait de lignee, pas de gabarit. On surcharge donc par groupe taxonomique
# la ou on le connait, et on ne retombe sur la loi de masse qu'a defaut.
$PORTEE_PAR_GROUPE = @{
  'sus'=8.0; 'rattus'=8.0; 'mus'=6.0; 'lapin'=6.0; 'canis'=5.0; 'vulpes'=5.0
  'nyctereutes'=5.0; 'felis'=4.0; 'lepus'=3.0; 'panthera'=2.5; 'ursus'=2.0
  'capra'=1.8; 'ovis'=1.3; 'bos'=1.0; 'equus'=1.0; 'camelide'=1.0
  'rhino'=1.0; 'elephant'=1.0
}

# --- mateMtb -----------------------------------------------------------
# Le jeu l'a fige a 12 h pour 693 animaux sur 835. On lui rend la pente
# du continuum r/K : les petits se reproduisent vite, les gros lentement.
$MATE_A = 12.0; $MATE_B = 0.25
$MATE_MIN = 4.0; $MATE_MAX = 240.0

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
function Borne([double]$v, [double]$lo, [double]$hi) { [math]::Max($lo, [math]::Min($hi, $v)) }

function PatchChamp([string]$def, [string]$champ, [string]$valeur) {
  @"
  <Operation Class="PatchOperationConditional">
    <xpath>/Defs/ThingDef[defName="$def"]/race/$champ</xpath>
    <match Class="PatchOperationReplace">
      <xpath>/Defs/ThingDef[defName="$def"]/race/$champ</xpath>
      <value><$champ>$valeur</$champ></value>
    </match>
    <nomatch Class="PatchOperationConditional">
      <xpath>/Defs/ThingDef[defName="$def"]/race</xpath>
      <match Class="PatchOperationAdd">
        <xpath>/Defs/ThingDef[defName="$def"]/race</xpath>
        <value><$champ>$valeur</$champ></value>
      </match>
    </nomatch>
  </Operation>
"@
}

# ---------------------------------------------------------------------------
$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$cib  = Import-Csv (Join-Path $Root 'output\cibles.csv')
$hyb  = Import-Csv (Join-Path $Root 'output\hybridation.csv')
$iP=@{}; foreach($r in $prod){$iP[$r.defName]=$r}
$iM=@{}; foreach($r in $mast){$iM[$r.defName]=$r}
$iG=@{}; foreach($r in $hyb){$iG[$r.defName]=$r.groupe}

$ops = @(); $rapport = @()
$nGest=0; $nPortee=0; $nMate=0

foreach ($c in $cib) {
  $d = $c.defName
  # masse_effective tient compte des geants : un geant volontaire paie le
  # cout reproductif de sa taille, pas celui de son espece d'origine.
  $kg = Num $c.masse_effective; if (-not $kg -or $kg -le 0) { continue }
  $p = $iP[$d]; $m = $iM[$d]

  $gestCible   = Borne ($GEST_A   * [math]::Pow($kg, $GEST_B))   $GEST_MIN   $GEST_MAX
  # Trois lignees echappent aux groupes d'hybridation et sortaient fausses :
  # le cerf a 1,9 petits quand un cervide en fait un seul, l'ecureuil a 4,2
  # pour 3, le furet a 3,8 pour 8. On les nomme.
  $nomPortee = if ($c) { $c.espece.ToLower() } else { '' }
  $grp = $iG[$d]
  $porteeCible = if ($nomPortee -match 'cerf|chevreuil|wapiti|\belan\b|orignal|caribou|renne|hydropote|girafe|okapi|tapir|chameau|dromadaire') { 1.0 }
  elseif ($nomPortee -match 'furet|belette|hermine|putois|vison|martre|fouine|zibeline|pekan') { 7.0 }
  elseif ($nomPortee -match 'ecureuil|tamia|marmotte|loir') { 3.0 }
  elseif ($grp -and $PORTEE_PAR_GROUPE.ContainsKey($grp)) {
    $PORTEE_PAR_GROUPE[$grp]
  } else {
    Borne ($PORTEE_A * [math]::Pow($kg, $PORTEE_B)) $PORTEE_MIN $PORTEE_MAX
  }
  $mateCible   = Borne ($MATE_A   * [math]::Pow($kg, $MATE_B))   $MATE_MIN   $MATE_MAX

  $gestAct   = if ($p) { Num $p.gestationDaysRaw } else { $null }
  $porteeAct = if ($p) { Num $p.litterSizeAvg }    else { $null }
  $mateAct   = if ($m) { Num $m.mateMtb }          else { $null }

  # Les ovipares n'ont pas de gestation : le champ ne les concerne pas.
  $ovipare = $p -and (Num $p.eggsYearly)

  if (-not $ovipare -and $gestAct -and [math]::Abs($gestAct/$gestCible - 1) -gt $TOL) {
    $ops += PatchChamp $d 'gestationPeriodDays' ([math]::Round($gestCible,2).ToString()); $nGest++
  }
  if ($porteeAct -and [math]::Abs($porteeAct/$porteeCible - 1) -gt $TOL) {
    # litterSizeCurve est une courbe, pas un scalaire : on la reecrit en
    # triangle centre sur la cible, borne a 1 au minimum.
    $lo = [math]::Max(1, [math]::Round($porteeCible * 0.6))
    $hi = [math]::Max($lo + 1, [math]::Round($porteeCible * 1.5))
    $mid = [math]::Round($porteeCible)
    $courbe = "<points><li>($lo, 0)</li><li>($mid, 1)</li><li>($hi, 0)</li></points>"
    $ops += PatchChamp $d 'litterSizeCurve' $courbe; $nPortee++
  }
  if ($mateAct -and [math]::Abs($mateAct/$mateCible - 1) -gt $TOL) {
    $ops += PatchChamp $d 'mateMtbHours' ([math]::Round($mateCible,1).ToString()); $nMate++
  }

  $rapport += [pscustomobject]@{
    defName=$d; espece=$c.espece; masse_kg=$kg
    gestation_actuelle=$gestAct; gestation_cible=[math]::Round($gestCible,2)
    portee_actuelle=$porteeAct;  portee_cible=[math]::Round($porteeCible,2)
    mate_actuel=$mateAct;        mate_cible=[math]::Round($mateCible,1)
    ovipare=[bool]$ovipare
  }
}

$rapport | Export-Csv (Join-Path $Root 'output\cibles_repro.csv') -NoTypeInformation -Encoding UTF8
$dest = Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Reproduction.xml'
$txt = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`r`n<Patch>`r`n" +
       "  <!-- Reproduction : gestation, portee et frequence d'accouplement.`r`n" +
       "       Durees converties a l'annee RimWorld de 60 jours (facteur 0.1644).`r`n" +
       "       Genere par scripts/genere_repro.ps1 - ne pas editer a la main. -->`r`n" +
       ($ops -join "`r`n") + "`r`n</Patch>`r`n"
[System.IO.File]::WriteAllText($dest, $txt, [System.Text.UTF8Encoding]::new($false))

"Reproduction.xml : $($ops.Count) operations"
"  gestation : $nGest"
"  portee    : $nPortee"
"  mateMtb   : $nMate"
