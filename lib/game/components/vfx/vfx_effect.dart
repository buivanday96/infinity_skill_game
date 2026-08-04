import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// Plays a one-shot Aseprite VFX then removes itself.
class VfxEffect extends SpriteAnimationComponent
    with HasGameReference<FlameGame> {
  VfxEffect({
    required this.entry,
    required Vector2 worldPosition,
    this.displaySize,
    this.onFinished,
  }) : super(
          position: worldPosition,
          anchor: Anchor.center,
          priority: 50,
        );

  final AsepriteEntry entry;
  final Vector2? displaySize;
  final void Function()? onFinished;

  @override
  Future<void> onLoad() async {
    final result = await loadAsepriteAnimation(
      entry: entry,
      images: game.images,
      loop: false,
    );
    animation = result.animation;
    size = displaySize ?? result.frameSize * 1.4;
    animationTicker?.onComplete = () {
      onFinished?.call();
      removeFromParent();
    };
  }
}
