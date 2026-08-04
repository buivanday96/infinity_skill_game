/// Domain models for battle stats, combatants, skills, and progression.
///
/// Architecture (chapter 7):
///   Base → Flat Bonus → Percent Bonus → Final
/// Combat reads finals only. Level-up grows base; floor picks / skill tree /
/// equipment / buffs add [StatModifier]s.
library;

export 'package:infinity_skill_game/features/battle/domain/combatant.dart';
export 'package:infinity_skill_game/features/battle/domain/hit_reaction.dart';
export 'package:infinity_skill_game/features/hero/domain/hero_model.dart';
export 'package:infinity_skill_game/features/monster/domain/monster_model.dart';
export 'package:infinity_skill_game/features/progression/domain/dungeon_system.dart';
export 'package:infinity_skill_game/features/progression/domain/floor_choice.dart';
export 'package:infinity_skill_game/features/progression/domain/floor_encounter.dart';
export 'package:infinity_skill_game/features/progression/domain/floor_encounter_catalog.dart';
export 'package:infinity_skill_game/features/progression/domain/growth_curve.dart';
export 'package:infinity_skill_game/features/progression/domain/progression_service.dart';
export 'package:infinity_skill_game/features/progression/domain/skill_tree.dart';
export 'package:infinity_skill_game/features/skill/domain/skill_model.dart';
export 'package:infinity_skill_game/features/stats/domain/combat_stats.dart';
export 'package:infinity_skill_game/features/stats/domain/modifier_source.dart';
export 'package:infinity_skill_game/features/stats/domain/stat_id.dart';
export 'package:infinity_skill_game/features/stats/domain/stat_modifier.dart';
