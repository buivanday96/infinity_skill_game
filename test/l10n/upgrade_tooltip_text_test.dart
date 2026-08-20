import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/l10n/game_strings.dart';
import 'package:infinity_skill_game/l10n/upgrade_tooltip_text.dart';
import 'package:infinity_skill_game/models/upgrade_data.dart';
import 'package:infinity_skill_game/models/upgrades.dart';

void main() {
  group('localizedTooltipDescription', () {
    test('starting_gems at level 0 uses the next-rank value', () {
      final data = upgradesMap[Upgrade.starting_gems]!;
      final text = localizedTooltipDescription(
        Upgrade.starting_gems,
        data,
        0,
      );
      expect(text, contains('start each run'));
      expect(text, contains('[value_after]5[/value_after]'));
      expect(text, isNot(contains('[value_before]')));
    });

    test('starting_gems mid-level shows before → after', () {
      final data = upgradesMap[Upgrade.starting_gems]!;
      final text = localizedTooltipDescription(
        Upgrade.starting_gems,
        data,
        2,
      );
      expect(
        text,
        contains(
          '[value_before]10[/value_before] → [value_after]15[/value_after]',
        ),
      );
    });

    test('appends a keyword gloss with a formatted value', () {
      final data = upgradesMap[Upgrade.slow_zone]!;
      final text = localizedTooltipDescription(
        Upgrade.slow_zone,
        data,
        0,
      );
      expect(text.split('\n\n').length, greaterThan(1));
      expect(
        text,
        contains(
          'Any enemy within a [kw_pool]Pool[/kw_pool] is [kw_slow]Slowed[/kw_slow]',
        ),
      );
      expect(text, contains('[value_after]50%[/value_after]'));
      expect(text, isNot(contains('KEYWORD_POOL')));
    });
  });

  group('coverage', () {
    test('every upgrade has a reconstructed UPGRADE_DESCRIPTION_ key', () {
      final missing = <String>[];
      for (final upgrade in Upgrade.values) {
        final key = upgradeDescriptionKey(upgrade);
        if (!GameStrings.has(key)) {
          missing.add(key);
        }
      }
      expect(missing, isEmpty, reason: missing.join('\n'));
    });
  });
}
