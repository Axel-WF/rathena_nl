# NamelessRO Custom Systems

This repository is the NamelessRO server codebase built on top of rAthena, with custom gameplay systems, SQL overlays, NPC content, and source-level extensions.

This README starts with the current custom drop injection system because it is now part of the server itself and is intended to be expanded over time.

## Current Focus

The first documented custom system is the mob drop injection layer:
- injects extra drops without editing every monster drop table manually
- supports a legacy global common essence for non-MVP monsters
- supports explicit MVP tier essences by monster ID
- supports reusable filtered pools for additional conditional drops
- allows MVPs to receive both their tier essence and matching filtered pool drops

## Mob Drop Injection

### What It Does

The custom mob essence injector adds extra drops during kill handling in source, instead of consuming normal mob drop slots in the database.

This is useful when the rule is broad, for example:
- all normal mobs should have a common essence chance
- specific MVPs should drop a tier-based essence
- all Ghost monsters level 75+ should have an extra Soul Essence chance

### Where It Lives

Core implementation:
- [src/map/mob.hpp](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/src/map/mob.hpp)
- [src/map/mob.cpp](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/src/map/mob.cpp)

Config files:
- [db/mob_essence_drop.yml](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/db/mob_essence_drop.yml)
- [db/import/mob_essence_drop.yml](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/db/import/mob_essence_drop.yml)
- [db/import-tmpl/mob_essence_drop.yml](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/db/import-tmpl/mob_essence_drop.yml)

The live file to edit is:
- [db/import/mob_essence_drop.yml](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/db/import/mob_essence_drop.yml)

`db/import-tmpl` is only a template source. Runtime changes belong in `db/import`.

## Config Structure

The file currently supports three sections under each body entry:

### `Common`

Legacy non-MVP injected drop.

Current behavior:
- single item
- single rate
- optional blacklist
- applies only to non-MVP monsters

Example:

```yml
Common:
  Item: 35605
  Rate: 5000
  Blacklist: []
```

### `Mvp`

Legacy tiered MVP injection by explicit monster ID list.

Current behavior:
- `Tier1`, `Tier2`, `Tier3`
- each tier is still a single item
- each tier has its own `Rate`
- each tier uses explicit `MobIds`

Example:

```yml
Mvp:
  Tier1:
    Item: 35600
    Rate: 10000
    MobIds: [1150, 1086]
```

### `Pools`

Reusable filtered injection rules.

Current behavior:
- each pool has a name
- each pool chooses who it applies to
- filters are optional
- every matching pool rolls every configured drop independently
- a single kill can trigger more than one pool drop
- MVPs can receive their tier essence and matching pool drops at the same time

Example:

```yml
Pools:
  - Name: SoulEssenceGhost75
    ApplyTo: All
    Filters:
      Elements: [Ghost]
      MinLevel: 75
    Drops:
      - Item: 41004
        Rate: 10
```

## Pool Rules

### `ApplyTo`

Supported values:
- `All`
- `NonMvp`
- `MvpOnly`

Meaning:
- `All`: can affect normal monsters and MVPs
- `NonMvp`: can affect only non-MVP monsters
- `MvpOnly`: can affect only MVPs

### Supported Filters

Current supported filters:
- `Elements`
- `MinLevel`
- `MaxLevel`

Element names currently supported:
- `Neutral`
- `Water`
- `Earth`
- `Fire`
- `Wind`
- `Poison`
- `Holy`
- `Dark`
- `Ghost`
- `Undead`

Notes:
- element filtering checks the monster defense element
- `MinLevel` and `MaxLevel` are inclusive
- if a filter block is omitted, the pool matches without that restriction

### Drop Rate Format

Rates follow rAthena-style `0..10000` logic:
- `10000` = `100%`
- `1000` = `10%`
- `100` = `1%`
- `10` = `0.1%`

## Current NamelessRO Essence Setup

### Common Non-MVP Essence

Current configured common essence:
- `35605` for non-MVP monsters

### MVP Tier Essences

Current configured MVP tier essences:
- `35600` for Tier 1 MVPs
- `35601` for Tier 2 MVPs
- `35602` for Tier 3 MVPs

These are assigned by explicit monster ID lists in:
- [db/import/mob_essence_drop.yml](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/db/import/mob_essence_drop.yml)

### Elemental Pool Essences

Current filtered pool setup includes:
- `41000` Death Essence for `Dark`
- `41001` Flame Essence for `Fire`
- `41002` Water Essence for `Water`
- `41003` Earth Essence for `Earth`
- `41004` Soul Essence for `Ghost`
- `41005` Holy Essence for `Holy`
- `41006` Venom Essence for `Poison`

These are currently configured in the live import file for testing and validation.

## Editing Workflow

When changing the drop injector:

1. Edit [db/import/mob_essence_drop.yml](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/db/import/mob_essence_drop.yml)
2. If schema/source behavior changes are needed, update:
   [src/map/mob.hpp](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/src/map/mob.hpp)
   [src/map/mob.cpp](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/src/map/mob.cpp)
3. Rebuild the map server binary
4. Restart or reload the map server

## Docker Rebuild Notes

This repository uses a separate Docker builder container for server rebuilds.

Typical rebuild flow from [tools/docker](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/tools/docker):

```powershell
docker compose run --rm builder bash
```

Inside the builder container:

```bash
cd /rathena
make clean server
```

Then restart services from the host:

```powershell
docker compose restart login char map
```

## SQL Overlay Convention

NamelessRO uses SQL upgrade files for custom item overlays and database patches.

Current examples:
- [upgrade_20260320_reusable_items_item_db2.sql](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/sql-files/upgrades/upgrade_20260320_reusable_items_item_db2.sql)
- [upgrade_20260320_custom_headgears_item_db2.sql](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/sql-files/upgrades/upgrade_20260320_custom_headgears_item_db2.sql)

These are used for:
- custom materials
- costume item overlays
- server-side item definitions that should not be maintained directly in the base YAML tables

## Custom Headgear System

NamelessRO includes a custom headgear crafting system built around:
- a quest NPC that exposes curated craftable hat lists
- recipe registration files grouped by content bucket
- an internal tiering model used for recipe design
- essence requirements that connect headgear crafting to monster and MVP farming
- a GM-facing atcommand to inspect registered recipes in-game

### Runtime Files

Core runtime NPC:
- [npc/nameless/quest_headgears.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears.txt)

Recipe registration files:
- [npc/nameless/quest_headgears_recipes_ad.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears_recipes_ad.txt)
- [npc/nameless/quest_headgears_recipes_eh.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears_recipes_eh.txt)
- [npc/nameless/quest_headgears_recipes_il.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears_recipes_il.txt)
- [npc/nameless/quest_headgears_recipes_mp.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears_recipes_mp.txt)
- [npc/nameless/quest_headgears_recipes_qt.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears_recipes_qt.txt)
- [npc/nameless/quest_headgears_recipes_uz.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears_recipes_uz.txt)

Supporting inventory/list reference:
- [npc/nameless/hats.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/hats.txt)

Design and audit docs:
- [tools/recipe_audit/README.md](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/tools/recipe_audit/README.md)
- [tools/recipe_audit/RECIPE_DESIGN_RULESET.md](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/tools/recipe_audit/RECIPE_DESIGN_RULESET.md)

### How The Quest Works

The headgear quest NPC uses a registration function:
- `F_RegisterHeadgearRecipe`

Each recipe file registers hats during `OnInit` with calls like:

```txt
// Angelic Helm [T2]
callfunc "F_RegisterHeadgearRecipe", 5246,916,100,7063,80,7751,30,720,3,35600,1,35605,175;
```

At runtime, the NPC:
- shows a category shop list
- lets the player choose one hat from that list
- looks up the registered recipe for that hat
- displays required materials
- validates inventory and weight
- removes ingredients
- creates the selected hat

The shop lists inside [quest_headgears.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears.txt) are effectively the public catalog of craftable hats. The recipe files are the source of truth for actual material costs.

### Recipe File Convention

Recipe entries should follow this format:

```txt
// Hat Name [T1]
callfunc "F_RegisterHeadgearRecipe", ...
```

Important conventions already in use:
- one recipe per hat
- internal tier tag in the comment directly above the recipe
- numeric `F_RegisterHeadgearRecipe` calls, not symbolic placeholders
- essence items included directly in the recipe declaration

The audit tooling intentionally expects concrete numeric registrations, so placeholder loops and abstract generators are not the preferred format for finished recipes.

### Tiering System

The custom headgear system uses three internal recipe difficulty tiers:
- `T1`
- `T2`
- `T3`

These tiers are design metadata first, but they directly affect recipe shape because each tier has an essence requirement policy.

Current policy:
- `T1`: easiest tier
- `T2`: intermediate tier
- `T3`: prestige tier

High-level assignment rules from the current design ruleset:
- `T1` hats do not have PvP, boss, ATK, MATK, or major stat-pressure effects
- `T2` hats are stronger than `T1` but do not cross into prestige-power territory
- `T3` hats include PvP, boss, ATK, MATK, or other high-impact effects and are treated as prestige crafts

### Essence Requirements By Tier

The current recipe system uses custom essences instead of older legacy prestige materials.

Essence items:
- `35605` Common Monster Essence
- `35600` Prestige Essence Tier 1
- `35601` Prestige Essence Tier 2
- `35602` Prestige Essence Tier 3

Recipe shape convention:
- `T1`: includes `35605`
- `T2`: includes `35605` plus `35600` or `35601`
- `T3`: includes `35605` plus `35602`

This is what links the headgear system to the custom mob drop injection system documented above.

### Recipe Design Rules

The current design ruleset is intentionally strict so recipes stay farmable and auditable.

Current guidance includes:
- use mostly normal material items, not equipment or special items
- avoid depending on MVP-only materials as normal recipe bulk ingredients
- keep recipe composition restrained
- use the best non-MVP source when deriving material rarity
- derive the headgear tier from item power first, then build the recipe to fit that tier

Current recommended limits from the tooling/docs:
- use `3` to `5` ingredients in a normal recipe
- keep catalog ingredients to `4` max
- keep total ingredients to `6` max including essences

### Recipe Audit Tooling

NamelessRO includes an offline audit workflow for headgear recipes.

Main tool docs:
- [tools/recipe_audit/README.md](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/tools/recipe_audit/README.md)

Main outputs:
- [tools/recipe_audit/report.md](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/tools/recipe_audit/report.md)
- `tools/recipe_audit/material_catalog.md`
- `tools/recipe_audit/material_catalog.json`

The audit checks for:
- invalid item IDs
- banned item types
- equipment used as materials
- ingredients with poor or missing normal mob sources
- over-demanding stacks for low-rate materials
- recipes that violate the current material sanity rules

### Headgear Atcommand

The headgear quest NPC binds a custom atcommand:
- `@craftrecipelog`

Binding location:
- [quest_headgears.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears.txt#L287)

Purpose:
- track ingredient farming progress for the currently selected headgear recipe
- show live `current / required` counts for recipe materials
- notify the player when tracked materials change
- inform the player when the tracked hat becomes craftable

Behavior:
- the selected hat recipe is copied into `@craftrecipelog_*` character variables when the player chooses to track it
- the NPC polls inventory progress on a timer
- updates are shown through bottom-screen messages
- supported forms are `@craftrecipelog`, `@craftrecipelog on`, and `@craftrecipelog off`

This command is part of the player-facing crafting flow, not a generic upstream rAthena feature.

### Practical Maintenance Notes

When updating the custom headgear system:

1. Add or change the hat in the relevant `quest_headgears_recipes_*.txt` file.
2. Ensure the hat exists in the category shop list in [quest_headgears.txt](/c:/Users/Axt_e/Documents/Axel-WF_Git/rathena/npc/nameless/quest_headgears.txt).
3. Keep the tier comment accurate.
4. Make sure the essence requirement matches that tier.
5. Run the recipe audit if the recipe is new or significantly changed.
6. Reload scripts or restart the map server to test it live.

## Scope Of This README

This is a NamelessRO custom systems README.

As more systems are stabilized, this file should be expanded with sections for:
- daily systems
- enchant systems
- custom shops
- item upgrade overlays
- NPC feature groups
- operational notes for Docker and database workflows
