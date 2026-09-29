# Extrait les valeurs finales des 57 fiches et les rattache a des defNames.
#
# Ces fiches sont un arbitrage humain : elles PRIMENT sur toute formule.
# Le rattachement se fait par le nom francais d'espece de masses.csv, avec
# normalisation des accents et de la casse. Tout ce qui ne se rattache pas
# est signale plutot que devine.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

function Normalise([string]$s) {
  if (-not $s) { return '' }
  $n = $s.Normalize([System.Text.NormalizationForm]::FormD)
  $sb = [System.Text.StringBuilder]::new()
  foreach ($c in $n.ToCharArray()) {
    if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne
        [System.Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($c) }
  }
  ($sb.ToString().ToLower() -replace '[^a-z0-9]', '')
}

# Correspondances que le nom seul ne permet pas de trouver.
$MANUEL = @{
  'muffalo'='Muffalo'; 'mouton'='Sheep'; 'ara'='Macaw'; 'cerf'='Deer'
  'zebre'='Zebra'; 'ane'='Donkey'; 'lama'='ACPLlama'; 'alpaga'='Alpaca'
  'bouquetin'='Ibex'; 'oie'='Goose'; 'dinde'='Turkey'; 'flamant'='Flamingo'
  'lievre'='Hare'; 'souris'='Mouse'; 'rat'='Rat'; 'ecureuilfauve'='FoxSquirrel'
  'ecureuilroux'='Squirrel'; 'ratonlaveur'='Raccoon'; 'opossum'='ERN_Opossum'
  'herisson'='ERN_Hedgehog'; 'kitfox'='Fox_Kit'; 'oursnoir'='BlackBear'
  'boomalope'='Boomalope'; 'megatherium'='Megasloth'; 'shibainu'='StrayDogs_Shiba'
  'levrierafghan'='SCAfghanHound'; 'doberman'='SCDoberman'; 'perruche'='BU_Budgerigar'
  'perrucheondulee'='BU_Budgerigar'; 'tourterelle'='TurtleDove'; 'roselin'='HouseFinch'
  'roselinfamilier'='HouseFinch'; 'crecerelle'='BB_Kestrel'; 'chouetteeffraie'='BB_BarnOwl'
  'grandeaigrette'='TYR_GreatEgret'; 'aigrettebovine'='TYR_CattleEgret'
  'ouaouaron'='Bullfrog'; 'gecko'='HC_Leopardgecko'; 'cloportegeant'='Nem_Woodlouse'
  'tortuealligator'='HC_Alligatorturtle'; 'rhinocerosblanc'='Rhinoceros'
  'rhincerosnoir'='ACPBlackRhinoceros'; 'rhinocerosnoir'='ACPBlackRhinoceros'
  'rhinoceroslaineux'='RG_WoollyRhinoceros'; 'mammouthlaineux'='RG_WoollyMammoth'
  'sourispoison'='TYR_MousePoison'; 'hamsterpudding'='PuddingHamster'
  'coucoupieaaileesnoires'='TYR_Cuckooshrike_BlackWinged'
  'feeriebleuedesphilippines'='TYR_FairyBluebird_Philippine'
  'echenilleur'='TYR_Triller_WhiteBrowed'; 'groundrunner'='AA_Groundrunner'
  'ursidetaupier'='AA_Groundrunner'; 'gutterhog'='FEB_Gutterhog'
  'guttersow'='FEB_Gutterhog'; 'kallana'='ZEle_Kallana'
  'mamuffalogenerique'='Mamuffalo'; 'mamuffaloperdulost'='WYD_MamuffaloLost'
  'mamuffalodesneigessnow'='WYD_MamuffaloSnow'
  'mamuffalodesboiswoodland'='WYD_MamuffaloWood'
  'mamuffalobois'='WYD_MamuffaloWood'; 'mamuffalolost'='WYD_MamuffaloLost'
  'mamuffaloneiges'='WYD_MamuffaloSnow'
  'moinokensparaken'='pphhyy_Sparaken'; 'moinoken'='pphhyy_Sparaken'
  'aeroglobe'='AA_Aerofleet'; 'aeroglobecolossal'='AA_ColossalAerofleet'
}

$ref = Import-Csv (Join-Path $Root 'reference\masses.csv')
$parNom = @{}
foreach ($r in $ref) { $k = Normalise $r.espece; if (-not $parNom[$k]) { $parNom[$k] = $r.defName } }

$lignes = Get-Content (Join-Path $Root 'Fiche_animaux_v2.md') -Encoding UTF8
$res = foreach ($l in $lignes) {
  if ($l -notmatch '^\s*\|') { continue }
  $c = ($l -split '\|') | ForEach-Object { $_.Trim() }
  if ($c.Count -lt 7) { continue }
  $espece = $c[1]; $kg = 0.0; $finale = 0.0
  if (-not [double]::TryParse($c[2], [ref]$kg)) { continue }
  if (-not [double]::TryParse($c[5], [ref]$finale)) { continue }
  $k = Normalise $espece
  $def = $MANUEL[$k]; if (-not $def) { $def = $parNom[$k] }
  [pscustomobject]@{
    espece = $espece; cle = $k; defName = $def
    masse_kg = $kg; bodySize_fiche = $finale
    notes = $c[6]
  }
}

$ok = @($res | Where-Object { $_.defName })
$ko = @($res | Where-Object { -not $_.defName })
$ok | Export-Csv (Join-Path $Root 'output\overrides_fiches.csv') -NoTypeInformation -Encoding UTF8

"fiches avec taille finale : $($res.Count)"
"rattachees a un defName   : $($ok.Count)"
"non rattachees            : $($ko.Count)"
if ($ko.Count) { ""; "-- a rattacher a la main --"; $ko | ForEach-Object { "  {0,-30} (cle: {1})" -f $_.espece, $_.cle } }
