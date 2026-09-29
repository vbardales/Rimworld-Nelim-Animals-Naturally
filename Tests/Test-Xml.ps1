[CmdletBinding()]
param()

# Offline XML patch-target tests (AUDIT.md, preTest -> done: "Tests XML ecrits, executes et au vert").
# This is not a substitute for Tests/Pickle/: Pickle proves a patch fires in a real, running game;
# this script proves the exact VALUE a patch writes, in milliseconds, with no game and no Workshop
# mods installed. It exists because Pickle's own vocabulary cannot read a value on a name shared
# between a ThingDef and a PawnKindDef (see TESTING.md), and because a fixture here can exercise the
# "target mod present vs absent" boundary directly, which Pickle can only do by staging real mods.
#
# It is a minimal interpreter for the seven PatchOperation classes this mod's ten files actually use
# (checked 2026-09-29: PatchOperationAdd, AddModExtension, Conditional, FindMod, Remove, Replace,
# Sequence). It is not a general RimWorld patch engine: MayRequire, PatchOperationInsert and anything
# else this mod does not use are deliberately unimplemented, and will throw if a future patch adds one.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()

function Assert([bool]$condition, [string]$message) {
    if (-not $condition) { $script:failures += $message }
}

function New-Doc([string]$xml) {
    $doc = New-Object System.Xml.XmlDocument
    $doc.LoadXml($xml)
    return $doc
}

# Minimal vanilla-shaped fixture: one ThingDef per family this mod's patches target by exactly one
# file (see Tests/Pickle/Mod/Pickle/Features/01-baseline.feature for the same choices, so a reader who
# knows that suite recognises these). foodType is left out on purpose: Forage.xml's guard is
# `race[foodType and not(contains(foodType, ...))]`, which is false (no match) when foodType is
# absent, so the fixture naturally takes the "add the comp" branch without asserting diet.
function New-Fixture {
    New-Doc @'
<Defs>
  <ThingDef><defName>Horse</defName><race></race></ThingDef>
  <ThingDef><defName>Cow</defName><race></race></ThingDef>
  <ThingDef><defName>Bear_Grizzly</defName><race></race></ThingDef>
  <ThingDef><defName>Chicken</defName><race></race></ThingDef>
  <ThingDef><defName>Warg</defName><race></race></ThingDef>
  <ThingDef><defName>Duck</defName><race></race></ThingDef>
  <ThingDef><defName>Alphabeaver</defName></ThingDef>
  <ThingDef><defName>Boomrat</defName></ThingDef>
  <ThingDef><defName>Megascarab</defName></ThingDef>
  <ThingDef><defName>Muffalo</defName></ThingDef>
  <ThingDef><defName>RawBerries</defName></ThingDef>
  <!-- Meat_Rat/Meat_Megaspider: the game generates these from the source races at load time, so
       they exist by the time patches run (confirmed in-game, Pickle run e85c, 2026-09-28). -->
  <ThingDef><defName>Meat_Rat</defName></ThingDef>
  <ThingDef><defName>Meat_Megaspider</defName></ThingDef>
  <ThingDef><defName>AA_CrystallineCaracal</defName><race></race></ThingDef>
  <ThingDef><defName>ACPHedgehog</defName><race></race></ThingDef>
  <!-- Doublons.xml: a duplicate-species pack def is not staged anywhere in Tests/Pickle/ (dozens of
       packs, not installed; see TESTING.md "What is not covered"), but the patch's own removal logic
       needs no real mod to prove: a synthetic ThingDef/BiomeDef pair with the same shapes is enough. -->
  <ThingDef><defName>SCWelshCorgi</defName><race><wildBiomes><li>TemperateForest</li></wildBiomes></race></ThingDef>
  <BiomeDef><defName>TemperateForest</defName><wildAnimals><SCWelshCorgi>0.5</SCWelshCorgi></wildAnimals></BiomeDef>
</Defs>
'@
}

function Select-Node($doc, [string]$xpath) {
    return @($doc.SelectNodes($xpath))
}

function Invoke-Operation($op, $doc, [string[]]$activeMods) {
    switch ($op.GetAttribute('Class')) {
        'PatchOperationSequence' {
            foreach ($child in @($op.operations.li)) { Invoke-Operation $child $doc $activeMods }
        }
        'PatchOperationFindMod' {
            # PowerShell's XML adapter auto-collapses a text-only <li> to a plain string when there
            # are several siblings, but leaves it an XmlElement when there is only one: handle both.
            $names = @($op.mods.li | ForEach-Object { if ($_ -is [string]) { $_ } else { $_.InnerText } })
            $hit = $false
            foreach ($n in $names) { if ($activeMods -contains $n) { $hit = $true } }
            if ($hit) { if ($op.match) { Invoke-Operation $op.match $doc $activeMods } }
            elseif ($op.nomatch) { Invoke-Operation $op.nomatch $doc $activeMods }
        }
        'PatchOperationConditional' {
            $nodes = Select-Node $doc $op.xpath
            if ($nodes.Count -gt 0) { if ($op.match) { Invoke-Operation $op.match $doc $activeMods } }
            elseif ($op.nomatch) { Invoke-Operation $op.nomatch $doc $activeMods }
        }
        'PatchOperationAdd' {
            $prepend = ($op.order -eq 'Prepend')
            foreach ($node in Select-Node $doc $op.xpath) {
                foreach ($childValue in @($op.value.ChildNodes)) {
                    $imported = $doc.ImportNode($childValue, $true)
                    if ($prepend -and $node.FirstChild) { [void]$node.InsertBefore($imported, $node.FirstChild) }
                    else { [void]$node.AppendChild($imported) }
                }
            }
        }
        'PatchOperationReplace' {
            foreach ($node in Select-Node $doc $op.xpath) {
                $imported = $doc.ImportNode($op.value.FirstChild, $true)
                [void]$node.ParentNode.ReplaceChild($imported, $node)
            }
        }
        'PatchOperationRemove' {
            foreach ($node in Select-Node $doc $op.xpath) { [void]$node.ParentNode.RemoveChild($node) }
        }
        'PatchOperationAddModExtension' {
            foreach ($node in Select-Node $doc $op.xpath) {
                $extensions = $node.SelectSingleNode('modExtensions')
                if (-not $extensions) {
                    $extensions = $doc.CreateElement('modExtensions')
                    [void]$node.AppendChild($extensions)
                }
                foreach ($childValue in @($op.value.ChildNodes)) {
                    [void]$extensions.AppendChild($doc.ImportNode($childValue, $true))
                }
            }
        }
        default { throw "Test-Xml.ps1 has no interpreter for PatchOperation$($op.GetAttribute('Class')): update the script before trusting its result." }
    }
}

function Apply-Patch([string]$fileName, $doc, [string[]]$activeMods) {
    $patch = [xml](Get-Content -Raw (Join-Path $root "Mod/Patches/$fileName"))
    foreach ($op in @($patch.Patch.Operation)) { Invoke-Operation $op $doc $activeMods }
}

$patchFiles = @(Get-ChildItem (Join-Path $root 'Mod/Patches') -Filter '*.xml' | Sort-Object Name)
Assert ($patchFiles.Count -eq 10) "Expected 10 patch files, found $($patchFiles.Count): patch inventory changed, update this script's file list."
foreach ($file in $patchFiles) { [xml](Get-Content -Raw $file.FullName) | Out-Null }

# --- About.xml contract -----------------------------------------------------------------------
[xml]$about = Get-Content -Raw (Join-Path $root 'Mod/About/About.xml')
Assert ($about.ModMetaData.packageId -eq 'nelim.animalrebalance') 'packageId changed unexpectedly.'
$hardDeps = @($about.ModMetaData.modDependencies.li.packageId)
Assert (($hardDeps.Count -eq 1) -and ($hardDeps[0] -eq 'Mlie.XNDNocturnalAnimals')) 'Nocturnal Animals must stay the one hard dependency.'
$loadAfter = @($about.ModMetaData.loadAfter.li)
foreach ($id in @('Mlie.DogsMate', 'Mlie.SomeLikeItRotten', 'com.abobashark.zoologymod')) {
    Assert ($loadAfter -contains $id) "Missing loadAfter for $id."
}
Assert ($about.ModMetaData.description.Contains('[url=https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally]Source code on GitHub[/url]')) 'GitHub source link missing from description.'

# --- Bare pass: no optional mod active, Nocturnal Animals present ----------------------------
$bareMods = @('[XND] Nocturnal Animals (Continued)')
$doc = New-Fixture
foreach ($file in $patchFiles) { Apply-Patch $file.Name $doc $bareMods }

Assert ($doc.SelectSingleNode("Defs/ThingDef[defName='Horse']/race/baseBodySize").InnerText -eq '1.926') 'BodySize.xml: Horse baseBodySize changed.'
Assert ($doc.SelectSingleNode("Defs/ThingDef[defName='Horse']/race/gestationPeriodDays").InnerText -eq '24.17') 'Reproduction.xml: Horse gestationPeriodDays changed.'
Assert ($doc.SelectSingleNode("Defs/ThingDef[defName='Warg']/race/maxPreyBodySize").InnerText -eq '1.4') 'Regles.xml: Warg maxPreyBodySize changed.'

foreach ($name in @('Alphabeaver', 'Boomrat', 'Megascarab')) {
    $clock = $doc.SelectSingleNode("Defs/ThingDef[defName='$name']/modExtensions/li[@Class='NocturnalAnimals.ExtendedRaceProperties']/bodyClock")
    Assert (($null -ne $clock) -and ($clock.InnerText -eq 'Nocturnal')) "Rythme.xml: $name should get bodyClock Nocturnal."
}
$muffaloClock = $doc.SelectSingleNode("Defs/ThingDef[defName='Muffalo']/modExtensions/li[@Class='NocturnalAnimals.ExtendedRaceProperties']/bodyClock")
Assert (($null -ne $muffaloClock) -and ($muffaloClock.InnerText -eq 'Crepuscular')) 'Rythme.xml: Muffalo should get bodyClock Crepuscular.'

$duckList = @($doc.SelectNodes("Defs/ThingDef[defName='Duck']/race/canCrossBreedWith/li") | ForEach-Object { $_.InnerText })
$expectedDuckList = @('ZDuck_Bufflehead', 'ZDuck_Cayuga', 'ZDuck_EiderPintail', 'ZDuck_GreaterMallard', 'ZDuck_RudderDuck')
Assert (($duckList.Count -eq $expectedDuckList.Count) -and (-not (Compare-Object $duckList $expectedDuckList))) 'Hybridation.xml: Duck canCrossBreedWith changed. Written unconditionally on the animal existing, regardless of whether the listed mods are present: expected, see TESTING.md on the suspected load-error defect (refuted by run f607, 2026-09-28).'

Assert ($null -eq $doc.SelectSingleNode("Defs/ThingDef[defName='SCWelshCorgi']/race/wildBiomes")) 'Doublons.xml: SCWelshCorgi should lose its wildBiomes entry.'
Assert ($null -eq $doc.SelectSingleNode("Defs/BiomeDef[defName='TemperateForest']/wildAnimals/SCWelshCorgi")) 'Doublons.xml: TemperateForest should lose its SCWelshCorgi wildAnimals entry.'

Assert ($null -eq $doc.SelectSingleNode("Defs/ThingDef[defName='Bear_Grizzly']/comps")) 'Forage.xml: Bear_Grizzly must stay untouched without Vanilla Expanded Framework.'
Assert ($null -eq $doc.SelectSingleNode("Defs/ThingDef[defName='AA_CrystallineCaracal']/comps")) 'Forage.xml: AA_CrystallineCaracal must stay untouched without Vanilla Expanded Framework.'

# --- No error on an absent-mod fixture: patches whose target defs don't exist must be no-ops --
$absentDoc = New-Doc '<Defs><ThingDef><defName>Unrelated</defName></ThingDef></Defs>'
foreach ($file in $patchFiles) { Apply-Patch $file.Name $absentDoc $bareMods }
Assert ($absentDoc.SelectSingleNode("Defs/ThingDef[defName='Unrelated']").ChildNodes.Count -eq 1) 'A patch touched an unrelated def when every one of its own targets was absent.'

# --- Rythme.xml is inert, not erroring, without its hard dependency ---------------------------
$noDependencyDoc = New-Fixture
foreach ($file in $patchFiles) { Apply-Patch $file.Name $noDependencyDoc @() }
Assert ($null -eq $noDependencyDoc.SelectSingleNode("Defs/ThingDef[defName='Alphabeaver']/modExtensions")) 'Rythme.xml: bodyClock must not apply without Nocturnal Animals active.'
Assert ($noDependencyDoc.SelectSingleNode("Defs/ThingDef[defName='Horse']/race/baseBodySize").InnerText -eq '1.926') 'BodySize.xml has no FindMod guard and must apply regardless of Nocturnal Animals.'

# --- Forage.xml, Vanilla Expanded Framework active -------------------------------------------
$vefDoc = New-Fixture
foreach ($file in $patchFiles) { Apply-Patch $file.Name $vefDoc ($bareMods + 'Vanilla Expanded Framework') }

function Get-DigComp($doc, [string]$defName) {
    return $doc.SelectSingleNode("Defs/ThingDef[defName='$defName']/comps/li[@Class='VEF.AnimalBehaviours.CompProperties_DigWhenHungry']")
}
$bearComp = Get-DigComp $vefDoc 'Bear_Grizzly'
Assert (($null -ne $bearComp) -and ($bearComp.customThingToDig -eq 'RawBerries') -and ($bearComp.customAmountToDig -eq '10')) 'Forage.xml: Bear_Grizzly should dig RawBerries x10 with VEF active.'
$caracalComp = Get-DigComp $vefDoc 'AA_CrystallineCaracal'
Assert (($null -ne $caracalComp) -and ($caracalComp.customThingToDig -eq 'Meat_Rat') -and ($caracalComp.customAmountToDig -eq '5')) 'Forage.xml: AA_CrystallineCaracal should dig Meat_Rat x5 with VEF active.'
$hedgehogComp = Get-DigComp $vefDoc 'ACPHedgehog'
Assert (($null -ne $hedgehogComp) -and ($hedgehogComp.customThingToDig -eq 'Meat_Megaspider') -and ($hedgehogComp.customAmountToDig -eq '10')) 'Forage.xml: ACPHedgehog should dig Meat_Megaspider x10 with VEF active.'

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Host "FAIL: $_" -ForegroundColor Red }
    throw "$($failures.Count) XML patch-target assertion(s) failed."
}
Write-Host "PASS: $($patchFiles.Count) patch files, About.xml contract, bare/no-dependency/VEF fixtures, absent-mod safety."
