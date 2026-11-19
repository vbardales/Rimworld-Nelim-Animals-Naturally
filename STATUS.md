---
mod: "Nelim's Animals, Naturally"
packageId: nelim.animalsnaturally
repo: https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally
visibility: public
detached: yes
workflow_stage: ecosystem
stage_meaning: "stage holds the 6-code field; workflow_stage carries the exact 12-state chain position, same value from preTest on. l10n→preTest crossed 2026-09-29 (see git history for detail). preTest→done is a static gate (AUDIT.md): automated + XML tests rerun (not read from an old report), Pickle suites written or their absence justified in writing. No in-game run is required for this gate (AUDIT.md's explicit 2026-09-21 clarification); that belongs to done→tested. Crossed 2026-09-30: Tests/Test-Xml.ps1 rejoué, vert (10 patch files, About.xml contract, fixtures, absent-mod safety); 5 Pickle feature files exist under Tests/Pickle/, coverage documented in TESTING.md."
licence: open
licence_at: "MIT for original rebalancing work; third-party definitions are not redistributed"
upstream_mod_remotes:
  - https://github.com/emipa606/XNDNocturnalAnimals
  - https://github.com/emipa606/DogsMate
  - https://github.com/emipa606/SomeLikeItRotten
  - https://github.com/emipa606/AnimalsForage
  - https://github.com/Vanilla-Expanded/VanillaExpandedFramework
  # Zoology has no GitHub link in its About.xml (checked 2026-09-28): N/A
upstream_synced: 2026-11-13 XNDNocturnalAnimals@9049d53; DogsMate@52c1478; SomeLikeItRotten@a7191e9; AnimalsForage@b0bc71d; VanillaExpandedFramework@4d68a92 (Zoology: Workshop only, no git repository, version not compared)
dependencies: partial
workshop_required_items: n/a, not released yet
showcase: partial
settings_audit: not_applicable
localization: not_applicable
translation_en: not_applicable
translation_fr: not_applicable
tested_on: RimWorld 1.6 (WSL headless Pickle), Mod/ patches unchanged since e656137; green on 313d491..88b3028: 01-baseline sans-facultatifs-r2, 03 dogsmate, 05 zoology-slow2, 04 rotten-slow2, 06 valeurs-r2 (2/2), 02 avec-vef-r7 (7/7)
workshop: 3811381865 (private prepublication 0.1.0, 2026-10-01; item not public)
remaining:
  - open 2026-11-19 replay-audit (ledger .replays/AnimalsNaturally-20261119.tsv): stage back from shootGallery[1.0.0] to ecosystem. 2.g open (mod never staged at ecosystem), 2.h open (ecosystem_line absent, report docs/inventory/ecosystem-steam/AnimalsNaturally.md dated 2026-11-13, no Ecosystem summary in STATUS). Next: run /mod-workflow:ecosystem (ECOSYSTEM? to PiI, short delta), copy the summary here, write ecosystem_line 1.0, then replay; sections 3 to 9 are not replayed yet. Gallery work below is unchanged and waits (shot 5 REDO, PiT asked, galerie-45 kept in Inbox).
  - open 2026-11-19 galerie-45 (ticket 20261119-094926-703-ed3f, tree 47afc91) GREEN, 1 passed 0 failed, exit passed, 45 s, read from the Inbox (no RUN_DONE seen). Capture opened full and at 268 px: floor still bright light green (DAY), no lamp pool, brazier and two torches flames only; cat walks East readable, Nelim faces East beside the milk bucket (milk reads). Shot 5 REDO (night absent). Told PiT with the Inbox path, asked the order of refresh and dim steps; evidence Tests/Pickle/Inbox/galerie-45 kept until PiT answers, then delete with the capture. Next: on PiT answer recompose shot 5 (ceiling 0.1 or the step order) and refile alone.
  - open 2026-11-19 galerie-44 (0657) GREEN, 1 passed 0 failed, exit passed, 53 s; dim step "light of the map dimmed to at most 0.3" played, no Harmony error, Player.log "[light] 5 reads of the glow are patched". Capture opened full and at 268 px: tatami now dark grey-green (night reads partly), cat white and grey walks East (about 40 px at 268 px, readable), Nelim faces West, Milk bucket beside her head (carried not clear), blue brazier and two torches with bright flames but NO light pool on the floor (ceiling clamps the lamp glow too). score-gallery shot 5: REDO (understanding 3.5: night partly, lamp not lit-looking, milk carried partly; adequacy 3: lamp glow absent, carried partly, night partly; image 4; decoration 4). Capture and evidence deleted. Asked NPT: lamp and torch glow kept above the ceiling (dim only the sun light). Next: on NPT answer recompose shot 5 (maybe ceiling 0.2) and refile alone.
  - open 2026-11-18 visual mods (Yayo Continued, SMYH, Tools) play green with no conflict and change nothing visible: keep wsl-deps.galerie-visual.map for shots 1, 3, 4, 5. Shots 1, 3, 4 stay candidates (Art/Gallery-clean). After all four notes at 4 on shot 5: rate-gallery (subtitles), then mountPreview.
code_review_sha: f438e5704676eae1c4f8b0f88e4698d97282f092
updated: 2026-11-19
protocols_read_sha: 7058cc281523968e3e76f541907b051e805ed558
---
# Nelim's Animals, Naturally — status


## NSB

**Resync 2026-11-18 (sync-nsb-npt, supersedes the ones below where they differ).** Rules said back: 1 NSB free; 2 outside-NSB domestic animals need owner validation (elephant, horse, cow, hen validated "garde les 4" 2026-11-07); 3 colonist properties need validation, none changed; 4 outfits free; 5 the mod ships no animal (Mod/ has Patches only), no gap. NSB since 2026-11-16 (ten commits, 2026-11-17 to 2026-11-18): colonists Iori, Miel, Quo, Quaren, Daichi, Dalia validated or tuned, BiB gene renames, sex stable test; none is Nelim, none touches our places (barn, window-backdrop-for-height, hut, flower-garden). New `Docs/RECONSTRUCTION-SAUVEGARDE.md` (2026-11-18): PLAN ONLY to rebuild the Sanctuary save as `Nelims-tribe-v2`, nothing built, gated on BiB 1.1.0, VTW, validated looks, NPT, decor policy; same places, names, centres, zoom frames kept. Our fixture `Nelims-tribe-decor-mods-z3.rws` and cells stay valid today; if v2 ships, 07-galerie repoints by batch (watch the cells of shots 3, 4, 5). NPT since 2026-11-16 (ten commits, steps.md and face-parts catalogue): head-type assert, screen text and window steps, orders with assertion, def metadata logging, terrain log with placement, face-part catalogue notes. No step called by 07-galerie renamed or removed; none replaces a hand-made setup. Scenarios untouched.

Places read: 2026-11-18 (NSB commit list since 2026-11-16, new RECONSTRUCTION-SAUVEGARDE.md read; place docs unchanged for our four places)
Tribe read: 2026-11-18 (VALIDE.md and NEUTRES-TETE.md diffs filtered on Nelim: none; roster, profile of Nelim unchanged)
Steps read: 2026-11-19 (PickleTools commits since 2026-11-18 on docs/steps.md and catalogues: no light, glow or dim step changed; none used by 07-galerie renamed or removed; NPT asked for a sun-only dim, see remaining)

**Resync 2026-11-16 (sync-nsb-npt, NPT part; supersedes the ones below where they differ).** Rules said back: 1 NSB free; 2 outside-NSB domestic animals need owner validation (elephant, horse, cow, hen validated "garde les 4" 2026-11-07); 3 colonist properties need validation, none changed; 4 outfits free; 5 the mod ships no animal, no gap. NSB: no commit since 2026-11-13, nothing changed. NPT since 2026-11-13 (`Docs/steps.md`, ten commits): new steps for render node hide, fast-forward loop, growing-zone guard, animals kept out of an area (more exceptions), aiming pose, filth spread on a rectangle (already used by shot 4), colonist builds a blueprint, hover over a gizmo, Beauty2 mouth offset. No step called by 07-galerie renamed or removed; none replaces a hand-made setup. Scenarios untouched.

Places read: 2026-11-16 (NSB commit list since 2026-11-13: empty)
Tribe read: 2026-11-16 (same commit list: empty)
Steps read: 2026-11-16 (PickleTools Docs/steps.md commit list since 2026-11-13, ten commits)

| Lieu | Plans | NSB 2026-11-07 | Action |
|---|---|---|---|
| window-backdrop-for-height | 2 | validated (free zone) | usable, but the card shows an elephant (not NSB) |
| sofa-corner | 3 | à embellir (lot 3 launched) | wait |
| plant-garden | 4 | à embellir (lot 4 launched) | wait |
| enclosure-south | 1 | à embellir (lot 4 launched) | wait |

| Animal | Plans | NSB 2026-11-07 | Action |
|---|---|---|---|
| Tama (`akaNEKO_N_Forest_Cat`, female, no trait) | 3 | validated face, profile, back | scene 3 cat becomes Tama herself (was "species of Tama, not Tama") once sofa-corner is validated; paper only, feature not touched (owner "pas de réécrire") |
| elephant, horse, cow, hen | 1, 2 | not in NSB (domestic animals outside NSB) | rule 2: PENDING owner validation or an NSB alternative |
| Bear_Grizzly | 4 | wild, decor (rule 2 does not apply) | free, blocked only by plant-garden |

NSB alternatives that the mod patches (grep of Mod/Patches, partial names, not a full audit): Thrumbo (Atticus, Rain), Flamingo (Wren, Wrille), FoxSquirrel (Pécan), Husky (Yuki), LabradorRetriever (Shogun), Forest Cat (Tama), kuroneko (Kuru), Bear_Grizzly. Boomalope, ERN_lizarddoggo and AA_Aerofleet not found in the patches.

Included animals (rule 5): the mod ships no animal (patches only): no MISSING.

Older NSB resyncs (2026-11-13 and before) and the dated shotlist drafts and states of 2026-11-05 to 2026-11-07 moved to `Docs/runs/STATUS-journal-2026-11-05-to-11-13.md` on 2026-11-18.
