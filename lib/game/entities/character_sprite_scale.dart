import 'package:flame/components.dart';

/// Shared on-screen sizing for character sprites with different native frame sizes.
///
/// Keeps aspect ratio and matches [referenceHeight] (wizard display height)
/// so every future character can look the same height as the wizard.
class CharacterSpriteScale {
  CharacterSpriteScale._();

  /// Wizard baseline display height in world units.
  static const double referenceHeight = 115;

  /// Display size for a native Aseprite frame, preserving aspect ratio.
  static Vector2 displaySize(
    Vector2 nativeFrameSize, {
    double targetHeight = referenceHeight,
  }) {
    assert(nativeFrameSize.x > 0 && nativeFrameSize.y > 0);
    final scale = targetHeight / nativeFrameSize.y;
    return Vector2(nativeFrameSize.x * scale, targetHeight);
  }
}

/// Applies [CharacterSpriteScale] to any [PositionComponent] (wizard, knight, …).
mixin ScaledCharacterSprite on PositionComponent {
  /// Set [size] from the sprite's native frame so height matches [targetHeight].
  void applyNativeFrameScale(
    Vector2 nativeFrameSize, {
    double targetHeight = CharacterSpriteScale.referenceHeight,
  }) {
    size = CharacterSpriteScale.displaySize(
      nativeFrameSize,
      targetHeight: targetHeight,
    );
  }
}
