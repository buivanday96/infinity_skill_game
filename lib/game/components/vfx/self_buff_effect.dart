import 'package:flame/components.dart';
import 'package:infinity_skill_game/features/battle/data/skill_vfx_catalog.dart';
import 'package:infinity_skill_game/game/combat_demo_game.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// One-shot aura attached to a combatant (e.g. knight Guard shield).
///
/// Parent should be the [CombatantActor]; effect centers on the body.
class SelfBuffEffect extends PositionComponent
    with HasGameReference<CombatDemoGame> {
  SelfBuffEffect({
    required this.vfx,
    this.onFinished,
    int? drawPriority,
  }) : super(
          anchor: Anchor.center,
          priority: drawPriority ?? 40,
        );

  final SkillVfxSpec vfx;
  final void Function()? onFinished;

  @override
  Future<void> onLoad() async {
    final parentSize = (parent is PositionComponent)
        ? (parent! as PositionComponent).size
        : Vector2(64, 64);

    // Sit mid-body so the cyan pillar wraps the knight.
    position = Vector2(parentSize.x / 2, parentSize.y * 0.55);

    final entry = vfx.hitEffect;
    if (entry == null) {
      removeFromParent();
      return;
    }

    final result = await loadAsepriteAnimation(
      entry: entry,
      images: game.images,
      loop: false,
    );

    final sprite = SpriteAnimationComponent(
      animation: result.animation,
      size: Vector2(vfx.splashWidth, vfx.splashHeight),
      anchor: Anchor.center,
      position: Vector2.zero(),
    );
    add(sprite);

    sprite.animationTicker?.onComplete = () {
      onFinished?.call();
      removeFromParent();
    };
  }
}
