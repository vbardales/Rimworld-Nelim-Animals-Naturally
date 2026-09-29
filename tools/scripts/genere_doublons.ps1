# Generateur - Doublons.xml : un seul exemplaire par espece a l'etat sauvage.
#
# 58 especes reelles sont livrees sous plusieurs defName, par des mods
# differents : quatre corgis, quatre once, trois pandas roux. Rien n'est
# supprime -- supprimer une def ferait disparaitre les animaux existants au
# chargement d'une sauvegarde et effacerait le contenu d'autres auteurs.
# On coupe seulement leur APPARITION A L'ETAT SAUVAGE.
#
# Deux voies mènent au spawn, il faut couper les deux :
#   - le vanilla passe par BiomeDef/wildAnimals, ou le defName est le NOM DE
#     BALISE : <wildAnimals><Lynx>0.3</Lynx></wildAnimals>. Un seul
#     PatchOperationRemove sur /Defs/BiomeDef/wildAnimals/<defName> les retire
#     de TOUS les biomes d'un coup, mods compris.
#   - les mods passent massivement par ThingDef/race/wildBiomes (333
#     occurrences rien que dans les sources locales).
#
# Qui garde-t-on ? Le vanilla quand il existe -- 11 grappes sur 58. Sinon le
# def du pack qui fournit le plus d'animaux par ailleurs : c'est celui qui a
# le plus de chances de rester installe.
#
# L'animal reste apprivoisable, echangeable et elevable : seule la generation
# sauvage cesse. Retirer ce fichier annule l'effet.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$grappes = Import-Csv (Join-Path $Root 'output\grappes_doublons.csv')
$master  = Import-Csv (Join-Path $Root 'output\master.csv')

# Taille de chaque pack, pour departager les grappes sans vanilla.
$poids = @{}
foreach ($m in $master) {
  $p = '(sans prefixe)'
  if ($m.defName -match '^(ACP|AEXP_|ERN_|CK_|HC_|SC|WD_|StrayDogs_|TVP_|akaNEKO_|aka_|TYR_|BU_|BB_|ZGF_|ZDuck_|ZPT_|ZTT_|ZEle_|VAERoy_|VAEWaste_|RG_|DA_|Nem_|FEB_|Grimstone_|dtf_|rtp_|pphhyy_|SMP_|WYD_|EM_|CCP|DW_|Taggerung_|VV_)') { $p = $Matches[1] }
  if (-not $poids.ContainsKey($p)) { $poids[$p] = 0 }
  $poids[$p]++
}

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('<?xml version="1.0" encoding="utf-8"?>')
[void]$sb.AppendLine('<!-- Un seul exemplaire par espece a l etat sauvage.')
[void]$sb.AppendLine('     Rien n est supprime : les animaux gardes restent apprivoisables et')
[void]$sb.AppendLine('     elevables, seule leur generation sauvage cesse.')
[void]$sb.AppendLine('     Genere par scripts/genere_doublons.ps1. -->')
[void]$sb.AppendLine('<Patch>')

$journal = New-Object System.Collections.Generic.List[object]
$nEcartes = 0

foreach ($g in ($grappes | Group-Object espece)) {
  $membres = $g.Group
  # 1. le vanilla, s'il existe
  $garde = $membres | Where-Object { $_.vanilla -eq 'oui' } | Select-Object -First 1
  $motif = 'vanilla'
  # 2. sinon le pack le plus fourni
  if (-not $garde) {
    $garde = $membres | Sort-Object @{Expression={ $p = $_.prefixe; if ($poids.ContainsKey($p)) { -$poids[$p] } else { 0 } }}, defName | Select-Object -First 1
    $motif = "pack le plus fourni ($($garde.prefixe), $($poids[$garde.prefixe]) animaux)"
  }

  foreach ($m in $membres) {
    $estGarde = ($m.defName -eq $garde.defName)
    $journal.Add([pscustomobject]@{
      espece = $g.Name; defName = $m.defName; prefixe = $m.prefixe
      sort = $(if ($estGarde) { 'GARDE' } else { 'ecarte' }); motif = $(if ($estGarde) { $motif } else { '' })
    })
    if ($estGarde) { continue }
    $nEcartes++
    $d = $m.defName
    [void]$sb.AppendLine('  <!-- ' + $g.Name + ' : ' + $d + ' cede la place a ' + $garde.defName + ' -->')
    [void]$sb.AppendLine('  <Operation Class="PatchOperationConditional">')
    [void]$sb.AppendLine('    <xpath>/Defs/ThingDef[defName="' + $d + '"]/race/wildBiomes</xpath>')
    [void]$sb.AppendLine('    <match Class="PatchOperationRemove">')
    [void]$sb.AppendLine('      <xpath>/Defs/ThingDef[defName="' + $d + '"]/race/wildBiomes</xpath>')
    [void]$sb.AppendLine('    </match>')
    [void]$sb.AppendLine('  </Operation>')
    [void]$sb.AppendLine('  <Operation Class="PatchOperationConditional">')
    [void]$sb.AppendLine('    <xpath>/Defs/BiomeDef/wildAnimals/' + $d + '</xpath>')
    [void]$sb.AppendLine('    <match Class="PatchOperationRemove">')
    [void]$sb.AppendLine('      <xpath>/Defs/BiomeDef/wildAnimals/' + $d + '</xpath>')
    [void]$sb.AppendLine('    </match>')
    [void]$sb.AppendLine('  </Operation>')
  }
}

[void]$sb.AppendLine('</Patch>')

$dest = Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Doublons.xml'
[System.IO.File]::WriteAllText($dest, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
try { [xml]$x = Get-Content $dest -Raw; $ok = 'OK' } catch { $ok = "XML INVALIDE : $_" }

$journal | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $Root 'output\doublons_choix.csv')

"Doublons.xml ecrit"
"  grappes traitees : $(($grappes | Group-Object espece).Count)"
"  gardes           : $(($journal | Where-Object sort -eq 'GARDE').Count)"
"  ecartes du spawn : $nEcartes"
"  validation XML   : $ok"
""
"-- motif de conservation --"
$journal | Where-Object sort -eq 'GARDE' | Group-Object { if ($_.motif -eq 'vanilla') { 'vanilla' } else { 'pack le plus fourni' } } | ForEach-Object {
  "  {0,-22} {1,3}" -f $_.Name, $_.Count
}
