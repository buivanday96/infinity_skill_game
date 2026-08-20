#!/usr/bin/env python3
"""Import Outhold English strings and reconstruct concatenated upgrade keys.

GDRE lost keys built at runtime (`UPGRADE_DESCRIPTION_` + enum). This script
keeps recovered keys, remaps MissingKey English rows onto Godot-style keys,
and writes `lib/l10n/en.g.dart`.
"""

from __future__ import annotations

import csv
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CSV_PATH = Path(
    "/Users/macbookm4/Downloads/untitled folder 2/.assets/localization/localization.csv"
)
OUT_PATH = ROOT / "lib" / "l10n" / "en.g.dart"
UPGRADES_PATH = ROOT / "lib" / "models" / "upgrades.dart"

MISSING_RE = re.compile(r"<!MissingKey:(\d+):(.*)>$", re.S)

# Descriptions that are mobile-only variants (tap / long-press). Skip for desktop keys.
MOBILE_MARKERS = (
    "tap to ",
    "tap and hold",
    "tapping on",
    "tapping on a",
    "by tapping",
    "long-pressing",
    "long pressing",
)

# Remaining keyword glosses that were concatenated at runtime.
KEYWORD_HINTS = {
    "KEYWORD_CRITICAL_HIT": (
        "a critical hit deals",
        "{value_percent}",
        "more damage",
    ),
    "KEYWORD_ARTIFACT_UNLOCK": (
        "every time you choose an",
        "artifact",
        "higher",
    ),
    "KEYWORD_REQUIRED_COMPLETED_LEVEL": (
        "special challenge level",
        "before unlocking",
    ),
}

# Each rule: all `must` substrings (normalized) must appear; none of `must_not`.
# Longer / more specific rules win via score = 10 * len(must) + extra.
DESCRIPTION_RULES: list[tuple[str, list[str], list[str]]] = [
    ("arrow_tower_unlock", ["unlocks the arrow tower", "clicking on any empty"], ["tap"]),
    ("slow_tower_unlock", ["unlocks the pulse tower"], []),
    ("starting_gems", ["start each run with", "by {value}"], ["additional"]),
    ("starting_gems_2", ["start each run with", "additional {value}"], []),
    ("arrow_tower_damage", ["arrow tower", "base damage", "by {value}"], ["additional", "additonal"]),
    ("arrow_tower_fire_rate", ["arrow tower", "base fire rate", "by {value_percent}"], ["additional", "reduce"]),
    ("arrow_tower_fire_rate_2", ["arrow tower", "base fire rate", "additional {value_percent}"], ["reduce"]),
    ("arrow_tower_fire_rate_3", ["arrow tower", "base fire rate", "additional {value_percent}"], ["reduce"]),
    ("arrow_tower_crit_chance", ["arrow tower", "critical hit", "by {value_percent}"], ["additional", "unharmed", "poison"]),
    ("arrow_tower_crit_damage", ["all", "critical hit damage", "by {value_percent}"], ["additional"]),
    ("arrow_tower_multicrit", ["multicrit limit", "by {value}"], ["additional", "level {level_required}"]),
    ("arrow_tower_multicrit_2", ["multicrit limit", "additional", "level {level_required}"], []),
    ("arrow_tower_multicrit_leveled", ["multicrit limit", "additional", "level {level_required}"], []),
    ("arrow_tower_multicrit_combustion", ["multicritting", "combust"], []),
    ("arrow_tower_build_cost_damage_multiplier", ["cost to build"], []),
    ("arrow_tower_upgrade_cost_damage_multiplier", ["leveling up an arrow tower", "cost to level up"], []),
    ("arrow_tower_poison", ["now applies {value} stacks of", "poison"], ["additional", "pools"]),
    ("arrow_tower_more_poison", ["additional {value} stack", "poison"], ["charged"]),
    ("arrow_tower_poison_on_shields", ["shielded", "full damage from", "poison"], []),
    ("arrow_tower_poison_pool", ["pools", "stacks of", "poison"], []),
    ("arrow_tower_poison_charge_add_stacks", ["charged", "stacks of", "poison"], []),
    ("arrow_tower_crit_poison", ["critical hits", "arrow towers", "poison"], []),
    ("arrow_tower_poison_vulnerable", ["vulnerable", "poison", "extra stack"], []),
    ("arrow_tower_fire_rate_increase_damage_decrease", ["raise the base fire rate of the arrow tower", "reduce its base damage"], []),
    ("arrow_tower_leveling_fire_rate_2", ["when leveling up the arrow tower", "base fire rate", "base damage"], []),
    ("arrow_tower_heavy", ["increased_damage_percent", "reduced_fire_rate_percent"], []),
    ("arrow_tower_range", ["range of the arrow tower"], []),
    ("arrow_tower_crit_chance_2", ["arrow tower", "critical hit", "additional {value_percent}"], ["unharmed", "poison"]),
    ("arrow_tower_crit_damage_2", ["all", "critical hit damage", "additional {value_percent}"], []),
    ("arrow_tower_damage_2", ["arrow tower", "base damage", "additonal {value}"], []),
    ("arrow_tower_damage_3", ["arrow tower", "base damage", "additonal {value}"], []),
    ("arrow_tower_damage_at_range", ["per_range_unit"], []),
    ("arrow_tower_unharmed_crit_chance", ["unharmed enemies", "critical hit"], []),
    ("arrow_tower_pierce_shield", ["shielded", "arrow tower", "able to deal"], []),
    ("arrow_tower_disable", ["stop an arrow tower from firing", "d key"], []),
    ("status_effect_count_increase_damage", ["unique status effect", "extra damage"], ["additional"]),
    ("status_effect_count_increase_damage_extra", ["unique status effect", "additional {value_percent} extra"], []),
    ("tower_upgrade_unlock", ["unlocks", "tower leveling", "clicking on a tower"], ["tapping"]),
    ("tower_demolish_unlock", ["unlocks the ability to", "demolish towers"], []),
    ("gem_convert", ["converted into", "tokens"], []),
    ("gem_drops", ["defeated enemies drop an additional"], []),
    ("basic_token_drops", ["tokens earned from defeated enemies"], []),
    ("gem_cannon", ["unlocks the coin cannon", "right mouse button"], []),
    ("early_spawn", ["spawn the next wave before", "gem_percent"], []),
    ("auto_start_wave", ["automatically starts the next wave", "bottom right"], ["long-press", "long press"]),
    ("arrow_tower_multishot", ["an additional arrow", "second arrow"], []),
    ("arrow_tower_multishot_increased_damage", ["secondary arrows", "base damage"], []),
    ("arrow_tower_multishot_triple_when_leveled", ["third arrow"], []),
    ("targetting", ["click to apply", "mark"], ["tap"]),
    ("gem_shot", ["arrow tower attack", "drop a", "coin"], []),
    ("early_spawn_gem_bonus", ["early spawn", "coin", "bonus", "additional"], []),
    ("early_spawn_charge", ["charge", "early spawn"], ["additional"]),
    ("early_spawn_charge_extra", ["charge", "early spawn", "additional"], []),
    ("accelerated_enemy_basic_token_bonus", ["accelerated", "tokens when defeated"], []),
    ("time_challenge_unlock", ["unlocks the time trial"], []),
    ("slow_tower_damage_link", ["slowed enemy takes direct damage", "same source"], []),
    ("slow_tower_damage_link_increase", ["linked damage", "additional"], []),
    ("slow_tower_damage_link_share_sources", ["damage link", "all sources"], []),
    ("targetting_auto", ["no enemy is marked", "automatically"], []),
    ("vulnerable_damage_multiplier", ["vulnerable enemies take an additional"], ["unharmed"]),
    ("slow_amount", ["slowing effect of all slows"], []),
    ("slow_vulnerable", ["slowed", "becoming", "vulnerable"], []),
    ("slow_tower_fire_rate", ["fire rate of the pulse tower"], []),
    ("slow_duration", ["duration of all slows", "by {value} seconds"], ["additional"]),
    ("slow_duration_2", ["duration of all slows", "additional {value}"], []),
    ("slow_tower_charge_buff", ["pulse tower", "charges towers within range"], []),
    ("slow_damage_bonus", ["slowed enemies take an additional"], []),
    ("charge_amount", ["all charge times", "a {value} seconds"], ["additional"]),
    ("charge_amount_2", ["all charge times", "additional {value}"], []),
    ("charge_damage_bonus", ["when a tower is charged", "next shot"], []),
    ("charge_damage_stacking", ["charge bonuses can now stack"], []),
    ("slow_zone", ["create a pool for", "duration"], []),
    ("explosive_grunts_chance", ["explosive grunts to spawn"], []),
    ("explosive_runners_chance", ["runners", "leapers", "explosive"], []),
    ("explosive_damage", ["all explosion damage by {value_percent}"], ["another"]),
    ("explosive_damage_2", ["all explosion damage", "another {value_percent}"], []),
    ("explosive_grunts", ["spawned", "grunts", "explosive grunts"], []),
    ("explosive_bosses", ["bosses have a {value_percent} chance to trigger an"], []),
    ("explosive_bosses_2", ["chance for bosses to trigger"], []),
    ("explosive_elites", ["elites have a {value_percent} chance to trigger an"], []),
    ("explosive_elites_2", ["chance for elites to trigger"], []),
    ("explosion_range_increase", ["size of explosions"], []),
    ("explosion_tower_charge", ["towers hit by", "explosions", "charge"], ["additional"]),
    ("explosion_tower_charge_extra", ["charged by explosions", "additional"], []),
    ("explosion_chance_to_create_pool", ["explosions have a {value_percent} chance to create a pool"], []),
    ("explosion_fireball", ["explosions have a {value_percent} chance to launch a"], ["additional"]),
    ("explosion_fireball_chance", ["chance for a fireball to launch by {value_percent}"], ["additional"]),
    ("explosion_fireball_double_chance", ["additional fireball", "explosive", "defeated"], []),
    ("explosion_fireball_burn_damage", ["burn damage caused by all fireballs"], []),
    ("explosion_fireball_explosion_damage", ["explosion damage caused by all fireballs"], []),
    ("tower_upgrade_auto", ["automatically level up", "least expensive"], []),
    ("gem_cannon_damage", ["coin cannon", "base damage by {value}"], ["additional"]),
    ("gem_cannon_damage_extra", ["coin cannon", "base damage by an additional {value}"], []),
    ("gem_cannon_fire_rate", ["coin cannon", "base fire rate"], []),
    ("gem_cannon_shot_reimbursement_chance", ["reimbursed"], []),
    ("gem_cannon_crit_chance", ["coin cannon", "critical hit", "chance"], []),
    ("auto_collect_gems", ["automatically collect all dropped"], []),
    ("gem_cannon_damage_expensive", ["coin cannon", "cost of each shot", "by {value_percent}"], ["another", "additional"]),
    ("gem_cannon_damage_expensive_extra", ["coin cannon", "another {value_percent}", "cost"], []),
    ("gem_cannon_auto_shoot", ["coin cannon shoots automatically", "bottom right"], ["long-press", "long press"]),
    ("demolish_unrestricted", ["demolished during an active wave"], []),
    ("demolish_refund_amount", ["demolishing", "recover an additional {value_percent}"], []),
    ("demolish_refund_amount_2", ["demolishing", "recover an additional {value_percent}"], []),
    ("demolish_explosion", ["explode a tower instead of refunding"], []),
    ("core_health", ["max health of the", "outhold", "by {value}"], ["additional"]),
    ("core_health_2", ["max health of the", "outhold", "additional {value}"], []),
    ("core_health_3", ["max health of the", "outhold", "additional {value}"], []),
    ("core_lost_health_increase_damage", ["each point of damage the", "outhold", "has taken"], []),
    ("core_burn_pulse", ["fiery pulse", "pulse_cooldown"], []),
    ("core_burn_pulse_damage", ["burn damage inflicted by the pulse"], []),
    ("core_burn_pulse_range", ["range of the pulse"], []),
    ("core_burn_combust", ["pulse also triggers a", "combust"], []),
    ("core_killed_enemy_reward", ["damage the", "outhold", "tokens upon death"], []),
    ("core_killed_enemy_reward_coins", ["damage the", "outhold", "coins upon death"], []),
    ("core_apply_wave_burn", ["first enemy of each wave", "burn"], []),
    ("core_charge", ["outhold is damaged", "charges all towers"], []),
    ("core_charge_extra", ["outhold is damaged", "charges all towers"], []),
    ("core_heal", ["pay", "heal the", "outhold"], []),
    ("core_heal_extra", ["heal restores an additional"], []),
    ("burn_damage", ["increase all burn damage by {value_percent}"], ["additional"]),
    ("burn_damage_fire_tower", ["fire tower", "burn damage by {value}"], []),
    ("burn_damage_extra", ["increase all burn damage", "additional {value_percent}"], []),
    ("burn_damage_extra_for_reduced_tick_rate", ["reduce the tick rate"], []),
    ("burn_ticks", ["all burns last for {value} additional tick"], []),
    ("burn_ticks_extra", ["all burns last for an additional {value} tick"], []),
    ("burn_crit", ["burn_crit_chance_percent"], []),
    ("burn_stacking_damage", ["already burning enemy"], ["spread"]),
    ("burn_spreading", ["spread the effect to the nearest enemy not already burning"], []),
    ("burn_spread_chance", ["burn spread chance"], []),
    ("burn_spread_to_burning", ["spread to enemies that are already burning"], []),
    ("burn_concentration", ["hits only one target"], []),
    ("fire_tower_unlock", ["unlocks the fire tower"], []),
    ("burn_crit_add_tick", ["critical hits against burning", "extra", "tick"], []),
    ("burn_tick_rate", ["rate of burn ticks by {value_percent}"], ["accelerated", "additional"]),
    ("burn_tick_crit_chance", ["chance for burn ticks to deal a critical hit"], []),
    ("burn_pool_apply_burn", ["enter a pool are afflicted with burn"], []),
    ("burn_pool_apply_burn_extra", ["burns applied from pools"], []),
    ("burn_tick_rate_accelerated_enemies", ["burn ticks by {value_percent} on", "accelerated"], ["additional"]),
    ("burn_tick_rate_accelerated_enemies_extra", ["burn ticks by an additional {value_percent} on", "accelerated"], []),
    ("lightning_tower_unlock", ["unlocks the lightning tower"], []),
    ("lightning_tower_spread_status", ["spread any status effects"], []),
    ("lightning_tower_jumps", ["number of lightning jumps by {value}"], ["additional"]),
    ("lightning_tower_extra_jumps", ["number of jumps", "additional {value}"], []),
    ("lightning_tower_damage", ["lightning tower", "base damage by {value}"], ["additional"]),
    ("lightning_tower_damage_extra", ["lightning tower", "base damage", "additional {value}"], []),
    ("lightning_tower_speed", ["lightning tower", "base fire rate by {value_percent}"], ["additional"]),
    ("lightning_tower_extra_speed", ["lightning tower", "base fire rate", "additional {value_percent}"], []),
    ("lightning_tower_crit_chance", ["lightning tower", "critical hit"], ["charge"]),
    ("lightning_tower_crit_charge", ["lightning tower fires a critical hit", "charges itself"], []),
    ("lightning_tower_charge_extra_jumps", ["lightning tower is charged", "jump an additional"], []),
    ("lightning_tower_overkill_damage", ["overkill damage", "nearby enemy"], ["additional", "trigger again"]),
    ("lightning_tower_overkill_damage_extra", ["overkill damage by an additional"], []),
    ("lightning_tower_overkill_retrigger_chance", ["overkill to trigger again"], []),
    ("lightning_tower_jump_damage_reduction", ["damage loss per jump"], []),
    ("lightning_tower_chance_to_jump_again", ["not consume a jump", "this effect can trigger"], []),
    ("lightning_tower_chance_to_jump_again_extra", ["not consume a jump", "additional {value_percent}"], []),
    ("lightning_tower_apply_shock", ["shock_count"], []),
    ("lightning_tower_shock_stun_duration", ["stun duration by {value} seconds"], ["additional"]),
    ("lightning_tower_shock_stun_duration_extra", ["stun duration by an additional"], []),
    ("lightning_tower_stun_increase_damage", ["damage to stunned enemies"], ["additional"]),
    ("lightning_tower_stun_increase_damage_extra", ["additional {value_percent} increased damage to stunned"], []),
    ("lightning_tower_discharge_combust", ["discharged it will combust"], []),
    ("lightning_tower_jump_range", ["jump range of lightning strike"], []),
    ("level_challenge_unlock", ["unlocks", "build specialization challenges"], []),
    ("increased_vulnerable_damage_undamaged_enemies", ["unharmed", "vulnerable"], []),
    ("boss_defeat_partial_token", ["drop_coin_per_health"], []),
    ("boss_damage_taken_basic_token_increase", ["coins gained from damaging bosses"], []),
    ("economy_damage_increase_by_coins", ["max_damage_increase"], []),
    ("economy_gem_interest", ["interest on your unspent"], []),
    ("economy_enemy_defeat_upgrade_discount", ["next level up", "cost is reduced"], []),
    ("economy_uncapped_levels", ["remove the max level cap"], []),
    ("bank_tower_unlock", ["unlocks the bank tower"], []),
    ("bank_tower_chance_to_spawn_coin", ["bank tower", "chance to drop", "additional {value_percent}"], []),
    ("bank_tower_number_coins", ["number of coins you get when enemies cross"], []),
    ("bank_tower_add_vulnerable", ["bank tower", "become vulnerable"], []),
    ("bank_tower_vulnerable_duration", ["vulnerability applied by the bank tower"], []),
    ("bank_tower_pool", ["bank tower", "considered to be a pool"], []),
    ("bank_tower_tokens", ["awards one", "token from each passing enemy"], []),
    ("bank_tower_basic_tokens_multiplier", ["one additional", "token from each passing enemy"], []),
    ("bank_tower_damage", ["min_damage"], []),
    ("bank_tower_damage_extra", ["bank tower", "damaged an additional {value_percent}"], []),
    ("bank_tower_accelerated_enemies", ["accelerated", "bank tower", "coin"], []),
    ("artifacts_unlock", ["grants access to artifacts"], []),
    ("fire_artifact_unlock", ["unlocks the", "fire artifact"], ["another"]),
    ("light_artifact_unlock", ["unlocks the", "light artifact"], ["another"]),
    ("earth_artifact_unlock", ["unlocks the", "earth artifact"], ["another"]),
    ("wind_artifact_unlock", ["unlocks the", "wind artifact"], ["another"]),
    ("ice_artifact_unlock", ["unlocks the", "ice artifact"], ["another"]),
    ("fire_artifact_2_unlock", ["unlocks another", "fire artifact"], []),
    ("light_artifact_2_unlock", ["unlocks another", "light artifact"], []),
    ("earth_artifact_2_unlock", ["unlocks another", "earth artifact"], []),
    ("wind_artifact_2_unlock", ["unlocks another", "wind artifact"], []),
    ("ice_artifact_2_unlock", ["unlocks another", "ice artifact"], []),
    ("build_presets_unlock", ["5 different build sets", "shift"], []),
]

# Distinctive short titles → upgrade. Only used when unique.
TITLE_HINTS: dict[str, str] = {
    "longshot": "arrow_tower_damage",
    "multicrit": "arrow_tower_multicrit",
    "multishot": "arrow_tower_multishot",
    "poison arrows": "arrow_tower_poison",
    "heavy arrows": "arrow_tower_heavy",
    "early spawn": "early_spawn",
    "auto collect": "auto_collect_gems",
    "auto mark": "targetting_auto",
    "auto level": "tower_upgrade_auto",
    "auto shoot": "gem_cannon_auto_shoot",
    "auto start wave": "auto_start_wave",
    "coin converter": "gem_convert",
    "coin drops": "gem_drops",
    "pulse rate": "slow_tower_fire_rate",
    "demolish towers": "tower_demolish_unlock",
    "artifacts": "artifacts_unlock",
    "fire artifact": "fire_artifact_unlock",
    "light artifact": "light_artifact_unlock",
    "earth artifact": "earth_artifact_unlock",
    "wind artifact": "wind_artifact_unlock",
    "ice artifact": "ice_artifact_unlock",
    "charged venom": "arrow_tower_poison_charge_add_stacks",
    "toxic gas": "arrow_tower_poison_pool",
    "piercing shot": "arrow_tower_pierce_shield",
    "overkill damage": "lightning_tower_overkill_damage_extra",
    "cannon fire rate": "gem_cannon_fire_rate",
    "lucky shot": "gem_cannon_crit_chance",
    "cashback": "gem_cannon_shot_reimbursement_chance",
    "early charge": "early_spawn_charge",
    "faster charging": "charge_amount",
    "charge buff": "slow_tower_charge_buff",
    "exposing slow": "slow_vulnerable",
    "lasting slow": "slow_duration",
    "crippling slow": "slow_amount",
    "pool of decay": "slow_zone",
    "explosive grunt": "explosive_grunts",
    "explosive runner": "explosive_runners_chance",
    "bigger bombs": "explosive_damage",
    "fireball": "explosion_fireball",
    "burn spreading": "burn_spreading",
    "wildfire": "burn_spread_to_burning",
    "focused fire": "burn_concentration",
    "accelerated burn": "burn_tick_rate_accelerated_enemies",
    "storm’s reach": "lightning_tower_jump_range",
    "storm's reach": "lightning_tower_jump_range",
    "aftershock": "lightning_tower_overkill_retrigger_chance",
    "shock therapy": "lightning_tower_apply_shock",
    "echoing shock": "lightning_tower_spread_status",
    "uncapped upside": "economy_uncapped_levels",
    "the rich get richer": "economy_gem_interest",
    "coin bank": "bank_tower_unlock",
    "death and taxes": "bank_tower_add_vulnerable",
    "token tariff": "bank_tower_tokens",
    "liquid assets": "bank_tower_pool",
    "build challenges": "level_challenge_unlock",
}


def dart_escape(value: str) -> str:
    return (
        value.replace("\\", "\\\\")
        .replace("'", "\\'")
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("$", "\\$")
    )


def fold(text: str) -> str:
    text = text.replace("\u2019", "'").replace("\u2018", "'")
    text = text.replace("\u201c", '"').replace("\u201d", '"')
    text = re.sub(r"\[/?[^\]]+\]", " ", text)
    return " ".join(text.lower().split())


def is_mobile_variant(text: str) -> bool:
    folded = fold(text)
    return any(marker in folded for marker in MOBILE_MARKERS)


def load_upgrade_names() -> list[str]:
    src = UPGRADES_PATH.read_text()
    match = re.search(r"enum Upgrade \{([^}]+)\}", src, re.S)
    if not match:
        raise SystemExit("Could not parse Upgrade enum")
    return [
        line.strip().rstrip(",")
        for line in match.group(1).splitlines()
        if line.strip() and not line.strip().startswith("//")
    ]


def load_csv_rows() -> list[tuple[str, str]]:
    with CSV_PATH.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        return [(row["key"] or "", row["en"] or "") for row in reader]


def contains_all(haystack: str, needles: list[str]) -> bool:
    return all(fold(needle) in haystack for needle in needles)


def contains_any(haystack: str, needles: list[str]) -> bool:
    return any(fold(needle) in haystack for needle in needles)


def match_description(english: str, used_upgrades: set[str]) -> list[str]:
    haystack = fold(english)
    hits: list[tuple[int, str]] = []
    for upgrade, must, must_not in DESCRIPTION_RULES:
        if upgrade in used_upgrades:
            continue
        if not contains_all(haystack, must):
            continue
        if must_not and contains_any(haystack, must_not):
            continue
        hits.append((len(must), upgrade))
    if not hits:
        return []
    best = max(score for score, _ in hits)
    return [upgrade for score, upgrade in hits if score == best]


def main() -> None:
    upgrades = load_upgrade_names()
    rows = load_csv_rows()

    strings: dict[str, str] = {}
    missing_rows: list[tuple[int, str]] = []

    for key, english in rows:
        match = MISSING_RE.match(key)
        if match:
            missing_rows.append((int(match.group(1)), english))
            continue
        if key and english:
            strings[key] = english

    # Keywords first so they are not eaten by upgrade rules.
    remaining = list(missing_rows)
    for key, needles in KEYWORD_HINTS.items():
        for index, english in list(remaining):
            if contains_all(fold(english), list(needles)):
                strings[key] = english
                remaining.remove((index, english))
                break

    assigned_upgrades: set[str] = set()
    used_missing: set[int] = set()
    for index, english in remaining:
        if is_mobile_variant(english):
            continue
        matches = match_description(english, assigned_upgrades)
        if not matches:
            continue
        for upgrade in matches:
            strings[f"UPGRADE_DESCRIPTION_{upgrade.upper()}"] = english
            assigned_upgrades.add(upgrade)
        used_missing.add(index)

    remaining = [(i, e) for i, e in remaining if i not in used_missing]

    taken_title_upgrades = {
        key.removeprefix("UPGRADE_TITLE_").lower()
        for key in strings
        if key.startswith("UPGRADE_TITLE_")
    }
    for index, english in remaining:
        folded = fold(english)
        if "\n" in english or "{" in english or "[" in english:
            continue
        if len(english) > 40:
            continue
        upgrade = TITLE_HINTS.get(folded)
        if not upgrade or upgrade in taken_title_upgrades:
            continue
        strings[f"UPGRADE_TITLE_{upgrade.upper()}"] = english
        taken_title_upgrades.add(upgrade)
        used_missing.add(index)

    remaining = [(i, e) for i, e in remaining if i not in used_missing]
    for index, english in remaining:
        strings[f"missing_{index}"] = english

    lines = [
        "// GENERATED CODE - DO NOT MODIFY BY HAND",
        "// dart run tool/import_localization.py",
        "const Map<String, String> kEnStrings = {",
    ]
    for key in sorted(strings):
        lines.append(f"  '{dart_escape(key)}': '{dart_escape(strings[key])}',")
    lines.append("};")
    lines.append("")
    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text("\n".join(lines))

    missing_desc = [
        name
        for name in upgrades
        if f"UPGRADE_DESCRIPTION_{name.upper()}" not in strings
    ]
    missing_title = [
        name
        for name in upgrades
        if f"UPGRADE_TITLE_{name.upper()}" not in strings
    ]
    print(f"Wrote {OUT_PATH} ({len(strings)} keys)")
    print(f"Upgrade descriptions mapped: {len(upgrades) - len(missing_desc)}/{len(upgrades)}")
    if missing_desc:
        print("Unmapped descriptions:")
        for name in missing_desc:
            print(f"  - {name}")
    print(f"Upgrade titles mapped: {len(upgrades) - len(missing_title)}/{len(upgrades)}")
    print(f"Leftover missing_* rows: {len(remaining)}")


if __name__ == "__main__":
    main()
