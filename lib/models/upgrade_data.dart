import 'upgrade_ids.dart';

class UpgradeData {
  final int maxLevel;
  final dynamic cost; // int, List<int>, or int Function(int)
  final String costToken;
  final String? iconPath;
  final ActivationLevel activationLevel;
  final List<Tag> tags;
  final Upgrade? dependency;
  final dynamic value; // Can be num or Function(int)
  final ValueFormat? valueFormat;
  final bool isMilestone;
  final bool isArtifact;
  final List<Keyword> keywords;
  final bool dynamicCost;
  final Map<String, dynamic>? data;
  final dynamic requiredCompletedLevel;
  final bool defaultUnlockedOnMobile;
  final bool availableInDemo;

  const UpgradeData({
    required this.maxLevel,
    required this.cost,
    required this.costToken,
    this.iconPath,
    this.activationLevel = ActivationLevel.hidden,
    this.tags = const [],
    this.dependency,
    this.value,
    this.valueFormat,
    this.isMilestone = false,
    this.isArtifact = false,
    this.keywords = const [],
    this.dynamicCost = false,
    this.data,
    this.requiredCompletedLevel,
    this.defaultUnlockedOnMobile = false,
    this.availableInDemo = true,
  });

  int getCost(int level) {
    if (level < 0 || level >= maxLevel) {
      return 0;
    }
    if (cost is int) {
      return cost as int;
    }
    if (cost is List) {
      final table = cost as List<dynamic>;
      if (level >= table.length) {
        return 0;
      }
      return (table[level] as num).toInt();
    }
    if (cost is Function) {
      return (cost as Function)(level);
    }
    return 0;
  }

  num getValue(int level) {
    if (value is num) {
      return value as num;
    } else if (value is Function) {
      return (value as Function)(level);
    }
    return 0;
  }
}

// Dummy classes to make the generated file compile
class Levels {
  static const LevelType = _LevelType();
}

class _LevelType {
  const _LevelType();
  final LEVEL_ARTIFACT_FIRE = 'LEVEL_ARTIFACT_FIRE';
  final LEVEL_ARTIFACT_LIGHT = 'LEVEL_ARTIFACT_LIGHT';
  final LEVEL_ARTIFACT_EARTH = 'LEVEL_ARTIFACT_EARTH';
  final LEVEL_ARTIFACT_WIND = 'LEVEL_ARTIFACT_WIND';
  final LEVEL_ARTIFACT_ICE = 'LEVEL_ARTIFACT_ICE';
}

class Enchants {
  static const Type = _EnchantsType();
}

class _EnchantsType {
  const _EnchantsType();
  final FIRE = 'FIRE';
  final LIGHT = 'LIGHT';
  final EARTH = 'EARTH';
  final WIND = 'WIND';
  final ICE = 'ICE';
}

class VulnerableStatus {
  static const BASE_DAMAGE_MULTIPLIER = 1.5;
}

class BurningStatus {
  static const BASE_DAMAGE_MULTIPLIER = 1.5;
  static const DEFAULT_TICKS = 5;
}

class SlowZone {
  static const BASE_SLOW_AMOUNT = 0.5;
}

class InputMap {
  static dynamic action_get_events(String action) => [];
}

class PackedStringArray {
  PackedStringArray(List<String> list);
}

class Damage {
  static const Type = _DamageType();
}

class _DamageType {
  const _DamageType();
  final LIGHTNING = 'LIGHTNING';
}

class GunMode {
  static const MULTISHOT = 'MULTISHOT';
}

dynamic func(dynamic event) => null;
dynamic event;

int artifact_cost(int l) => 100;
