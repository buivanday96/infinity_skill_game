/// Data-driven catalog of all browsable sprites under assets/sprites/.
enum SpriteKind { character, monster, effect }

class SpriteCatalogEntry {
  const SpriteCatalogEntry({
    required this.name,
    required this.kind,
    required this.group,
    required this.imageAssetPath,
    this.jsonAssetPath,
  });

  final String name;
  final SpriteKind kind;

  /// Folder / character name, e.g. `knight`, `fire`, `wizzard`.
  final String group;

  /// PNG sheet or frame image.
  final String imageAssetPath;

  /// Aseprite JSON when the sprite is animated; null for static sheets.
  final String? jsonAssetPath;

  bool get isAnimated => jsonAssetPath != null;
}

const spriteCatalog = <SpriteCatalogEntry>[
  // ── Characters: knight ──────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'attack1',
    kind: SpriteKind.character,
    group: 'knight',
    imageAssetPath: 'assets/sprites/characters/knight/attack1.png',
    jsonAssetPath: 'assets/sprites/characters/knight/attack1.json',
  ),
  SpriteCatalogEntry(
    name: 'attack2',
    kind: SpriteKind.character,
    group: 'knight',
    imageAssetPath: 'assets/sprites/characters/knight/attack2.png',
    jsonAssetPath: 'assets/sprites/characters/knight/attack2.json',
  ),
  SpriteCatalogEntry(
    name: 'attack3',
    kind: SpriteKind.character,
    group: 'knight',
    imageAssetPath: 'assets/sprites/characters/knight/attack3.png',
    jsonAssetPath: 'assets/sprites/characters/knight/attack3.json',
  ),
  SpriteCatalogEntry(
    name: 'attack4',
    kind: SpriteKind.character,
    group: 'knight',
    imageAssetPath: 'assets/sprites/characters/knight/attack4.png',
    jsonAssetPath: 'assets/sprites/characters/knight/attack4.json',
  ),
  SpriteCatalogEntry(
    name: 'dying1',
    kind: SpriteKind.character,
    group: 'knight',
    imageAssetPath: 'assets/sprites/characters/knight/dying1.png',
    jsonAssetPath: 'assets/sprites/characters/knight/dying1.json',
  ),
  SpriteCatalogEntry(
    name: 'hurt1',
    kind: SpriteKind.character,
    group: 'knight',
    imageAssetPath: 'assets/sprites/characters/knight/hurt1.png',
    jsonAssetPath: 'assets/sprites/characters/knight/hurt1.json',
  ),
  SpriteCatalogEntry(
    name: 'powerup1',
    kind: SpriteKind.character,
    group: 'knight',
    imageAssetPath: 'assets/sprites/characters/knight/powerup1.png',
    jsonAssetPath: 'assets/sprites/characters/knight/powerup1.json',
  ),

  // ── Characters: wizzard ─────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'Idle',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Idle.png',
    jsonAssetPath: 'assets/sprites/characters/wizzard/Idle.json',
  ),
  SpriteCatalogEntry(
    name: 'Attack1',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Attack1.png',
    jsonAssetPath: 'assets/sprites/characters/wizzard/Attack1.json',
  ),
  SpriteCatalogEntry(
    name: 'Attack2',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Attack2.png',
    jsonAssetPath: 'assets/sprites/characters/wizzard/Attack2.json',
  ),
  SpriteCatalogEntry(
    name: 'Death',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Death.png',
  ),
  SpriteCatalogEntry(
    name: 'Fall',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Fall.png',
  ),
  SpriteCatalogEntry(
    name: 'Hit',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Hit.png',
  ),
  SpriteCatalogEntry(
    name: 'Jump',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Jump.png',
  ),
  SpriteCatalogEntry(
    name: 'Run',
    kind: SpriteKind.character,
    group: 'wizzard',
    imageAssetPath: 'assets/sprites/characters/wizzard/Run.png',
  ),

  // ── Monsters: slime ─────────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'idle',
    kind: SpriteKind.monster,
    group: 'slime',
    imageAssetPath: 'assets/sprites/monster/slime/idle.png',
    jsonAssetPath: 'assets/sprites/monster/slime/idle-sheet.json',
  ),
  SpriteCatalogEntry(
    name: 'walk01',
    kind: SpriteKind.monster,
    group: 'slime',
    imageAssetPath: 'assets/sprites/monster/slime/walk01.png',
    jsonAssetPath: 'assets/sprites/monster/slime/walk01-sheet.json',
  ),
  SpriteCatalogEntry(
    name: 'attack01',
    kind: SpriteKind.monster,
    group: 'slime',
    imageAssetPath: 'assets/sprites/monster/slime/attack01.png',
    jsonAssetPath: 'assets/sprites/monster/slime/attack01-sheet.json',
  ),
  SpriteCatalogEntry(
    name: 'dead01',
    kind: SpriteKind.monster,
    group: 'slime',
    imageAssetPath: 'assets/sprites/monster/slime/dead01-sheet.png',
    jsonAssetPath: 'assets/sprites/monster/slime/dead01-sheet.json',
  ),

  // ── Monsters: flying demon ──────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'IDLE',
    kind: SpriteKind.monster,
    group: 'flying_demon',
    imageAssetPath: 'assets/sprites/monster/flying_demon/IDLE.png',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/IDLE.json',
  ),
  SpriteCatalogEntry(
    name: 'FLYING',
    kind: SpriteKind.monster,
    group: 'flying_demon',
    imageAssetPath: 'assets/sprites/monster/flying_demon/FLYING.png',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/FLYING.json',
  ),
  SpriteCatalogEntry(
    name: 'ATTACK',
    kind: SpriteKind.monster,
    group: 'flying_demon',
    imageAssetPath: 'assets/sprites/monster/flying_demon/ATTACK.png',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/ATTACK.json',
  ),
  SpriteCatalogEntry(
    name: 'HURT',
    kind: SpriteKind.monster,
    group: 'flying_demon',
    imageAssetPath: 'assets/sprites/monster/flying_demon/HURT.png',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/HURT.json',
  ),
  SpriteCatalogEntry(
    name: 'DEATH',
    kind: SpriteKind.monster,
    group: 'flying_demon',
    imageAssetPath: 'assets/sprites/monster/flying_demon/DEATH.png',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/DEATH.json',
  ),
  SpriteCatalogEntry(
    name: 'projectile',
    kind: SpriteKind.monster,
    group: 'flying_demon',
    imageAssetPath: 'assets/sprites/monster/flying_demon/projectile.png',
    jsonAssetPath: 'assets/sprites/monster/flying_demon/projectile.json',
  ),

  // ── Effects: fire ───────────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'explosion_1',
    kind: SpriteKind.effect,
    group: 'fire',
    imageAssetPath: 'assets/sprites/effects/fire/explosion_1.png',
    jsonAssetPath: 'assets/sprites/effects/fire/explosion_1.json',
  ),
  SpriteCatalogEntry(
    name: 'explosion_2',
    kind: SpriteKind.effect,
    group: 'fire',
    imageAssetPath: 'assets/sprites/effects/fire/explosion_2.png',
    jsonAssetPath: 'assets/sprites/effects/fire/explosion_2.json',
  ),

  // ── Effects: ice ────────────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'hit_1',
    kind: SpriteKind.effect,
    group: 'ice',
    imageAssetPath: 'assets/sprites/effects/ice/hit_1.png',
    jsonAssetPath: 'assets/sprites/effects/ice/hit_1.json',
  ),
  SpriteCatalogEntry(
    name: 'ice2_active',
    kind: SpriteKind.effect,
    group: 'ice',
    imageAssetPath: 'assets/sprites/effects/ice/ice2_active.png',
    jsonAssetPath: 'assets/sprites/effects/ice/ice2_active.json',
  ),
  SpriteCatalogEntry(
    name: 'ice2_ending',
    kind: SpriteKind.effect,
    group: 'ice',
    imageAssetPath: 'assets/sprites/effects/ice/ice2_ending.png',
    jsonAssetPath: 'assets/sprites/effects/ice/ice2_ending.json',
  ),
  SpriteCatalogEntry(
    name: 'ice2_start',
    kind: SpriteKind.effect,
    group: 'ice',
    imageAssetPath: 'assets/sprites/effects/ice/ice2_start.png',
    jsonAssetPath: 'assets/sprites/effects/ice/ice2_start.json',
  ),
  SpriteCatalogEntry(
    name: 'repeatable_1',
    kind: SpriteKind.effect,
    group: 'ice',
    imageAssetPath: 'assets/sprites/effects/ice/repeatable_1.png',
    jsonAssetPath: 'assets/sprites/effects/ice/repeatable_1.json',
  ),
  SpriteCatalogEntry(
    name: 'start_1',
    kind: SpriteKind.effect,
    group: 'ice',
    imageAssetPath: 'assets/sprites/effects/ice/start_1.png',
    jsonAssetPath: 'assets/sprites/effects/ice/start_1.json',
  ),

  // ── Effects: wind ───────────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'breath',
    kind: SpriteKind.effect,
    group: 'wind',
    imageAssetPath: 'assets/sprites/effects/wind/breath.png',
    jsonAssetPath: 'assets/sprites/effects/wind/breath.json',
  ),
  SpriteCatalogEntry(
    name: 'hit',
    kind: SpriteKind.effect,
    group: 'wind',
    imageAssetPath: 'assets/sprites/effects/wind/hit.png',
    jsonAssetPath: 'assets/sprites/effects/wind/hit.json',
  ),
  SpriteCatalogEntry(
    name: 'projectile',
    kind: SpriteKind.effect,
    group: 'wind',
    imageAssetPath: 'assets/sprites/effects/wind/projectile.png',
    jsonAssetPath: 'assets/sprites/effects/wind/projectile.json',
  ),

  // ── Effects: thunder ────────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'splash_w',
    kind: SpriteKind.effect,
    group: 'thunder',
    imageAssetPath: 'assets/sprites/effects/thunder/splash_w.png',
    jsonAssetPath: 'assets/sprites/effects/thunder/splash_w.json',
  ),
  SpriteCatalogEntry(
    name: 'splash_wo',
    kind: SpriteKind.effect,
    group: 'thunder',
    imageAssetPath: 'assets/sprites/effects/thunder/splash_wo.png',
    jsonAssetPath: 'assets/sprites/effects/thunder/splash_wo.json',
  ),
  SpriteCatalogEntry(
    name: 'strike_w',
    kind: SpriteKind.effect,
    group: 'thunder',
    imageAssetPath: 'assets/sprites/effects/thunder/strike_w.png',
    jsonAssetPath: 'assets/sprites/effects/thunder/strike_w.json',
  ),
  SpriteCatalogEntry(
    name: 'strike_wo',
    kind: SpriteKind.effect,
    group: 'thunder',
    imageAssetPath: 'assets/sprites/effects/thunder/strike_wo.png',
    jsonAssetPath: 'assets/sprites/effects/thunder/strike_wo.json',
  ),

  // ── Effects: water ──────────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'blast',
    kind: SpriteKind.effect,
    group: 'water',
    imageAssetPath: 'assets/sprites/effects/water/blast.png',
    jsonAssetPath: 'assets/sprites/effects/water/blast.json',
  ),
  SpriteCatalogEntry(
    name: 'blast_end',
    kind: SpriteKind.effect,
    group: 'water',
    imageAssetPath: 'assets/sprites/effects/water/blast_end.png',
    jsonAssetPath: 'assets/sprites/effects/water/blast_end.json',
  ),
  SpriteCatalogEntry(
    name: 'waterball',
    kind: SpriteKind.effect,
    group: 'water',
    imageAssetPath: 'assets/sprites/effects/water/waterball.png',
    jsonAssetPath: 'assets/sprites/effects/water/waterball.json',
  ),
  SpriteCatalogEntry(
    name: 'waterball_end',
    kind: SpriteKind.effect,
    group: 'water',
    imageAssetPath: 'assets/sprites/effects/water/waterball_end.png',
    jsonAssetPath: 'assets/sprites/effects/water/waterball_end.json',
  ),

  // ── Effects: buff1 ──────────────────────────────────────────────────
  SpriteCatalogEntry(
    name: 'buff3',
    kind: SpriteKind.effect,
    group: 'buff1',
    imageAssetPath: 'assets/sprites/effects/buff1/buff3.png',
    jsonAssetPath: 'assets/sprites/effects/buff1/buff3.json',
  ),
  SpriteCatalogEntry(
    name: 'buff4',
    kind: SpriteKind.effect,
    group: 'buff1',
    imageAssetPath: 'assets/sprites/effects/buff1/buff4.png',
    jsonAssetPath: 'assets/sprites/effects/buff1/buff4.json',
  ),
  SpriteCatalogEntry(
    name: 'buff5',
    kind: SpriteKind.effect,
    group: 'buff1',
    imageAssetPath: 'assets/sprites/effects/buff1/buff5.png',
    jsonAssetPath: 'assets/sprites/effects/buff1/buff5.json',
  ),
  SpriteCatalogEntry(
    name: 'buff6',
    kind: SpriteKind.effect,
    group: 'buff1',
    imageAssetPath: 'assets/sprites/effects/buff1/buff6.png',
    jsonAssetPath: 'assets/sprites/effects/buff1/buff6.json',
  ),
];

List<SpriteCatalogEntry> spritesForKind(SpriteKind kind) =>
    spriteCatalog.where((e) => e.kind == kind).toList(growable: false);

List<String> groupsForKind(SpriteKind kind) {
  final groups = <String>{};
  for (final entry in spriteCatalog) {
    if (entry.kind == kind) groups.add(entry.group);
  }
  return groups.toList()..sort();
}
