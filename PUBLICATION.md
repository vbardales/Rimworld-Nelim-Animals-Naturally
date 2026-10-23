# Publication notes — Nelim's Animals, Naturally

The Workshop item exists since the 0.1.0 prepublication (2026-10-01): id `3811381865`, private, `About/PublishedFileId.txt` committed in e656137. Replace `<THIS_MOD_ID>` below with it only once the item is public. Publishing goes through GitHub Actions per `AGENTS.md`/`Rimworld-Release-Admin/docs/OPERATIONS.md`;
this file only prepares what needs the item's own ID, filled in once it exists.

## Steam description

Single source (PUBLISHING.md, "Description : UN SEUL COUP"): English Markdown, no code fence inside the block. The `<description>` of
`Mod/About/About.xml` is generated from it by `sync-about-description.mjs` at `writeDocs`; it is **not** synced yet, so the two differ
until then (the About.xml text still says "a macaw lives for 55 years", which `Lifespan.xml` does not write: fixed below).
Figures checked against the patches on 2026-10-10 (`TEST_SCENARIOS.md`, "Figures checked").

```markdown
Rebalances animals against one another using biological reference values.

Every value is derived from a single physical anchor: the species' real mass in kilograms.

- **Body size**: the cube root of mass relative to a 70 kg human.
- **Lifespan**: allometric laws calibrated by clade. A chicken lives for 7 years, a cockatoo from an animal pack for 52: birds do not follow one curve.
- **Growth, reproduction, productivity**: maturity age, gestation, litter size, milk, wool and eggs follow the same mass.
- **Circadian rhythm**: nocturnal, crepuscular and cathemeral animals get their real body clock, through the Nocturnal Animals extension.
- **Hard rules**: retaliation is at least as likely as taming failure; trainable animals do not escape their pens; maximum prey size accounts for the hunting method.
- **Hybridisation**: groups derived from real taxonomy, in Dogs Mate format.
- **Forage** (only with Vanilla Expanded Framework): animals that Animals Forage (Continued) does not cover dig for food when hungry.

Precautionary rule: a value changes only when it differs from its target by more than 15 percent. Ludeon's existing hand-tuning is not overwritten when it is already close, deliberately oversized creatures keep their intended size, and apex predators keep the maxPreyBodySize = 99999 sentinel.

All patches are conditional: removing an animal mod simply makes its corresponding patches inert, without load errors.

Requires [[XND] Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409). Load AFTER all animal mods.

**IF I GO QUIET**: If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

**AI-GENERATED**: Claude (Anthropic) and Codex (OpenAI) assisted with the XML patches, tests, documentation and audit maintenance. The values and rules are mine.

**THANKS**: Ludeon Studios and the authors of the animal mods whose definitions are targeted. [[XND] Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409) by Mlie, from the original [[XND] Nocturnal Animals](https://steamcommunity.com/sharedfiles/filedetails/?id=2004368312) by XeoNovaDan, whose bodyClock extension this mod uses. [Animals Forage (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=3667046888) by Mlie, [Alpha Animals](https://steamcommunity.com/sharedfiles/filedetails/?id=1541721856) by Sarg Bjornson and [Vanilla Animals Expanded](https://steamcommunity.com/sharedfiles/filedetails/?id=2871933948) by Oskar Potocki, whose animals the forage patches extend. [Vanilla Animals Expanded - Royal Animals](https://steamcommunity.com/sharedfiles/filedetails/?id=2858079457) by Oskar Potocki, Erin and Sarg Bjornson, whose pheasants the forage patches extend too. Load-order integrations, tested but never patched: [Dogs Mate (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2441132298) by Mlie, from the original by Revoluss, whose list format Hybridation.xml writes; [Some Like It Rotten](https://steamcommunity.com/sharedfiles/filedetails/?id=2503519676) by Mlie; [Zoology: Realistic Animal Overhaul](https://steamcommunity.com/sharedfiles/filedetails/?id=3679396881) by AbobaShark. [Vanilla Expanded Framework](https://steamcommunity.com/sharedfiles/filedetails/?id=2023507013) provides the forage components. Development only, never a dependency: [Pickle](https://steamcommunity.com/sharedfiles/filedetails/?id=3791648678), [RimLogging](https://steamcommunity.com/sharedfiles/filedetails/?id=3733484696) and PickleTools.

See ATTRIBUTION.md and the MIT License in the GitHub repository.

[Source code on GitHub](https://github.com/vbardales/Rimworld-Nelim-Animals-Naturally)
```

Open points for this block, none decided here:

- The "54 vanilla species, 7 percent median error" sentence of the old description is dropped: it comes from the generator, which is not in this repository, and cannot be checked from `Mod/`.

## Steam change notes

### 1.0.0

[h3]1.0.0[/h3]
[list]
[*] First public release of Nelim's Animals, Naturally: lifespans, body sizes, growth, gestation, productivity, foraging and roaming patched for modded animals, using only XML patches.
[*] Optional integrations with Dogs Mate, Some Like It Rotten and Zoology, loaded after them when present.
[*] New Workshop description, icon and preview.
[/list]

## Thanks to post, after the item is public

`../WORKSHOP_COMMENTS.md` is the shared register: read it first, one main comment per recipient page
across the whole collection. Rows already added or updated for this mod on 2026-09-29 (see that file's
own history for the exact diff):

| Recipient | Workshop id | Register today | What to do |
| --- | --- | --- | --- |
| [XND] Nocturnal Animals (Continued) | `2269731409` | `posted` | added to `Covers`, post nothing (hard dependency, no new mechanic to credit beyond what's already thanked) |
| Vanilla Expanded Framework | `2023507013` | `posted` | added to `Covers`, post nothing |
| Pickle | `3791648678` | `posted` | added to `Covers`, post nothing (development/test tool) |
| RimLogging | `3733484696` | `posted` | added to `Covers`, post nothing |
| PickleTools | `3806142401` | `not_applicable` | added to `Covers` anyway per the existing convention (the author's own project) |
| Animals Forage (Continued), Mlie | `3667046888` | `drafted` | post the first draft below once this mod's own item is public |
| Alpha Animals, Sarg Bjornson | `1541721856` | `drafted` | second draft |
| Vanilla Animals Expanded, Oskar Potocki | `2871933948` | `drafted` | third draft |
| Vanilla Animals Expanded - Royal Animals, Erin / Oskar Potocki / Sarg Bjornson | `2858079457` | `drafted` | fourth draft, after `02-forage-vef` is green |
| Some Like It Rotten, Mlie | `2503519676` | `drafted` | fifth draft |
| Zoology: Realistic Animal Overhaul, AbobaShark | `3679396881` | `drafted` | sixth draft |
| Dogs Mate (Continued), Mlie | `2441132298` | `drafted` (Moa Renew's row) | covered by the message drafted in `MoaRenew/PUBLICATION.md`; nothing to post from here |

**Integrations with no patch on their defs** (Virginie, 2026-10-10: thank every integration, `PUBLISHING.md`, "Remerciements"; the register `../WORKSHOP_COMMENTS.md` decides what is posted). Dogs Mate (`2441132298`) already has a `drafted` row from Moa Renew: this mod is added to its `Covers`, no separate comment here (Hybridation.xml writes the same list format on the vanilla `canCrossBreedWith` field, tested by pass `03-dogsmate`). Some Like It Rotten (`2503519676`) and Zoology (`3679396881`) are `<loadAfter>` only and have a pass of their own (`04-rotten`, `05-zoology`): new `drafted` rows and a draft each below. Vanilla Animals Expanded - Royal Animals (`2858079457`), staged by the `avec-vef` pass, has its own row and draft too.

Each draft below needs `[url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]`.
`<THIS_MOD_ID>` is `3811381865` (the private prepublication item, id known since 2026-10-01); the placeholder stays
in the drafts on purpose, and the id goes in only when the item is public, since nobody can open the link before.
Do not post with the placeholder still in place. Read the page's last comments again before posting
(WORKSHOP_COMMENTS.md's method), in case the tone has moved since 2026-09-29.

**Mlie, on Animals Forage (Continued)** (289 characters):

> Your list of who already forages (grizzly bears -> berries, ducks -> fish) turned out to be the
> perfect map of who still needed it. My rebalance mod hands the same comp to animals your patch
> hadn't reached yet, no overlap. Thanks for laying the groundwork :)
> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

**Sarg Bjornson, on Alpha Animals** (223 characters):

> Borrowed a page from Animals Forage and gave the Crystalline Caracal the same dig-when-hungry trick,
> since nothing else covered it yet. Simple graphic, real mechanic — the recipe works. Thanks for the
> caracal xD
> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

**Oskar Potocki, on Vanilla Animals Expanded** (241 characters):

> Extended the same forage-when-hungry behaviour Animals Forage gives vanilla critters to the VAE
> animals it hadn't reached — no overlap, just filling the gaps your own spreadsheet already mapped
> out. Appreciate the sheer scale of it :)
> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

**Mlie, on Some Like It Rotten** (217 characters):

> Ran my animal rebalance with Some Like It Rotten loaded above it and it comes up clean, my patches never touch your defs. Rotting corpses at half nutrition is the kind of small rule that makes a rat farm make sense :)

> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

**AbobaShark, on Zoology** (238 characters):

> Zoology and my rebalance came at the same itch from two sides: stats worked out from real body mass. I load mine below Zoology in my test list and it starts clean. Pack hunting that stops always picking the weakest prey is a clever fix :)

> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

**Erin, Oskar Potocki and Sarg Bjornson, on Vanilla Animals Expanded - Royal Animals** (226 characters). Post only after ticket 3b7a (`02-forage-vef`, VAERoy_Pheasant) has run green:

> The royal pheasants got a small gift from my forage patch: they now dig for a snack when hungry, the same trick Animals Forage gives vanilla critters. Thanks Erin, Oskar and Sarg for nine animals that keep vanilla balancing xD

> [url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]

## Gallery captures (2026-10-02)

Folder `Art/Gallery/` holds only the images to upload, numbered `0-` to `4-`; `0-preview.png` is a byte copy of `Mod/About/Preview.png`. Captures come from `Tests/Pickle/Mod/Pickle/Features/07-galerie.feature` (pass `galerie`), raw pictures stay in the ignored `Tests/Pickle/Evidence/` and are cropped before they go to `Art/Gallery/`. Preview inputs: `Art/Preview-source.png`, `Art/echo-concept.png`, `Art/ModIcon-source.png`, `Art/Preview.config.json`, rendered by `node ../scripts/Render-Preview.cjs`; the two `.ico` files in `Art/` are the local folder icons, outside `Mod/`.

**Zoom rule (owner, 2026-10-02): the subject fills at least 50 percent of the screen height or width.** Not stated in the shared `PUBLISHING.md`, so it is written here and in the feature header. The numbers of the framing steps (`I frame` sets zoom 9, then `I zoom in`) are only a starting point: judge the picture, not the number.

| Order | Image | Shows | State |
|---|---|---|---|
| 0 | `0-preview.png` | the Preview | done |
| 1 | feed round, 07:00 | Nelim walks past elephant, horse, cow and hen at real scale | galerie-11 played, tint over the left ground; scenario rewritten, filed in galerie-12 |
| 2 | elephant info card, 11:00 | Stats tab, window only, no subtitle | galerie-11 failed at the animal spawn; scenario rewritten, filed in galerie-12 |
| 3 | cat asleep, 13:00 | a vanilla cat asleep in broad day (night rhythm), Nelim tiptoes past | scenario written, filed in galerie-12 |
| 4 | grizzly at dusk, 18:00 | a hungry grizzly has just dug for berries (forage) | scenario written, filed in galerie-12; the royal pheasant is dropped |

## Gallery subtitles

Scenes without an interface window carry one English line at the bottom (`GALLERY.md`, "Sous-titres"). Image 2 is a window capture: no line. Lines and file names are provisional until the captures are accepted; clean originals go to `Art/Gallery-clean/`.

| Index | File | Line |
|---|---|---|
| 1 | 1-feed-round.png | At seven, Nelim walks the feed round: the hen to her knee, the elephant over her. |
| 3 | 3-cat-asleep.png | The cat keeps the night: asleep at noon, while Nelim tiptoes past. |
| 4 | 4-grizzly-dusk.png | At dusk, a hungry grizzly digs for berries of its own. |


### Staging of the gallery (owner's rule, 2026-10-02)

Every gallery image is a staged photograph, except menus (the Health tab, image 2, is a screenshot of what it is). Story for the series (rewritten 2026-10-23, replaces "the naturalist's plate"): **one day at Nelim's Sanctuary**, Nelim the field naturalist measuring the animals against herself, one outfit all day. 07:00 the feed round among elephant, horse, cow and hen (image 1, wide); 11:00 her field notes, the Stats card of the elephant (image 2, interface); 13:00 a cat asleep in broad day, the night rhythm (image 3, close); 18:00 at dusk a hungry grizzly has just dug for berries (image 4, medium). Places, props, outfit and instants: the header of `07-galerie.feature` and "Shotlist 2026-10-23" in `STATUS.md`. Decor is placed, photographed, removed, then the next image. The steps asked of Pickle Tools on 2026-10-02 now exist; only the scenes' jobs (walk, lie down, unforbid) are new in the 2026-10-23 run.
