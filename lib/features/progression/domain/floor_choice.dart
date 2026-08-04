import 'dart:math' as math;

import 'package:infinity_skill_game/features/hero/domain/hero_model.dart';
import 'package:infinity_skill_game/features/skill/domain/skill_model.dart';
import 'package:infinity_skill_game/features/stats/domain/modifier_source.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_id.dart';
import 'package:infinity_skill_game/features/stats/domain/stat_modifier.dart';

/// Gacha-style rarity for post-floor picks.
enum FloorChoiceRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary;

  String get label => switch (this) {
        FloorChoiceRarity.common => 'Common',
        FloorChoiceRarity.uncommon => 'Uncommon',
        FloorChoiceRarity.rare => 'Rare',
        FloorChoiceRarity.epic => 'Epic',
        FloorChoiceRarity.legendary => 'Legendary',
      };

  /// Stat / heal power vs common baseline.
  double get powerMultiplier => switch (this) {
        FloorChoiceRarity.common => 1.0,
        FloorChoiceRarity.uncommon => 1.25,
        FloorChoiceRarity.rare => 1.6,
        FloorChoiceRarity.epic => 2.15,
        FloorChoiceRarity.legendary => 2.9,
      };

  /// Base pull weight before floor pity (sums ≈ 100).
  double get baseWeight => switch (this) {
        FloorChoiceRarity.common => 52,
        FloorChoiceRarity.uncommon => 26,
        FloorChoiceRarity.rare => 14,
        FloorChoiceRarity.epic => 6,
        FloorChoiceRarity.legendary => 2,
      };

  /// Accent color as ARGB (UI maps this to Flutter [Color]).
  int get accentArgb => switch (this) {
        FloorChoiceRarity.common => 0xFF9AA3A0,
        FloorChoiceRarity.uncommon => 0xFF4CAF71,
        FloorChoiceRarity.rare => 0xFF4A9EFF,
        FloorChoiceRarity.epic => 0xFFC45CFF,
        FloorChoiceRarity.legendary => 0xFFFFB020,
      };

  /// Soft background tint for choice cards.
  int get fillArgb => switch (this) {
        FloorChoiceRarity.common => 0xFF1A221E,
        FloorChoiceRarity.uncommon => 0xFF13261C,
        FloorChoiceRarity.rare => 0xFF122033,
        FloorChoiceRarity.epic => 0xFF1E1430,
        FloorChoiceRarity.legendary => 0xFF2A2110,
      };
}

/// One option shown after clearing a floor (Infinite Skill pick).
enum FloorChoiceKind {
  statBoost,
  unlockSkill,
  upgradeSkill,
  heal,
}

class FloorChoice {
  const FloorChoice({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    this.rarity = FloorChoiceRarity.common,
    this.iconAsset,
    this.modifiers = const [],
    this.skillToUnlock,
    this.skillIdToUpgrade,
    this.healPercent = 0,
  });

  final String id;
  final String title;
  final String description;
  final FloorChoiceKind kind;
  final FloorChoiceRarity rarity;

  /// Asset path under `assets/icons/...`, if any.
  final String? iconAsset;

  /// Applied with [ModifierSource.floorChoice] when picked.
  final List<StatModifier> modifiers;

  final SkillDefinition? skillToUnlock;
  final String? skillIdToUpgrade;

  /// 0–1 portion of max HP restored (e.g. 0.3 = 30%).
  final double healPercent;

  /// Applies this choice to [hero]. Safe to call once per pick.
  void applyTo(HeroModel hero, {required int floor}) {
    final key = 'floor_choice:$id:f$floor';

    switch (kind) {
      case FloorChoiceKind.statBoost:
        hero.applyModifiers(
          modifiers.map(
            (m) => m.copyWith(
              id: '$key:${m.stat.name}',
              source: ModifierSource.floorChoice,
              sourceKey: key,
            ),
          ),
        );
      case FloorChoiceKind.unlockSkill:
        final def = skillToUnlock;
        if (def != null) {
          hero.addSkill(SkillInstance(definition: def));
        }
      case FloorChoiceKind.upgradeSkill:
        final skillId = skillIdToUpgrade;
        if (skillId != null) {
          hero.skillById(skillId)?.upgrade();
        }
      case FloorChoiceKind.heal:
        hero.heal(hero.maxHp * healPercent.clamp(0.0, 1.0));
    }
  }
}

/// Blueprint rolled into a concrete [FloorChoice] at a given rarity.
class FloorChoiceTemplate {
  const FloorChoiceTemplate({
    required this.id,
    required this.kind,
    required this.description,
    this.iconAsset,
    this.baseFlat = 0,
    this.basePercent = 0,
    this.stat,
    this.baseHealPercent = 0,
  });

  final String id;
  final FloorChoiceKind kind;
  final String description;

  /// Icon matched by filename under `assets/icons/`.
  final String? iconAsset;
  final double baseFlat;
  final double basePercent;
  final StatId? stat;
  final double baseHealPercent;

  FloorChoice materialize(FloorChoiceRarity rarity) {
    final mult = rarity.powerMultiplier;
    final flat = baseFlat * mult;
    final percent = basePercent * mult;
    final heal = (baseHealPercent * mult).clamp(0.0, 1.0);

    return FloorChoice(
      id: '$id:${rarity.name}',
      title: _title(flat: flat, percent: percent, heal: heal),
      description: description,
      kind: kind,
      rarity: rarity,
      iconAsset: iconAsset,
      healPercent: heal,
      modifiers: kind == FloorChoiceKind.statBoost && stat != null
          ? [
              StatModifier(
                id: 'tpl',
                stat: stat!,
                source: ModifierSource.floorChoice,
                flat: flat,
                percent: percent,
              ),
            ]
          : const [],
    );
  }

  String _title({
    required double flat,
    required double percent,
    required double heal,
  }) {
    return switch (kind) {
      FloorChoiceKind.heal => 'Field Mend (+${(heal * 100).round()}% HP)',
      FloorChoiceKind.statBoost when percent != 0 && flat != 0 =>
        '${_statLabel(stat!)} +${flat.round()} / +${_pct(percent)}',
      FloorChoiceKind.statBoost when percent != 0 =>
        '+${_pct(percent)} ${_statLabel(stat!)}',
      FloorChoiceKind.statBoost =>
        '+${_formatFlat(stat!, flat)} ${_statLabel(stat!)}',
      FloorChoiceKind.unlockSkill => 'Unlock Skill',
      FloorChoiceKind.upgradeSkill => 'Upgrade Skill',
    };
  }

  static String _pct(double p) {
    final v = p * 100;
    return v == v.roundToDouble() ? '${v.round()}%' : '${v.toStringAsFixed(1)}%';
  }

  static String _formatFlat(StatId stat, double flat) {
    // Crit / CDR stored as 0–1 rates — show as percent points.
    if (stat == StatId.criticalRate ||
        stat == StatId.cooldownReduction ||
        stat == StatId.evasion ||
        stat == StatId.accuracy) {
      return _pct(flat);
    }
    return flat == flat.roundToDouble()
        ? '${flat.round()}'
        : flat.toStringAsFixed(1);
  }

  static String _statLabel(StatId stat) => switch (stat) {
        StatId.attack => 'Attack',
        StatId.maxHp => 'Max HP',
        StatId.attackSpeed => 'Attack Speed',
        StatId.criticalRate => 'Crit Rate',
        StatId.cooldownReduction => 'CDR',
        StatId.moveSpeed => 'Move Speed',
        StatId.defense => 'Defense',
        StatId.magicAttack => 'Magic Attack',
        StatId.criticalDamage => 'Crit Damage',
        _ => stat.name,
      };
}

/// Weighted gacha offers — 3 picks after each floor clear.
class FloorChoiceCatalog {
  const FloorChoiceCatalog();

  /// Rolls [count] unique templates, each with an independent rarity pull.
  ///
  /// Pass [rng] for tests; production uses a fresh [math.Random].
  /// Deeper floors slightly bias toward higher rarities (soft pity).
  List<FloorChoice> offerForFloor(
    int floor, {
    int count = 3,
    math.Random? rng,
  }) {
    final random = rng ?? math.Random();
    final templates = List<FloorChoiceTemplate>.of(_templates)..shuffle(random);
    final result = <FloorChoice>[];
    final used = <String>{};

    for (var i = 0; i < count; i++) {
      final rarity = _rollRarity(floor, random);
      // Prefer unused templates; wrap if pool smaller than count.
      FloorChoiceTemplate? picked;
      for (final t in templates) {
        if (!used.contains(t.id)) {
          picked = t;
          break;
        }
      }
      picked ??= templates[i % templates.length];
      used.add(picked.id);
      result.add(picked.materialize(rarity));
    }
    return result;
  }

  /// Soft pity: every 5 floors, shift weight from common toward rare+.
  static FloorChoiceRarity _rollRarity(int floor, math.Random rng) {
    final pity = ((floor - 1) ~/ 5).clamp(0, 6);
    final weights = <FloorChoiceRarity, double>{
      for (final r in FloorChoiceRarity.values) r: r.baseWeight,
    };
    weights[FloorChoiceRarity.common] =
        (weights[FloorChoiceRarity.common]! - pity * 3).clamp(18, 52);
    weights[FloorChoiceRarity.uncommon] =
        weights[FloorChoiceRarity.uncommon]! - pity * 0.5;
    weights[FloorChoiceRarity.rare] = weights[FloorChoiceRarity.rare]! + pity * 1.5;
    weights[FloorChoiceRarity.epic] = weights[FloorChoiceRarity.epic]! + pity * 1.2;
    weights[FloorChoiceRarity.legendary] =
        weights[FloorChoiceRarity.legendary]! + pity * 0.8;

    final total = weights.values.fold<double>(0, (a, b) => a + b);
    var roll = rng.nextDouble() * total;
    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }
    return FloorChoiceRarity.common;
  }

  static const List<FloorChoiceTemplate> _templates = [
    FloorChoiceTemplate(
      id: 'atk_pct',
      kind: FloorChoiceKind.statBoost,
      description: 'Increase physical attack permanently this run.',
      iconAsset: 'assets/icons/stats/strength_arm.png',
      stat: StatId.attack,
      basePercent: 0.10,
    ),
    FloorChoiceTemplate(
      id: 'hp_flat',
      kind: FloorChoiceKind.statBoost,
      description: 'Bulk up for deeper floors.',
      iconAsset: 'assets/icons/stats/stamina_heart.png',
      stat: StatId.maxHp,
      baseFlat: 60,
    ),
    FloorChoiceTemplate(
      id: 'aspd',
      kind: FloorChoiceKind.statBoost,
      description: 'Strike more often.',
      iconAsset: 'assets/icons/physical/rapid_strikes.png',
      stat: StatId.attackSpeed,
      basePercent: 0.08,
    ),
    FloorChoiceTemplate(
      id: 'crit',
      kind: FloorChoiceKind.statBoost,
      description: 'Land critical hits more often.',
      iconAsset: 'assets/icons/status/critical_hit.png',
      stat: StatId.criticalRate,
      baseFlat: 0.05,
    ),
    FloorChoiceTemplate(
      id: 'cdr',
      kind: FloorChoiceKind.statBoost,
      description: 'Skills come back faster.',
      iconAsset: 'assets/icons/symbol/hourglass_sand.png',
      stat: StatId.cooldownReduction,
      baseFlat: 0.06,
    ),
    FloorChoiceTemplate(
      id: 'move',
      kind: FloorChoiceKind.statBoost,
      description: 'Reposition faster in battle.',
      iconAsset: 'assets/icons/utility/speed_boots.png',
      stat: StatId.moveSpeed,
      basePercent: 0.08,
    ),
    FloorChoiceTemplate(
      id: 'def_flat',
      kind: FloorChoiceKind.statBoost,
      description: 'Shrug off more physical hits.',
      iconAsset: 'assets/icons/utility/defense_up.png',
      stat: StatId.defense,
      baseFlat: 8,
    ),
    FloorChoiceTemplate(
      id: 'mend',
      kind: FloorChoiceKind.heal,
      description: 'Restore HP before the next floor.',
      iconAsset: 'assets/icons/holy/restore.png',
      baseHealPercent: 0.28,
    ),
  ];
}
