# Generateur - age de maturite (lifeStageAges).
#
# RISQUE ASSUME : lifeStageAges est une LISTE de stades dont les <def>
# varient selon les animaux et les mods (AnimalAdult, AnimalAdultTiny, et
# des stades maison). Impossible de cibler un stade par son nom sans les
# defs. On cible donc par POSITION : li[last()] est toujours le stade
# adulte, quelle que soit la faÃ§on dont il s'appelle et quel que soit le
# nombre de stades. C'est une hypothese de structure, pas de nommage --
# nettement plus robuste, mais elle reste une hypothese.
#
# Le patch est conditionnel : si le chemin n'existe pas, l'operation est
# inerte. Un echec serait donc silencieux, pas destructeur.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# Maturite : A * masse^0.30 annees.
# Ancrage sur le mouton (70 kg, 1 an), qui cale aussi la souris a 0.09 an
# et la vache a 2.0 ans -- les valeurs reelles. L'elephant ressort a 3.4 ans
# contre 12 en realite : la megafaune murit beaucoup plus lentement que
# l'allometrie ne le prevoit, et je prefere sous-estimer que rendre un
# elephant inexploitable pendant 12 annees de jeu.
# DEUX lois, et non une. Une loi unique sous-estimait gravement les grands
# sauvages -- elephant 3,4 ans contre 12 reels, ours 1,56 contre 4, lion
# 1,36 contre 3 -- parce qu'elle etait calee sur du betail. Or la
# domestication a precisement selectionne la maturite precoce : une truie
# est feconde a 7 mois quand une laie sauvage attend 18.
#
# Sauvages   : 0.463 * masse^0.392  (souris 0,1 an, loup 2, lion 3,6,
#                                    ours 4,3, elephant 11,9 -- ajuste sur
#                                    ces valeurs publiees)
# Domestiques: 0.400 * masse^0.246  (poule 0,5, chien 0,9, mouton 1,1,
#                                    vache 2,0)
$MATU_A_SAUVAGE = 0.463; $MATU_B_SAUVAGE = 0.392
$MATU_A_DOMESTIQUE = 0.400; $MATU_B_DOMESTIQUE = 0.246
$SEUIL_DOMESTIQUE = 35.0   # wildness en pourcent
$MATU_MIN = 0.05; $MATU_MAX = 12.0   # l'elephant reel mut a 12 ans

# Les ongules sont NIDIFUGES : le petit marche dans l'heure et suit le
# troupeau. Cette strategie va de pair avec une maturite precoce pour le
# gabarit -- un cerf de 80 kg est adulte a 18 mois quand un ours de 300 kg
# attend 4 ans. Sans ce facteur, le cheval sortait a 5,3 ans contre 3 reels
# et le cerf a 2,6 contre 1,5.
# Ne s'applique qu'a la loi SAUVAGE : les ongules domestiques suivent deja
# la loi domestique, qui les place au bon endroit.
$FACTEUR_NIDIFUGE = 0.55
$MOTIF_ONGULE = 'cerf|chevreuil|wapiti|\belan\b|orignal|caribou|renne|hydropote|gazelle|antilope|addax|oryx|gemsbok|bongo|gnou|bouquetin|mouflon|argali|bison|boeuf musque|cheval|poney|\bane\b|zebre|quagga|girafe|okapi|tapir|chameau|dromadaire|lama|alpaga|sanglier|pecari'
$TOL = 0.15

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

$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$cib  = Import-Csv (Join-Path $Root 'output\cibles.csv')
$iP=@{}; foreach($r in $prod){$iP[$r.defName]=$r}

$ops = @(); $rapport = @()
foreach ($c in $cib) {
  $d = $c.defName
  $kg = Num $c.masse_effective; if (-not $kg -or $kg -le 0) { continue }
  $p = $iP[$d]; if (-not $p) { continue }

  $actJours = Num $p.adultAgeDays; if (-not $actJours -or $actJours -le 0) { continue }
  $actAns = $actJours / 60.0     # l'annee RimWorld fait 60 jours

  $w = Num $p.wildness
  $domestique = ($null -ne $w -and $w -lt $SEUIL_DOMESTIQUE)
  $a = if ($domestique) { $MATU_A_DOMESTIQUE } else { $MATU_A_SAUVAGE }
  $b = if ($domestique) { $MATU_B_DOMESTIQUE } else { $MATU_B_SAUVAGE }
  $brut = $a * [math]::Pow($kg, $b)
  if (-not $domestique -and $c.espece -and $c.espece.ToLower() -match $MOTIF_ONGULE) {
    $brut *= $FACTEUR_NIDIFUGE
  }
  $cibleAns = [math]::Max($MATU_MIN, [math]::Min($MATU_MAX, $brut))
  $vie = Num $c.lifespan_cible

  # La maturite ne peut jamais approcher la longevite : un animal doit avoir
  # le temps de vivre adulte. Sans ce plafond, la mante geante devenait
  # adulte a 2,91 ans pour une esperance de vie de 1 an -- sa protection de
  # geant lui donne une masse effective de 2,4 tonnes pour la maturite, mais
  # son clade insecte plafonne sa vie a une saison. Deux regles justes prises
  # separement produisaient une impossibilite.
  if ($vie -and $vie -gt 0) { $cibleAns = [math]::Min($cibleAns, 0.4 * $vie) }
  $cibleAns = [math]::Max($MATU_MIN, $cibleAns)

  # ON NE PATCHE QUE VERS LE HAUT.
  #
  # lifeStageAges est une liste ordonnee : bebe < juvenile < adulte. En ne
  # touchant que le dernier element, abaisser son minAge peut le faire passer
  # SOUS le juvenile qui le precede -- l'animal devient alors juvenile apres
  # avoir ete adulte. Bug observe en jeu sur l'echenilleur, dont la maturite
  # tombait de 0.6 a 0.11 an.
  #
  # Reculer l'age adulte est en revanche toujours sur : le juvenile etait
  # deja inferieur a l'ancienne valeur, il reste inferieur a une valeur plus
  # grande. Les 139 baisses sont donc abandonnees -- elles demanderaient de
  # reechelonner tous les stades, ce qui exige de lire les defs.
  if ($cibleAns -gt $actAns -and ($cibleAns/$actAns - 1) -gt $TOL) {
    $base = "/Defs/ThingDef[defName=`"$d`"]/race/lifeStageAges/li[last()]/minAge"
    $ops += @"
  <Operation Class="PatchOperationConditional">
    <xpath>$base</xpath>
    <match Class="PatchOperationReplace">
      <xpath>$base</xpath>
      <value><minAge>$([math]::Round($cibleAns,3))</minAge></value>
    </match>
  </Operation>
"@
  }

  $rapport += [pscustomobject]@{
    defName=$d; espece=$c.espece; masse_kg=$kg
    maturite_actuelle_ans=[math]::Round($actAns,2)
    maturite_cible_ans=[math]::Round($cibleAns,2)
    longevite_cible=$vie
    part_de_vie=$(if($vie -and $vie -gt 0){[math]::Round(100*$cibleAns/$vie,1)}else{''})
  }
}

$rapport | Export-Csv (Join-Path $Root 'output\cibles_croissance.csv') -NoTypeInformation -Encoding UTF8
$dest = Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Croissance.xml'
$txt = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`r`n<Patch>`r`n" +
       # Un commentaire XML ne peut pas contenir la sequence '--'.
       "  <!-- Age de maturite. Cible par POSITION : li[last()] est le stade`r`n" +
       "       adulte quel que soit son nom, faute de pouvoir lire les defs.`r`n" +
       "       Genere par scripts/genere_croissance.ps1 - ne pas editer a la main. -->`r`n" +
       ($ops -join "`r`n") + "`r`n</Patch>`r`n"
[System.IO.File]::WriteAllText($dest, $txt, [System.Text.UTF8Encoding]::new($false))

"Croissance.xml : $($ops.Count) operations"
