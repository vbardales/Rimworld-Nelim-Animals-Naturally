# Verifie la coherence de chaque animal, toutes sources confondues.
#
# Le mod et la conf Customize sont produits par des generateurs differents,
# a partir de tables differentes. Rien ne garantit qu'ils racontent la meme
# histoire sur un animal donne, ni que cette histoire soit interne-ment
# coherente. Ce script reconstitue, pour chaque animal, l'etat FINAL tel
# qu'il sera en jeu -- valeur d'origine, puis patch XML, puis conf Customize
# qui a le dernier mot -- et lui applique une batterie de controles.
#
# Chaque controle porte sur une contradiction VERIFIABLE, pas sur une
# opinion de gameplay : un juvenile apres l'adulte est un bug, un mouton
# rapide est un choix.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
$inv = [System.Globalization.CultureInfo]::InvariantCulture

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [System.Globalization.NumberStyles]::Float, $inv, [ref]$v)) { return $v }
  $null
}

$JOURS_AN = 60.0
$VITESSE_MAX = 6.5
$FACTEUR_PROIE = @{ 'solitaire'=1.0; 'meute'=3.0; 'venimeux'=5.0 }
$MOTIF_MEUTE    = 'loup|chien|coyote|chacal|dingo|dhole|lycaon|hyene|husky|berger |retriever|doberman|mastiff'
$MOTIF_VENIMEUX = 'serpent|cobra|vipere|crotale|mocassin|couleuvre|scorpion|python|anaconda'

# ---------------------------------------------------------------------------
# Reconstitution de l'etat final
# ---------------------------------------------------------------------------
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$ref  = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$hyb  = Import-Csv (Join-Path $Root 'output\hybridation.csv')
$cust = [xml](Get-Content (Join-Path $Root 'ReequilibrageAnimaux/config/Mod_2587157544_CustomizeAnimals.xml') -Raw)

$espece=@{}; $clade=@{}; $masse=@{}
foreach ($r in $ref) { $espece[$r.defName]=$r.espece; $clade[$r.defName]=$r.clade; $masse[$r.defName]=Num $r.masse_kg }
$groupe=@{}; foreach ($r in $hyb) { $groupe[$r.defName]=$r.groupe }

# Reglages Customize, a plat.
$cs = @{}
foreach ($a in $cust.SettingsBlock.ModSettings.ChildNodes) {
  if ($a.NodeType -ne 'Element' -or $a.Name -eq 'Global') { continue }
  $h = @{}
  foreach ($p in $a.ChildNodes) { if ($p.NodeType -eq 'Element') { $h[$p.Name] = $p } }
  $cs[$a.Name] = $h
}

# Valeurs des patches XML, relues depuis les fichiers generes.
$xmlVal = @{}
foreach ($f in (Get-ChildItem (Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\*.xml'))) {
  $txt = Get-Content $f.FullName -Raw
  foreach ($m in [regex]::Matches($txt, '<xpath>/Defs/ThingDef\[defName="([^"]+)"\]/race/(\w+)</xpath>\s*</match>|<value><(\w+)>([^<]*)</\3></value>')) { }
  foreach ($m in [regex]::Matches($txt, 'defName="([^"]+)"\]/race/(\w+)</xpath>\s*<value><\2>([^<]*)</\2>')) {
    $xmlVal["$($m.Groups[1].Value)|$($m.Groups[2].Value)"] = $m.Groups[3].Value
  }
}

function Final([string]$def, [string]$nomCust, [string]$nomXml, [string]$colMaster) {
  # Customize a le dernier mot, puis le patch XML, puis la valeur d'origine.
  if ($cs.ContainsKey($def) -and $cs[$def].ContainsKey($nomCust)) {
    $e = $cs[$def][$nomCust]
    if (-not $e.HasAttribute('IsNull')) { return Num $e.InnerText }
    return $null
  }
  if ($nomXml -and $xmlVal.ContainsKey("$def|$nomXml")) { return Num $xmlVal["$def|$nomXml"] }
  $g = $mast | Where-Object defName -eq $def | Select-Object -First 1
  if ($g -and $colMaster) { return Num $g.$colMaster }
  $null
}

# Index master pour eviter un balayage par appel.
$iM=@{}; foreach ($r in $mast) { $iM[$r.defName]=$r }
function FinalRapide([string]$def, [string]$nomCust, [string]$nomXml, [string]$colMaster) {
  if ($cs.ContainsKey($def) -and $cs[$def].ContainsKey($nomCust)) {
    $e = $cs[$def][$nomCust]
    if ($e.HasAttribute('IsNull')) { return $null }
    return Num $e.InnerText
  }
  if ($nomXml -and $xmlVal.ContainsKey("$def|$nomXml")) { return Num $xmlVal["$def|$nomXml"] }
  if ($colMaster -and $iM.ContainsKey($def)) { return Num $iM[$def].$colMaster }
  $null
}

# ---------------------------------------------------------------------------
$anomalies = [System.Collections.Generic.List[object]]::new()
function Signale([string]$def, [string]$regle, [string]$detail, [string]$gravite) {
  $anomalies.Add([pscustomobject]@{
    defName=$def; espece=$espece[$def]; regle=$regle; detail=$detail; gravite=$gravite })
}

foreach ($m in $mast) {
  $d = $m.defName
  $nom = if ($espece[$d]) { $espece[$d].ToLower() } else { $d.ToLower() }

  $taille = FinalRapide $d 'BodySize'      'baseBodySize'   'bodySize'
  $vie    = FinalRapide $d 'LifeExpectancy' 'lifeExpectancy' 'lifespan'
  $vit    = FinalRapide $d 'MoveSpeed'     $null            'speed'
  $tmin   = FinalRapide $d 'MinTemperature' $null           'tempMin'
  $tmax   = FinalRapide $d 'MaxTemperature' $null           'tempMax'
  $gest   = FinalRapide $d 'GestationPeriodDays' 'gestationPeriodDays' $null
  $proie  = FinalRapide $d 'MaxPreyBodySize' 'maxPreyBodySize' 'maxPreyBodySize'
  $prix   = FinalRapide $d 'MarketValue'   $null            'marketValue'

  # --- stades de vie, source la plus riche : Customize ---
  $juv = $null; $adu = $null
  if ($cs.ContainsKey($d) -and $cs[$d].ContainsKey('LifeStageAges')) {
    $ls = $cs[$d]['LifeStageAges']
    foreach ($s in $ls.ChildNodes) {
      if ($s.NodeType -ne 'Element') { continue }
      $v = Num $s.MinAge
      if ($s.Name -match 'Juvenile') { $juv = $v }
      elseif ($s.Name -match 'Adult') { $adu = $v }
    }
  }
  if ($null -eq $adu -and $xmlVal.ContainsKey("$d|lifeStageAges")) { }

  # === CONTROLES ===========================================================

  # 1. ordre des stades de vie
  if ($null -ne $juv -and $null -ne $adu -and $juv -ge $adu) {
    Signale $d 'stades inverses' "juvenile $juv >= adulte $adu" 'bloquant'
  }
  # 2. l'age adulte doit rester tres inferieur a l'esperance de vie
  if ($null -ne $adu -and $null -ne $vie -and $vie -gt 0 -and $adu -ge $vie) {
    Signale $d 'adulte apres la mort' "adulte $adu >= longevite $vie" 'bloquant'
  }
  if ($null -ne $adu -and $null -ne $vie -and $vie -gt 0 -and $adu -gt 0.6 * $vie) {
    Signale $d 'maturite tardive' "adulte $adu pour une longevite de $vie" 'suspect'
  }
  # 3. plage de temperature
  if ($null -ne $tmin -and $null -ne $tmax) {
    if ($tmin -ge $tmax) { Signale $d 'plage thermique inversee' "min $tmin >= max $tmax" 'bloquant' }
    elseif (($tmax - $tmin) -lt 15) { Signale $d 'plage thermique etroite' "$tmin a $tmax" 'suspect' }
  }
  # 4. vitesse dans l'echelle du guide
  if ($null -ne $vit) {
    if ($vit -le 0) { Signale $d 'vitesse nulle' "$vit" 'bloquant' }
    elseif ($vit -gt $VITESSE_MAX + 0.01) { Signale $d 'vitesse hors echelle' "$vit pour un plafond de $VITESSE_MAX" 'suspect' }
  }
  # 5. taille
  if ($null -ne $taille) {
    if ($taille -le 0) { Signale $d 'taille nulle' "$taille" 'bloquant' }
    elseif ($taille -lt 0.04) { Signale $d 'taille sous le plancher' "$taille" 'suspect' }
  }
  # 6. gestation : une grossesse ne peut pas depasser la vie entiere
  if ($null -ne $gest -and $null -ne $vie -and $vie -gt 0 -and $gest -gt $vie * $JOURS_AN) {
    Signale $d 'gestation plus longue que la vie' "$gest j pour $vie ans" 'bloquant'
  }
  # 7. proie selon le mode de chasse
  if ($m.predator -eq [char]0x2713 -and $null -ne $proie -and $null -ne $taille -and $proie -ne 99999) {
    $mode = 'solitaire'
    if ($nom -match $MOTIF_MEUTE) { $mode = 'meute' }
    if ($nom -match $MOTIF_VENIMEUX) { $mode = 'venimeux' }
    $plafond = $taille * $FACTEUR_PROIE[$mode]
    if ($proie -gt $plafond * 1.02) {
      Signale $d 'proie trop grosse' "proie $proie > $([math]::Round($plafond,2)) (taille $taille, $mode)" 'suspect'
    }
  }
  # 8. riposte au moins aussi probable que l'echec d'apprivoisement
  $harm = FinalRapide $d 'ManhunterOnDamage' 'manhunterOnDamageChance' $null
  $tame = FinalRapide $d 'ManhunterOnTameFail' $null $null
  if ($null -eq $harm) { $h2 = Num ($m.manhunterDmg -replace '%',''); if ($null -ne $h2) { $harm = $h2 / 100 } }
  if ($null -eq $tame) { $t2 = Num ($m.manhunterTame -replace '%',''); if ($null -ne $t2) { $tame = $t2 / 100 } }
  if ($null -ne $harm -and $null -ne $tame -and $harm -lt $tame - 0.001) {
    Signale $d 'riposte inferieure a l echec' "harm $harm < tame $tame" 'suspect'
  }
  # 9. prix positif
  if ($null -ne $prix -and $prix -le 0) { Signale $d 'prix nul' "$prix" 'suspect' }
}

# --- controles portant sur les listes ------------------------------------
$listes = @('CanCrossBreedWith','CrossAggroWith')
foreach ($nomListe in $listes) {
  $membres = @{}
  foreach ($d in $cs.Keys) {
    if (-not $cs[$d].ContainsKey($nomListe)) { continue }
    $l = @()
    foreach ($li in $cs[$d][$nomListe].ChildNodes) { if ($li.NodeType -eq 'Element') { $l += $li.InnerText } }
    $membres[$d] = $l
    if ($l -contains $d) { Signale $d "$nomListe auto-reference" "se liste lui-meme" 'suspect' }
    if ($l.Count -ne ($l | Sort-Object -Unique).Count) { Signale $d "$nomListe doublons" "$($l.Count) entrees" 'suspect' }
  }
  # symetrie : A liste B implique B liste A
  foreach ($d in $membres.Keys) {
    foreach ($autre in $membres[$d]) {
      if ($autre -eq $d) { continue }
      if (-not $membres.ContainsKey($autre)) {
        Signale $d "$nomListe asymetrique" "$autre ne renvoie pas la reciproque" 'suspect'
      } elseif ($membres[$autre] -notcontains $d) {
        Signale $d "$nomListe asymetrique" "$autre ne le liste pas en retour" 'suspect'
      }
    }
  }
  # coherence de clade
  foreach ($d in $membres.Keys) {
    $c1 = $clade[$d]; if (-not $c1) { continue }
    foreach ($autre in $membres[$d]) {
      $c2 = $clade[$autre]
      if ($c2 -and $c2 -ne $c1) { Signale $d "$nomListe clades melanges" "$d est $c1, $autre est $c2" 'bloquant' }
    }
  }
}

# ---------------------------------------------------------------------------
$anomalies | Export-Csv (Join-Path $Root 'output\coherence.csv') -NoTypeInformation -Encoding UTF8
"animaux examines  : $($mast.Count)"
"anomalies         : $($anomalies.Count)"
$toucheS = @($anomalies | Group-Object defName).Count
"animaux concernes : $toucheS  ($($mast.Count - $toucheS) sans anomalie)"
""
foreach ($g in ($anomalies | Group-Object gravite | Sort-Object Name)) { "  {0,-10} {1,5}" -f $g.Name, $g.Count }
""
"-- par regle --"
$anomalies | Group-Object regle | Sort-Object Count -Descending | ForEach-Object {
  "  {0,-34} {1,5}" -f $_.Name, $_.Count
}
