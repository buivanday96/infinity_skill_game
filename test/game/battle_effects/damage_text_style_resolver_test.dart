import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/game/battle_effects/effects/damage_text_style_resolver.dart';
import 'package:infinity_skill_game/game/battle_effects/enums/damage_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DamageTextStyleResolver', () {
    const resolver = DamageTextStyleResolver();

    test('normal is white Pixelify Sans Bold', () {
      final style = resolver.resolve(DamageType.normal);
      expect(style.color, const Color(0xFFFFFFFF));
      expect(style.fontSize, 18);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.fontFamily, startsWith('Pixelify'));
    });

    test('critical is yellow ExtraBold larger', () {
      final style = resolver.resolve(DamageType.critical);
      expect(style.color, const Color(0xFFFFE566));
      expect(style.fontSize, 30);
      expect(style.fontWeight, FontWeight.w800);
      expect(style.fontFamily, startsWith('Pixelify'));
    });

    test('heal is green Pixelify Sans Medium', () {
      final style = resolver.resolve(DamageType.heal);
      expect(style.color, const Color(0xFF66FF99));
      expect(style.fontWeight, FontWeight.w500);
      expect(style.fontFamily, startsWith('Pixelify'));
    });

    test('gold is orange', () {
      final style = resolver.resolve(DamageType.gold);
      expect(style.color, const Color(0xFFFFAA33));
    });

    test('miss and dodge use muted Silkscreen', () {
      final miss = resolver.resolve(DamageType.miss);
      final dodge = resolver.resolve(DamageType.dodge);
      expect(miss.color, dodge.color);
      expect(miss.color, const Color(0xFFB0B0B0));
      expect(miss.fontFamily, startsWith('Silkscreen'));
      expect(miss.fontWeight, FontWeight.w400);
    });

    test('shield is cyan', () {
      final style = resolver.resolve(DamageType.shield);
      expect(style.color, const Color(0xFF66E0FF));
    });
  });
}
