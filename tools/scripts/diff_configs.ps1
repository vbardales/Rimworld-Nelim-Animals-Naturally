# Compare les reglages generes aux reglages actuels de Virginie, pour
# fournir des cas de test ou la difference est visible immediatement.
# Un animal dont la valeur ne change pas ne prouve rien.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$RYTHME = @{ '0'='Diurne'; '1'='Nocturne'; '2'='Crepusculaire'; '3'='Cathemeral' }
$ancien = Join-Path $Root 'allModConfigs\AllModConfigs'
$neuf   = Join-Path $Root 'ReequilibrageAnimaux/config'

function Dico([string]$fichier) {
  $x = [xml](Get-Content $fichier -Raw)
  $n = $x.SettingsBlock.ModSettings.AnimalSleepType
  $k = @($n.keys.li); $v = @($n.values.li)
  $h = @{}
  for ($i = 0; $i -lt $k.Count; $i++) { $h[$k[$i]] = $v[$i] }
  $h
}

"=========== NOCTURNAL ANIMALS ==========="
$a = Dico (Join-Path $ancien 'Mod_2269731409_NocturnalAnimalsMod.xml')
$b = Dico (Join-Path $neuf   'Mod_2269731409_NocturnalAnimalsMod.xml')
$change = foreach ($k in $b.Keys) {
  if ($a.ContainsKey($k) -and $a[$k] -ne $b[$k]) {
    [pscustomobject]@{ defName=$k; avant=$RYTHME[$a[$k]]; apres=$RYTHME[$b[$k]] }
  }
}
"  entrees actuelles : $($a.Count)   generees : $($b.Count)"
"  valeurs modifiees : $(@($change).Count)"
""
"  -- animaux temoins : ceux dont le rythme change --"
$vedettes = @('Cat','Mouse','Rat','Wolf_Timber','Deer','Flamingo','BB_BarnOwl','Cow','Elephant','Macaw','AEXP_Koala','Tiger')
foreach ($v in $vedettes) {
  $c = $change | Where-Object defName -eq $v
  if ($c) { "     {0,-14} {1,-14} -> {2}" -f $c.defName, $c.avant, $c.apres }
}
$change | Export-Csv (Join-Path $Root 'output\diff_rythme.csv') -NoTypeInformation -Encoding UTF8

""
"=========== SOME LIKE IT ROTTEN ==========="
$xa = [xml](Get-Content (Join-Path $ancien 'Mod_2503519676_SomeLikeItRottenMod.xml') -Raw)
$xb = [xml](Get-Content (Join-Path $neuf   'Mod_2503519676_SomeLikeItRottenMod.xml') -Raw)
foreach ($liste in @('RottenAnimals','BoneAnimals')) {
  $va = @($xa.SettingsBlock.ModSettings.$liste.li)
  $vb = @($xb.SettingsBlock.ModSettings.$liste.li)
  $ajout  = @($vb | Where-Object { $_ -notin $va })
  $retire = @($va | Where-Object { $_ -notin $vb })
  ""
  "  $liste : actuel $($va.Count), genere $($vb.Count)"
  "    ajoutes : $($ajout.Count)   retires : $($retire.Count)"
  if ($ajout.Count)  { "    -- a cocher apres import : {0}" -f (($ajout  | Select-Object -First 6) -join ', ') }
  if ($retire.Count) { "    -- a decocher apres import : {0}" -f (($retire | Select-Object -First 6) -join ', ') }
}
