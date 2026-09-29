# tools/

The derivation chain of the former animal-rebalance mod (renamed Animals, Naturally), moved here from
the monorepo root on 2026-09-29. It is archived tooling, not run by CI or by the mod.

- `scripts/` - audit, derive, generate and merge scripts (PowerShell).
- `data/allModConfigs/` - the CustomizeAnimals-style configuration exports of the mods it read.
- `data/reference/` - species mass, size, forage and analogue tables.

The scripts still default `$Root` to the monorepo root and read `1.csv`, `2.csv`, `3.csv`, `output/`
and `reference/` from there; `output/` no longer exists and the mod folder was `ReequilibrageAnimaux/`.
Point `-Root` at a working copy that has those inputs before running any of them.
