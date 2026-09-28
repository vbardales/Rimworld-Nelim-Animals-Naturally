# Why this folder exists

This folder is not a translation. It exists so that RimWorld stops logging

    Mod Animals Naturally - Pickle tests did not load any content.

at every start, which would make every `no errors were logged` of this suite fail for a reason
that has nothing to do with the mod under test.

`LoadedModManager.LoadModContent` (1.6) logs that error for any active mod whose
`ModContentPack.AnyContentLoaded()` returns false. That method is satisfied by a texture, a clip, a
`Strings/` entry, an assembly, a `Patches/` operation, a Def, or, through `AnyTranslationsLoaded()`,
*any file at all* under a `Languages/` folder. This companion ships only `About/` and feature files
under `Pickle/`, which RimWorld does not load itself (Pickle does), so none of them count.

A loose file under `Languages/` puts nothing anywhere: `LanguageDatabase` enumerates the
*directories* under `Languages/`, never loose files, so this file is never parsed and no key enters
any database. Do not add a language subfolder here: the moment `Languages/<Language>/` exists its
keyed and DefInjected files are loaded for real, and this companion stops being inert.

Same file as `TechLevelFixes/Tests/Pickle/Mod/Languages/README.md`, adapted to this mod's name.
