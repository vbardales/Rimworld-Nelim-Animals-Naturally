# Generateur - reglages de Nocturnal Animals.
#
# Pourquoi ecrire les reglages plutot que se contenter des patches :
# ExtendedRaceProperties.Update() sort immediatement si l'animal a deja une
# entree dans AnimalSleepType. Comme le mod en cree une pour chaque animal
# des le premier chargement, nos patches de def seraient ignores. Ecrire le
# dictionnaire directement contourne le probleme au lieu de l'esperer.
#
# Structure relevee sur le fichier reel :
#   <SettingsBlock>
#     <ModSettings Class="NocturnalAnimals.NocturnalAnimalsSettings">
#       <VerboseLogging>...</VerboseLogging>
#       <AnimalSleepType><keys>...</keys><values>...</values></AnimalSleepType>
#
# Les valeurs sont les entiers de l'enum BodyClock.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$CODE = @{ 'Diurnal' = 0; 'Nocturnal' = 1; 'Crepuscular' = 2; 'Cathemeral' = 3 }

# rythmes.csv ne couvre que les animaux dont l'espece est connue (727 sur
# 835). On repart de master.csv pour que le dictionnaire soit exhaustif :
# un animal absent verrait le mod lui creer une entree a lui, et nos patches
# de def n'y changeraient rien.
$connus = @{}
foreach ($r in (Import-Csv (Join-Path $Root 'output\rythmes.csv'))) { $connus[$r.defName] = $r.rythme }
$ryt = foreach ($m in (Import-Csv (Join-Path $Root 'output\master.csv'))) {
  $v = $connus[$m.defName]; if (-not $v) { $v = 'Diurnal' }
  [pscustomobject]@{ defName = $m.defName; rythme = $v }
}

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('<?xml version="1.0" encoding="utf-8"?>')
[void]$sb.AppendLine('<SettingsBlock>')
[void]$sb.AppendLine('	<ModSettings Class="NocturnalAnimals.NocturnalAnimalsSettings">')
[void]$sb.AppendLine('		<VerboseLogging>False</VerboseLogging>')
[void]$sb.AppendLine('		<AnimalSleepType>')
[void]$sb.AppendLine('			<keys>')
foreach ($r in $ryt) { [void]$sb.AppendLine("				<li>$($r.defName)</li>") }
[void]$sb.AppendLine('			</keys>')
[void]$sb.AppendLine('			<values>')
foreach ($r in $ryt) {
  $v = $CODE[$r.rythme]; if ($null -eq $v) { $v = 0 }
  [void]$sb.AppendLine("				<li>$v</li>")
}
[void]$sb.AppendLine('			</values>')
[void]$sb.AppendLine('		</AnimalSleepType>')
[void]$sb.AppendLine('	</ModSettings>')
[void]$sb.AppendLine('</SettingsBlock>')

$dossier = Join-Path $Root 'ReequilibrageAnimaux/config'
New-Item -ItemType Directory -Force $dossier | Out-Null
$dest = Join-Path $dossier 'Mod_2269731409_NocturnalAnimalsMod.xml'
[System.IO.File]::WriteAllText($dest, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

"$($ryt.Count) animaux ecrits -> config\Mod_2269731409_NocturnalAnimalsMod.xml"
$ryt | Group-Object rythme | Sort-Object Count -Descending | ForEach-Object {
  "  {0,-13} {1,4}  (code {2})" -f $_.Name, $_.Count, $CODE[$_.Name]
}
