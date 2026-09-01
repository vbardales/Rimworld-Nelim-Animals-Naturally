# Rééquilibrage réaliste des animaux — RimWorld 1.6

Rééquilibre les animaux **entre eux** sur une base biologique, vanilla et mods confondus.
Environ 3 630 opérations de patch, aucun assemblage : que du XML.

Toutes les valeurs descendent d'une seule ancre physique, **la masse réelle de l'espèce en
kilogrammes**.

## La loi fondatrice

```
bodySize = ∛(masse_kg / 70)
```

La taille de RimWorld est une **dimension linéaire**, pas une masse — d'où la racine cubique,
relative à un humain de 70 kg. Validée contre les masses réelles de 54 espèces vanilla :
**erreur médiane de 7 %**.

Un panda roux de 5 kg passe ainsi de 0,25–0,30 (trois valeurs différentes selon le mod d'origine)
à 0,415 pour tous.

## Ce qui est corrigé

| Fichier | Opérations | Objet |
|---|---:|---|
| `Reproduction.xml` | 1 210 | gestation, portées, pontes, œufs fécondés, intervalle d'accouplement |
| `Productivite.xml` | 555 | lait, laine, plumes, fourrure, chitine, essence |
| `Croissance.xml` | 375 | âges de passage entre stades de vie |
| `Lifespan.xml` | 350 | longévité, par lois allométriques calibrées **par clade** |
| `BodySize.xml` | 338 | taille corporelle |
| `Hybridation.xml` | 331 | groupes de croisement, au format DogsMate |
| `Rythme.xml` | 249 | rythme circadien |
| `Regles.xml` | 130 | cohérences dures (voir plus bas) |
| `Forage.xml` | 92 | fourrage, complément d'Animals Forage |

La longévité ne suit pas une courbe unique : un perroquet, une poule et un moineau relèvent de
lois différentes. Un ara vit 55 ans, une poule 7.

### Les règles dures

- La riposte est toujours au moins aussi probable que l'échec d'apprivoisement.
- Un animal dressable ne s'échappe plus de son enclos.
- La taille maximale de proie tient compte du **mode de chasse** : ×1 en solitaire, ×3 en meute,
  ×5 pour les venimeux. Un loup abat plus gros que lui, un cobra avale plus large que lui.

## Principe de prudence

**Une valeur n'est corrigée que si elle s'écarte de plus de 15 % de la cible.** Le réglage manuel
de Ludeon, déjà très bon sur le vanilla, n'est pas écrasé. Les créatures volontairement géantes
gardent la taille voulue par leur auteur, et les prédateurs apex qui portent la sentinelle
`maxPreyBodySize = 99999` la conservent.

**Tous les patches sont conditionnels.** Retirer un mod d'animaux rend les patches correspondants
inertes, sans erreur au chargement.

## Installation

À charger **après tous les mods d'animaux**.

| Quoi | Où |
|---|---|
| ce dossier | `~/.local/share/Steam/steamapps/common/RimWorld/Mods/` |
| `config/Mod_*.xml` | `~/.config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/Config/` |
| `config/userRules.json` | `~/.local/share/RimSort/dbs/` |

Les trois fichiers `Mod_*.xml` sont les réglages générés pour les mods compagnons ; ils écrasent
la configuration existante de ces mods. `userRules.json` porte une règle `loadBottom` qui force ce
mod en dernière position, ce qu'un `loadAfter` ne sait pas exprimer face à une liste de mods
inconnue à l'avance.

## Mods compagnons

Aucun n'est obligatoire — leur absence rend simplement la partie correspondante inerte.

- **Customize Animals** — reçoit ce que le XML ne peut pas exprimer : stades de vie nommés,
  `FenceBlocked` découplé du vagabondage, croisements, capacités spéciales.
- **Dogs mate** — cible des `AnimalGroupDef` d'hybridation.
- **[XND] Nocturnal Animals** — ses réglages priment sur les defs, d'où le fichier de config.
- **Some Like It Rotten** — listes des mangeurs de charogne et d'os.
- **Animals Forage (Continued)** + **Vanilla Expanded Framework** — requis par `Forage.xml`, qui
  complète la couverture d'Animals Forage pour 91 animaux qu'il ne traitait pas. Le fichier est
  gardé par un `PatchOperationFindMod` : sans VEF, il ne s'applique pas.

## Méthode

Les valeurs ne sont pas saisies à la main. Elles sont dérivées par une chaîne de scripts à partir
d'une table de masses réelles (506 espèces), d'une classification en 18 clades, et de 223 analogies
morphologiques pour les créatures fictives. Chaque propriété est ensuite vérifiée par un audit
dédié : cohérence globale, réalisme des portées et des âges, chaîne alimentaire, collisions de
motifs de nommage, surfaces corporelles.

## Licence et attribution

Code et données sous licence MIT (voir `LICENSE`).

Ce mod ne redistribue **aucun contenu tiers** : il ne contient que des opérations de patch qui
modifient des définitions appartenant au jeu de base et aux mods installés chez le joueur.
