import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/l10n/game_strings.dart';

void main() {
  group('GameStrings.tr', () {
    test('returns the imported English string for a recovered key', () {
      expect(GameStrings.tr('TOOLTIP_UPGRADE'), 'Upgrade');
      expect(GameStrings.tr('TOOLTIP_REFUND'), 'Refund');
    });

    test('returns the key when the string is missing', () {
      expect(GameStrings.tr('NOT_A_REAL_KEY'), 'NOT_A_REAL_KEY');
    });
  });

  group('GameStrings.format', () {
    test('replaces Godot-style placeholders', () {
      expect(
        GameStrings.format('Raise by {value}.', {'value': '8'}),
        'Raise by 8.',
      );
    });

    test('leaves unknown placeholders in place', () {
      expect(
        GameStrings.format('Hello {name}', {'other': 'x'}),
        'Hello {name}',
      );
    });
  });
}
