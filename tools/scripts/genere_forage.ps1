# Generateur - Forage.xml, complement d'Animals Forage (Continued).
#
# Structure copiee sur celle du mod d'origine, verifiee dans
# emipa606/AnimalsForage 1.6/Patches/Vanilla.xml :
#   Operation conditionnelle sur l'animal, <success>Always</success>
#     -> conditionnelle sur la RESSOURCE (BoneItem, AEXP_RawFish... peuvent
#        venir d'un mod absent)
#        -> conditionnelle sur <comps> : Add dedans s'il existe, sinon on cree
#           le noeud <comps> entier.
#
# PIEGE : les deux comps portent les MEMES noms de champs avec une arite
# differente.
#   CompProperties_DigWhenHungry    -> <customThingToDig>X</customThingToDig>
#   CompProperties_DigPeriodically  -> <customThingToDig><li>X</li></...>
# Se tromper d'arite fait echouer la def entiere au chargement.
#
# Le fichier entier est garde par un PatchOperationFindMod sur Vanilla
# Expanded Framework : c'est lui qui fournit la classe VEF.AnimalBehaviours.
# Sans ce garde, la classe ne se resout pas et le jeu jette une erreur par
# animal.
param([string]$Root = "C:\Users\nelim\Documents\rimworld")
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$TICKS_JOUR = 60000   # valeur du mod d'origine : une fouille par jour

# --- Garde de regime, portee par le XPath lui-meme ------------------------
# On ne peut PAS deriver foodType : nos donnees (herbivore + predator) sont
# plus grossieres que ce que les auteurs ont ecrit, et 2 des 91 fourrageurs
# seulement ont leur def sur cette machine. Le test est donc delegue au jeu.
#
# Le predicat cible le cas INCOMPATIBLE : "l'animal declare un foodType, et
# ce foodType ne contient aucun des drapeaux qui rendent la ressource
# mangeable". Quand il matche, on n'ajoute rien.
#
# La formulation "foodType and not(...)" est essentielle : la moitie des defs
# HERITENT foodType d'une abstraite au lieu de le declarer. Sans le premier
# terme, le not() serait vrai pour elles et on les ecarterait toutes a tort.
# Ici, pas de <foodType> => le predicat est faux => nomatch => on applique.
$DRAPEAUX = @{
  'AEXP_RawFish'    = @('Carnivore','Omnivore','Meat','Corpse')
  'Meat_Rat'        = @('Carnivore','Omnivore','Meat','Corpse')
  'Meat_Megaspider' = @('Carnivore','Omnivore','Meat','Corpse')
  'BoneItem'        = @('Carnivore','Omnivore','Meat','Corpse')
  'RawBerries'      = @('Vegetarian','Omnivore','Plant','VegetableOrFruit','Dendrovore')
  'RawFungus'       = @('Vegetarian','Omnivore','Plant','Fungus','VegetableOrFruit')
  'Bamboo'          = @('Vegetarian','Omnivore','Plant','VegetableOrFruit','Dendrovore')
}

function PredicatRegime($res) {
  $f = $DRAPEAUX[$res]
  if (-not $f) { return $null }
  $tests = ($f | ForEach-Object { "contains(foodType,`"$_`")" }) -join ' or '
  return "foodType and not($tests)"
}

$cibles = Import-Csv (Join-Path $Root 'output\cibles_forage.csv')
if (-not $cibles -or $cibles.Count -eq 0) { throw "cibles_forage.csv est vide : lancer derive_forage.ps1 d'abord" }

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('<?xml version="1.0" encoding="utf-8"?>')
[void]$sb.AppendLine('<!-- Complement d Animals Forage (Continued) : ' + $cibles.Count + ' animaux')
[void]$sb.AppendLine('     que le mod ne couvrait pas. Genere par scripts/genere_forage.ps1. -->')
[void]$sb.AppendLine('<Patch>')
[void]$sb.AppendLine('  <Operation Class="PatchOperationFindMod">')
[void]$sb.AppendLine('    <mods>')
[void]$sb.AppendLine('      <li>Vanilla Expanded Framework</li>')
[void]$sb.AppendLine('    </mods>')
[void]$sb.AppendLine('    <match Class="PatchOperationSequence">')
[void]$sb.AppendLine('      <operations>')

function BlocComp($comp, $res, $qte) {
  $s = [System.Text.StringBuilder]::new()
  if ($comp -eq 'periodique') {
    [void]$s.AppendLine('                    <li Class="VEF.AnimalBehaviours.CompProperties_DigPeriodically">')
    [void]$s.AppendLine('                      <customThingToDig>')
    [void]$s.AppendLine('                        <li>' + $res + '</li>')
    [void]$s.AppendLine('                      </customThingToDig>')
    [void]$s.AppendLine('                      <customAmountToDig>')
    [void]$s.AppendLine('                        <li>' + $qte + '</li>')
    [void]$s.AppendLine('                      </customAmountToDig>')
    [void]$s.AppendLine('                      <ticksToDig>' + $TICKS_JOUR + '</ticksToDig>')
    [void]$s.AppendLine('                      <onlyWhenTamed>true</onlyWhenTamed>')
    [void]$s.AppendLine('                    </li>')
  } else {
    [void]$s.AppendLine('                    <li Class="VEF.AnimalBehaviours.CompProperties_DigWhenHungry">')
    [void]$s.AppendLine('                      <customThingToDig>' + $res + '</customThingToDig>')
    [void]$s.AppendLine('                      <customAmountToDig>' + $qte + '</customAmountToDig>')
    [void]$s.AppendLine('                    </li>')
  }
  return $s.ToString().TrimEnd("`r", "`n")
}

$n = 0
foreach ($c in $cibles) {
  $d = $c.defName; $res = $c.ressource; $qte = $c.quantite
  $bloc = BlocComp $c.comp $res $qte
  $n++
  [void]$sb.AppendLine('        <!-- ' + $c.espece + ' -> ' + $res + ' -->')
  [void]$sb.AppendLine('        <li Class="PatchOperationConditional">')
  [void]$sb.AppendLine('          <xpath>/Defs/ThingDef[defName="' + $d + '"]</xpath>')
  [void]$sb.AppendLine('          <success>Always</success>')
  [void]$sb.AppendLine('          <match Class="PatchOperationConditional">')
  [void]$sb.AppendLine('            <xpath>/Defs/ThingDef[defName="' + $res + '"]</xpath>')
  # Garde de regime : si l'animal declare un foodType qui exclut cette
  # nourriture, le predicat matche et on ne pose rien. S'il n'en declare pas,
  # le predicat est faux et on applique.
  $pred = PredicatRegime $res
  [void]$sb.AppendLine('            <match Class="PatchOperationConditional">')
  [void]$sb.AppendLine('              <xpath>/Defs/ThingDef[defName="' + $d + '"]/race[' + $pred + ']</xpath>')
  [void]$sb.AppendLine('              <nomatch Class="PatchOperationConditional">')
  [void]$sb.AppendLine('              <xpath>/Defs/ThingDef[defName="' + $d + '"]/comps</xpath>')
  [void]$sb.AppendLine('              <match Class="PatchOperationAdd">')
  [void]$sb.AppendLine('                <xpath>/Defs/ThingDef[defName="' + $d + '"]/comps</xpath>')
  [void]$sb.AppendLine('                <value>')
  [void]$sb.AppendLine($bloc)
  [void]$sb.AppendLine('                </value>')
  [void]$sb.AppendLine('              </match>')
  [void]$sb.AppendLine('              <nomatch Class="PatchOperationAdd">')
  [void]$sb.AppendLine('                <xpath>/Defs/ThingDef[defName="' + $d + '"]</xpath>')
  [void]$sb.AppendLine('                <value>')
  [void]$sb.AppendLine('                  <comps>')
  [void]$sb.AppendLine($bloc)
  [void]$sb.AppendLine('                  </comps>')
  [void]$sb.AppendLine('                </value>')
  [void]$sb.AppendLine('              </nomatch>')
  [void]$sb.AppendLine('              </nomatch>')
  [void]$sb.AppendLine('            </match>')
  [void]$sb.AppendLine('          </match>')
  [void]$sb.AppendLine('        </li>')
}

[void]$sb.AppendLine('      </operations>')
[void]$sb.AppendLine('    </match>')
[void]$sb.AppendLine('  </Operation>')
[void]$sb.AppendLine('</Patch>')

$dest = Join-Path $Root 'ReequilibrageAnimaux\Mod\Patches\Forage.xml'
[System.IO.File]::WriteAllText($dest, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

# Controle : le XML doit se charger.
try { [xml]$x = Get-Content $dest -Raw; $ok = 'OK' } catch { $ok = "XML INVALIDE : $_" }

"Forage.xml ecrit : $n animaux"
"  validation XML : $ok"
""
$cibles | Group-Object ressource | Sort-Object Count -Descending | ForEach-Object {
  "  {0,-18} {1,3}" -f $_.Name, $_.Count
}
