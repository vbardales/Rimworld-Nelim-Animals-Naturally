# Publication notes — Nelim's Animals, Naturally

The Workshop item exists since the 0.1.0 prepublication (2026-10-01): id `3811381865`, private, `About/PublishedFileId.txt` committed in e656137. Replace `<THIS_MOD_ID>` below with it only once the item is public. Publishing goes through GitHub Actions per `AGENTS.md`/`Rimworld-Release-Admin/docs/OPERATIONS.md`;
this file only prepares what needs the item's own ID, filled in once it exists.

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

**Deliberately not drafted:** Dogs Mate (`2441132298`), Some Like It Rotten (`2503519676`), Zoology
(`3679396881`). All three are `<loadAfter>` only — `TESTING.md` confirmed on 2026-09-28 that no XPath of
this mod targets any of them (Hybridation.xml writes the *vanilla* `canCrossBreedWith` field, not their
defs). Per the register's own rule, "post only where the mod is really used or covered" — a load-order
declaration with zero patches doesn't clear that bar. Dogs Mate already has a `drafted` row from Moa
Renew for a genuinely shared mechanism (the vanilla crossbreeding lists); nothing is added here to it.
Revisit only if a future patch actually targets one of the three.

Each draft below needs `[url=https://steamcommunity.com/sharedfiles/filedetails/?id=<THIS_MOD_ID>]Nelim's Animals, Naturally[/url]`
with `<THIS_MOD_ID>` filled in once the Workshop item exists — the placeholder is left as `<THIS_MOD_ID>`
on purpose, do not post with it still in place. Read the page's last comments again before posting
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

## Gallery captures (2026-10-02)

Folder `Art/gallery/` holds only the images to upload, numbered `0-`, `1-`, `2-`; `0-preview.png` is a byte copy of `Mod/About/Preview.png`. Captures come from `Tests/Pickle/Mod/Pickle/Features/07-galerie.feature` (pass `galerie`), raw pictures stay in the ignored `Tests/Pickle/Evidence/` and are cropped before they go to `Art/gallery/`.

**Zoom rule (owner, 2026-10-02): the subject fills at least 50 percent of the screen height or width.** Not stated in the shared `PUBLISHING.md`, so it is written here and in the feature header. The numbers of the framing steps (`I frame` sets zoom 9, then `I zoom in`) are only a starting point: judge the picture, not the number.

| Order | Image | Shows | State |
|---|---|---|---|
| 0 | `0-preview.png` | the Preview | done |
| 1 | size range | mouse to elephant side by side | scenario written, not played |
| 2 | horse health tab | the Health tab of a rebalanced horse (an animal has no Bio tab: Health, Log, Needs, Social, Training) | scenario written; no animal tab shows lifespan or body size, so the picture may not sell the mod: judge it, or drop it |
| 3 | forage | a grizzly digging berries | not written: needs a way to make the animal hungry (no step does it) or a long film |
