import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_skill_game/features/battle/domain/hit_reaction.dart';

void main() {
  group('HitReactionState', () {
    test('multi-hit window: only first hit reacts, rest are HP-only', () {
      final rx = HitReactionState(maxPoise: 100);
      final first = rx.resolve(
        poiseDamage: 20,
        isCommitted: false,
        isDead: false,
      );
      expect(first.kind, HitReactKind.flinch);
      expect(first.flash, isTrue);

      final second = rx.resolve(
        poiseDamage: 20,
        isCommitted: false,
        isDead: false,
      );
      expect(second.kind, HitReactKind.none);
      expect(second.applySkillCc, isFalse);
      // Poise should not rise from gated hits.
      expect(rx.poise, 20);
    });

    test('hit anim cooldown blocks flinch but not skill CC on next window', () {
      final rx = HitReactionState(maxPoise: 100);
      final a = rx.resolve(poiseDamage: 10, isCommitted: false, isDead: false);
      expect(a.kind, HitReactKind.flinch);

      // Expire react window but keep hit-anim cooldown.
      rx.tick(HitReactionState.reactWindow + 0.01);
      expect(rx.reactLockout, 0);
      expect(rx.hitAnimCooldownLeft, greaterThan(0));

      final b = rx.resolve(
        poiseDamage: 10,
        isCommitted: false,
        isDead: false,
        wantsSkillCc: true,
      );
      expect(b.kind, HitReactKind.none);
      expect(b.applySkillCc, isTrue);
      expect(b.flash, isTrue);
    });

    test('poise break causes stagger', () {
      final rx = HitReactionState(maxPoise: 50);
      final d = rx.resolve(poiseDamage: 50, isCommitted: false, isDead: false);
      expect(d.kind, HitReactKind.stagger);
      expect(rx.poise, 0);
    });

    test('committed action is not interrupted; stagger is deferred', () {
      final rx = HitReactionState(maxPoise: 40);
      final d = rx.resolve(poiseDamage: 40, isCommitted: true, isDead: false);
      expect(d.kind, HitReactKind.deferredStagger);
      expect(d.playHurt, isFalse);
      expect(rx.staggerQueued, isTrue);

      final queued = rx.consumeQueuedStagger();
      expect(queued.kind, HitReactKind.stagger);
      expect(rx.staggerQueued, isFalse);
    });

    test('poise regenerates after delay', () {
      final rx = HitReactionState(maxPoise: 100);
      rx.resolve(poiseDamage: 40, isCommitted: false, isDead: false);
      expect(rx.poise, 40);

      rx.tick(HitReactionState.poiseRegenDelay + 0.5);
      expect(rx.poise, lessThan(40));
    });
  });
}
