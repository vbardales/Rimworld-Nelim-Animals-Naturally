# tools/

Reference data of the former animal-rebalance mod (renamed Animals, Naturally), moved here from
the monorepo root on 2026-09-29. It is not run by CI or by the mod.

- `data/allModConfigs/` - the CustomizeAnimals-style configuration exports of the mods it read.
- `data/reference/` - species mass, size, forage and analogue tables.

The derivation scripts (`tools/scripts/*.ps1`, 38 PowerShell files) were deleted on 2026-10-12 by the
owner's decision, because nobody runs them. Git history keeps them: `git log --diff-filter=D -- tools/scripts`.
