# GUIDE COMPLET - GÉNÉRATION FICHES ANIMAUX RIMWORLD

## Vue d'ensemble

Création de fiches animaux RimWorld équilibrant **réalisme biologique** ("by the book") et **gameplay cohérent** (échelles des défauts du jeu).

### Priorités d'arbitrage (dans l'ordre)
1. **Cohérence globale** (hiérarchies inter-espèces)
2. **Réalisme biologique** (by the book)
3. **Échelles gameplay** (défauts)
4. **Équilibre jeu** (productions, difficultés)

### Dressage vs Intelligence
**NE PAS CONFONDRE :**
- **Dressage** = capacités entraînables (gameplay)
- **Intelligence biologique** = QI naturel (réalisme)
- Un animal très intelligent biologiquement peut avoir dressage none (ex: rhinos)

---

## MÉTHODOLOGIE EN 3 PHASES

### Phase 1 : FICHE INITIALE (by the book)
Claude propose des valeurs basées sur la **biologie réelle** de l'animal.

### Phase 2 : AJOUT DÉFAUTS
Virginie fournit les **valeurs par défaut** du jeu RimWorld.

### Phase 3 : FICHE FINALE (compromis)
Claude arbitre entre BTB et défauts selon les priorités.

---

## FORMULE DE TAILLE

```
Taille = ³√(masse_kg / 70)
```

**Corrélation avec défauts : 71%**

### Quand appliquer la formule BTB ?
- ✅ Animaux réels avec poids connu
- ✅ Cohérence hiérarchie (mouton < cerf < éléphant)
- ⚠️ Gameplay si défaut très éloigné → flag "GAMEPLAY"
- ❌ Créatures fictives → estimer poids ou garder défaut

### Exemples de calcul
| Espèce | Poids réel (kg) | Taille BTB | Défaut | Final |
|--------|-----------------|------------|---------|-------|
| Mouton | 70 | 1.00 | 0.75 | 1.00 |
| Rhinocéros blanc | 2000 | 3.06 | 3.0 | 3.06 |
| Mégathérium | 4000 | 3.85 | 4.0 | 3.85 |
| Mammouth laineux | 6000 | 4.40 | 4.2 | 4.40 |

---

## PARAMÈTRES DÉTAILLÉS

### (1) Identité / comportement (core)

#### Taille
- Utiliser formule ³√(m/70) si poids connu
- Référence échelle défauts pour créatures fictives

#### Vitesse de déplacement (c/s)
**Échelle de référence :**
- Tortue-alligator : 1.2 (le plus lent)
- Cloporte géant : 2.5
- Ursidé taupier : 2.8 (fouisseur)
- Muffalo/Mamuffalos : 3.5 (gros herbivores)
- Humain : 4.6 (référence)
- Shiba Inu : 5.0 (chien moyen)
- Tourterelle : 5.5 (oiseau)
- Crécerelle : 6.0 (rapace agile)
- Échenilleur : 6.5 (petit oiseau rapide)
- Zèbre : 6.5 (équidé rapide)

#### Intelligence / Dressage
| Dressage | Définition | Exemples |
|----------|------------|----------|
| **none** | Non dressable | Mouton, Flamant, Cerf, Tourterelle |
| **inter** (intermediate) | Dressable basique | Perruche, Shiba, Rat, Opossum |
| **av** (advanced) | Dressable avancé | Ara, Doberman, Alpaga, Ours |

**⚠️ RÈGLE STRICTE : Dressage inter/av → Roaming = 0**

#### Réconfort humain
**Nuzzle → Réconfort OUI** (règle stricte)
- Si nuzzle actif (48h, 60h, 72h...) → Réconfort humain = **oui**
- Si nuzzle off → Réconfort humain = **non** (sauf cas gameplay)

#### Roaming delay
**RÈGLE STRICTE :**
- **Dressage inter/av** → Roaming **0** (toujours)
- **Dressage none** → Roaming **2d-4d** selon comportement

**Signification du roaming :**
- Représente la **fréquence d'échappement** des enclos standard
- Ne représente PAS le nomadisme général

**Échelle pour dressage none :**
- 2d : Herbivores moyens, oiseaux non-volants
- 3d : Petits animaux, oiseaux terrestres, tortues
- 4d : Oiseaux très territoriaux (tourterelle)

#### Enclos
**Qui peut être contenu ?**
- ✅ Herbivores domestiques/semi-domestiques none
- ✅ Gutterhog (fouisseur mais dressé inter)
- ✅ Montures (alpaga, lama, âne même si av)
- ❌ Animaux dressés inter/av (sauf exceptions gameplay)
- ❌ Oiseaux volants
- ❌ Prédateurs sauvages

#### Domptage (%)
**Échelle défauts :**
- 0-30% : Domestiques (mouton, oie, dinde, gutterhog)
- 40-60% : Semi-domestiques (aigrette, certains oiseaux)
- 65-75% : Sauvages dociles (alpaga, lama, âne, crécerelle)
- 80-90% : Difficiles (cerf, bouquetin, flamant, rhinos)
- 90-97% : Très difficiles (ours, mégathérium, mammouth)

#### Lifespan
**Échelle défauts :**
- Petits rongeurs : 4-8 ans
- Petits oiseaux : 8-15 ans
- Chiens : 12-15 ans
- Herbivores moyens : 12-18 ans
- Grands rapaces/mammifères : 15-25 ans
- Mégafaune : 45-60 ans (éléphant, mammouth)

**Arbitrage :** Respecter BTB sauf si défaut cohérent avec espèce similaire

#### Températures confort (°C)
**MAX - Échelle défauts :**
- Tempéré : 35-38°C
- Désertique/Tropical : 40-50°C

**MIN - Échelle défauts :**
- Tropical strict : 5-10°C
- Tempéré : -10 à 0°C
- Polaire/Montagne : -25 à -50°C

#### Tame fail / Harm
**RÈGLE STRICTE : Harm ≥ Tame fail (toujours)**

**Échelle Tame fail :**
- Dociles : 2-8%
- Moyens : 10-20%
- Agressifs : 25-30%

**Échelle Harm :**
- Pacifiques : 8-25%
- Défensifs : 30-50%
- Agressifs : 60-90%

#### Prédateur / Max proie
**Formule Max proie :**
```
Max proie = 0.7 à 1.0 × taille du prédateur
```

**Exemples :**
| Prédateur | Taille | Max proie |
|-----------|--------|-----------|
| Kit fox | 0.42 | 0.30 |
| Crécerelle | 0.19 | 0.15 |
| Shiba Inu | 0.50 | 0.35 |
| Doberman | 0.83 | 0.60 |
| Ours noir | 1.86 | 1.30 |
| Mammouth (si préd) | 4.40 | 3.0-4.0 |

**Qui est prédateur ?**
- ✅ Carnivores actifs (ours, renards, rapaces)
- ✅ Omnivores opportunistes avec chasse (ratons, rats)
- ❌ Charognards purs (vautours, cloportes)
- ❌ Insectivores (aigrettes, écureuils sauf si omnivores)

#### Nuzzle interval
**Échelle :**
- 48h : Très affectueux (ara, doberman, rat)
- 60h : Affectueux moyen (tourterelle)
- 72h : Affectueux léger (shiba, perruche, souris, opossum, lama)
- **off** : Pas affectueux (tous les autres)

---

### (2) Reproduction / hybridation

#### Hybridation
**Qui hybride ?**
- ✅ Équidés (âne × cheval, âne × zèbre)
- ✅ Camélidés (alpaga × lama)
- ✅ Rhinocéros (blanc × noir × laineux)
- ✅ Muffalo famille (muffalo × mamuffalo variants)
- ✅ Chiens (races entre elles)
- ✅ Souris (souris × souris-poison)
- ❌ Familles trop éloignées

#### Gestation / Ponte
**Oiseaux - Interval ponte :**
- **1 couvée/an (espèces naturelles)** : 60d RW
  - Ara, Flamant, Grande aigrette, Crécerelle, Coucou-pie, Féerie bleue, Échenilleur
- **2-3 couvées/an** : 20-25d
  - Tourterelle (25d), Roselin (20d)
- **Pondeuses domestiques** : 10-15d
  - Dinde (10d), Oie (15d), Perruche (15d)

**Jours éclosion :** 2.5-5d selon taille

**Œufs / Max fécondés :**
- Grands oiseaux : 1-4 œufs, 1-3 fécondés
- Moyens : 2-6 œufs, 2-5 fécondés
- Petits : 3-8 œufs, 4-6 fécondés
- Volaille : 6-15 œufs, 8-12 fécondés

**Mammifères - Gestation :**
- BTB en jours RW basé sur réalité
- Compromis si défaut très différent

**Portée :**
- Grands mammifères : 1-2
- Moyens : 1-4
- Petits rongeurs : 4-10

#### Âges (y RW)
**Juvenil** : ~10-20% de lifespan BTB
**Adult** : ~15-30% de lifespan BTB

---

### (3) Productivité

#### Lait
**Échelle défauts :**
- Gros producteurs : 18/3d (mégathérium)
- Moyens : 12-15 / 2-3d
- (Vaches à venir, échelle à revoir)

#### Laine/Poils
**Échelle défauts :**
- Gros laineux : 140-200 / 15-20d (mamuffalos, mégathérium)
- Moyens : 70-120 / 15d
- Petits/faibles : 15-50 / 10-25d

#### Plumes
**Échelle :**
- Gros oiseaux : 15-20 / 15d
- Moyens : 5-12 / 15-20d
- Petits : 2-6 / 20-25d

---

### (4) Rythme

| Rythme | Définition | Exemples |
|--------|------------|----------|
| **Diurne** | Actif jour | Aigrettes, Crécerelle, Écureuil, Coucou-pie, Féerie bleue |
| **Nocturne** | Actif nuit | Tortue-alligator, Cloporte, Kit fox, Raton-laveur, Ouaouaron, Gecko, Hamster |
| **Crépusculaire** | Aube/crépuscule | Lièvre, Cerf, Bouquetin |
| **Cathémeral** | Flexibilité jour/nuit | Flamant rose |

---

### (5) Alimentation

#### Rotten
**Oui** : Charognards, omnivores opportunistes, détritivores
**Non** : Herbivores, insectivores stricts, rapaces chasseurs

#### Os
**Oui** : Carnivores, charognards, omnivores avec composante carnée
**Non** : Herbivores, frugivores, insectivores, détritivores végétaux

**Exemples :**
| Catégorie | Rotten | Os |
|-----------|--------|-----|
| Charognards carnivores | oui | oui |
| Détritivores végétaux | oui | non |
| Rapaces chasseurs | non | oui |
| Herbivores | non | non |

---

## LISTE DRESSAGE + ROAMING/ENCLOS (référence complète)

### NONE
| Espèce | Roaming | Enclos |
|--------|---------|--------|
| Mouton | 3d | oui |
| Dinde | 3d | oui |
| Oie | 3d | oui |
| Boomalope | 2d | oui |
| Cerf | 2d | oui |
| Bouquetin | 2d | oui |
| Muffalo, Mamuffalos (tous) | 2d | oui |
| Zèbre | 2d | oui |
| Flamant | 2d | oui |
| Tourterelle | 4d | non |
| Roselin | 2d | non |
| Souris, Souris-poison | 2d | non |
| Hérisson | 3d | non |
| Grande aigrette | 3d | non |
| Rhinocéros (blanc, noir, laineux) | 2d | non |
| Tortue-alligator | 3d | non |

### INTER
| Espèce | Roaming | Enclos |
|--------|---------|--------|
| Perruche | 0 | non |
| Échenilleur | 0 | non |
| Shiba Inu | 0 | non |
| Lévrier | 0 | non |
| Kit fox | 0 | non |
| Gutterhog | 0 | oui |
| Rat | 0 | non |
| Opossum | 0 | non |
| Raton-laveur | 0 | non |
| Écureuil | 0 | non |
| Groundrunner | 0 | non |
| Lièvre | 0 | non |
| Mégathérium | 0 | non |
| Crécerelle | 0 | non |
| Coucou-pie | 0 | non |
| Ouaouaron | 0 | non |
| Gecko | 0 | non |
| Féerie bleue | 0 | non |
| Hamster pudding | 0 | non |
| Chouette effraie | 0 | non |

### AV
| Espèce | Roaming | Enclos |
|--------|---------|--------|
| Ara | 0 | non |
| Kallana | 0 | non |
| Humain | 0 | non |
| Alpaga | 0 | oui |
| Lama | 0 | oui |
| Âne | 0 | oui |
| Doberman | 0 | non |
| Ours noir | 0 | non |
| Mammouth laineux | 0 | non |
| Moinoken | 0 | oui |

---

## RÈGLES IMPORTANTES

### Règles strictes (jamais violées)
1. **Harm ≥ Tame fail** (toujours)
2. **Dressage inter/av → Roaming 0** (toujours)
3. **Nuzzle actif → Réconfort oui** (toujours)
4. **Max proie ≤ 1.0 × taille prédateur** (toujours)

### Règles BTB (prioritaires sauf gameplay)
1. Formule taille ³√(m/70) pour animaux réels
2. Interval ponte 60d pour 1 couvée/an
3. Prédateur basé sur régime alimentaire
4. Températures cohérentes avec habitat naturel

### Arbitrages gameplay acceptables
1. Tailles fictives si créature de mod
2. Productions augmentées pour utilité
3. Domestication facilitée si espèce-clé
4. Températures élargies pour accessibilité

---

## FLAGS & NOTES SPÉCIALES

### Flag "GAMEPLAY"
Appliqué quand défaut RimWorld s'éloigne fortement du BTB pour raisons de gameplay :
- Lièvre : taille 0.2 (défaut) vs 0.38 (BTB)
- Guttersow : taille 1.7 (défaut) vs 1.13 (BTB)
- Moinoken : taille 2.0 (défaut - monture) vs 0.42 (BTB)

### Flag "FICTIF"
Créatures de mod sans équivalent réel :
- Aéroglobe, Aéroglobe colossal
- Mamuffalo (variants)
- Boomalope
- Kallana

### Corrections rétroactives
Quand un nouvel animal révèle une incohérence dans l'échelle :
- Grande aigrette : ponte 45d → 60d (règle 1 couvée/an)
- Aigrette bovine : ponte → 60d
- Alpaga/Lama/Âne : roaming 2d → 0 (règle dressage av)

---

✅ **GUIDE COMPLET ET DÉFINITIF**
