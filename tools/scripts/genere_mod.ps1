# Generateur du mod - perimetre B : taille, longevite, regles strictes.
#
# Source de verite : masses.csv (+ clades) et Algo_animaux.md.
# Les 57 fiches de Fiche_animaux_v2.md PRIMENT sur toute formule.
#
# Logique de corridor : une valeur n'est corrigee que si elle sort d'une
# bande de +/- 15% autour de la cible. Le vanilla bien regle par Ludeon
# n'est pas touche -- sur 20 especes temoin, son erreur mediane de longevite
# est de 17%, meilleure qu'une formule generique.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
$V = [char]0x2713
$TOL = 0.15

# R4 module par mode de chasse. Plafonner la proie a la taille du predateur
# interdirait la chasse en meute et la chasse au venin, deux des trois
# grandes strategies du vivant : un loup de 45 kg abat un elan de 400 kg.
$FACTEUR_PROIE = @{ 'solitaire' = 1.0; 'meute' = 3.0; 'venimeux' = 5.0 }
$MOTIF_MEUTE    = 'loup|chien|coyote|chacal|dingo|dhole|lycaon|hyene|husky|berger |retriever|doberman|mastiff'
$MOTIF_VENIMEUX = 'serpent|cobra|vipere|crotale|mocassin|couleuvre|scorpion|python|anaconda'

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -eq '' -or $t -eq '-' -or $t -eq '.') { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

# Un patch conditionnel : remplace si le champ existe, ajoute sinon.
# Robuste au retrait d'un mod comme a un nom de champ inattendu.
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

# Suppression d'un champ, uniquement s'il est present.
function SupprimeChamp([string]$def, [string]$champ) {
  @"
  <Operation Class="PatchOperationConditional">
    <xpath>/Defs/ThingDef[defName="$def"]/race/$champ</xpath>
    <match Class="PatchOperationRemove">
      <xpath>/Defs/ThingDef[defName="$def"]/race/$champ</xpath>
    </match>
  </Operation>
"@
}

function EcritPatch([string]$nom, [string[]]$ops, [string]$entete) {
  $dest = Join-Path $Root "ReequilibrageAnimaux\Mod\Patches\$nom.xml"
  $txt = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`r`n<Patch>`r`n  <!-- $entete`r`n       Genere par scripts/genere_mod.ps1 - ne pas editer a la main. -->`r`n" +
         ($ops -join "`r`n") + "`r`n</Patch>`r`n"
  [System.IO.File]::WriteAllText($dest, $txt, [System.Text.UTF8Encoding]::new($false))
  $ops.Count
}

# ---------------------------------------------------------------------------
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$cib  = Import-Csv (Join-Path $Root 'output\cibles.csv')
$ovr  = Import-Csv (Join-Path $Root 'output\overrides_fiches.csv')
$ENT3 = @('devNote','defName','trainability','x4','x5','x6','x7','x8','x9','x10','x11',
  'bodySize','x13','x14','x15','x16','x17','x18','x19','x20','x21','x22','x23','x24',
  'x25','x26','x27','x28','x29','x30','x31','x32','x33','tempMin','tempMax','tempWidth',
  'moveSpeed','wildness','roamMtbDays','petness','nuzzleMtbHours','x43','x44','x45','x46','x47')
$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1

$iC = @{}; foreach ($r in $cib) { $iC[$r.defName] = $r }
# Les 57 fiches ne font plus autorite : Virginie demande une reestimation
# entierement biologique. Leurs valeurs restent archivees et servent encore
# de jeu de calibration pour mesurer l'ecart, mais elles ne surchargent
# plus la formule.
$iO = @{}
$iP = @{}; foreach ($r in $prod) { $iP[$r.defName] = $r }

New-Item -ItemType Directory -Force (Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches') | Out-Null
$opsTaille = @(); $opsVie = @(); $opsRegles = @()
$statFiche = 0; $statFormule = 0

foreach ($m in $mast) {
  $d = $m.defName; $c = $iC[$d]; $o = $iO[$d]; $p = $iP[$d]
  $bsAct = Num $m.bodySize

  # --- TAILLE -------------------------------------------------------------
  if ($o) {
    # Fiche manuelle : elle fait autorite, sans corridor.
    $cible = Num $o.bodySize_fiche
    if ($cible -and $bsAct -and [math]::Abs($bsAct - $cible) -gt 0.001) {
      $opsTaille += PatchChamp $d 'baseBodySize' ([math]::Round($cible,3).ToString())
      $statFiche++
    }
  } elseif ($c -and $c.geant -ne 'True') {
    $cible = Num $c.bodySize_cible
    if ($cible -and $bsAct -and [math]::Abs($bsAct/$cible - 1) -gt $TOL) {
      $opsTaille += PatchChamp $d 'baseBodySize' ([math]::Round($cible,3).ToString())
      $statFormule++
    }
  }

  # --- LONGEVITE ----------------------------------------------------------
  if ($c) {
    $act = Num $c.lifespan_actuel; $cibleV = Num $c.lifespan_cible
    if ($act -and $cibleV -and [math]::Abs($act/$cibleV - 1) -gt $TOL) {
      $opsVie += PatchChamp $d 'lifeExpectancy' ([math]::Round($cibleV,1).ToString())
    }
  }

  # --- R1 : Harm >= Tame fail ---------------------------------------------
  $harm = Num $m.manhunterDmg; $tame = Num $m.manhunterTame
  if ($null -ne $harm -and $null -ne $tame -and $harm -lt $tame) {
    $opsRegles += PatchChamp $d 'manhunterOnDamageChance' (($tame/100.0).ToString('0.###'))
  }

  # --- R2 : dressable -> plus de fugue ------------------------------------
  # "Roaming 0" du guide veut dire AUCUNE fugue. Or roamMtbDays est un temps
  # moyen entre deux fugues : y mettre 0 signifierait fuguer en permanence.
  # L'absence de fugue s'exprime en retirant le champ.
  $roam = if ($p) { Num $p.roamMtbDays } else { $null }
  if ($m.trainability -in @('Intermediate','Advanced') -and $roam -and $roam -gt 0) {
    $opsRegles += SupprimeChamp $d 'roamMtbDays'
  }

  # --- R4 : proie plafonnee selon le mode de chasse ------------------------
  $prey = Num $m.maxPreyBodySize
  if ($m.predator -eq $V -and $bsAct -and $prey -and $prey -ne 99999) {
    $esp = if ($c) { $c.espece.ToLower() } else { '' }
    $mode = 'solitaire'
    if ($esp -match $MOTIF_MEUTE)    { $mode = 'meute' }
    if ($esp -match $MOTIF_VENIMEUX) { $mode = 'venimeux' }
    # Le plafond se calcule sur la taille CIBLE, pas sur l'ancienne. Sinon
    # l'ours brun, reduit de 2,15 a 1,62, gardait un plafond de proie de
    # 2,15 -- il chassait plus gros que lui. Quarante predateurs etaient
    # dans ce cas, tous ceux dont la taille change.
    # La reference est la taille qui S'APPLIQUERA, pas la taille visee : le
    # corridor de 15% laisse beaucoup de tailles inchangees. Le crocodile du
    # Nil visait 1,79 mais reste a 1,60, et son plafond de proie calcule sur
    # 1,79 le faisait chasser plus gros que lui.
    # NE PAS nommer cette variable $v : PowerShell ignore la casse, et $V
    # porte la coche qui sert a tester le champ predator. Nommer $v ici
    # detruisait $V des le premier predateur, et tous les suivants echouaient
    # au test -- seuls les 12 premiers dans l'ordre alphabetique etaient
    # patches. Le meme piege avait deja frappe avec $r contre $R.
    $bsRef = $bsAct
    if ($o) {
      $bsFiche = Num $o.bodySize_fiche
      if ($bsFiche -and [math]::Abs($bsAct - $bsFiche) -gt 0.001) { $bsRef = $bsFiche }
    } elseif ($c -and $c.geant -ne 'True') {
      $bsCible = Num $c.bodySize_cible
      if ($bsCible -and $bsCible -gt 0 -and [math]::Abs($bsAct / $bsCible - 1) -gt $TOL) { $bsRef = $bsCible }
    }
    $plafond = $bsRef * $FACTEUR_PROIE[$mode]
    if ($prey -gt $plafond) {
      $opsRegles += PatchChamp $d 'maxPreyBodySize' ([math]::Round($plafond,2).ToString())
    }
  }
}

$nT = EcritPatch 'BodySize' $opsTaille 'Taille corrigee : racine cubique de la masse reelle, plancher 0.10.'
$nV = EcritPatch 'Lifespan' $opsVie    'Longevite corrigee : lois allometriques par clade.'
$nR = EcritPatch 'Regles'   $opsRegles 'Regles strictes R1, R2 et R4 du guide.'

"BodySize.xml : $nT operations   (dont $statFiche depuis tes fiches, $statFormule depuis la formule)"
"Lifespan.xml : $nV operations"
"Regles.xml   : $nR operations"
"TOTAL        : $($nT+$nV+$nR) operations"
