# Runs, one line each

Newest last. Evidence stays in Tests/Pickle/Evidence/ (ignored by git).

- 2026-09-28 df0bb78 filed, not played: sans-facultatifs (b488), avec-vef (e85c), avec-loadafter (72fd); no report yet.
- 2026-09-28 df0bb78 played: sans-facultatifs (b488) 10/10 passed; avec-vef (e85c) 6 passed, 1 failed (test fault: asserted Meat_Rat patched, the mod patches animals only), 5 skipped by @requires design; avec-loadafter (72fd) pending.
- 2026-09-28 uncommitted: 02-forage-vef meat scenario corrected (AA_CrystallineCaracal, Herisson); 01-baseline gains value scenario using existing step `def "X" of type "T" field "..." is "..."` (Horse baseBodySize 1.926, gestationPeriodDays 24.17); avec-vef and sans-facultatifs need a rerun.
- 2026-09-28 value scenario moved out of 01-baseline into 06-valeurs (pass "valeurs", companion DefFields); ticket 869d cancelled before it ran.
- 2026-09-28 1cf2 (avec-vef-r2, no -Filter by mistake): 13 passed, 4 failed, 6 skipped; 3 failures were the whole-suite bug (bare-pass scenarios run with optional mods present), 1 was a real test bug (wrong defName Herisson, corrected to ACPHedgehog). Resubmitted with -Filter 02-forage-vef.
- 2026-09-28 f607 (sans-facultatifs-r2): 10 passed, 0 failed, 13 skipped (the 12 conditional + 06-valeurs scenarios, correctly skipped by @requires). Superseded evidence deleted: sans-facultatifs (b488, no unique proof left) and avec-vef (e85c, superseded by -r2 for the same 12 scenarios, no unique proof left).
- 2026-09-28 574d (dogsmate): 1 passed, 0 failed. 1899 (rotten): stall, exit 3, no report — reproduces the avec-loadafter stall alone, so it (not Dogs Mate) is implicated; not a defect of this mod. 6e7f (zoology) still pending.
- 2026-09-29 fd90 (valeurs): 11 passed, 0 failed, 12 skipped, first game run of the DefFields companion, green. 6e7f (zoology): stall, exit 3, identical signature to the rotten stall; only Dogs Mate loads cleanly of the three loadAfter mods.
