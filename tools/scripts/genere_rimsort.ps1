# Generateur - regles RimSort.
#
# About.xml suffit a exprimer "apres tel mod precis", mais pas "apres TOUS
# les mods d'animaux" : on ne peut pas les enumerer, et la liste changerait
# a chaque ajout. RimSort resout ca avec loadBottom, qui force le mod en
# derniere position quoi qu'il arrive.
#
# Schema releve dans tests/data/dbs/userRules.json du depot RimSort :
#   { "timestamp": <unix>, "rules": { "<packageid>": { ... } } }
# avec loadAfter/loadBefore en dictionnaires de packageid, et
# loadBottom / loadTop en { "value": bool, "comment": str }.
#
# Emplacement du fichier (PlatformDirs, appname RimSort, appauthor false) :
#   Linux   ~/.local/share/RimSort/dbs/userRules.json
#   Windows %LOCALAPPDATA%\RimSort\dbs\userRules.json
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$NOTRE_ID = 'virginie.animalrebalance'

$compagnons = [ordered]@{
  'Mlie.DogsMate'            = 'Dogs mate (Continued)'
  'Mlie.XNDNocturnalAnimals' = '[XND] Nocturnal Animals (Continued)'
  'Mlie.SomeLikeItRotten'    = 'Some Like It Rotten'
  # Zoology couvre vanilla, Alpha Animals et Vanilla Animals Expanded avec
  # son propre pipeline. On se charge apres : ses systemes de comportement
  # restent actifs, nos valeurs s'appliquent partout.
  'com.abobashark.zoologymod' = 'Zoology: Realistic Animal Overhaul'
}

$loadAfter = [ordered]@{}
foreach ($k in $compagnons.Keys) {
  $loadAfter[$k] = [ordered]@{
    name    = $compagnons[$k]
    comment = "Le reequilibrage patche des definitions creees par ce mod."
  }
}

$regle = [ordered]@{
  loadAfter  = $loadAfter
  loadBottom = [ordered]@{
    value   = $true
    comment = "Corrige les animaux de tous les autres mods : doit se charger en dernier."
  }
}

# ConvertTo-Json de PowerShell 5.1 produit une indentation proportionnelle a
# la profondeur, vite illisible. Comme ce fichier doit pouvoir etre fusionne
# a la main dans un userRules.json existant, on le compose nous-memes.
$ts = [int][double]::Parse((Get-Date -UFormat %s))
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('{')
[void]$sb.AppendLine("    `"timestamp`": $ts,")
[void]$sb.AppendLine('    "rules": {')
[void]$sb.AppendLine("        `"$NOTRE_ID`": {")
[void]$sb.AppendLine('            "loadAfter": {')
$i = 0
foreach ($k in $compagnons.Keys) {
  $i++
  $virgule = if ($i -lt $compagnons.Count) { ',' } else { '' }
  [void]$sb.AppendLine("                `"$k`": {")
  [void]$sb.AppendLine("                    `"name`": `"$($compagnons[$k])`",")
  [void]$sb.AppendLine("                    `"comment`": `"$($regle.loadAfter[$k].comment)`"")
  [void]$sb.AppendLine("                }$virgule")
}
[void]$sb.AppendLine('            },')
[void]$sb.AppendLine('            "loadBottom": {')
[void]$sb.AppendLine('                "value": true,')
[void]$sb.AppendLine("                `"comment`": `"$($regle.loadBottom.comment)`"")
[void]$sb.AppendLine('            }')
[void]$sb.AppendLine('        }')
[void]$sb.AppendLine('    }')
[void]$sb.AppendLine('}')

$dossier = Join-Path $Root 'ReequilibrageAnimaux/config'
New-Item -ItemType Directory -Force $dossier | Out-Null
$dest = Join-Path $dossier 'userRules.json'
[System.IO.File]::WriteAllText($dest, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

"regles ecrites -> ReequilibrageAnimaux/config/userRules.json"
"  packageId  : $NOTRE_ID"
"  loadAfter  : $($compagnons.Count) mods"
"  loadBottom : true"
