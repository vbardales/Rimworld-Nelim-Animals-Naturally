<#
.SYNOPSIS
  Extracts one source of a merged pack into a standalone mod folder.
.DESCRIPTION
  Animal Ark merged two dozen mods: the defs are kept one folder per source, but the textures,
  the sounds and the translations were merged into shared trees. Splitting a source back out is
  therefore not a folder copy - the textures have to be found from the texPaths the defs name.

  What it carries over:
    Defs/<Source>        verbatim
    Patches/<Source>     verbatim, when there is one
    Textures             every file whose path starts with a texPath named in those defs
    Sounds               every clip a SoundDef in those defs names
    Languages            the DefInjected entries whose key belongs to one of those defs

  What it reports rather than guesses:
    - texPaths that match no file at all
    - defNames referenced by these defs but declared by ANOTHER source, which is the one thing
      that silently breaks a split mod: the def loads, its reference resolves to nothing
    - C# classes named in the XML, since the assembly is not split by this script

  Nothing is deleted from the pack. The split is a copy; removing the source from the pack is a
  separate decision, taken once the standalone mod is known to work.
.EXAMPLE
  pwsh -File Split-Source.ps1 -PackDir ..\AnimalArk -Source SlothMod -Out ..\..\tmp\SlothMod
#>
param(
    [Parameter(Mandatory=$true)][string]$PackDir,
    [Parameter(Mandatory=$true)][string]$Source,
    [Parameter(Mandatory=$true)][string]$Out
)

$ErrorActionPreference = 'Stop'
# Chemin absolu obligatoire : les chemins relatifs des textures se calculent en retirant la
# longueur de la racine au chemin complet du fichier, ce qui ne veut rien dire si la racine est
# relative et le fichier absolu. Premiere version de ce script : zero texture trouvee, sans erreur.
$mod = Join-Path (Resolve-Path $PackDir).Path 'Mod'
$defsDir = Join-Path $mod "Defs\$Source"
if (-not (Test-Path $defsDir)) { throw "no such source: $defsDir" }

function Rel($base, $full) { $full.Substring($base.Length).TrimStart('\') }

# ---------- 1. les defs, et les patchs du meme nom ----------
$outDefs = Join-Path $Out "Defs\$Source"
New-Item -ItemType Directory -Force -Path $outDefs | Out-Null
Copy-Item "$defsDir\*" $outDefs -Recurse -Force

$patchDir = Join-Path $mod "Patches\$Source"
$hasPatches = Test-Path $patchDir
if ($hasPatches) {
    $outPatches = Join-Path $Out "Patches\$Source"
    New-Item -ItemType Directory -Force -Path $outPatches | Out-Null
    Copy-Item "$patchDir\*" $outPatches -Recurse -Force
}

# tous les XML de la source, defs + patchs : c'est la matiere de tout le reste
$xmlFiles = @(Get-ChildItem $defsDir -Recurse -File -Filter *.xml)
if ($hasPatches) { $xmlFiles += @(Get-ChildItem $patchDir -Recurse -File -Filter *.xml) }
$allXml = ($xmlFiles | ForEach-Object { [IO.File]::ReadAllText($_.FullName) }) -join "`n"

# ---------- 2. les defNames declares ici, et ceux qu'on cite ----------
$declared = [System.Collections.Generic.HashSet[string]]::new()
foreach ($m in [regex]::Matches($allXml, '<defName>([^<]+)</defName>')) { [void]$declared.Add($m.Groups[1].Value) }

# ---------- 3. les textures, retrouvees depuis les chemins nommes ----------
$texRoot = Join-Path $mod 'Textures'
$texPaths = [System.Collections.Generic.HashSet[string]]::new()
foreach ($tag in 'texPath','iconPath','uiIconPath','texPathSymbol','graphicPath') {
    foreach ($m in [regex]::Matches($allXml, "<$tag>([^<]+)</$tag>")) { [void]$texPaths.Add($m.Groups[1].Value.Trim()) }
}
$allTex = @()
if (Test-Path $texRoot) { $allTex = Get-ChildItem $texRoot -Recurse -File }
$texCopied = 0; $texMissing = @()
foreach ($tp in $texPaths) {
    $prefix = ($tp -replace '/','\')
    $hits = $allTex | Where-Object { (Rel $texRoot $_.FullName) -like "$prefix*" }
    if (-not $hits) { $texMissing += $tp; continue }
    foreach ($h in $hits) {
        $rel = Rel $texRoot $h.FullName
        $dest = Join-Path $Out "Textures\$rel"
        New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
        Copy-Item $h.FullName $dest -Force
        $texCopied++
    }
}

# ---------- 4. les sons nommes par les SoundDef de la source ----------
$sndRoot = Join-Path $mod 'Sounds'
$sndCopied = 0; $sndMissing = @()
if (Test-Path $sndRoot) {
    $clips = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($tag in 'clipPath','clipFolderPath') {
        foreach ($m in [regex]::Matches($allXml, "<$tag>([^<]+)</$tag>")) { [void]$clips.Add($m.Groups[1].Value.Trim()) }
    }
    $allSnd = Get-ChildItem $sndRoot -Recurse -File
    foreach ($c in $clips) {
        $prefix = ($c -replace '/','\')
        $hits = $allSnd | Where-Object { (Rel $sndRoot $_.FullName) -like "$prefix*" }
        if (-not $hits) { $sndMissing += $c; continue }
        foreach ($h in $hits) {
            $rel = Rel $sndRoot $h.FullName
            $dest = Join-Path $Out "Sounds\$rel"
            New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
            Copy-Item $h.FullName $dest -Force
            $sndCopied++
        }
    }
}

# ---------- 5. les traductions dont la cle appartient a cette source ----------
$langRoot = Join-Path $mod 'Languages'
$keysKept = 0
if (Test-Path $langRoot) {
    foreach ($f in Get-ChildItem $langRoot -Recurse -File -Filter *.xml) {
        $lines = [IO.File]::ReadAllLines($f.FullName)
        $keep = New-Object System.Collections.Generic.List[string]
        $kept = 0
        foreach ($l in $lines) {
            $m = [regex]::Match($l, '^\s*<([A-Za-z0-9_]+)\.')
            if ($m.Success) {
                if ($declared.Contains($m.Groups[1].Value)) { $keep.Add($l); $kept++ }
            } else {
                # en-tete, commentaires, balises d'ouverture et de fermeture : toujours gardes
                $keep.Add($l)
            }
        }
        if ($kept -eq 0) { continue }
        $rel = Rel $langRoot $f.FullName
        $dest = Join-Path $Out "Languages\$rel"
        New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
        [IO.File]::WriteAllLines($dest, $keep)
        $keysKept += $kept
    }
}

# ---------- 6. ce qui sort de la source : a traiter a la main ----------
# les defNames cites ici mais declares par une AUTRE source du pack
$otherDeclared = @{}
foreach ($d in Get-ChildItem (Join-Path $mod 'Defs') -Directory) {
    if ($d.Name -eq $Source) { continue }
    foreach ($f in Get-ChildItem $d.FullName -Recurse -File -Filter *.xml) {
        foreach ($m in [regex]::Matches([IO.File]::ReadAllText($f.FullName), '<defName>([^<]+)</defName>')) {
            $otherDeclared[$m.Groups[1].Value] = $d.Name
        }
    }
}
$crossRefs = @{}
foreach ($name in $otherDeclared.Keys) {
    if ($declared.Contains($name)) { continue }
    if ([regex]::IsMatch($allXml, "(?<![A-Za-z0-9_])$([regex]::Escape($name))(?![A-Za-z0-9_])")) {
        $crossRefs[$name] = $otherDeclared[$name]
    }
}
# les classes C# nommees dans le XML : l'assembly n'est pas decoupee ici
$classes = [System.Collections.Generic.HashSet[string]]::new()
foreach ($m in [regex]::Matches($allXml, 'Class="([^"]+)"')) { [void]$classes.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches($allXml, '<(?:thingClass|workerClass|compClass|verbClass|jobClass|driverClass|defName)>([A-Za-z0-9_]+\.[A-Za-z0-9_.]+)</')) { [void]$classes.Add($m.Groups[1].Value) }
$own = @($classes | Where-Object { $_ -notlike 'Patch*' -and $_ -notlike 'RimWorld.*' -and $_ -notlike 'Verse.*' })

# ---------- rapport ----------
Write-Host ""
Write-Host "$Source -> $Out" -ForegroundColor Green
Write-Host ("  defs declares     : {0}" -f $declared.Count)
Write-Host ("  fichiers XML      : {0}{1}" -f $xmlFiles.Count, $(if ($hasPatches) { ' (patchs inclus)' } else { '' }))
Write-Host ("  textures copiees  : {0} pour {1} chemins" -f $texCopied, $texPaths.Count)
Write-Host ("  sons copies       : {0}" -f $sndCopied)
Write-Host ("  cles traduites    : {0}" -f $keysKept)
if ($texMissing) { Write-Host ("  TEXTURES INTROUVABLES : {0}" -f ($texMissing -join ', ')) -ForegroundColor Red }
if ($sndMissing) { Write-Host ("  SONS INTROUVABLES     : {0}" -f ($sndMissing -join ', ')) -ForegroundColor Red }
if ($crossRefs.Count) {
    Write-Host "  REFERENCES VERS UNE AUTRE SOURCE (a resoudre a la main) :" -ForegroundColor Yellow
    foreach ($k in ($crossRefs.Keys | Sort-Object)) { Write-Host ("     {0,-34} declare par {1}" -f $k, $crossRefs[$k]) }
}
if ($own) { Write-Host ("  classes C# citees : {0}" -f ($own -join ', ')) -ForegroundColor Yellow }
Write-Host ""
Write-Host "  Reste a faire a la main : About/, icone et vitrine, LICENSE, ATTRIBUTION, README," -ForegroundColor DarkGray
Write-Host "  CHANGELOG, .gitignore, .gitattributes, le workflow, et l'assembly si des classes" -ForegroundColor DarkGray
Write-Host "  sont citees ci-dessus." -ForegroundColor DarkGray
