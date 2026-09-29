# Verifie les capacites speciales, jamais modifiees jusqu'ici.
#
# Text File.txt est le relevé du mode dev (AnimalSpecialTrainables) : la
# liste, capacite par capacite, des animaux qui la possedent. Il est clé sur
# les noms AFFICHES, en francais et parfois en anglais, d'ou un rattachement
# aux defName par correspondance de nom.
#
# Ce releve permet enfin de controler la regle R3 du guide, restee
# invérifiable jusqu'a present : "Nuzzle actif -> Reconfort oui". La colonne
# nuzzle des tables sources s'etait revelee etre un calcul (12 + 0.6 x
# wildness), donc sans valeur ; mais la conf Customize porte de vrais
# NuzzleMtbHours, et ce fichier porte la vraie liste des "reconforter".
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

function Normalise([string]$s) {
  if (-not $s) { return '' }
  $n = $s.Normalize([System.Text.NormalizationForm]::FormD)
  $sb = [System.Text.StringBuilder]::new()
  foreach ($ch in $n.ToCharArray()) {
    if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch) -ne
        [System.Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($ch) }
  }
  ($sb.ToString().ToLower() -replace '[^a-z0-9]','')
}

# --- lecture du releve ---------------------------------------------------
$capacites = [ordered]@{}
$courante = $null
foreach ($l in (Get-Content (Join-Path $Root 'Text File.txt') -Encoding UTF8)) {
  if ($l -match '^\s*-\s*(.+?)\s*$') {
    if ($courante) { $capacites[$courante].Add($matches[1].Trim()) }
    continue
  }
  $t = $l.Trim()
  if (-not $t -or $t -match '^(UnityEngine|Verse|LudeonTK|\(wrapper)') { continue }
  $courante = $t
  if (-not $capacites.Contains($courante)) { $capacites[$courante] = [System.Collections.Generic.List[string]]::new() }
}

"=== capacites relevees ==="
foreach ($c in $capacites.Keys) { "  {0,-38} {1,4} animaux" -f $c, $capacites[$c].Count }

# --- rattachement aux defName -------------------------------------------
$ref = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$ana = Import-Csv (Join-Path $Root 'reference\analogues_fictifs.csv')
$parNom = @{}
foreach ($r in $ref) { $k = Normalise $r.espece; if ($k -and -not $parNom.ContainsKey($k)) { $parNom[$k] = $r.defName } }
foreach ($r in $ana) { $k = Normalise $r.nom;    if ($k -and -not $parNom.ContainsKey($k)) { $parNom[$k] = $r.defName } }
$mast = Import-Csv (Join-Path $Root 'output\master.csv')
foreach ($m in $mast) { $k = Normalise $m.defName; if ($k -and -not $parNom.ContainsKey($k)) { $parNom[$k] = $m.defName } }

function Def([string]$nom) {
  $k = Normalise $nom
  if ($parNom.ContainsKey($k)) { return $parNom[$k] }
  $null
}

$rattaches = 0; $orphelins = 0
$parCapacite = @{}
foreach ($c in $capacites.Keys) {
  $l = [System.Collections.Generic.List[string]]::new()
  foreach ($n in $capacites[$c]) {
    $d = Def $n
    if ($d) { if (-not $l.Contains($d)) { $l.Add($d) }; $rattaches++ } else { $orphelins++ }
  }
  $parCapacite[$c] = $l
}
"`n  entrees rattachees a un defName : $rattaches"
"  entrees non rattachees          : $orphelins"

# --- REGLE R3 : nuzzle actif implique reconfort ---------------------------
$cust = [xml](Get-Content (Join-Path $Root 'ReequilibrageAnimaux/config/Mod_2587157544_CustomizeAnimals.xml') -Raw)
$nuzzle = @{}
foreach ($a in $cust.SettingsBlock.ModSettings.ChildNodes) {
  if ($a.NodeType -ne 'Element') { continue }
  foreach ($p in $a.ChildNodes) {
    if ($p.NodeType -eq 'Element' -and $p.Name -eq 'NuzzleMtbHours' -and -not $p.HasAttribute('IsNull')) {
      $v = 0.0
      if ([double]::TryParse($p.InnerText, [ref]$v) -and $v -gt 0) { $nuzzle[$a.Name] = $v }
    }
  }
}
# Comparer sur la forme normalisee : le libelle porte un accent, et
# 'reconforter' ne matche pas 'réconforter'.
$reconfort = [System.Collections.Generic.List[string]]::new()
foreach ($c in $parCapacite.Keys) {
  if ((Normalise $c) -match 'reconforter|comfort') { $reconfort = $parCapacite[$c] }
}

"`n=== REGLE R3 du guide : nuzzle actif -> reconfort oui ==="
"  animaux avec un nuzzle actif dans la conf : $($nuzzle.Count)"
"  animaux ayant la capacite reconforter     : $(if($reconfort){$reconfort.Count}else{0})"
$manquants = @($nuzzle.Keys | Where-Object { $reconfort -and -not $reconfort.Contains($_) })
"  nuzzle actif SANS reconfort (violation)   : $($manquants.Count)"
if ($manquants.Count) { $manquants | Sort-Object | ForEach-Object { "     $_" } }

$inverse = @($reconfort | Where-Object { -not $nuzzle.ContainsKey($_) })
"`n  reconfort SANS nuzzle dans la conf        : $($inverse.Count)"
"     (pas une violation : le guide n impose que le sens nuzzle -> reconfort)"

# --- capacites incompatibles avec le dressage ----------------------------
"`n=== capacites portees par des animaux non dressables ==="
$trainab = @{}
foreach ($m in $mast) { $trainab[$m.defName] = $m.trainability }
$incoherents = @()
foreach ($c in $parCapacite.Keys) {
  foreach ($d in $parCapacite[$c]) {
    if ($trainab[$d] -eq 'None') { $incoherents += [pscustomobject]@{defName=$d; capacite=$c} }
  }
}
"  $($incoherents.Count) couples animal/capacite sur un dressage 'None'"
if ($incoherents.Count) {
  $incoherents | Group-Object capacite | Sort-Object Count -Descending | Select-Object -First 8 | ForEach-Object {
    "     {0,-34} {1,3}" -f $_.Name, $_.Count }
}
