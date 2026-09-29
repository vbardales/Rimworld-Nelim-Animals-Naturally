# Generateur - hybridation, via le champ VANILLA de RimWorld 1.6.
#
# Premiere version, abandonnee : elle etendait les AnimalGroupDef de
# DogsMate. Deux defauts fatals, reveles par son code source :
#   - AnimalGroupDef.pawnKinds attend des noms de PawnKindDef, resolus par
#     DefDatabase.GetNamedSilentFail. J'y mettais des noms de ThingDef, qui
#     different souvent -- echec silencieux, aucun message.
#   - la dependance a DogsMate n'avait pas lieu d'etre.
#
# Version actuelle : on ecrit directement RaceProperties.canCrossBreedWith,
# le champ natif de la 1.6 (une List<ThingDef>, donc des noms de ThingDef).
# DogsMate, s'il est present, se contente de symetriser les listes au
# demarrage -- ce que l'on fait deja nous-memes en ecrivant chaque cote.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# Les ovipares sont conserves : DogsMate annonce ne pas savoir les patcher,
# mais c'est une limite de SES patches, pas forcement du champ vanilla. Au
# pire la liste reste inerte. Les aras Catalina, Arlequin et Shamrock sont
# de vrais hybrides d'aras, il serait dommage de les exclure par principe.

$h = Import-Csv (Join-Path $Root 'output\hybridation.csv')
$groupes = $h | Group-Object groupe

$ETIQUETTES = @{
  'canis'='canides'; 'felis'='chats'; 'equus'='equides'; 'bos'='bovines'
  'panthera'='grands felins'; 'ovis'='ovines'; 'vulpes'='renards'
  'elephant'='elephantides'; 'sus'='suides'; 'camelide'='camelides'
  'rhino'='rhinoceros'; 'ursus'='ursides'; 'rattus'='rats'; 'lapin'='lapins'
  'capra'='caprines'; 'lepus'='lievres'; 'mus'='souris'
  'nyctereutes'='chiens viverrins'; 'ara'='aras'; 'anas'='anatides'
  'galliforme'='galliformes'; 'testudo'='tortues terrestres'
}

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('<?xml version="1.0" encoding="utf-8"?>')
[void]$sb.AppendLine('<Patch>')
[void]$sb.AppendLine('  <!-- Hybridation derivee de la taxonomie reelle, ecrite dans le champ')
[void]$sb.AppendLine('       vanilla race/canCrossBreedWith de RimWorld 1.6. Chaque animal recoit')
[void]$sb.AppendLine('       la liste complete des autres membres de son groupe : les listes sont')
[void]$sb.AppendLine('       donc symetriques par construction.')
[void]$sb.AppendLine('       Genere par scripts/genere_hybridation.ps1 - ne pas editer a la main. -->')

$nOps = 0
foreach ($g in ($groupes | Sort-Object Name)) {
  $membres = @($g.Group | Sort-Object defName)
  if ($membres.Count -lt 2) { continue }
  $lib = $ETIQUETTES[$g.Name]; if (-not $lib) { $lib = $g.Name }
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine("  <!-- $lib : $($membres.Count) especes -->")

  foreach ($m in $membres) {
    $d = $m.defName
    $autres = @($membres | Where-Object { $_.defName -ne $d })
    $liste = ($autres | ForEach-Object { "            <li>$($_.defName)</li>" }) -join "`r`n"
    $base = "/Defs/ThingDef[defName=`"$d`"]/race"
    [void]$sb.AppendLine(@"
  <Operation Class="PatchOperationConditional">
    <xpath>$base/canCrossBreedWith</xpath>
    <match Class="PatchOperationReplace">
      <xpath>$base/canCrossBreedWith</xpath>
      <value>
        <canCrossBreedWith>
$liste
        </canCrossBreedWith>
      </value>
    </match>
    <nomatch Class="PatchOperationConditional">
      <xpath>$base</xpath>
      <match Class="PatchOperationAdd">
        <xpath>$base</xpath>
        <value>
          <canCrossBreedWith>
$liste
          </canCrossBreedWith>
        </value>
      </match>
    </nomatch>
  </Operation>
"@)
    $nOps++
  }
}
[void]$sb.AppendLine('</Patch>')

$dest = Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Hybridation.xml'
[System.IO.File]::WriteAllText($dest, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

"groupes  : $(@($groupes | Where-Object { $_.Count -ge 2 }).Count)"
"especes  : $(@($h).Count)"
"Hybridation.xml : $nOps operations"
