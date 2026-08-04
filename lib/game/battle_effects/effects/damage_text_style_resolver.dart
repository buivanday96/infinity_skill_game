import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinity_skill_game/game/battle_effects/enums/damage_type.dart';

/// Maps [DamageType] → paint style. Single place to tune floating-text look.
///
/// Pixel art vibe: [Pixelify Sans] for combat numbers, [Silkscreen] for miss/dodge.
class DamageTextStyleResolver {
  const DamageTextStyleResolver();

  TextStyle resolve(DamageType type) {
    return switch (type) {
      DamageType.normal => GoogleFonts.pixelifySans(
          color: const Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          shadows: _shadow,
        ),
      DamageType.critical => GoogleFonts.pixelifySans(
          color: const Color(0xFFFFE566),
          fontSize: 30,
          fontWeight: FontWeight.w800,
          shadows: _shadow,
        ),
      DamageType.heal => GoogleFonts.pixelifySans(
          color: const Color(0xFF66FF99),
          fontSize: 20,
          fontWeight: FontWeight.w500,
          shadows: _shadow,
        ),
      DamageType.poison => GoogleFonts.pixelifySans(
          color: const Color(0xFFB8FF66),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          shadows: _shadow,
        ),
      DamageType.burn => GoogleFonts.pixelifySans(
          color: const Color(0xFFFF8844),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          shadows: _shadow,
        ),
      DamageType.miss || DamageType.dodge => GoogleFonts.silkscreen(
          color: const Color(0xFFB0B0B0),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          shadows: _shadow,
        ),
      DamageType.shield => GoogleFonts.pixelifySans(
          color: const Color(0xFF66E0FF),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          shadows: _shadow,
        ),
      DamageType.mana => GoogleFonts.pixelifySans(
          color: const Color(0xFF6699FF),
          fontSize: 18,
          fontWeight: FontWeight.w500,
          shadows: _shadow,
        ),
      DamageType.exp => GoogleFonts.pixelifySans(
          color: const Color(0xFFD4A0FF),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          shadows: _shadow,
        ),
      DamageType.gold => GoogleFonts.pixelifySans(
          color: const Color(0xFFFFAA33),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          shadows: _shadow,
        ),
    };
  }

  static const _shadow = [
    Shadow(color: Color(0xCC000000), blurRadius: 3, offset: Offset(1, 1)),
  ];
}
