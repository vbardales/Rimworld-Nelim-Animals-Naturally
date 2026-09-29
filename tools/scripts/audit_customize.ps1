# Inventorie le fichier de reglages Customize Animals existant.
#
# Ce fichier contient le reglage manuel de Virginie. Toute generation devra
# le FUSIONNER, jamais le remplacer : ses valeurs font autorite, exactement
# comme les 57 fiches font autorite sur la formule.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$src = Join-Path $Root 'allModConfigs\AllModConfigs\Mod_2587157544_CustomizeAnimals.xml'
$x = [xml](Get-Content $src -Raw)
$racine = $x.SettingsBlock.ModSettings

$animaux = @($racine.ChildNodes | Where-Object { $_.NodeType -eq 'Element' -and $_.Name -ne 'Global' })
"animaux deja regles : $($animaux.Count)"
""

# Quelles proprietes sont utilisees, et sur combien d'animaux ?
$props = @{}
foreach ($a in $animaux) {
  foreach ($p in $a.ChildNodes) {
    if ($p.NodeType -ne 'Element') { continue }
    $props[$p.Name] = 1 + $props[$p.Name]
  }
}
"--- proprietes utilisees ---"
$props.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
  "  {0,-24} {1,4} animaux" -f $_.Key, $_.Value
}
""

# Export a plat, pour pouvoir comparer et fusionner ensuite.
$plat = foreach ($a in $animaux) {
  foreach ($p in $a.ChildNodes) {
    if ($p.NodeType -ne 'Element') { continue }
    $val = if ($p.HasAttribute('IsNull')) { '(null)' }
           elseif ($p.ChildNodes.Count -eq 1 -and $p.FirstChild.NodeType -eq 'Text') { $p.InnerText }
           else { $p.InnerXml -replace '\s+', ' ' }
    [pscustomobject]@{ defName = $a.Name; propriete = $p.Name; valeur = $val }
  }
}
$plat | Export-Csv (Join-Path $Root 'output\customize_existant.csv') -NoTypeInformation -Encoding UTF8
"lignes exportees : $($plat.Count) -> output\customize_existant.csv"
