import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/game/debug_hitbox.dart';
import 'package:infinity_skill_game/game/entities/character_sprite_scale.dart';
import 'package:infinity_skill_game/ui/aseprite_animation.dart';

enum _ProjectilePhase { start, flying, hit, ending, done }

enum _KnightState { idle, hurt, dying, powerup }

class IceSkillDemoGame extends FlameGame {
  IceSkillDemoGame({this.onPhaseChanged});

  final ValueChanged<String>? onPhaseChanged;

  /// Draw AABB outlines used for projectile ↔ knight collision.
  static const bool showCollisionBoxes = true;

  late final WizardComponent wizard;
  late final KnightComponent knight;
  IceProjectile? _projectile;
  BuffAuraComponent? _buffAura;
  bool _casting = false;

  @override
  Color backgroundColor() => const Color(0xFF1A1F2A);

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    images.prefix = 'assets/';

    await images.loadAll([
      'sprites/characters/wizzard/Attack1.png',
      'sprites/characters/wizzard/Idle.png',
      'sprites/characters/knight/attack1.png',
      'sprites/characters/knight/hurt1.png',
      'sprites/characters/knight/dying1.png',
      'sprites/characters/knight/powerup1.png',
      'sprites/effects/ice/start_1.png',
      'sprites/effects/ice/repeatable_1.png',
      'sprites/effects/ice/hit_1.png',
      'sprites/effects/ice/ice2_ending.png',
      'sprites/effects/buff1/buff3.png',
      'sprites/effects/buff1/buff4.png',
    ]);

    wizard = WizardComponent(images: images);
    knight = KnightComponent(
      images: images,
      onPhaseChanged: _notify,
    );
    await world.addAll([wizard, knight]);
    wizard.alignToViewport(size);
    knight.alignToViewport(size);
    _notify('Ready — tap Cast or Buff');
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    wizard.alignToViewport(size);
    knight.alignToViewport(size);
  }

  void _notify(String phase) => onPhaseChanged?.call(phase);

  Future<void> castSkill() async {
    if (_casting || _projectile != null) return;
    _casting = true;
    _notify('Casting');

    wizard.playAttack();

    final spawn = wizard.projectileSpawnPoint();
    _projectile = IceProjectile(
      images: images,
      spawn: spawn,
      target: knight,
      onPhaseChanged: _notify,
      onFinished: () {
        _projectile = null;
        _casting = false;
        if (!knight.isReacting) {
          _notify('Ready — tap Cast or Buff');
        }
      },
    );
    await world.add(_projectile!);
  }

  Future<void> castBuff() async {
    _buffAura?.removeFromParent();
    _buffAura = null;
    _notify('Buff active');

    late final BuffAuraComponent aura;
    aura = BuffAuraComponent(
      images: images,
      jsonAssetPath: 'assets/sprites/effects/buff1/buff4.json',
      name: 'buff4',
      onFinished: () {
        if (_buffAura == aura) {
          _buffAura = null;
          if (_projectile == null && !_casting && !knight.isReacting) {
            _notify('Ready — tap Cast or Buff');
          }
        }
      },
    );
    _buffAura = aura;
    await wizard.add(aura);
  }

  void reset() {
    _projectile?.removeFromParent();
    _projectile = null;
    _buffAura?.removeFromParent();
    _buffAura = null;
    _casting = false;
    wizard.resetIdle();
    knight.reset();
    _notify('Ready — tap Cast or Buff');
  }
}

class WizardComponent extends SpriteAnimationComponent with HasGameReference<IceSkillDemoGame>, ScaledCharacterSprite, DebugHitbox {
  @override
  bool get showHitbox => IceSkillDemoGame.showCollisionBoxes;

  @override
  Color get hitboxColor => const Color(0xFF40C4FF);

  /// Smaller core of the ice bolt.
  @override
  Rect get localHitbox => const HitboxInset(
    left: 0.3,
    top: 0.25,
    right: 0.35,
    bottom: 0.25,
  ).toLocalRect(size);

  WizardComponent({required this.images})
    : super(
        size: Vector2.zero(),
        anchor: Anchor.centerLeft,
      );

  final Images images;

  SpriteAnimation? _idle;
  SpriteAnimation? _attack;

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
    _idle = idleResult.animation;
    applyNativeFrameScale(idleResult.frameSize);

    _attack = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'Attack1',
        category: 'wizzard',
        jsonAssetPath: 'assets/sprites/characters/wizzard/Attack1.json',
        loop: false,
      ),
      images: images,
      loop: false,
    )).animation;

    animation = _idle;
    alignToViewport(game.size);
    return super.onLoad();
  }

  void alignToViewport(Vector2 viewSize) {
    position = Vector2(24, viewSize.y * 0.55);
  }

  Vector2 projectileSpawnPoint() {
    return position + Vector2(size.x * 0.75, -size.y * 0.05);
  }

  Future<void> playAttack() async {
    if (_attack == null) return;
    animation = _attack;
    animationTicker?.reset();

    final completer = Completer<void>();
    animationTicker?.onComplete = () {
      if (!completer.isCompleted) completer.complete();
    };
    await completer.future.timeout(
      const Duration(milliseconds: 1200),
      onTimeout: () {},
    );

    animation = _idle;
    animationTicker?.reset();
  }

  void resetIdle() {
    animation = _idle;
    animationTicker?.reset();
  }
}

class KnightComponent extends SpriteAnimationComponent with HasGameReference<IceSkillDemoGame>, ScaledCharacterSprite, DebugHitbox {
  KnightComponent({
    required this.images,
    required this.onPhaseChanged,
  }) : super(
         size: Vector2.zero(),
         anchor: Anchor.center,
       );

  @override
  bool get showHitbox => IceSkillDemoGame.showCollisionBoxes;

  @override
  Color get hitboxColor => const Color(0xFFFF5252);

  /// Tighter body box — ignores sword/arm padding on the sprite sheet.
  @override
  Rect get localHitbox => const HitboxInset(
    left: 0.38,
    top: 0.12,
    right: 0.42,
    bottom: 0.06,
  ).toLocalRect(size);

  final Images images;
  final ValueChanged<String> onPhaseChanged;

  static const int maxHp = 3;

  int hp = maxHp;
  _KnightState _state = _KnightState.idle;
  BuffAuraComponent? _buffAura;

  SpriteAnimation? _idle;
  SpriteAnimation? _hurt;
  SpriteAnimation? _dying;
  SpriteAnimation? _powerup;

  bool get isInvulnerable => _state == _KnightState.dying || _state == _KnightState.powerup;

  bool get isReacting => _state != _KnightState.idle;

  @override
  FutureOr<void> onLoad() async {
    // Face left toward the wizard (flip around center so it stays on-screen).
    flipHorizontally();

    final attackResult = await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'attack1',
        category: 'knight',
        jsonAssetPath: 'assets/sprites/characters/knight/attack1.json',
      ),
      images: images,
      loop: true,
    );
    applyNativeFrameScale(attackResult.frameSize, targetHeight: 50);

    _idle = SpriteAnimation.spriteList(
      [attackResult.animation.frames.first.sprite],
      stepTime: 1.0,
      loop: true,
    );

    _hurt = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'hurt1',
        category: 'knight',
        jsonAssetPath: 'assets/sprites/characters/knight/hurt1.json',
        loop: false,
      ),
      images: images,
      loop: false,
    )).animation;

    _dying = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'dying1',
        category: 'knight',
        jsonAssetPath: 'assets/sprites/characters/knight/dying1.json',
        loop: false,
      ),
      images: images,
      loop: false,
    )).animation;

    _powerup = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'powerup1',
        category: 'knight',
        jsonAssetPath: 'assets/sprites/characters/knight/powerup1.json',
        loop: false,
      ),
      images: images,
      loop: false,
    )).animation;

    animation = _idle;
    alignToViewport(game.size);
    return super.onLoad();
  }

  void alignToViewport(Vector2 viewSize) {
    // Inset from the right so the full sprite stays inside the viewport.
    position = Vector2(viewSize.x - size.x * 0.5 - 24, viewSize.y * 0.55);
  }

  void takeHit() {
    if (isInvulnerable || _state == _KnightState.hurt) return;

    hp = (hp - 1).clamp(0, maxHp);
    _playHurt();
  }

  void reset() {
    _buffAura?.removeFromParent();
    _buffAura = null;
    hp = maxHp;
    _state = _KnightState.idle;
    animation = _idle;
    animationTicker?.reset();
  }

  Future<void> _playHurt() async {
    if (_hurt == null) return;
    _state = _KnightState.hurt;
    onPhaseChanged('Knight: hurt (HP $hp/$maxHp)');
    animation = _hurt;
    animationTicker?.reset();

    await _awaitAnimComplete(timeoutMs: 800);

    if (_state != _KnightState.hurt) return;

    if (hp > 0) {
      _state = _KnightState.idle;
      animation = _idle;
      animationTicker?.reset();
      onPhaseChanged('Knight idle (HP $hp/$maxHp)');
    } else {
      await _playDyingThenPowerup();
    }
  }

  Future<void> _playDyingThenPowerup() async {
    if (_dying == null || _powerup == null) return;

    _state = _KnightState.dying;
    onPhaseChanged('Knight: dying');
    animation = _dying;
    animationTicker?.reset();
    await _awaitAnimComplete(timeoutMs: 1000);

    if (_state != _KnightState.dying) return;

    _state = _KnightState.powerup;
    onPhaseChanged('Knight: powerup + buff3');
    animation = _powerup;
    animationTicker?.reset();

    _buffAura?.removeFromParent();
    late final BuffAuraComponent aura;
    aura = BuffAuraComponent(
      images: images,
      jsonAssetPath: 'assets/sprites/effects/buff1/buff3.json',
      name: 'buff3',
      onFinished: () {
        if (_buffAura == aura) _buffAura = null;
      },
    );
    _buffAura = aura;
    await add(aura);

    await _awaitAnimComplete(timeoutMs: 1500);

    if (_state != _KnightState.powerup) return;

    hp = maxHp;
    _state = _KnightState.idle;
    animation = _idle;
    animationTicker?.reset();
    onPhaseChanged('Knight revived (HP $hp/$maxHp)');
  }

  Future<void> _awaitAnimComplete({required int timeoutMs}) async {
    final completer = Completer<void>();
    animationTicker?.onComplete = () {
      if (!completer.isCompleted) completer.complete();
    };
    await completer.future.timeout(
      Duration(milliseconds: timeoutMs),
      onTimeout: () {},
    );
  }
}

class BuffAuraComponent extends SpriteAnimationComponent {
  BuffAuraComponent({
    required this.images,
    required this.onFinished,
    this.jsonAssetPath = 'assets/sprites/effects/buff1/buff3.json',
    this.name = 'buff3',
  }) : super(
         size: Vector2(96, 128),
         anchor: Anchor.center,
         priority: 10,
       );

  final Images images;
  final VoidCallback onFinished;
  final String jsonAssetPath;
  final String name;

  static const double _duration = 2.5;
  double _elapsed = 0;

  @override
  FutureOr<void> onLoad() async {
    final parentSize = (parent as PositionComponent?)?.size ?? Vector2(140, 115);
    position = Vector2(parentSize.x * 0.45, parentSize.y * 0.35);

    animation = (await loadAsepriteAnimation(
      entry: AsepriteEntry(
        name: name,
        category: 'buff1',
        jsonAssetPath: jsonAssetPath,
      ),
      images: images,
      loop: false,
    )).animation;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= _duration) {
      onFinished();
      removeFromParent();
    }
  }
}

class IceProjectile extends SpriteAnimationComponent with HasGameReference<IceSkillDemoGame>, DebugHitbox {
  IceProjectile({
    required this.images,
    required Vector2 spawn,
    required this.target,
    required this.onPhaseChanged,
    required this.onFinished,
  }) : super(
         position: spawn.clone(),
         size: Vector2(72, 48),
         anchor: Anchor.center,
       );

  @override
  bool get showHitbox => IceSkillDemoGame.showCollisionBoxes;

  @override
  Color get hitboxColor => const Color(0xFF40C4FF);

  /// Smaller core of the ice bolt.
  @override
  Rect get localHitbox => const HitboxInset(
    left: 0.2,
    top: 0.25,
    right: 0.15,
    bottom: 0.25,
  ).toLocalRect(size);

  final Images images;
  final KnightComponent target;
  final ValueChanged<String> onPhaseChanged;
  final VoidCallback onFinished;

  late SpriteAnimation _start;
  late SpriteAnimation _flying;
  late SpriteAnimation _hit;
  late SpriteAnimation _ending;

  _ProjectilePhase _phase = _ProjectilePhase.start;
  static const double _speed = 280;

  @override
  FutureOr<void> onLoad() async {
    _start = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'start_1',
        category: 'ice',
        jsonAssetPath: 'assets/sprites/effects/ice/start_1.json',
        loop: false,
      ),
      images: images,
      loop: false,
    )).animation;
    _flying = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'repeatable_1',
        category: 'ice',
        jsonAssetPath: 'assets/sprites/effects/ice/repeatable_1.json',
      ),
      images: images,
      loop: true,
    )).animation;
    _hit = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'hit_1',
        category: 'ice',
        jsonAssetPath: 'assets/sprites/effects/ice/hit_1.json',
        loop: false,
      ),
      images: images,
      loop: false,
    )).animation;
    _ending = (await loadAsepriteAnimation(
      entry: const AsepriteEntry(
        name: 'ice2_ending',
        category: 'ice',
        jsonAssetPath: 'assets/sprites/effects/ice/ice2_ending.json',
        loop: false,
      ),
      images: images,
      loop: false,
    )).animation;

    _setPhase(_ProjectilePhase.start);

    size = Vector2(72 / 1.5, 48 / 1.5);
    return super.onLoad();
  }

  void _setPhase(_ProjectilePhase phase, {bool hitKnight = false}) {
    _phase = phase;
    switch (phase) {
      case _ProjectilePhase.start:
        onPhaseChanged('Projectile: start');
        animation = _start;
        animationTicker?.reset();
        animationTicker?.onComplete = () {
          if (_phase == _ProjectilePhase.start) {
            _setPhase(_ProjectilePhase.flying);
          }
        };
      case _ProjectilePhase.flying:
        onPhaseChanged('Projectile: flying');
        animation = _flying;
        animationTicker?.reset();
        animationTicker?.onComplete = null;
      case _ProjectilePhase.hit:
        onPhaseChanged(
          hitKnight ? 'Projectile: hit knight' : 'Projectile: hit (screen edge)',
        );
        animation = _hit;
        animationTicker?.reset();
        animationTicker?.onComplete = () {
          if (_phase == _ProjectilePhase.hit) {
            _setPhase(_ProjectilePhase.ending);
          }
        };
      case _ProjectilePhase.ending:
        onPhaseChanged('Projectile: ending');
        animation = _ending;
        animationTicker?.reset();
        animationTicker?.onComplete = () {
          if (_phase == _ProjectilePhase.ending) {
            _phase = _ProjectilePhase.done;
            onPhaseChanged('Complete');
            onFinished();
            removeFromParent();
          }
        };
      case _ProjectilePhase.done:
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_phase != _ProjectilePhase.flying) return;

    position.x += _speed * dt;

    if (absoluteHitbox().overlaps(target.absoluteHitbox())) {
      target.takeHit();
      _setPhase(_ProjectilePhase.hit, hitKnight: true);
      return;
    }

    final rightEdge = game.size.x - size.x * 0.5 - 8;
    if (position.x >= rightEdge) {
      position.x = rightEdge;
      _setPhase(_ProjectilePhase.hit);
    }
  }
}
