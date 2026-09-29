# Detecte les collisions de noms entre motifs, comme celle du bobtail.
#
# Tous mes classifieurs fonctionnent en "premier motif qui matche l'emporte".
# Quand un nom d'espece matche DEUX motifs du meme jeu de regles, le second
# est silencieusement perdu -- et si l'ordre est malheureux, l'animal part
# dans la mauvaise categorie sans qu'aucun controle ne s'en apercoive.
#
# C'est ainsi que "Bobtail japonais", un chat, s'est retrouve chez les
# canides : le mot bobtail designe aussi le berger anglais ancien, et le
# motif canis passe avant felis. Le controle mono-clade etait aveugle,
# chats et chiens etant tous deux des mammiferes.
#
# Ce script lit les motifs DANS LES SCRIPTS eux-memes, pour qu'aucune copie
# ne puisse deriver, et signale chaque nom qui en matche plusieurs.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

# Jeux de regles a auditer : fichier, nom de la table, ordre d'application.
$JEUX = @(
  @{ fichier='hybridation.ps1';        table='REGLES_GENRE';    libelle='groupes de genre' }
  @{ fichier='clades.ps1';             table='regles';          libelle='clades' }
  @{ fichier='derive_vitesse_temp.ps1';table='HABITAT_NOM';     libelle='habitats' }
  @{ fichier='derive_vitesse_temp.ps1';table='VITESSE_ESPECE';  libelle='vitesses nommees' }
  @{ fichier='derive_comportement.ps1';table='DRESSAGE_ESPECE'; libelle='dressage nomme' }
)

# Extrait les couples cle/motif d'une table [ordered]@{ ... } d'un script.
function LisTable([string]$chemin, [string]$table) {
  $txt = Get-Content $chemin -Raw
  $i = $txt.IndexOf("`$$table")
  if ($i -lt 0) { return $null }
  $j = $txt.IndexOf('@{', $i); if ($j -lt 0) { return $null }
  # on avance jusqu'a l'accolade fermante correspondante
  $prof = 0; $k = $j
  while ($k -lt $txt.Length) {
    if ($txt[$k] -eq '{') { $prof++ }
    elseif ($txt[$k] -eq '}') { $prof--; if ($prof -eq 0) { break } }
    $k++
  }
  $bloc = $txt.Substring($j, $k - $j + 1)
  $regles = [ordered]@{}
  foreach ($m in [regex]::Matches($bloc, "'([^']+)'\s*=\s*'([^']*)'")) {
    $regles[$m.Groups[1].Value] = $m.Groups[2].Value
  }
  $regles
}

# Recolte TOUS les motifs d'un script : tables et variables simples,
# valeurs texte comme valeurs numeriques. Sert au controle par token.
function LisTousMotifs([string]$chemin) {
  $txt = Get-Content $chemin -Raw
  $out = @{}
  # 'cle' = 'motif'   ou   'motif' = 6.5   ou   $MOTIF_X = 'motif'
  foreach ($m in [regex]::Matches($txt, "'([^']{4,})'\s*=\s*(?:'[^']*'|[\d.]+)")) {
    $out[$m.Groups[1].Value] = $true
  }
  foreach ($m in [regex]::Matches($txt, "=\s*'([^']{4,})'")) {
    $out[$m.Groups[1].Value] = $true
  }
  # on ne garde que ce qui ressemble a un motif d'espece : minuscules,
  # alternatives, pas de chemin de fichier ni de nom de champ XML
  # Ne PAS exclure sur l'antislash : \b est present dans presque tous mes
  # motifs, et le filtrer vidait la recolte. On n'ecarte que ce qui
  # ressemble a un chemin, a du XML ou a un nom de champ.
  $garde = @()
  foreach ($k in $out.Keys) {
    if ($k -match '/|\.csv|\.xml|\.ps1|<|>|^[A-Z]') { continue }
    if ($k -notmatch '[a-z]{3}') { continue }
    $garde += $k
  }
  $garde
}

$ref = Import-Csv (Join-Path $Root 'reference\masses_clades.csv')
$ana = Import-Csv (Join-Path $Root 'reference\analogues_fictifs.csv')
$noms = @{}
foreach ($r in $ref) { $noms[$r.defName] = $r.espece }
foreach ($r in $ana) { if (-not $noms.ContainsKey($r.defName)) { $noms[$r.defName] = $r.nom } }

$total = 0
foreach ($jeu in $JEUX) {
  $chemin = Join-Path $Root "scripts\$($jeu.fichier)"
  $regles = LisTable $chemin $jeu.table
  if (-not $regles -or $regles.Count -eq 0) {
    "  {0,-22} table introuvable dans {1}" -f $jeu.libelle, $jeu.fichier
    continue
  }

  $collisions = @()
  foreach ($d in $noms.Keys) {
    $n = $noms[$d].ToLower()
    if (-not $n) { continue }
    $touches = @()
    foreach ($k in $regles.Keys) { if ($n -match $regles[$k]) { $touches += $k } }
    if ($touches.Count -gt 1) {
      # le premier l'emporte, les suivants sont perdus
      $collisions += [pscustomobject]@{
        defName = $d; espece = $noms[$d]
        retenu  = $touches[0]
        perdus  = ($touches[1..($touches.Count-1)] -join ', ')
      }
    }
  }

  ""
  "=== {0} ({1}, {2} motifs) : {3} collisions ===" -f $jeu.libelle, $jeu.table, $regles.Count, $collisions.Count
  if ($collisions.Count) {
    $collisions | Sort-Object retenu, espece | ForEach-Object {
      "  {0,-30} {1,-24} retenu: {2,-13} perdu: {3}" -f $_.defName, $_.espece, $_.retenu, $_.perdus
    }
  }
  $total += $collisions.Count
}

""
"TOTAL : $total collisions dans les tables ordonnees"

# ---------------------------------------------------------------------------
# CONTROLE PAR TOKEN, tous scripts confondus.
#
# Les tables ordonnees ne sont qu'une partie du probleme : MOTIF_ROTTEN,
# MOTIF_DETRITIVORE, MOTIF_MEUTE et les motifs de capacites speciales sont
# des chaines uniques, sans notion de "premier qui gagne", donc invisibles
# au controle precedent. Un token trompeur y passe pourtant tout autant --
# c'est ainsi que 'ver' attrapait "retriever" et 'caille' attrapait "ecaille".
#
# Signal retenu : un token qui attrape des especes de PLUSIEURS CLADES est
# presque toujours accidentel. Un vrai nom d'animal ne traverse pas les
# clades ; une sous-chaine, si.
# ---------------------------------------------------------------------------
$clades = @{}
foreach ($r in $ref) { $clades[$r.defName] = $r.clade }

$scripts = @('hybridation.ps1','clades.ps1','derive_vitesse_temp.ps1',
             'derive_comportement.ps1','genere_rotten.ps1','genere_mod.ps1')
$suspects = @()
$vus = @{}
foreach ($f in $scripts) {
  $chemin = Join-Path $Root "scripts\$f"
  if (-not (Test-Path $chemin)) { continue }
  foreach ($motif in (LisTousMotifs $chemin)) {
    foreach ($token in ($motif -split '\|')) {
      # NE PAS trim : l'espace final de '\bara ' est significatif, c'est lui
      # qui empeche le motif d'attraper "Araignee". Le supprimer fabriquait
      # une fausse alerte.
      $t = $token
      if ($t.Trim().Length -lt 4) { continue }
      if ($vus.ContainsKey("$f|$t")) { continue }
      $vus["$f|$t"] = $true
      $touches = @()
      foreach ($d in $noms.Keys) {
        $n = $noms[$d].ToLower(); if (-not $n) { continue }
        try { if ($n -match $t) { $touches += $d } } catch { }
      }
      if ($touches.Count -lt 2) { continue }
      $cl = @($touches | ForEach-Object { $clades[$_] } | Where-Object { $_ } | Sort-Object -Unique)
      if ($cl.Count -gt 1) {
        $ex = @($touches | Select-Object -First 4 | ForEach-Object { "$($noms[$_]) [$($clades[$_])]" })
        $suspects += [pscustomobject]@{
          fichier = $f; token = $t; clades = ($cl -join ', ')
          exemples = ($ex -join ' | ')
        }
      }
    }
  }
}

""
"=== tokens attrapant plusieurs clades : $($suspects.Count) ==="
if ($suspects.Count) {
  $suspects | Sort-Object fichier, token | ForEach-Object {
    "  [{0,-24}] '{1}'" -f $_.fichier, $_.token
    "      clades : {0}" -f $_.clades
    "      touche : {0}" -f $_.exemples
  }
}
