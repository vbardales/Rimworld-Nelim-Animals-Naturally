# Deplace <wildness> de <race> vers la stat <Wildness> de <statBases>.
#
# En 1.6 la sauvagerie n'est plus un champ de RaceProperties mais une StatDef, dont
# la valeur par defaut est -1 -- volontairement hors bornes, "so we can catch missing
# wildness stats on animals" dit le commentaire de Core. Une def restee a l'ancienne
# forme perd donc sa sauvagerie et l'animal s'apprivoise comme un rat.
#
# Le remplacement se fait en texte et non par le DOM XML, pour ne pas reformater des
# fichiers entiers la ou deux lignes changent -- et chaque fichier est reecrit avec la
# BOM et les fins de ligne qu'il avait, pour la meme raison.
#
# Attention : toutes les comparaisons de balises passent par [regex], jamais par
# -match, qui est insensible a la casse en PowerShell et confondrait <wildness>
# avec <Wildness>.

param(
    [string]$Root = (Join-Path $PSScriptRoot '..'),
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

$files = Get-ChildItem -Path $Root -Recurse -Filter *.xml |
    Where-Object { $_.FullName -notmatch '\\(obj|bin|\.build|_mods-sources)\\' } |
    Where-Object { [regex]::IsMatch([System.IO.File]::ReadAllText($_.FullName), '<wildness>') }

$totalDefs = 0
$totalFiles = 0

foreach ($file in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $text = [System.IO.File]::ReadAllText($file.FullName)
    if ($hasBom -and $text.Length -gt 0 -and $text[0] -eq [char]0xFEFF) { $text = $text.Substring(1) }

    $crlf = [regex]::Matches($text, "\r\n").Count
    $lf = [regex]::Matches($text, "(?<!\r)\n").Count
    $eol = if ($crlf -ge $lf) { "`r`n" } else { "`n" }

    $script:changed = 0

    # Un bloc <ThingDef ...> ... </ThingDef> a la fois : la valeur doit atterrir dans
    # le statBases de SA def, pas dans celui du voisin.
    $result = [regex]::Replace($text, '(?s)<ThingDef\b.*?</ThingDef>', {
        param($match)
        $block = $match.Value

        # Certaines lignes trainent un commentaire de comparaison ("<!-- emu: 0.95 -->")
        # qui vaut la peine de suivre la valeur plutot que de disparaitre avec elle.
        $wild = [regex]::Match($block, '(?m)^([ \t]*)<wildness>([^<]*)</wildness>([ \t]*<!--.*?-->)?[ \t]*\r?\n')
        if (-not $wild.Success) { return $block }

        $value = $wild.Groups[2].Value.Trim()
        $trail = $wild.Groups[3].Value
        $stripped = $block.Remove($wild.Index, $wild.Length)

        # Deja pourvue de la stat : on ne retire que le champ mort.
        if ([regex]::IsMatch($block, '<Wildness>')) {
            $script:changed++
            return $stripped
        }

        $stats = [regex]::Match($stripped, '(?m)^([ \t]*)<statBases>[ \t]*\r?\n')
        if (-not $stats.Success) { return $block }   # rien a faire sans statBases

        $indent = $stats.Groups[1].Value + '  '
        $line = "$indent<Wildness>$value</Wildness>$trail" + "`r`n"

        $script:changed++
        return $stripped.Insert($stats.Index + $stats.Length, $line)
    })

    if ($script:changed -gt 0) {
        $totalDefs += $script:changed
        $totalFiles++
        if (-not $WhatIf) {
            # On normalise sur la fin de ligne d'origine du fichier.
            $result = $result -replace "`r`n", "`n"
            if ($eol -eq "`r`n") { $result = $result -replace "`n", "`r`n" }
            [System.IO.File]::WriteAllText($file.FullName, $result, (New-Object System.Text.UTF8Encoding($hasBom)))
        }
        Write-Output ("{0,-64} {1} def(s)" -f $file.FullName.Replace($Root, '').TrimStart('\'), $script:changed)
    }
}

Write-Output ''
Write-Output ("{0} def(s) dans {1} fichier(s)" -f $totalDefs, $totalFiles)
