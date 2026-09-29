# Verifie les trois familles que Virginie veut controler :
#   . qui se reproduit avec qui
#   . qui produit du lait -- ou de l'essence, car le boomalope utilise le
#     MEME composant Milkable pour produire du chemfuel
#   . qui produit de la laine -- ou tout materiau qui se tond et repousse :
#     soie, plumes, cuirs speciaux, tous portes par Shearable
#
# Le risque est le meme des deux cotes : mes lois d'echelle sont ancrees sur
# la vache pour le lait et sur le mouton pour la laine. Les appliquer a un
# animal dont le composant produit autre chose reviendrait a calculer une
# quantite de chemfuel avec une loi de production laitiere.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

function Num($s) {
  if ($null -eq $s -or "$s".Trim() -eq '') { return $null }
  $t = "$s" -replace '[^0-9.\-]',''
  if ($t -in @('','-','.')) { return $null }
  $v = 0.0; if ([double]::TryParse($t, [ref]$v)) { return $v }
  $null
}

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

$prod = Import-Csv (Join-Path $Root '3.csv') -Header $ENT3 | Select-Object -Skip 1
$ref  = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$hyb  = Import-Csv (Join-Path $Root 'output\hybridation.csv')
$cust = [xml](Get-Content (Join-Path $Root 'ReequilibrageAnimaux/config/Mod_2587157544_CustomizeAnimals.xml') -Raw)
$patch = Get-Content (Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Productivite.xml') -Raw

$espece=@{}; foreach($r in $ref){$espece[$r.defName]=$r.espece}
$ana = Import-Csv (Join-Path $Root 'reference\analogues_fictifs.csv')
foreach($r in $ana){ if(-not $espece.ContainsKey($r.defName)){$espece[$r.defName]=$r.nom} }

# Ressource produite, lue dans la conf Customize quand elle y figure.
$ressource = @{}
foreach ($a in $cust.SettingsBlock.ModSettings.ChildNodes) {
  if ($a.NodeType -ne 'Element') { continue }
  foreach ($p in $a.ChildNodes) {
    if ($p.NodeType -ne 'Element') { continue }
    if ($p.Name -eq 'Shearable' -and $p.WoolDef) { $ressource["$($a.Name)|laine"] = $p.WoolDef }
    if ($p.Name -eq 'Milkable'  -and $p.MilkDef) { $ressource["$($a.Name)|lait"]  = $p.MilkDef }
  }
}

"=========== 1. REPRODUCTION CROISEE ==========="
$groupes = $hyb | Group-Object groupe
"  animaux dans un groupe : $($hyb.Count)"
"  groupes                : $($groupes.Count)"
$sansGroupe = @($ref | Where-Object { -not ($hyb | Where-Object defName -eq $_.defName) })
"  sans groupe            : $($sansGroupe.Count) (espece unique, aucun partenaire possible)"
""
"  -- tailles de groupe --"
$groupes | Group-Object Count | Sort-Object { [int]$_.Name } | ForEach-Object {
  "     {0,3} membres : {1,3} groupes" -f $_.Name, $_.Count }

"`n=========== 2. LAIT ET ESSENCE ==========="
$laitiers = @($prod | Where-Object { (Num $_.milkYearly) -gt 0 })
"  animaux avec un composant Milkable : $($laitiers.Count)"
$patchesLait = @([regex]::Matches($patch, 'defName="([^"]+)"\]/comps/li\[@Class="CompProperties_Milkable"\]') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
"  patches par le mod                 : $($patchesLait.Count)"
""
"  -- ceux dont la ressource N'EST PAS du lait --"
$suspects = @()
foreach ($l in $laitiers) {
  $n = $espece[$l.defName]; if (-not $n) { $n = $l.defName }
  $res = $ressource["$($l.defName)|lait"]
  if ($n -match 'boom|explos|chemfuel|essence' -or ($res -and $res -notmatch 'Milk')) {
    $suspects += [pscustomobject]@{defName=$l.defName; nom=$n; ressource=$(if($res){$res}else{'(inconnue)'}); patche=$(if($patchesLait -contains $l.defName){'OUI'}else{'non'})}
  }
}
if ($suspects.Count) { $suspects | Format-Table -AutoSize | Out-String } else { "     aucun detecte par le nom" }

"`n=========== 3. LAINE ET MATERIAUX TONDUS ==========="
$laineux = @($prod | Where-Object { (Num $_.woolYearly) -gt 0 })
"  animaux avec un composant Shearable : $($laineux.Count)"
$patchesLaine = @([regex]::Matches($patch, 'defName="([^"]+)"\]/comps/li\[@Class="CompProperties_Shearable"\]') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
"  patches par le mod                  : $($patchesLaine.Count)"
""
"  -- ressources tondues connues, hors laine --"
$autres = @()
foreach ($k in $ressource.Keys) {
  if ($k -notlike '*|laine') { continue }
  $d = $k -replace '\|laine',''
  $r = $ressource[$k]
  if ($r -notmatch 'Wool') {
    $autres += [pscustomobject]@{defName=$d; nom=$espece[$d]; ressource=$r; patche=$(if($patchesLaine -contains $d){'OUI'}else{'non'})}
  }
}
if ($autres.Count) { $autres | Format-Table -AutoSize | Out-String } else { "     aucune ressource non-laine visible dans la conf" }
