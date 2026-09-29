<#
.SYNOPSIS
  Recense toutes les especes animales fournies par les mods installes.
.DESCRIPTION
  Parcourt chaque mod, retient les ThingDef qui heritent d'une base animale ou portent un
  bloc <race>, et note leur defName, leur libelle, le mod d'origine, sa version effective et
  si l'espece figure deja dans un pack donne. Cherche par libelle autant que par defName :
  beaucoup de mods prefixent leurs defs (ACP_Platypus, NK_Hyena_Spotted...).
.EXAMPLE
  pwsh -File Index-Animals.ps1 -OutCsv animaux.csv
  Import-Csv animaux.csv | Where-Object { $_.Libelle -like '*koala*' }
#>
param(
    [string]$WorkshopDir = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100',
    [string]$LocalDir    = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Mods',
    [string]$PackDir     = 'C:\Users\nelim\Documents\rimworld\AnimalArk',
    # Table dossier de defs -> licence, pour taguer les especes du pack.
    [string]$LicenceMap,
    [string]$OutCsv
)

$inPack = @{}
if (Test-Path $PackDir) {
    foreach ($f in Get-ChildItem "$PackDir\Defs" -Filter *.xml -Recurse -File -ErrorAction SilentlyContinue) {
        foreach ($m in [regex]::Matches((Get-Content -LiteralPath $f.FullName -Raw), '<defName>([^<]+)</defName>')) {
            $inPack[$m.Groups[1].Value] = $true
        }
    }
}


# Tag de licence : quelles especes du pack sont redistribuables. La correspondance se fait par
# dossier de Defs, jamais par rapprochement de noms -- c'est une decision juridique, elle doit
# etre explicite. Une source absente de la table ressort en "?" plutot qu'en "autorise".
$licParSource = @{}
if ($LicenceMap -and (Test-Path $LicenceMap)) {
    foreach ($r in Import-Csv $LicenceMap) { $licParSource[$r.DossierDefs] = $r }
}
$licParDef = @{}
if ($licParSource.Count -and (Test-Path "$PackDir\Defs")) {
    foreach ($sub in Get-ChildItem "$PackDir\Defs" -Directory) {
        $r = $licParSource[$sub.Name]
        foreach ($f in Get-ChildItem $sub.FullName -Filter *.xml -Recurse -File) {
            foreach ($m in [regex]::Matches((Get-Content -LiteralPath $f.FullName -Raw), '<defName>([^<]+)</defName>')) {
                $licParDef[$m.Groups[1].Value] = $(if ($r) { $r } else { $null })
            }
        }
    }
}
$dirs = @()
foreach ($d in @($WorkshopDir, $LocalDir)) { if (Test-Path $d) { $dirs += Get-ChildItem $d -Directory } }

$out = New-Object System.Collections.Generic.List[object]
$i = 0
foreach ($dir in $dirs) {
    $i++; if ($i % 200 -eq 0) { Write-Host "  $i / $($dirs.Count)..." -ForegroundColor DarkGray }
    $about = Join-Path $dir.FullName 'About\About.xml'
    if (-not (Test-Path $about)) { continue }
    try { [xml]$x = Get-Content $about -Raw -Encoding UTF8 } catch { continue }
    $modName = $x.ModMetaData.name
    $vers = @($x.ModMetaData.supportedVersions.li) | Where-Object { $_ -match '^\d+\.\d+$' }
    $maxV = ($vers | Sort-Object { [version]$_ } | Select-Object -Last 1)
    $verDirs = Get-ChildItem $dir.FullName -Directory -ErrorAction SilentlyContinue |
               Where-Object { $_.Name -match '^\d+\.\d+$' } | ForEach-Object { $_.Name }
    $maxF = ($verDirs | Sort-Object { [version]$_ } | Select-Object -Last 1)
    $eff = @($maxV, $maxF) | Where-Object { $_ } | Sort-Object { [version]$_ } | Select-Object -Last 1

    # ne lire qu'une fois chaque def, meme quand le mod la duplique par dossier de version
    $seen = @{}
    foreach ($f in Get-ChildItem $dir.FullName -Filter *.xml -Recurse -File -ErrorAction SilentlyContinue) {
        $t = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $t -or $t -notmatch 'AnimalThingBase|AnimalKindBase|<wildBiomes>|<race>') { continue }
        foreach ($m in [regex]::Matches($t, '(?s)<ThingDef[^>]*>((?:(?!</ThingDef>).)*?)</ThingDef>')) {
            $blk = $m.Value
            if ($blk -notmatch '<race>') { continue }
            $dn = [regex]::Match($blk, '<defName>([^<]+)</defName>')
            if (-not $dn.Success) { continue }
            $name = $dn.Groups[1].Value
            if ($seen[$name]) { continue }
            $seen[$name] = $true
            $lb = [regex]::Match($blk, '<label>([^<]+)</label>')
            $out.Add([pscustomobject]@{
                Libelle = $(if ($lb.Success) { $lb.Groups[1].Value } else { '' })
                DefName = $name
                Mod     = $modName
                Id      = $dir.Name
                Version = $eff
                DansLePack = [bool]$inPack[$name]
                Build      = $(if ($inPack[$name]) { if ($licParDef[$name]) { $licParDef[$name].Build } else { "?" } } else { "" })
                Licence    = $(if ($inPack[$name] -and $licParDef[$name]) { $licParDef[$name].Licence } else { "" })
            })
        }
    }
}

Write-Host ""
Write-Host "=== $($out.Count) especes recensees dans $($dirs.Count) mods ===" -ForegroundColor Cyan
Write-Host ("   deja dans le pack : {0}" -f (@($out | Where-Object DansLePack).Count))
if ($OutCsv) { $out | Sort-Object Libelle | Export-Csv $OutCsv -NoTypeInformation -Encoding UTF8; Write-Host "index : $OutCsv" -ForegroundColor Green }
