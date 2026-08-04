import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// Player-cast skills for the 1v1 combat demo.
enum DemoSkillId { fire, ice, thunder, water, mend }

class DemoSkill {
  const DemoSkill({
    required this.id,
    required this.label,
    required this.manaCost,
    required this.cooldown,
    required this.power,
    required this.effect,
    this.range = 4,
    this.isHeal = false,
  });

  final DemoSkillId id;
  final String label;
  final double manaCost;
  final double cooldown;
  final double power;

  /// Attack reach in range-stat units (same scale as [StatId.range]).
  final double range;
  final AsepriteEntry effect;
  final bool isHeal;
}

const demoSkills = <DemoSkill>[
  DemoSkill(
    id: DemoSkillId.fire,
    label: 'Fire',
    manaCost: 22,
    cooldown: 4,
    power: 55,
    range: 5,
    effect: AsepriteEntry(
      name: 'explosion_1',
      category: 'fire',
      jsonAssetPath: 'assets/sprites/effects/fire/explosion_1.json',
      sheetAssetPath: 'assets/sprites/effects/fire/explosion_1-sheet.png',
      loop: false,
    ),
  ),
  DemoSkill(
    id: DemoSkillId.ice,
    label: 'Ice',
    manaCost: 18,
    cooldown: 3.5,
    power: 48,
    range: 5,
    effect: AsepriteEntry(
      name: 'hit_1',
      category: 'ice',
      jsonAssetPath: 'assets/sprites/effects/ice/hit_1.json',
      sheetAssetPath: 'assets/sprites/effects/ice/hit_1.png',
      loop: false,
    ),
  ),
  DemoSkill(
    id: DemoSkillId.thunder,
    label: 'Thunder',
    manaCost: 28,
    cooldown: 5,
    power: 70,
    range: 6,
    effect: AsepriteEntry(
      name: 'strike_w',
      category: 'thunder',
      jsonAssetPath: 'assets/sprites/effects/thunder/strike_w.json',
      sheetAssetPath: 'assets/sprites/effects/thunder/strike_w.png',
      loop: false,
    ),
  ),
  DemoSkill(
    id: DemoSkillId.water,
    label: 'Water',
    manaCost: 16,
    cooldown: 3,
    power: 38,
    range: 5,
    effect: AsepriteEntry(
      name: 'waterball',
      category: 'water',
      jsonAssetPath: 'assets/sprites/effects/water/waterball.json',
      sheetAssetPath: 'assets/sprites/effects/water/waterball-sheet.png',
      loop: false,
    ),
  ),
  DemoSkill(
    id: DemoSkillId.mend,
    label: 'Mend',
    manaCost: 20,
    cooldown: 6,
    power: 80,
    range: 0,
    isHeal: true,
    effect: AsepriteEntry(
      name: 'buff3',
      category: 'buff1',
      jsonAssetPath: 'assets/sprites/effects/buff1/buff3.json',
      sheetAssetPath: 'assets/sprites/effects/buff1/buff3.png',
      loop: false,
    ),
  ),
];
