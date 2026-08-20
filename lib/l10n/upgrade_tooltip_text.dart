import '../models/upgrade_data.dart';
import '../models/upgrades.dart';
import 'game_strings.dart';

String upgradeTitleKey(Upgrade upgrade) =>
    'UPGRADE_TITLE_${upgrade.name.toUpperCase()}';

String upgradeDescriptionKey(Upgrade upgrade) =>
    'UPGRADE_DESCRIPTION_${upgrade.name.toUpperCase()}';

String keywordKey(Keyword keyword) => 'KEYWORD_${keyword.name.toUpperCase()}';

String localizedTooltipTitle(Upgrade upgrade) {
  final key = upgradeTitleKey(upgrade);
  if (!GameStrings.has(key)) {
    return _humanizeUpgradeName(upgrade);
  }
  return GameStrings.tr(key);
}

/// Godot `Upgrades.get_tooltip_description`.
String localizedTooltipDescription(
  Upgrade upgrade,
  UpgradeData data,
  int currentLevel,
) {
  final key = upgradeDescriptionKey(upgrade);
  if (!GameStrings.has(key)) {
    return _fallbackDescription(data, currentLevel);
  }

  final formatData = <String, String>{};
  addFormattedValue(
    formatData,
    data: data,
    currentLevel: currentLevel,
  );
  final extra = data.data;
  if (extra != null) {
    for (final dataKey in extra.keys) {
      addFormattedValue(
        formatData,
        data: data,
        currentLevel: currentLevel,
        dataKey: dataKey,
      );
    }
  }

  var formatted = GameStrings.format(GameStrings.tr(key), formatData);

  for (final keyword in data.keywords) {
    final keywordStringKey = keywordKey(keyword);
    final keywordStats = keywordValue(keyword);
    if (keywordStats != null) {
      final isPercentage =
          keywordStats.format == ValueFormat.percentage ||
          keywordStats.format == ValueFormat.percentage_decimals;
      final valueKey = isPercentage ? 'value_percent' : 'value';
      final keywordFormat = <String, String>{
        valueKey:
            '[value_after]${getFormattedValue(keywordStats.format, keywordStats.value)}[/value_after]',
      };
      formatted +=
          '\n\n${GameStrings.format(GameStrings.tr(keywordStringKey), keywordFormat)}';
    } else {
      formatted +=
          '\n\n${GameStrings.format(GameStrings.tr(keywordStringKey), formatData)}';
    }
  }

  return formatted;
}

class KeywordStats {
  const KeywordStats({required this.value, required this.format});

  final num value;
  final ValueFormat format;
}

KeywordStats? keywordValue(Keyword keyword) {
  return switch (keyword) {
    Keyword.combustion => const KeywordStats(
      value: 0.5,
      format: ValueFormat.percentage,
    ),
    Keyword.critical_hit => const KeywordStats(
      value: 0.5,
      format: ValueFormat.percentage,
    ),
    Keyword.vulnerable => KeywordStats(
      value: VulnerableStatus.BASE_DAMAGE_MULTIPLIER - 1.0,
      format: ValueFormat.percentage,
    ),
    Keyword.pool => KeywordStats(
      value: SlowZone.BASE_SLOW_AMOUNT,
      format: ValueFormat.percentage,
    ),
    _ => null,
  };
}

void addFormattedValue(
  Map<String, String> formattedData, {
  required UpgradeData data,
  required int currentLevel,
  String dataKey = '',
}) {
  final isDataValue = dataKey.isNotEmpty;
  final resolvedKey = isDataValue ? dataKey : 'value';

  if (isDataValue) {
    if (data.data == null || !data.data!.containsKey(dataKey)) {
      return;
    }
  } else if (data.value == null) {
    return;
  }

  late final ValueFormat format;
  if (isDataValue) {
    format = _dataFormat(data.data![dataKey]);
  } else {
    format = data.valueFormat ?? ValueFormat.number;
  }

  final isPercentage =
      format == ValueFormat.percentage ||
      format == ValueFormat.percentage_decimals;
  final variableName = isPercentage ? '${resolvedKey}_percent' : resolvedKey;

  String formattedAt(int levelOffset) {
    if (isDataValue) {
      return getFormattedValue(
        format,
        getDataValue(data, dataKey, currentLevel + levelOffset),
      );
    }
    return getFormattedValue(format, data.getValue(currentLevel + levelOffset));
  }

  final isMaxed = data.maxLevel > 0 && currentLevel >= data.maxLevel;
  if (isMaxed) {
    formattedData[variableName] =
        '[value_after]${formattedAt(0)}[/value_after]';
    return;
  }
  if (currentLevel == 0) {
    formattedData[variableName] =
        '[value_after]${formattedAt(1)}[/value_after]';
    return;
  }

  final before = formattedAt(0);
  final after = formattedAt(1);
  if (before == after) {
    formattedData[variableName] = '[value_after]$after[/value_after]';
  } else {
    formattedData[variableName] =
        '[value_before]$before[/value_before] → [value_after]$after[/value_after]';
  }
}

dynamic getDataValue(UpgradeData data, String key, int level) {
  final raw = data.data?[key];
  if (raw is Map) {
    final value = raw['value'];
    if (value is Function) {
      return value(level);
    }
    return value;
  }
  return raw;
}

ValueFormat _dataFormat(dynamic raw) {
  if (raw is Map) {
    final format = raw['format'];
    if (format is ValueFormat) {
      return format;
    }
  }
  return ValueFormat.number;
}

String getFormattedValue(ValueFormat format, dynamic value) {
  if (value is! num) {
    return '$value';
  }
  switch (format) {
    case ValueFormat.percentage:
      return '${(value * 100).round()}%';
    case ValueFormat.percentage_decimals:
      return '${(value * 100).toStringAsFixed(2)}%';
    case ValueFormat.number:
      if (value == value.roundToDouble()) {
        return '${value.round()}';
      }
      return '$value';
  }
}

String _humanizeUpgradeName(Upgrade upgrade) {
  return upgrade.name
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _fallbackDescription(UpgradeData data, int currentLevel) {
  if (data.value == null) {
    return 'Unlocks this upgrade';
  }
  final value = data.getValue(currentLevel == 0 ? 1 : currentLevel);
  return switch (data.valueFormat) {
    ValueFormat.percentage => 'Value: ${(value * 100).round()}%',
    ValueFormat.percentage_decimals =>
      'Value: ${(value * 100).toStringAsFixed(1)}%',
    _ => 'Value: $value',
  };
}
