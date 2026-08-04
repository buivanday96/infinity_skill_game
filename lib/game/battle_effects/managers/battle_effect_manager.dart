import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:infinity_skill_game/game/battle_effects/enums/damage_type.dart';
import 'package:infinity_skill_game/game/battle_effects/managers/damage_text_manager.dart';
import 'package:infinity_skill_game/game/battle_effects/models/damage_text_data.dart';
import 'package:infinity_skill_game/game/components/vfx/vfx_effect.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

/// Central battle presentation entry. Battle logic talks only to this manager.
class BattleEffectManager extends Component with HasGameReference<FlameGame> {
  BattleEffectManager({DamageTextManager? damageText})
      : damageText = damageText ?? DamageTextManager();

  final DamageTextManager damageText;

  @override
  Future<void> onLoad() async {
    await add(damageText);
  }

  void showDamage({
    required double amount,
    required Vector2 worldPosition,
    bool critical = false,
    double delay = 0,
  }) {
    final type = critical ? DamageType.critical : DamageType.normal;
    damageText.showDamage(
      DamageTextData(
        text: _formatAmount(amount),
        type: type,
        worldPosition: worldPosition,
        delay: delay,
      ),
    );
  }

  void showHeal({
    required double amount,
    required Vector2 worldPosition,
    double delay = 0,
  }) {
    damageText.showHeal(
      DamageTextData(
        text: '+${_formatAmount(amount)}',
        type: DamageType.heal,
        worldPosition: worldPosition,
        delay: delay,
      ),
    );
  }

  void showShield({
    required double amount,
    required Vector2 worldPosition,
    double delay = 0,
  }) {
    damageText.showShield(
      DamageTextData(
        text: '+${_formatAmount(amount)}',
        type: DamageType.shield,
        worldPosition: worldPosition,
        delay: delay,
      ),
    );
  }

  void showMiss({required Vector2 worldPosition, double delay = 0}) {
    damageText.showMiss(
      DamageTextData(
        text: 'MISS',
        type: DamageType.miss,
        worldPosition: worldPosition,
        delay: delay,
      ),
    );
  }

  void showGold({
    required double amount,
    required Vector2 worldPosition,
    double delay = 0,
  }) {
    damageText.showGold(
      DamageTextData(
        text: '+${_formatAmount(amount)}g',
        type: DamageType.gold,
        worldPosition: worldPosition,
        delay: delay,
      ),
    );
  }

  void showExp({
    required double amount,
    required Vector2 worldPosition,
    double delay = 0,
  }) {
    damageText.showExp(
      DamageTextData(
        text: '+${_formatAmount(amount)} XP',
        type: DamageType.exp,
        worldPosition: worldPosition,
        delay: delay,
      ),
    );
  }

  /// Spawns a one-shot Aseprite hit spark via existing [VfxEffect].
  void playHitEffect({
    required AsepriteEntry entry,
    required Vector2 worldPosition,
    Vector2? displaySize,
    int priority = 60,
  }) {
    game.add(
      VfxEffect(
        entry: entry,
        worldPosition: worldPosition,
        displaySize: displaySize,
      )..priority = priority,
    );
  }

  /// Reserved for camera shake — no-op until CameraShakeManager lands.
  void cameraShake({double intensity = 1, double duration = 0.15}) {}

  /// Reserved for SFX — no-op until SoundEffectManager lands.
  void playSound(String soundId) {}

  void clear() => damageText.clear();

  String _formatAmount(double amount) {
    if (amount >= 100) return amount.round().toString();
    if (amount == amount.roundToDouble()) return amount.round().toString();
    return amount.toStringAsFixed(0);
  }
}
