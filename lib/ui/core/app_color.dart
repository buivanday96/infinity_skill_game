import 'package:flutter/material.dart';

import 'color_utils.dart';

/// Godot `ProjectColors` palette.
abstract final class AppColor {
  static const foreground = Color(0xFFFFFFFF);
  static const subtleForeground = Color(0xFFBECCCC);
  static const subtleForeground2 = Color(0xFF677E7E);
  static const highlightedForeground = Color(0xFF2BD4AE);
  static const highlightedForeground2 = Color(0xFFF2CF5A);
  static const highlightedForeground3 = Color(0xFFF3695E);
  static const successForeground = Color(0xFF6EDB46);
  static const failForeground = Color(0xFFDB465D);

  static const core = Color(0xFFF19A0E);

  /// Godot `rendering/environment/defaults/default_clear_color`.
  static const background = Color.from(
    alpha: 1,
    red: 0.13812998,
    green: 0.1159,
    blue: 0.19,
  );

  static final successBackground = ColorUtils.darkenedHueShift(
    successForeground,
    0.1,
  );
  static final failBackground = ColorUtils.darkenedHueShift(
    failForeground,
    0.1,
  );
  static final darkBackground = ColorUtils.darkenedHueShift(background, 0.35);
  static final lightBackground = ColorUtils.darkenedHueShift(core, 0.7);

  static final shadow = ColorUtils.darkened(background, 0.6);

  static final wallTop = ColorUtils.darkened(highlightedForeground, 0.085);
  static final wallEdge = ColorUtils.darkened(
    ColorUtils.darkenedHueShift(wallTop, 0.15),
    0.3,
  );

  static final buildPointEdge = wallEdge;
  static final buildPointCenter = ColorUtils.darkenedHueShift(wallTop, 0.1);

  static final tileTop = ColorUtils.darkened(highlightedForeground, 0.125);
  static final tileBottom = ColorUtils.darkenedHueShift(tileTop);

  static final highlightedTileTopChallenge = ColorUtils.darkened(
    successForeground,
    0.15,
  );
  static final highlightedTileBottomChallenge = ColorUtils.darkenedHueShift(
    highlightedTileTopChallenge,
    0.35,
  );
  static final highlightedTileTopChallengeMaxed = ColorUtils.mixColors(
    ColorUtils.darkened(highlightedTileTopChallenge, 0.3),
    background,
    0.3,
  );

  static final highlightedTileTopStar = ColorUtils.darkened(
    highlightedForeground2,
    0.05,
  );
  static final highlightedTileBottomStar = ColorUtils.darkenedHueShift(
    highlightedTileTopStar,
    0.15,
  );
  static final highlightedTileTopStarMaxed = ColorUtils.mixColors(
    ColorUtils.darkened(highlightedTileTopStar, 0.0),
    background,
    0.3,
  );
  static final highlightedTileBottomStarMaxed = ColorUtils.darkenedHueShift(
    highlightedTileTopStarMaxed,
    0.15,
  );

  static final highlightedTileTop = ColorUtils.darkened(tileTop, 0.15);
  static final highlightedTileBottom = ColorUtils.darkenedHueShift(
    highlightedTileTop,
  );

  static final highlightedTileTopMaxed = ColorUtils.lightened(
    ColorUtils.mixColors(
      ColorUtils.darkened(highlightedTileTop, 0.35),
      background,
      0.5,
    ),
    0.15,
  );
  static final highlightedTileBottomMaxed = ColorUtils.mixColors(
    ColorUtils.darkened(highlightedTileBottom, 0.35),
    background,
    0.5,
  );

  static const highlightedTileTopTime = Color(0xFFC92BD4);
  static final highlightedTileBottomTime = ColorUtils.darkenedHueShift(
    highlightedTileTopTime,
  );
  static final highlightedTileTopTimeMaxed = ColorUtils.desaturated(
    ColorUtils.mixColors(
      ColorUtils.darkened(highlightedTileTopTime, 0.3),
      background,
      0.3,
    ),
    0.2,
  );

  static const highlightedTileTopAdvanced = Color(0xFF3075C9);
  static final highlightedTileBottomAdvanced = ColorUtils.darkenedHueShift(
    highlightedTileTopAdvanced,
    0.25,
  );
  static final highlightedTileTopAdvancedMaxed = ColorUtils.desaturated(
    ColorUtils.mixColors(
      ColorUtils.darkened(highlightedTileTopAdvanced, 0.3),
      background,
      0.3,
    ),
    0.2,
  );
  static final highlightedTileBottomAdvancedMaxed = ColorUtils.desaturated(
    ColorUtils.mixColors(
      ColorUtils.darkened(highlightedTileBottomAdvanced, 0.3),
      background,
      0.3,
    ),
    0.2,
  );

  static const unavailableTileTop = failForeground;
  static final unavailableTileBottom = ColorUtils.darkenedHueShift(
    unavailableTileTop,
  );

  static const explosiveStatus = Color(0xFF8D00A4);
  static const slowedStatus = Color(0xFF5E59C6);
  static const speedupStatus = Color(0xFFFF000F);
  static const burningStatus = Color(0xFFE65F35);
  static const shieldedStatus = Color(0xFF0084D3);

  static const enraged = speedupStatus;

  static const levelChallengeColor = Color(0xFF0084D3);
  static const timeChallengeColor = highlightedTileTopTime;

  static const fireEnchant = Color(0xFFF28241);
  static const lightEnchant = Color(0xFFDD77FC);
  static const earthEnchant = Color(0xFF994C37);
  static const iceEnchant = Color(0xFF7784FD);
  static const windEnchant = Color(0xFF00A323);

  static const keywordVulnerable = Color(0xFFFF5958);
  static const keywordOverkill = Color(0xFFFF69B4);
  static const keywordBurn = fireEnchant;
  static const keywordSlow = iceEnchant;
  static const keywordCharge = windEnchant;
  static const keywordStun = Color(0xFF5E59C6);
  static final keywordShock = ColorUtils.lightened(highlightedForeground2, 0.5);
  static const keywordPool = Color(0xFF0084D3);
  static const keywordCombustion = core;
  static final keywordExplosive = ColorUtils.lightened(explosiveStatus, 0.25);
  static const keywordPoison = windEnchant;
  static final keywordAccelerated = ColorUtils.lightened(speedupStatus, 0.25);
  static const keywordFrostfire = keywordSlow;
  static const keywordShielded = shieldedStatus;

  static const enemyGrunt = failForeground;
  static const enemyGruntElite = highlightedTileTopTime;
  static const enemyGruntBoss = enemyGruntElite;
  static const enemyRunner = core;
  static const enemyRunnerElite = burningStatus;
  static const enemyRunnerBoss = enemyRunnerElite;
  static final enemyLeaper = highlightedTileTopChallenge;
  static final enemyLeaperElite = ColorUtils.lightened(enemyLeaper, 0.25);
  static final enemyLeaperBoss = ColorUtils.lightened(enemyLeaper, 0.35);
  static const enemySlimeBoss = Color(0xFF5E9437);
  static const enemyTwinBoss = highlightedForeground3;
  static const enemyCentipedeBoss = levelChallengeColor;
  static const enemyShielder = levelChallengeColor;
}
