---
mod: "Nelim's Animals, Naturally"
packageId: nelim.animalsnaturally
repo: https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally
visibility: public
detached: yes
workflow_stage: declareDependencies[1.0.0]
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
  - open 2026-11-20 protocols read: (1) any workflow_stage change needs Virginie's explicit "oui" in this chat (written as "À toi, maintenant : valider le passage à <stade>"), replay included; (2) at the next stage passage ATTRIBUTION.md needs a "Gallery set" section (name, author, Workshop id) for every external mod the gallery scenes use (visual mods of wsl-deps.galerie-visual.map, Stick Lantern style props); (3) a failed run whose cause is only a hypothesis goes to Parked/ with RELEASE.md, not deleted.
  - open 2026-11-22 replay ecosystem.. (ledger .replays/AnimalsNaturally-20261122-ecosystem-end.tsv, Virginie typed it): stage declareDependencies[1.0.0], 4.f and 4.g done 2026-11-22 (Dependencies section written); next replay decides settings (section 5: Settings audit record). Ecosystem done (ecosystem_line 1.0). Then rate-gallery for shots 1, 3, 4, 5 (all candidates).
  - open 2026-11-19 galerie-45 (ticket 20261119-094926-703-ed3f, tree 47afc91) GREEN, 1 passed 0 failed, exit passed, 45 s, read from the Inbox (no RUN_DONE seen). Capture opened full and at 268 px: floor still bright light green (DAY), no lamp pool, brazier and two torches flames only; cat walks East readable, Nelim faces East beside the milk bucket (milk reads). Shot 5 REDO (night absent). Told PiT with the Inbox path, asked the order of refresh and dim steps; evidence Tests/Pickle/Inbox/galerie-45 deleted 2026-11-20 with the capture (REDO read, rule: never keep a read run "just in case"). Next: on PiT answer recompose shot 5 (ceiling 0.1 or the step order) and refile alone.
  - open 2026-11-20 galerie-51 (f179, tree 8d062a4, lamps 45 percent) GREEN 1/1: shot 5 CANDIDATE, saved Art/Gallery-clean/5-cat-wakes.jpg (282 KB). Read at 268 px: night (dark grey-green floor), cat walks East beside the torches, Nelim faces West next to the milk pail (carried partly), blue brazier lit, lamp pool faint but a lighter patch around the torches. [light-at] (137, 72) lamp r22 g23 b18 ground 0.32; (143, 77) r8 g9 b7 ground 0.15. score-gallery shot 5: understanding 4, adequacy 4, image 4.5, decoration 4 = candidate. Evidence deleted. All four shots 1, 3, 4, 5 are candidates (shot 2 elephant card is the window capture). Next: rate-gallery (subtitles, session runs it), then the stage question (workflow_stage is ecosystem since the 2026-11-19 replay, 2.h open: ecosystem_line) and mountPreview.
  - open 2026-11-20 (superseded) FILED galerie-51, ticket 20261120-151315-056-f179, shot 5 only (same options), tree 8d062a4, evidence Tests/Pickle/Inbox/galerie-51, keep tree until RUN_DONE. galerie-50 (a596, lamps 60 percent) GREEN: floor medium green, dim but flat (dusk, no pool): [light-at] (137, 72) lamp glow r53 g55 b42, ground glow 0.50; (143, 77) r19 g21 b16, ground glow 0.30. score-gallery shot 5: REDO (night partly, pool absent; adequacy 3). Capture and evidence deleted. Series so far: 30 percent night with ground glow 0.15 / 0.13 (flat dark), 60 percent 0.50 / 0.30 (flat dim). Now 45 percent: expect near a torch about 0.3-0.4, far corner about 0.15. On RUN_DONE: summary, [light-at], open capture at 268 px, score-gallery, delete if REDO; if still no pool also try the dim ceiling 0.10 or tell PiT the values.
  - open 2026-11-20 (superseded) FILED galerie-50, ticket 20261120-150253-014-a596, shot 5 only (same options as 49), tree 1f37557, evidence Tests/Pickle/Inbox/galerie-50, keep tree until RUN_DONE. galerie-49 (dafd, lamps at 30 percent) GREEN: floor reads NIGHT, cat centred and close to Nelim, pail beside her (carried partly), but lamp pool too faint: [light-at] (137, 72) lamp glow r7 g7 b5, ground glow 0.15; (143, 77) lamp glow r2 g3 b2, ground glow 0.13, both roofed, sky 0.12 sun 0.12. score-gallery shot 5: REDO (understanding 4, adequacy 3.5, image 4.5, decoration 4); capture and evidence deleted. Now lamps at 60 percent. On RUN_DONE: summary, junit, [light-at], open capture at 268 px, score-gallery, delete if REDO; try 80 or tell PiT the values if the pool stays faint or the floor goes day.
  - open 2026-11-20 (superseded) FILED galerie-49, ticket 20261120-145515-576-dafd, shot 5 only (07-galerie::workshop 5, wsl-deps.galerie-visual.map, -StallMinutes 20 -RunTimeoutMinutes 25), tree d54373e, evidence Tests/Pickle/Inbox/galerie-49, keep tree until RUN_DONE. PiT reading: Color32 reads are lamp light only, so the bright floor is the lamps themselves (3 torches + brazier flood the small room); new steps "the glow of the lamps is scaled to 30 percent" (try 30, then 50 or 15) and "the light at (x, z) is logged" (cells (137, 72) near a torch, (143, 77) far corner), both compiled not played. Scenario order: sun dim, lamps scaled, refresh, shot. On RUN_DONE: summary.json, junit, Player.log "[light-at]" lines, open capture at 268 px (night floor, lamp pool, cat, Nelim with milk), score-gallery, delete if REDO; if still flat send PiT the [light-at] values.
  - open 2026-11-20 galerie-48 (fd5f, tree 841d4ef) GREEN 1/1 but shot 5 REDO: with the sun-only dim (lamps kept, Color32 reads unclamped) the floor reads DAY again, same as galerie-45; night only appeared in galerie-46 (plain dim, all 5 reads clamped). So the overlay day look comes from the Color32 reads. Cat walks East, Nelim carries nothing visible (pail on floor), no lamp pool judgeable. Capture and evidence deleted; facts and [light] lines sent to PiT (suggest clamping Color32 reads to max(ceiling, lamp-only term)). Next: PiT new build, then refile shot 5 alone (same scenario, composition already fixed).
  - open 2026-11-20 galerie-47 (b8a8, tree 4c66414) RED 0/1, 24 s, no capture: PiT step "the sun light of the map is dimmed to at most 0.15, lamps kept" fails "the lamp glow of the grid cannot be read (field glowGrid or map not found): the game changed" (cause drawn, evidence deleted; GlowGrid methods line sent to PiT, no field list logged). Scenario 07-galerie shot 5 already uses the new step + refresh, composition fixed (Nelim 140,75 to 139,75; daylily 143,75). Next: PiT fixes the field read, then refile shot 5 alone (same scenario).
  - open 2026-11-20 galerie-46 (0088, tree bbf8bdd) GREEN, 1 passed 0 failed, 47 s. Dim step "light of the map is dimmed to at most 0.15" after the 0.12 sun hold WORKS: floor dark grey-green, night reads. Capture opened full and at 268 px: torches and blue brazier flames bright but NO lamp pool (dim clamps lamp glow too); cat walks East readable (about 40 px at 268); Nelim upper right, hair over the daylily, pail of milk on the floor beside her (carried not clear), far from the cat. score-gallery shot 5: REDO (understanding 3.5, adequacy 3, image 3.5, decoration 4). Capture and evidence deleted. Asked PiT for a dim that spares lit lamps. PiT first said hold alone (= galerie-45, floor read day), told him it is already played; he is to build a variant that clamps only the sun term of the overlay, lamps untouched. Next: on PiT answer refile shot 5 alone; meanwhile fix composition (Nelim off the daylily, closer to the cat, milk carried).
  - open 2026-11-19 galerie-44 (0657) GREEN, 1 passed 0 failed, exit passed, 53 s; dim step "light of the map dimmed to at most 0.3" played, no Harmony error, Player.log "[light] 5 reads of the glow are patched". Capture opened full and at 268 px: tatami now dark grey-green (night reads partly), cat white and grey walks East (about 40 px at 268 px, readable), Nelim faces West, Milk bucket beside her head (carried not clear), blue brazier and two torches with bright flames but NO light pool on the floor (ceiling clamps the lamp glow too). score-gallery shot 5: REDO (understanding 3.5: night partly, lamp not lit-looking, milk carried partly; adequacy 3: lamp glow absent, carried partly, night partly; image 4; decoration 4). Capture and evidence deleted. Asked NPT: lamp and torch glow kept above the ceiling (dim only the sun light). Next: on NPT answer recompose shot 5 (maybe ceiling 0.2) and refile alone.
  - open 2026-11-18 visual mods (Yayo Continued, SMYH, Tools) play green with no conflict and change nothing visible: keep wsl-deps.galerie-visual.map for shots 1, 3, 4, 5. Shots 1, 3, 4 stay candidates (Art/Gallery-clean). After all four notes at 4 on shot 5: rate-gallery (subtitles), then mountPreview.
code_review_sha: f438e5704676eae1c4f8b0f88e4698d97282f092
updated: 2026-11-22
ecosystem_line: 1.0
protocols_read_sha: 9076dc7ed32ed99800d4f0026157da2053469dd4
---
# Nelim's Animals, Naturally — status


## Dependencies

Record of 2026-11-22, Mod revision f438e57 (last commit touching Mod/), read from About.xml, OptionalCompat.xml and Mod/Patches/*.xml this day.

| Mod | Kind | Where it acts | Reason |
|---|---|---|---|
| [XND] Nocturnal Animals (Continued), Mlie.XNDNocturnalAnimals, 2269731409 | hard (modDependencies + loadAfter) | Rythme.xml adds NocturnalAnimals.ExtendedRaceProperties (bodyClock), under PatchOperationFindMod | The extension class belongs to that mod: a missing class drops the whole def (vanilla animals, muffalo included, vanish at load). |
| Dogs mate (Continued), Mlie.DogsMate, 2441132298 | loadAfter only | no XPath targets it | Ordering safety. Hybridation.xml writes the vanilla canCrossBreedWith field in Dogs Mate list format, it patches no Dogs Mate def (confirmed 2026-09-28, TESTING.md). |
| Some Like It Rotten, Mlie.SomeLikeItRotten, 2503519676 | loadAfter only | no XPath targets it | Ordering safety, same reason. |
| Zoology: Realistic Animal Overhaul, com.abobashark.zoologymod, 3679396881 | loadAfter only | no XPath targets it | Load after it so its C# behaviour stays active and these values apply to every affected animal. |
| Vanilla Expanded Framework, OskarPotocki.VanillaFactionsExpanded.Core, 2023507013 | optional (OptionalCompat.xml, kind patch) | Forage.xml, PatchOperationFindMod on Vanilla Expanded Framework | Forage components; patch inert without it. |
| [XND] Nocturnal Animals (original), XeoNovaDan.NocturnalAnimals, 2004368312 | optional (OptionalCompat.xml, kind patch) | Rythme.xml, PatchOperationFindMod on the original display name | Same extension, original mod; patch inert without it. |

- DLC: none required. supportedVersions 1.6 only, no LoadFolders.xml.
- Check-OptionalCompat.ps1 2026-11-22: OK, 1 patched target ordered by loadAfter or modDependencies, 2 declared.
- workshop_required_items: n/a, not released yet (field in the front matter).

### Animal-mod integrations (4.f, ANIMALS.md)

The mod ships no animal (patches only), so no race or PawnKindDef of ours needs adding to another mod list. Grep of Mod/Patches 2026-11-22: no ADS_Cat, DZY or Revolus.DogsMate hit.

| Integration | Status | Reason |
|---|---|---|
| A Dog Said Animal Prosthetics 2 | not applicable | No animal added, no ADS_Cat1 to ADS_Cat3 list to extend. |
| Nocturnal Animals | done | Rythme.xml, guarded by PatchOperationFindMod, plus the hard dependency above. |
| Dogs mate | partial by design | Hybridation.xml uses the vanilla canCrossBreedWith field in its list format; no pawnKinds group to extend since no animal is added. loadAfter keeps the order. |
| Better Crossbreeding | not applicable | No animal added, no DZY.CrossBreeding extension to write. |

## Ecosystem

Ecosystem (Steam, 2026-11-22, delta, PiI report docs/inventory/ecosystem-steam/AnimalsNaturally.md, commit 7e143a0): parent Zoology 3679396881 (updated 2026-10-25); no duplicate or fork found; 4 Zoology companions (2 zh translations, 2 patches) and 18 linked mods, all already listed in the ecosystem-links block. Nothing new since 2026-11-13, no subscription made. Verdict: the mod continues.

## NSB

**Resync 2026-11-18 (sync-nsb-npt, supersedes the ones below where they differ).** Rules said back: 1 NSB free; 2 outside-NSB domestic animals need owner validation (elephant, horse, cow, hen validated "garde les 4" 2026-11-07); 3 colonist properties need validation, none changed; 4 outfits free; 5 the mod ships no animal (Mod/ has Patches only), no gap. NSB since 2026-11-16 (ten commits, 2026-11-17 to 2026-11-18): colonists Iori, Miel, Quo, Quaren, Daichi, Dalia validated or tuned, BiB gene renames, sex stable test; none is Nelim, none touches our places (barn, window-backdrop-for-height, hut, flower-garden). New `Docs/RECONSTRUCTION-SAUVEGARDE.md` (2026-11-18): PLAN ONLY to rebuild the Sanctuary save as `Nelims-tribe-v2`, nothing built, gated on BiB 1.1.0, VTW, validated looks, NPT, decor policy; same places, names, centres, zoom frames kept. Our fixture `Nelims-tribe-decor-mods-z3.rws` and cells stay valid today; if v2 ships, 07-galerie repoints by batch (watch the cells of shots 3, 4, 5). NPT since 2026-11-16 (ten commits, steps.md and face-parts catalogue): head-type assert, screen text and window steps, orders with assertion, def metadata logging, terrain log with placement, face-part catalogue notes. No step called by 07-galerie renamed or removed; none replaces a hand-made setup. Scenarios untouched.

Places read: 2026-11-18 (NSB commit list since 2026-11-16, new RECONSTRUCTION-SAUVEGARDE.md read; place docs unchanged for our four places)
Tribe read: 2026-11-18 (VALIDE.md and NEUTRES-TETE.md diffs filtered on Nelim: none; roster, profile of Nelim unchanged)
Steps read: 2026-11-22 (PickleTools commit f0f87205 of 2026-11-21 on Docs/steps.md: two new ClickDiagnostics steps, windows and buttons logged; no light, glow or dim step changed; none used by 07-galerie renamed or removed; nothing for the gallery)

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
