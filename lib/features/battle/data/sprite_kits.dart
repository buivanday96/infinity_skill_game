import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// Sprite kit for a combatant actor (idle / walk / attack / hurt / dead / buff).
class SpriteKit {
  const SpriteKit({
    required this.idle,
    required this.attack,
    required this.hurt,
    required this.dead,
    this.walk,
    this.buff,
    this.footShadowLift = 0,
    this.footShadowWidth = 0.48,
    this.footShadowHeight = 0.14,
    this.artFacesLeft = false,
  });

  final AsepriteEntry idle;
  final AsepriteEntry? walk;
  final AsepriteEntry attack;
  final AsepriteEntry hurt;
  final AsepriteEntry dead;

  /// Played only when applying a buff (e.g. knight `powerup1`).
  final AsepriteEntry? buff;

  /// Lift foot shadow above sprite bottom (fraction of display size).
  /// Higher = art has more empty padding under the feet.
  final double footShadowLift;

  /// Shadow oval width / height as fractions of display size.
  final double footShadowWidth;
  final double footShadowHeight;

  /// When true, source sheets face left (e.g. flying demon).
  final bool artFacesLeft;
}

const knightKit = SpriteKit(
  // Idle = first frame of attack stance (not powerup).
  idle: AsepriteEntry(
    name: 'attack1',
    category: 'knight',
    jsonAssetPath: 'assets/sprites/characters/knight/attack1.json',
    sheetAssetPath: 'assets/sprites/characters/knight/attack1.png',
    holdFirstFrame: true,
  ),
  walk: AsepriteEntry(
    name: 'walking',
    category: 'knight',
    jsonAssetPath: 'assets/sprites/characters/knight/walking.json',
    sheetAssetPath: 'assets/sprites/characters/knight/walking.png',
  ),
  attack: AsepriteEntry(
    name: 'attack1',
    category: 'knight',
    jsonAssetPath: 'assets/sprites/characters/knight/attack1.json',
    sheetAssetPath: 'assets/sprites/characters/knight/attack1.png',
    loop: false,
  ),
  hurt: AsepriteEntry(
    name: 'hurt1',
    category: 'knight',
    jsonAssetPath: 'assets/sprites/characters/knight/hurt1.json',
    sheetAssetPath: 'assets/sprites/characters/knight/hurt1.png',
    loop: false,
  ),
  dead: AsepriteEntry(
    name: 'dying1',
    category: 'knight',
    jsonAssetPath: 'assets/sprites/characters/knight/dying1.json',
    sheetAssetPath: 'assets/sprites/characters/knight/dying1.png',
    loop: false,
  ),
  // powerup1 is reserved for buffs only.
  buff: AsepriteEntry(
    name: 'powerup1',
    category: 'knight',
    jsonAssetPath: 'assets/sprites/characters/knight/powerup1.json',
    sheetAssetPath: 'assets/sprites/characters/knight/powerup1.png',
    loop: false,
  ),
  // Feet sit near the frame bottom — keep shadow slightly below body.
  footShadowLift: -0.02,
  footShadowWidth: 0.42,
  footShadowHeight: 0.11,
);

/// Wizard — no dedicated hurt/death JSON yet; reuse idle / attack2.
const wizardKit = SpriteKit(
  idle: AsepriteEntry(
    name: 'Idle',
    category: 'wizzard',
    jsonAssetPath: 'assets/sprites/characters/wizzard/Idle.json',
    sheetAssetPath: 'assets/sprites/characters/wizzard/Idle.png',
  ),
  attack: AsepriteEntry(
    name: 'Attack1',
    category: 'wizzard',
    jsonAssetPath: 'assets/sprites/characters/wizzard/Attack1.json',
    sheetAssetPath: 'assets/sprites/characters/wizzard/Attack1.png',
    loop: false,
  ),
  hurt: AsepriteEntry(
    name: 'Idle',
    category: 'wizzard',
    jsonAssetPath: 'assets/sprites/characters/wizzard/Idle.json',
    sheetAssetPath: 'assets/sprites/characters/wizzard/Idle.png',
    loop: false,
  ),
  dead: AsepriteEntry(
    name: 'Attack2',
    category: 'wizzard',
    jsonAssetPath: 'assets/sprites/characters/wizzard/Attack2.json',
    sheetAssetPath: 'assets/sprites/characters/wizzard/Attack2.png',
    loop: false,
  ),
  // Large bottom padding in wizard sheets — pull shadow up to the feet.
  footShadowLift: 0.16,
  footShadowWidth: 0.38,
  footShadowHeight: 0.10,
);

const slimeKit = SpriteKit(
  idle: AsepriteEntry(
    name: 'idle',
    category: 'slime',
    jsonAssetPath: 'assets/sprites/monster/slime/idle-sheet.json',
    sheetAssetPath: 'assets/sprites/monster/slime/idle.png',
  ),
  walk: AsepriteEntry(
    name: 'walk01',
    category: 'slime',
    jsonAssetPath: 'assets/sprites/monster/slime/walk01-sheet.json',
    sheetAssetPath: 'assets/sprites/monster/slime/walk01.png',
  ),
  attack: AsepriteEntry(
    name: 'attack01',
    category: 'slime',
    jsonAssetPath: 'assets/sprites/monster/slime/attack01-sheet.json',
    sheetAssetPath: 'assets/sprites/monster/slime/attack01.png',
    loop: false,
  ),
  hurt: AsepriteEntry(
    name: 'idle',
    category: 'slime',
    jsonAssetPath: 'assets/sprites/monster/slime/idle-sheet.json',
    sheetAssetPath: 'assets/sprites/monster/slime/idle.png',
    loop: false,
  ),
  dead: AsepriteEntry(
    name: 'dead01',
    category: 'slime',
    jsonAssetPath: 'assets/sprites/monster/slime/dead01-sheet.json',
    sheetAssetPath: 'assets/sprites/monster/slime/dead01-sheet.png',
    loop: false,
  ),
  // Slightly less gap under the blob.
  footShadowLift: 0.06,
  footShadowWidth: 0.52,
  footShadowHeight: 0.16,
);

const golemKit = SpriteKit(
  idle: AsepriteEntry(
    name: 'Golem_1_idle',
    category: 'golem',
    jsonAssetPath: 'assets/sprites/monster/golem/Golem_1_idle.json',
    sheetAssetPath: 'assets/sprites/monster/golem/Golem_1_idle.png',
  ),
  walk: AsepriteEntry(
    name: 'Golem_1_walk',
    category: 'golem',
    jsonAssetPath: 'assets/sprites/monster/golem/Golem_1_walk.json',
    sheetAssetPath: 'assets/sprites/monster/golem/Golem_1_walk.png',
  ),
  attack: AsepriteEntry(
    name: 'Golem_1_attack',
    category: 'golem',
    jsonAssetPath: 'assets/sprites/monster/golem/Golem_1_attack.json',
    sheetAssetPath: 'assets/sprites/monster/golem/Golem_1_attack.png',
    loop: false,
  ),
  hurt: AsepriteEntry(
    name: 'Golem_1_hurt',
    category: 'golem',
    jsonAssetPath: 'assets/sprites/monster/golem/Golem_1_hurt.json',
    sheetAssetPath: 'assets/sprites/monster/golem/Golem_1_hurt.png',
    loop: false,
  ),
  dead: AsepriteEntry(
    name: 'Golem_1_die',
    category: 'golem',
    jsonAssetPath: 'assets/sprites/monster/golem/Golem_1_die.json',
    sheetAssetPath: 'assets/sprites/monster/golem/Golem_1_die.png',
    loop: false,
  ),
  // Wide 90×64 frames — shadow sits near the stone feet.
  footShadowLift: 0.04,
  footShadowWidth: 0.55,
  footShadowHeight: 0.14,
);

/// Flying demon — sheets face left; FLYING doubles as locomotion.
const flyingDemonKit = SpriteKit(
  idle: AsepriteEntry(
    name: 'IDLE',
    category: 'flying_demon',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/IDLE.json',
    sheetAssetPath: 'assets/sprites/monster/flying_demon/IDLE.png',
  ),
  walk: AsepriteEntry(
    name: 'FLYING',
    category: 'flying_demon',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/FLYING.json',
    sheetAssetPath: 'assets/sprites/monster/flying_demon/FLYING.png',
  ),
  attack: AsepriteEntry(
    name: 'ATTACK',
    category: 'flying_demon',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/ATTACK.json',
    sheetAssetPath: 'assets/sprites/monster/flying_demon/ATTACK.png',
    loop: false,
  ),
  hurt: AsepriteEntry(
    name: 'HURT',
    category: 'flying_demon',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/HURT.json',
    sheetAssetPath: 'assets/sprites/monster/flying_demon/HURT.png',
    loop: false,
  ),
  dead: AsepriteEntry(
    name: 'DEATH',
    category: 'flying_demon',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/DEATH.json',
    sheetAssetPath: 'assets/sprites/monster/flying_demon/DEATH.png',
    loop: false,
  ),
  artFacesLeft: true,
  footShadowLift: 0.08,
  footShadowWidth: 0.40,
  footShadowHeight: 0.12,
);
