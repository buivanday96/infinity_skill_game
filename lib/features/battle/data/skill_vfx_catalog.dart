import 'package:flame/components.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// How a skill presents its effect in the world.
enum SkillDelivery {
  /// Instant hit at the target (melee swing, bite, etc.).
  instant,

  /// Homing / directed projectile that applies damage on contact.
  projectile,

  /// Bolt appears above the target and strikes downward, then splash.
  strikeDown,

  /// Aura / shield VFX attached to the caster (self-target).
  selfBuff,

  /// Caster loops a body anim and deals periodic AOE (knight whirlwind).
  channelSpin,
}

/// Presentation-only VFX for a [SkillDefinition.id].
///
/// Domain skills stay data-only; combat looks up visuals here.
class SkillVfxSpec {
  const SkillVfxSpec({
    required this.skillId,
    required this.delivery,
    this.projectileStart,
    this.projectileFly,
    this.strikeEffect,
    this.hitEffect,
    this.endEffect,
    this.castAnim,
    this.projectileSpeed = 280,
    this.projectileWidth = 48,
    this.projectileHeight = 32,
    this.projectileFacesLeft = false,
    this.projectileSpawnFrame,
    this.strikeWidth = 96,
    this.strikeHeight = 96,
    this.splashWidth = 72,
    this.splashHeight = 72,
  });

  final String skillId;
  final SkillDelivery delivery;

  final AsepriteEntry? projectileStart;
  final AsepriteEntry? projectileFly;

  /// Top-down strike sheet (thunder bolt).
  final AsepriteEntry? strikeEffect;

  final AsepriteEntry? hitEffect;
  final AsepriteEntry? endEffect;

  /// Optional caster body animation (e.g. knight attack4 channel).
  final AsepriteEntry? castAnim;

  final double projectileSpeed;
  final double projectileWidth;
  final double projectileHeight;

  /// When true, fly sheet points left (−X); angle is rotated by π.
  final bool projectileFacesLeft;

  /// 0-based attack anim frame that releases the projectile.
  /// `null` = spawn immediately when cast starts.
  final int? projectileSpawnFrame;
  final double strikeWidth;
  final double strikeHeight;
  final double splashWidth;
  final double splashHeight;

  Vector2 get projectileSize => Vector2(projectileWidth, projectileHeight);
}

/// Ice bolt — wizard skill using `assets/sprites/effects/ice/`.
const iceBoltVfx = SkillVfxSpec(
  skillId: 'ice_bolt',
  delivery: SkillDelivery.projectile,
  projectileStart: AsepriteEntry(
    name: 'start_1',
    category: 'ice',
    jsonAssetPath: 'assets/sprites/effects/ice/start_1.json',
    sheetAssetPath: 'assets/sprites/effects/ice/start_1.png',
    loop: false,
  ),
  projectileFly: AsepriteEntry(
    name: 'repeatable_1',
    category: 'ice',
    jsonAssetPath: 'assets/sprites/effects/ice/repeatable_1.json',
    sheetAssetPath: 'assets/sprites/effects/ice/repeatable_1.png',
  ),
  hitEffect: AsepriteEntry(
    name: 'hit_1',
    category: 'ice',
    jsonAssetPath: 'assets/sprites/effects/ice/hit_1.json',
    sheetAssetPath: 'assets/sprites/effects/ice/hit_1.png',
    loop: false,
  ),
  endEffect: AsepriteEntry(
    name: 'ice2_ending',
    category: 'ice',
    jsonAssetPath: 'assets/sprites/effects/ice/ice2_ending.json',
    sheetAssetPath: 'assets/sprites/effects/ice/ice2_ending.png',
    loop: false,
  ),
  projectileSpeed: 300,
  projectileWidth: 48,
  projectileHeight: 32,
);

/// Thunder strike — drops on the monster, then splash on hit.
const thunderStrikeVfx = SkillVfxSpec(
  skillId: 'thunder_strike',
  delivery: SkillDelivery.strikeDown,
  strikeEffect: AsepriteEntry(
    name: 'strike_w',
    category: 'thunder',
    jsonAssetPath: 'assets/sprites/effects/thunder/strike_w.json',
    sheetAssetPath: 'assets/sprites/effects/thunder/strike_w.png',
    loop: false,
  ),
  hitEffect: AsepriteEntry(
    name: 'splash_w',
    category: 'thunder',
    jsonAssetPath: 'assets/sprites/effects/thunder/splash_w.json',
    sheetAssetPath: 'assets/sprites/effects/thunder/splash_w.png',
    loop: false,
  ),
  strikeWidth: 110,
  strikeHeight: 110,
  splashWidth: 80,
  splashHeight: 80,
);

/// Water ball — projectile using waterball sheets.
const waterBallVfx = SkillVfxSpec(
  skillId: 'water_ball',
  delivery: SkillDelivery.projectile,
  projectileFly: AsepriteEntry(
    name: 'waterball',
    category: 'water',
    jsonAssetPath: 'assets/sprites/effects/water/waterball.json',
    sheetAssetPath: 'assets/sprites/effects/water/waterball-sheet.png',
  ),
  hitEffect: AsepriteEntry(
    name: 'waterball_end',
    category: 'water',
    jsonAssetPath: 'assets/sprites/effects/water/waterball_end.json',
    sheetAssetPath: 'assets/sprites/effects/water/waterball_end-sheet.png',
    loop: false,
  ),
  projectileSpeed: 260,
  projectileWidth: 56,
  projectileHeight: 56,
);

/// Water blast — AOE pillar at the target, then blast_end splash.
const waterBlastVfx = SkillVfxSpec(
  skillId: 'water_blast',
  delivery: SkillDelivery.strikeDown,
  strikeEffect: AsepriteEntry(
    name: 'blast',
    category: 'water',
    jsonAssetPath: 'assets/sprites/effects/water/blast.json',
    sheetAssetPath: 'assets/sprites/effects/water/blast-sheet.png',
    loop: false,
  ),
  hitEffect: AsepriteEntry(
    name: 'blast_end',
    category: 'water',
    jsonAssetPath: 'assets/sprites/effects/water/blast_end.json',
    sheetAssetPath: 'assets/sprites/effects/water/blast_end.png',
    loop: false,
  ),
  strikeWidth: 140,
  strikeHeight: 140,
  splashWidth: 130,
  splashHeight: 130,
);

/// Wind breath — directional gust projectile + hit swirl.
const windBreathVfx = SkillVfxSpec(
  skillId: 'wind_breath',
  delivery: SkillDelivery.projectile,
  projectileFly: AsepriteEntry(
    name: 'breath',
    category: 'wind',
    jsonAssetPath: 'assets/sprites/effects/wind/breath.json',
    sheetAssetPath: 'assets/sprites/effects/wind/breath.png',
  ),
  hitEffect: AsepriteEntry(
    name: 'hit',
    category: 'wind',
    jsonAssetPath: 'assets/sprites/effects/wind/hit.json',
    sheetAssetPath: 'assets/sprites/effects/wind/hit.png',
    loop: false,
  ),
  projectileSpeed: 340,
  projectileWidth: 72,
  projectileHeight: 48,
);

/// Knight Guard — cyan shield aura on self (`buff4` + powerup cast).
const guardVfx = SkillVfxSpec(
  skillId: 'guard',
  delivery: SkillDelivery.selfBuff,
  hitEffect: AsepriteEntry(
    name: 'buff4',
    category: 'buff',
    jsonAssetPath: 'assets/sprites/buff/buff4.json',
    sheetAssetPath: 'assets/sprites/buff/buff4.png',
    loop: false,
  ),
  splashWidth: 88,
  splashHeight: 112,
);

/// Knight Whirlwind — loop attack4 for channel duration, hit sparks on ticks.
const whirlwindVfx = SkillVfxSpec(
  skillId: 'whirlwind',
  delivery: SkillDelivery.channelSpin,
  castAnim: AsepriteEntry(
    name: 'attack4',
    category: 'knight',
    jsonAssetPath: 'assets/sprites/characters/knight/attack4.json',
    sheetAssetPath: 'assets/sprites/characters/knight/attack4.png',
  ),
  hitEffect: AsepriteEntry(
    name: 'hit1',
    category: 'hit',
    jsonAssetPath: 'assets/sprites/effects/hit/hit1.json',
    sheetAssetPath: 'assets/sprites/effects/hit/hit1.png',
    loop: false,
  ),
  splashWidth: 48,
  splashHeight: 48,
);

/// Flying demon — static hellfire bolt (`projectile.png`).
const hellfireBoltVfx = SkillVfxSpec(
  skillId: 'hellfire_bolt',
  delivery: SkillDelivery.projectile,
  projectileFly: AsepriteEntry(
    name: 'projectile',
    category: 'flying_demon',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/projectile.json',
    sheetAssetPath: 'assets/sprites/monster/flying_demon/projectile.png',
  ),
  projectileSpeed: 320,
  projectileWidth: 48,
  projectileHeight: 32,
  // Sheet nose points left (−X).
  projectileFacesLeft: true,
  // ATTACK 0..7 — release around frame 3.
  projectileSpawnFrame: 3,
);

const skillVfxCatalog = <SkillVfxSpec>[
  iceBoltVfx,
  thunderStrikeVfx,
  waterBallVfx,
  waterBlastVfx,
  windBreathVfx,
  guardVfx,
  whirlwindVfx,
  hellfireBoltVfx,
];

SkillVfxSpec? skillVfxOf(String skillId) {
  for (final spec in skillVfxCatalog) {
    if (spec.skillId == skillId) return spec;
  }
  return null;
}
