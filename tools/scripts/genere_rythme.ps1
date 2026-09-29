# Generateur - rythme circadien, au format Nocturnal Animals.
#
# Enum du mod (Source/NocturnalAnimals/Enums/BodyClock.cs) :
#   Diurnal = 0, Nocturnal = 1, Crepuscular = 2, Cathemeral = 3
# Diurnal etant la valeur par defaut, on n'emet AUCUN patch pour les diurnes.
#
# Priorite : les rythmes des 57 fiches de Virginie priment sur toute
# derivation ecologique.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# Ordre important : premier motif qui matche l'emporte.
# On ne liste que Nocturnal et Crepuscular ; tout le reste reste Diurnal.
$REGLES = [ordered]@{
  'Nocturnal' = @(
    # rapaces nocturnes
    'effraie|grand-duc|hibou|chouette|nestor kea',
    # rongeurs et apparentes
    'souris|\brat\b|rat brun|rat domestique|rat a bourse|rat des moissons|rat musque|rat-taupe|rat a criniere|rat-nuage|grand rat|hamster|gerbille|gerboise|campagnol|lemming|rat-kangourou|porc-epic|ragondin|castor',
    # mustelides et procyonides
    'belette|hermine|furet|putois|martre|fouine|zibeline|vison|blaireau|ratel|glouton|pekan|raton laveur|chien viverrin|tanuki',
    # insectivores et xenarthres
    'herisson|taupe|pangolin|tatou|ornithorynque',
    # marsupiaux nocturnes
    'opossum|koala|diable de tasmanie',
    # chiropteres
    'roussette|chauve-souris',
    # petits felins
    # '^bengal$' et non 'bengal' : sans ancrage, "Tigre du Bengale" matchait
    # la race de chat Bengal et partait en nocturne au lieu de crepusculaire.
    'chat de pallas|serval|chat domestique|chat americain|chat tigre|chat noir|chat blanc|maine coon|norvegien|persan|siamois|abyssin|somali|sphynx|munchkin|bleu russe|scottish fold|bobtail japonais|^bengal$|ecaille de tortue',
    # amphibiens, geckos, invertebres
    'ouaouaron|crapaud|grenouille|gecko|blatte|araignee|scorpion|cloporte|moustique|mante religieuse|criquet|fourmi|scarab',
    # divers
    'kiwi|aye-aye|civette|genette|paresseux'
  )
  'Crepuscular' = @(
    # cervides
    'cerf|wapiti|\belan\b|caribou|chevreuil|hydropote|renne',
    # lagomorphes
    'lievre|lapin|pika',
    # canides sauvages
    'loup|renard|fennec|coyote|chacal|dingo|lycaon|dhole',
    # ursides
    'ours ',
    # grands felins
    'lion|tigre|jaguar|leopard|once|puma|panthere|lynx|machairodus|smilodon',
    # bovides sauvages et suides
    'bouquetin|mouflon|argali|gazelle|addax|oryx|bongo|gnou|sanglier|pecari|capybara|chinchilla|kangourou'
  )
}

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

# --- rythmes des 57 fiches, qui font autorite ---------------------------
$FICHES = @{}
$sectionVers = @{ 'DIURNE'='Diurnal'; 'NOCTURNE'='Nocturnal'
                  'CREPUSCULAIRE'='Crepuscular'; 'CATHEMERAL'='Cathemeral' }
$lignes = Get-Content (Join-Path $Root 'Fiche_animaux_v2.md') -Encoding UTF8
$courant = $null; $dansRythmes = $false
foreach ($l in $lignes) {
  if ($l -match '^###\s+RYTHMES') { $dansRythmes = $true; continue }
  if ($dansRythmes -and $l -match '^###\s+[A-Z]' -and $l -notmatch 'RYTHMES') { break }
  if (-not $dansRythmes) { continue }
  if ($l -match '^####\s+(.+?)\s*$') {
    $k = (Normalise $matches[1]).ToUpper()
    $courant = $null
    foreach ($s in $sectionVers.Keys) { if ((Normalise $s).ToUpper() -eq $k) { $courant = $sectionVers[$s] } }
    continue
  }
  if ($courant -and $l.Trim() -and $l -notmatch '^\*\*') {
    foreach ($nom in ($l -split ',')) {
      $n = $nom.Trim() -replace '\(.*?\)',''
      if ($n) { $FICHES[(Normalise $n)] = $courant }
    }
  }
}

# --- rattachement -------------------------------------------------------
$ref = Import-Csv (Join-Path $Root 'reference\masses.csv')
$ana = Import-Csv (Join-Path $Root 'reference\analogues_fictifs.csv')
$especes = @{}
foreach ($r in $ref) { $especes[$r.defName] = $r.espece }
foreach ($r in $ana) { if (-not $especes[$r.defName]) { $especes[$r.defName] = $r.nom } }

$mast = Import-Csv (Join-Path $Root 'output\master.csv')
$ops = @(); $stats = @{}; $rapport = @()

foreach ($m in $mast) {
  $d = $m.defName
  $esp = $especes[$d]; if (-not $esp) { continue }
  $cle = Normalise $esp

  $rythme = $null; $source = 'ecologie'
  if ($FICHES.ContainsKey($cle)) { $rythme = $FICHES[$cle]; $source = 'fiche' }
  if (-not $rythme) {
    $bas = $esp.ToLower()
    foreach ($r in $REGLES.Keys) {
      foreach ($motif in $REGLES[$r]) { if ($bas -match $motif) { $rythme = $r; break } }
      if ($rythme) { break }
    }
  }
  if (-not $rythme) { $rythme = 'Diurnal' }

  $stats[$rythme] = 1 + $stats[$rythme]
  $rapport += [pscustomobject]@{ defName=$d; espece=$esp; rythme=$rythme; source=$source }

  # Diurnal est la valeur par defaut de l'enum : rien a ecrire.
  if ($rythme -eq 'Diurnal') { continue }

  $ops += @"
        <li Class="PatchOperationConditional">
          <xpath>/Defs/ThingDef[defName="$d"]</xpath>
          <match Class="PatchOperationAddModExtension">
            <xpath>/Defs/ThingDef[defName="$d"]</xpath>
            <value>
              <li Class="NocturnalAnimals.ExtendedRaceProperties">
                <bodyClock>$rythme</bodyClock>
              </li>
            </value>
          </match>
        </li>
"@
}

$rapport | Export-Csv (Join-Path $Root 'output\rythmes.csv') -NoTypeInformation -Encoding UTF8
$dest = Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Rythme.xml'
$txt = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`r`n<Patch>`r`n" +
       "  <!-- Rythme circadien, format Nocturnal Animals.`r`n" +
       "       Diurnal etant la valeur par defaut de l'enum, seuls les`r`n" +
       "       nocturnes, crepusculaires et cathemeraux sont ecrits.`r`n" +
       "       Genere par scripts/genere_rythme.ps1 - ne pas editer a la main.`r`n" +
       "`r`n" +
       "       Tout est sous PatchOperationFindMod, et ce n'est pas une precaution`r`n" +
       "       de confort : la classe de l'extension appartient a Nocturnal Animals.`r`n" +
       "       Quand elle est introuvable, le jeu ne se contente pas d'ignorer`r`n" +
       "       l'extension, il abandonne la def entiere. Le 2026-09-10, ce mod`r`n" +
       "       desactive a fait disparaitre 47 animaux vanilla, Muffalo compris,`r`n" +
       "       et le chargement s'est arrete la.`r`n" +
       "`r`n" +
       "       FindMod compare au <name> du mod, pas a son packageId, d'ou les deux`r`n" +
       "       entrees : la reprise de Mlie s'appelle (Continued).`r`n" +
       "`r`n" +
       "       La sequence est sure malgre son abandon au premier echec : une`r`n" +
       "       PatchOperationConditional dont le xpath ne trouve rien rend true,`r`n" +
       "       verifie sur Verse.PatchOperationConditional decompile. Les animaux`r`n" +
       "       des mods absents laissent donc passer les suivants. -->`r`n" +
       "  <Operation Class=`"PatchOperationFindMod`">`r`n" +
       "    <mods>`r`n" +
       "      <li>[XND] Nocturnal Animals</li>`r`n" +
       "      <li>[XND] Nocturnal Animals (Continued)</li>`r`n" +
       "    </mods>`r`n" +
       "    <match Class=`"PatchOperationSequence`">`r`n" +
       "      <operations>`r`n" +
       ($ops -join "`r`n") + "`r`n" +
       "      </operations>`r`n" +
       "    </match>`r`n" +
       "  </Operation>`r`n" +
       "</Patch>`r`n"
[System.IO.File]::WriteAllText($dest, $txt, [System.Text.UTF8Encoding]::new($false))

"rythmes issus des fiches : $(@($rapport | Where-Object source -eq 'fiche').Count)"
"rythmes derives          : $(@($rapport | Where-Object source -eq 'ecologie').Count)"
""
$stats.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object { "  {0,-13} {1,4}" -f $_.Key, $_.Value }
""
"Rythme.xml : $($ops.Count) operations (les diurnes n'en demandent aucune)"
