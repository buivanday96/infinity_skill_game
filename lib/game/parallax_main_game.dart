import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/game/debug_hitbox.dart';
import 'package:infinity_skill_game/game/entities/character_sprite_scale.dart';
import 'package:infinity_skill_game/ui/aseprite_animation.dart';

/// Fraction of viewport height where Layer_0001_8 opaque ground begins
/// (measured from art: opaque_top_y / image_height ≈ 0.910).
const double kGroundTopFraction = 0.910;

class ParallaxMainGame extends FlameGame with HasCollisionDetection {
  late final GroundComponent ground;
  late final StandingWizard wizard;

  /// Separate cache so sprites keep `assets/` prefix while parallax uses
  /// Flame's default `assets/images/`.
  final Images spriteImages = Images(prefix: 'assets/');

  @override
  Color backgroundColor() => const Color(0xFF0B1A12);

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/Layer_0009_2 1.png'),
        ParallaxImageData('parallax/Layer_0008_3 1.png'),
        ParallaxImageData('parallax/Layer_0006_4 1.png'),
        ParallaxImageData('parallax/Layer_0005_5 1.png'),
        ParallaxImageData('parallax/Layer_0003_6 1.png'),
        ParallaxImageData('parallax/Layer_0001_8 1.png'),
        ParallaxImageData('parallax/Layer_0000_9 1.png'),
      ],
      baseVelocity: Vector2(1, 0),
      velocityMultiplierDelta: Vector2(1.5, 1.0),
      fill: LayerFill.none,
      alignment: Alignment.bottomLeft,
    );

    // Backdrop paints behind the world so characters stay in front of parallax.
    await camera.backdrop.add(parallax);

    ground = GroundComponent();
    wizard = StandingWizard(images: spriteImages);
    await world.addAll([ground, wizard]);

    ground.alignToViewport(size);
    wizard.spawnAboveGround(size, ground.topY);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    ground.alignToViewport(size);
    if (wizard.isMounted) {
      wizard.snapToGround(ground.topY);
    }
  }
}

/// Invisible solid floor aligned to the grass top of Layer_0001_8.
class GroundComponent extends PositionComponent with CollisionCallbacks, DebugHitbox {
  GroundComponent() : super(anchor: Anchor.topLeft);

  double topY = 0;

  @override
  bool get showHitbox => true;

  @override
  Color get hitboxColor => const Color(0xFF40C4FF);

  void alignToViewport(Vector2 viewSize) {
    topY = viewSize.y * kGroundTopFraction;
    position = Vector2(0, topY);
    size = Vector2(viewSize.x, viewSize.y - topY);
  }

  @override
  FutureOr<void> onLoad() async {
    await add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }
}

class StandingWizard extends SpriteAnimationComponent with HasGameReference<ParallaxMainGame>, CollisionCallbacks, ScaledCharacterSprite, DebugHitbox {
  StandingWizard({required this.images}) : super(anchor: Anchor.bottomCenter);

  final Images images;

  static const double gravity = 980;
  final Vector2 velocity = Vector2.zero();
  bool onGround = false;

  @override
  bool get showHitbox => true;

  @override
  Color get hitboxColor => const Color(0xFF40C4FF);

  @override
  Rect get localHitbox => const HitboxInset(
    left: 0.35,
    top: 0.25,
    right: 0.35,
    bottom: 0.25,
  ).toLocalRect(size);

  @override
  FutureOr<void> onLoad() async {
    final idleResult = await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'Idle',
        category: 'wizzard',
        jsonAssetPath: 'assets/sprites/characters/wizzard/Idle.json',
      ),
      images: images,
      loop: true,
    );
    animation = idleResult.animation;
    applyNativeFrameScale(idleResult.frameSize);

    await add(
      RectangleHitbox.relative(
        Vector2(0.4, 0.7),
        parentSize: size,
        position: Vector2(size.x * 0.3, size.y * 0.25),
        collisionType: CollisionType.active,
      ),
    );
    return super.onLoad();
  }

  void spawnAboveGround(Vector2 viewSize, double groundTopY) {
    position = Vector2(viewSize.x * 0.28, groundTopY);
    velocity.setZero();
    onGround = false;
  }

  void snapToGround(double groundTopY) {
    position.y = groundTopY + localHitbox.height / 2;
    velocity.y = 0;
    onGround = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!onGround) {
      velocity.y += gravity * dt;
      position.y += velocity.y * dt;
    }
    // Keep feet from sinking if a collision frame is missed.
    final groundTop = game.ground.topY;
    if (position.y > groundTop) {
      snapToGround(groundTop);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is GroundComponent) {
      snapToGround(other.topY);
    }
  }
}
