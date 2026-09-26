# Nelim's Animals, Naturally

Nelim's Animals, Naturally rebalances RimWorld animals against one another using
biological reference values. It contains XML patches only; it does not redistribute
any third-party definitions, textures, or code.

## What it changes

- Body size from real species mass: `bodySize = cbrt(mass_kg / 70)`.
- Reproduction, growth, lifespan, productivity, circadian rhythm, and hybridisation.
- Hard consistency rules for taming, pen escape, retaliation, and maximum prey size.
- Optional forage coverage for Animals Forage (Continued).

Values are changed only when the existing value differs from the calculated target by
more than 15 percent. Deliberately oversized creatures and the `99999` apex-predator
sentinel are preserved.

## Installation

Load this mod after the animal mods whose definitions it patches. [XND] Nocturnal
Animals (Continued) is required: `Rythme.xml` applies its `DefModExtension`, and the
referenced class must be available when definitions load. Dogs Mate, Some Like It
Rotten, Zoology, and Animals Forage (Continued) are optional; their patches are guarded
and remain inert when their target mod is absent.

The files in `config/` are optional user configuration imports. In particular, the
Some Like It Rotten and Nocturnal Animals configuration files must be imported through
the respective mod's in-game import feature rather than copied directly into RimWorld.

## Licence and attribution

The rebalancing rules, values, and XML patches are released under the MIT License. The
definitions targeted by those patches remain the property of Ludeon Studios and their
respective mod authors. See [LICENSE](LICENSE) and [ATTRIBUTION.md](ATTRIBUTION.md).

## Status

The current, evidence-based audit is recorded in [STATUS.md](STATUS.md). It distinguishes
static checks from the game validation that has not yet been run.
