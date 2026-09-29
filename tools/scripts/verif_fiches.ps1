# Verifie les tailles BTB saisies a la main dans Fiche_animaux_v2.md contre
# la formule du guide : Taille = racine_cubique(masse_kg / 70).
#
# 57 fiches ont ete calculees a la main. Ce script cherche les derives
# arithmetiques : la formule est la source de verite, la saisie peut glisser.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$lignes = Get-Content (Join-Path $Root 'Fiche_animaux_v2.md')
$res = foreach ($l in $lignes) {
  # | Espece | Poids reel (kg) | Taille BTB | Taille defaut | Taille finale | Notes |
  if ($l -notmatch '^\s*\|') { continue }
  $c = ($l -split '\|') | ForEach-Object { $_.Trim() }
  if ($c.Count -lt 7) { continue }
  $espece = $c[1]; $poids = $c[2]; $btb = $c[3]; $final = $c[5]; $notes = $c[6]
  $kg = 0.0; $vBtb = 0.0
  if (-not [double]::TryParse($poids, [ref]$kg))  { continue }
  if (-not [double]::TryParse($btb,   [ref]$vBtb)) { continue }
  if ($kg -le 0) { continue }
  $attendu = [math]::Round([math]::Pow($kg / 70.0, 1.0/3.0), 2)
  [pscustomobject]@{
    espece    = $espece
    masse_kg  = $kg
    btb_saisi = $vBtb
    btb_calcule = $attendu
    ecart_pct = [math]::Round(100.0 * ($vBtb - $attendu) / $attendu, 1)
    taille_finale = $final
    notes     = $notes
  }
}

$res | Export-Csv (Join-Path $Root 'output\verif_fiches.csv') -NoTypeInformation -Encoding UTF8
"$($res.Count) fiches avec un poids exploitable"
$derive = @($res | Where-Object { [math]::Abs($_.ecart_pct) -ge 5 })
"conformes a moins de 5%  : $($res.Count - $derive.Count)"
"derives de 5% ou plus    : $($derive.Count)"
""
$derive | Sort-Object { -[math]::Abs($_.ecart_pct) } |
  Select-Object espece, masse_kg, btb_saisi, btb_calcule, ecart_pct, notes |
  Format-Table -AutoSize | Out-String
