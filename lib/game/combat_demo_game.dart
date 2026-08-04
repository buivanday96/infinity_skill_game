import 'dart:async';
import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:infinity_skill_game/features/battle/data/skill_vfx_catalog.dart';
import 'package:infinity_skill_game/game/battle_effects/managers/battle_effect_manager.dart';
import 'package:infinity_skill_game/game/components/battle_arena.dart';
import 'package:infinity_skill_game/features/battle/presentation/combat_hud_state.dart';
import 'package:infinity_skill_game/game/components/combatant_actor.dart';
import 'package:infinity_skill_game/game/components/vfx/ice_projectile.dart';
import 'package:infinity_skill_game/features/battle/data/sprite_kits.dart';
import 'package:infinity_skill_game/game/components/vfx/self_buff_effect.dart';
import 'package:infinity_skill_game/game/components/vfx/thunder_strike_effect.dart';
import 'package:infinity_skill_game/game/components/vfx/world_burst_effect.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';
import 'package:infinity_skill_game/shared/domain.dart';

/// Melee impact spark for knight basic attacks.
const _meleeHitEffect = AsepriteEntry(
  name: 'hit1',
  category: 'hit',
  jsonAssetPath: 'assets/sprites/effects/hit/hit1.json',
  sheetAssetPath: 'assets/sprites/effects/hit/hit1.png',
  loop: false,
);

/// Runtime unit in the auto-battle demo.
class BattleUnit {
  BattleUnit({
    required this.model,
    required this.actor,
    required this.isHero,
    required this.kit,
  });

  final Combatant model;
  final CombatantActor actor;
  final bool isHero;
  final SpriteKit kit;
  double atkTimer = 0;
  bool removing = false;
  bool casting = false;

  bool get isAlive => model.isAlive && !removing;
}

/// Multi-unit auto battle hosted as a dungeon run (floor loop).
///
/// Layout: top 1/4 wall, bottom 3/4 battle floor.
/// Units auto-cast ready skills (e.g. Wizard Ice Bolt) when in range.
/// Victory → floor choice (UI) → next floor; defeat → retry run.
class CombatDemoGame extends FlameGame {
  CombatDemoGame({
    ValueNotifier<CombatHudState>? hud,
    DungeonSystem? dungeon,
  })  : hud = hud ?? ValueNotifier(CombatHudState.empty),
        dungeon = dungeon ?? DungeonSystem();

  final ValueNotifier<CombatHudState> hud;
  final DungeonSystem dungeon;

  static const double rangeUnit = 40;
  static const double knightSpriteSize = 56;
  static const double wizardSpriteSize = 96;
  static const double monsterSpriteSize = 64;
  static const double wallRatio = 0.25;

  /// Passive mana restore so casters can reuse skills in a long fight.
  static const double manaRegenPerSec = 6;

  /// Wizard / mage mana restore — higher so multi-skill casting stays fluid.
  static const double wizardManaRegenPerSec = 24;

  final List<BattleUnit> units = [];
  final List<MonsterModel> _killedThisFloor = [];
  bool _battleOver = false;
  final _rng = math.Random();

  /// Overlay toggles: action range, body hitbox, sprite collision bounds.
  final ValueNotifier<CombatDebugFlags> debugFlags = ValueNotifier(CombatDebugFlags.allOn);

  late WallBackdrop _wall;
  late BattleFloor _floor;
  late BattleEffectManager battleEffects;

  double get wallHeight => size.y * wallRatio;
  double get battleTop => wallHeight;
  double get battleHeight => size.y - wallHeight;

  /// Three vertical lanes inside the battle area (feet Y).
  List<double> get _laneYs {
    final top = battleTop + battleHeight * 0.38;
    final mid = battleTop + battleHeight * 0.62;
    final bot = battleTop + battleHeight * 0.88;
    return [top, mid, bot];
  }

  /// Melee / short skills must share a combat line (feet Y).
  /// Above this range stat, cross-lane targeting is allowed (wizard bolts, etc.).
  static const double meleeRangeCap = 1.0;

  double attackReachPx(double rangeStat) => math.max(rangeStat, 0.15) * rangeUnit;

  bool isMeleeRange(double rangeStat) => rangeStat <= meleeRangeCap;

  /// Max |ΔfeetY| to count as the same combat line (~⅓ of lane spacing).
  double get lineAlignPx {
    final lanes = _laneYs;
    if (lanes.length < 2) return 28;
    return (lanes[1] - lanes[0]).abs() * 0.35;
  }

  bool onSameLine(BattleUnit a, BattleUnit b) => (a.actor.position.y - b.actor.position.y).abs() <= lineAlignPx;

  /// Horizontal-only gap between body hitboxes (ignores Y).
  /// Melee uses this so tall sprites on other lanes don't "block" or fake range.
  double horizontalHitboxGap(BattleUnit a, BattleUnit b) {
    final ra = a.actor.absoluteHitbox();
    final rb = b.actor.absoluteHitbox();
    if (ra.isEmpty || rb.isEmpty) {
      return (a.actor.position.x - b.actor.position.x).abs();
    }
    return math.max(0.0, math.max(ra.left - rb.right, rb.left - ra.right));
  }

  /// Gap between body hitboxes (0 = overlapping / touching).
  /// Used for ranged / AOE — not foot X distance — so units must close in.
  double hitboxGap(BattleUnit a, BattleUnit b) {
    final ra = a.actor.absoluteHitbox();
    final rb = b.actor.absoluteHitbox();
    if (ra.isEmpty || rb.isEmpty) {
      final dx = a.actor.position.x - b.actor.position.x;
      final dy = a.actor.position.y - b.actor.position.y;
      return math.sqrt(dx * dx + dy * dy);
    }
    final dx = math.max(0.0, math.max(ra.left - rb.right, rb.left - ra.right));
    final dy = math.max(0.0, math.max(ra.top - rb.bottom, rb.top - ra.bottom));
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Attacker sprite faces toward defender's feet X.
  bool isFacingTarget(BattleUnit attacker, BattleUnit defender) {
    final dx = defender.actor.position.x - attacker.actor.position.x;
    if (dx.abs() < 8) return true;
    return attacker.actor.facingRight == dx > 0;
  }

  /// Engagement gap for a given range stat (melee = X-only + same line).
  double engagementGap(BattleUnit a, BattleUnit b, double rangeStat) {
    if (isMeleeRange(rangeStat)) {
      if (!onSameLine(a, b)) return double.infinity;
      return horizontalHitboxGap(a, b);
    }
    return hitboxGap(a, b);
  }

  bool inAttackRange(
    BattleUnit attacker,
    BattleUnit defender, {
    double? rangeStat,
  }) {
    final range = rangeStat ?? attacker.model.range;
    final reach = attackReachPx(range);
    if (engagementGap(attacker, defender, range) > reach) return false;
    // Directed attacks require facing the target (AOE/spin bypass this separately).
    if (!isFacingTarget(attacker, defender)) return false;
    return true;
  }

  @override
  Color backgroundColor() => const Color(0xFF12100E);

  @override
  Future<void> onLoad() async {
    images.prefix = 'assets/';
    _buildArena();
    battleEffects = BattleEffectManager();
    await add(battleEffects);
    await startRun();
  }

  void _buildArena() {
    _wall = WallBackdrop(size: Vector2(size.x, wallHeight));
    _floor = BattleFloor(
      position: Vector2(0, battleTop),
      size: Vector2(size.x, battleHeight),
    );
    add(_floor);
    add(_wall);
  }

  /// Fresh dungeon run from floor 1 (new heroes).
  Future<void> startRun() async {
    final encounter = dungeon.startRun();
    await _clearAllUnits();
    await _spawnHeroes();
    await _spawnMonstersFor(encounter);
    _battleOver = false;
    _pushHud(status: 'Floor ${dungeon.floor} — fight!');
  }

  /// Defeat → retry from floor 1.
  Future<void> retryRun() => startRun();

  /// After floor choice: apply pick, spawn next floor (heroes persist).
  Future<void> pickFloorChoice(String choiceId) async {
    if (dungeon.phase != DungeonPhase.choosing) return;
    final heroes = _livingHeroModels();
    final next = dungeon.pickChoiceById(heroes, choiceId);
    if (next == null) return;

    await _removeMonsterUnits();
    await _repositionLivingHeroes();
    await _spawnMonstersFor(next);
    _battleOver = false;
    _pushHud(status: 'Floor ${dungeon.floor} — fight!');
  }

  Future<void> _clearAllUnits() async {
    for (final u in units) {
      u.actor.removeFromParent();
    }
    units.clear();
    _killedThisFloor.clear();
  }

  Future<void> _spawnHeroes() async {
    final lanes = _laneYs;
    await _addUnit(
      model: HeroModel.knight(id: 'hero_tank', name: 'Knight'),
      kit: knightKit,
      isHero: true,
      pos: Vector2(size.x * 0.14, lanes[0]),
      size: knightSpriteSize,
      showMana: true,
      range: 0.35,
    );
    await _addUnit(
      model: HeroModel.mage(id: 'hero_mage', name: 'Wizard'),
      kit: wizardKit,
      isHero: true,
      pos: Vector2(size.x * 0.10, lanes[1]),
      size: wizardSpriteSize,
      showMana: true,
      range: 5,
    );
    for (final u in units.where((u) => u.isHero)) {
      u.atkTimer = u.model.basicAttackInterval * (0.3 + _rng.nextDouble() * 0.7);
      _delayAllSkills(u);
    }
  }

  Future<void> _removeMonsterUnits() async {
    final monsters = units.where((u) => !u.isHero).toList();
    for (final u in monsters) {
      u.actor.removeFromParent();
      units.remove(u);
    }
    _killedThisFloor.clear();
  }

  Future<void> _repositionLivingHeroes() async {
    final lanes = _laneYs;
    final heroes = units.where((u) => u.isHero && u.isAlive).toList();
    for (var i = 0; i < heroes.length; i++) {
      final u = heroes[i];
      u.removing = false;
      u.casting = false;
      final y = lanes[i.clamp(0, lanes.length - 1)];
      final x = u.model is HeroModel &&
              (u.model as HeroModel).heroClass == HeroClass.mage
          ? size.x * 0.10
          : size.x * 0.14;
      u.actor.position.setValues(x, y);
      u.actor.setFacingRight(true);
      u.actor.setMoving(false);
      u.atkTimer =
          u.model.basicAttackInterval * (0.3 + _rng.nextDouble() * 0.7);
      _delayAllSkills(u);
      _syncUnitBars(u);
    }
    // Drop dead hero actors so the next floor stays readable.
    final deadHeroes = units.where((u) => u.isHero && !u.isAlive).toList();
    for (final u in deadHeroes) {
      u.actor.removeFromParent();
      units.remove(u);
    }
  }

  Future<void> _spawnMonstersFor(FloorEncounter encounter) async {
    final lanes = _laneYs;
    final progression = dungeon.progression;

    for (var i = 0; i < encounter.spawns.length; i++) {
      final spec = encounter.spawns[i];
      final model = progression.spawnFromArchetype(
        archetype: spec.archetype,
        floor: encounter.floor,
        rank: spec.rank,
        id: '${spec.archetype.name}_f${encounter.floor}_$i',
      );
      final lane = spec.laneHint.clamp(0, lanes.length - 1);
      final visual = _monsterVisual(spec.archetype, spec.rank);
      final xJitter = (i % 3) * 0.04;
      await _addUnit(
        model: model,
        kit: visual.kit,
        isHero: false,
        pos: Vector2(size.x * (visual.xFrac - xJitter), lanes[lane]),
        size: visual.size,
        showMana: visual.showMana,
        range: visual.range,
      );
    }

    for (final u in units.where((u) => !u.isHero)) {
      u.atkTimer = u.model.basicAttackInterval * (0.3 + _rng.nextDouble() * 0.7);
      _delayAllSkills(u);
    }
  }

  ({SpriteKit kit, double size, double range, double xFrac, bool showMana})
      _monsterVisual(MonsterArchetype archetype, MonsterRank rank) {
    final rankScale = switch (rank) {
      MonsterRank.normal => 1.0,
      MonsterRank.elite => 1.12,
      MonsterRank.boss => 1.28,
    };
    return switch (archetype) {
      MonsterArchetype.slime => (
          kit: slimeKit,
          size: monsterSpriteSize * 0.9 * rankScale,
          range: 0.3,
          xFrac: 0.84,
          showMana: false,
        ),
      MonsterArchetype.golem => (
          kit: golemKit,
          size: monsterSpriteSize * rankScale,
          range: 0.3,
          xFrac: 0.86,
          showMana: false,
        ),
      MonsterArchetype.flyingDemon => (
          kit: flyingDemonKit,
          size: monsterSpriteSize * 1.05 * rankScale,
          range: 5,
          xFrac: 0.90,
          showMana: true,
        ),
    };
  }

  List<HeroModel> _livingHeroModels() {
    return units
        .where((u) => u.isHero && u.isAlive && u.model is HeroModel)
        .map((u) => u.model as HeroModel)
        .toList();
  }

  /// Put every castable skill on its full cooldown (3s for wizard spells).
  void _delayAllSkills(BattleUnit u) {
    for (final skill in u.model.skills) {
      if (skill.isPassive) continue;
      if (skillVfxOf(skill.definition.id) == null) continue;
      skill.startCooldown(cooldownReduction: 0);
    }
  }

  Future<void> _addUnit({
    required Combatant model,
    required SpriteKit kit,
    required bool isHero,
    required Vector2 pos,
    required double size,
    required double range,
    bool showMana = false,
  }) async {
    model.stats.setBase(StatId.range, range);
    final actor = CombatantActor(
      actorId: model.id,
      facingRight: isHero,
      worldPosition: pos,
      displaySize: size,
      showManaBar: showMana,
      isHeroTeam: isHero,
      idleEntry: kit.idle,
      walkEntry: kit.walk,
      attackEntry: kit.attack,
      hurtEntry: kit.hurt,
      deadEntry: kit.dead,
      buffEntry: kit.buff,
      footShadowLift: kit.footShadowLift,
      footShadowWidth: kit.footShadowWidth,
      footShadowHeight: kit.footShadowHeight,
      artFacesLeft: kit.artFacesLeft,
      maxPoise: model.poise,
    );
    actor.configurePoise(model.poise);
    actor.attackRangePx = attackReachPx(range);
    await add(actor);
    final unit = BattleUnit(
      model: model,
      actor: actor,
      isHero: isHero,
      kit: kit,
    );
    units.add(unit);
    _syncUnitBars(unit);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    _wall.size = Vector2(size.x, wallHeight);
    _floor
      ..position = Vector2(0, battleTop)
      ..size = Vector2(size.x, battleHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_battleOver) return;

    for (final u in units) {
      if (!u.isAlive) continue;
      _tickResources(u, dt);
      _syncUnitBars(u);
      u.actor.priority = u.actor.position.y.round();

      if (u.actor.isBusy || u.casting || u.actor.isCrowdControlled) {
        u.actor.setMoving(false);
        continue;
      }

      final target = _nearestEnemy(u);
      if (target == null) continue;

      final skill = _preferredSkill(u);
      final selfSkill = skill != null && _isSelfSkill(skill) ? skill : null;
      final offensiveSkill = skill != null && selfSkill == null ? skill : null;

      // Always close distance using weapon range — never let self-buffs freeze chase.
      final moveRange = u.model.range;
      final castRange = offensiveSkill?.definition.range ?? moveRange;
      final reach = attackReachPx(castRange);
      u.actor.attackRangePx = reach;
      final gap = engagementGap(u, target, castRange);

      u.actor.setFacingRight(
        target.actor.position.x >= u.actor.position.x,
      );

      if (gap <= reach) {
        u.actor.setMoving(false);
        u.atkTimer -= dt;
        if (u.atkTimer <= 0) {
          u.atkTimer = u.model.basicAttackInterval;
          if (selfSkill != null) {
            // Guard / shields only while already in fighting range.
            unawaited(_performSelfSkill(u, selfSkill));
          } else if (offensiveSkill != null) {
            unawaited(_performSkill(u, target, offensiveSkill));
          } else {
            unawaited(_performAttack(u, target));
          }
        }
      } else {
        u.atkTimer = math.max(0, u.atkTimer - dt * 0.25);
        // Chase on weapon range so skill range (e.g. whirlwind 1.2) can't stall movers.
        _chase(
          u,
          target,
          dt,
          rangeStat: moveRange,
          stopGap: attackReachPx(moveRange),
        );
      }
    }

    _checkBattleEnd();
  }

  void _tickResources(BattleUnit u, double dt) {
    for (final skill in u.model.skills) {
      skill.tickCooldown(dt);
    }
    if (u.model.maxMana > 0) {
      u.model.restoreMana(_manaRegenRate(u) * dt);
    }
  }

  double _manaRegenRate(BattleUnit u) {
    final model = u.model;
    if (model is HeroModel && model.heroClass == HeroClass.mage) {
      return wizardManaRegenPerSec;
    }
    return manaRegenPerSec;
  }

  /// Random ready, affordable skill that has a VFX entry (castable in demo).
  /// Prefers self-shield when hurt; never returns self-buffs at full HP so
  /// units keep basic-attacking instead of standing to cast Guard.
  SkillInstance? _preferredSkill(BattleUnit u) {
    final ready = <SkillInstance>[];
    for (final skill in u.model.skills) {
      if (skill.isPassive) continue;
      if (!skill.isReady) continue;
      if (u.model.currentMana < skill.manaCost) continue;
      if (skillVfxOf(skill.definition.id) == null) continue;
      ready.add(skill);
    }
    if (ready.isEmpty) return null;

    if (u.model.hpRatio < 0.9) {
      final selfReady = ready.where(_isSelfSkill).toList();
      if (selfReady.isNotEmpty) {
        return selfReady[_rng.nextInt(selfReady.length)];
      }
    }

    final offensive = ready.where((s) => !_isSelfSkill(s)).toList();
    if (offensive.isEmpty) return null;
    return offensive[_rng.nextInt(offensive.length)];
  }

  bool _isSelfSkill(SkillInstance skill) {
    final def = skill.definition;
    if (def.targetType == SkillTargetType.self) return true;
    final vfx = skillVfxOf(def.id);
    return vfx?.delivery == SkillDelivery.selfBuff;
  }

  BattleUnit? _nearestEnemy(BattleUnit self) {
    BattleUnit? best;
    var bestScore = double.infinity;
    final preferLine = isMeleeRange(self.model.range);
    for (final other in units) {
      if (!other.isAlive || other.isHero == self.isHero) continue;
      final same = onSameLine(self, other);
      // Melee: strongly prefer enemies already on our line.
      final linePenalty = preferLine && !same ? 400.0 : 0.0;
      final d = preferLine ? horizontalHitboxGap(self, other) + (self.actor.position.y - other.actor.position.y).abs() : hitboxGap(self, other);
      final score = d + linePenalty;
      if (score < bestScore) {
        bestScore = score;
        best = other;
      }
    }
    return best;
  }

  void _chase(
    BattleUnit self,
    BattleUnit target,
    double dt, {
    required double rangeStat,
    required double stopGap,
  }) {
    final melee = isMeleeRange(rangeStat);
    final aligned = onSameLine(self, target);

    // Melee: close on feet Y first so tall hitboxes on other lanes don't engage.
    // Ranged: steer toward hitbox centers (can shoot cross-lane).
    late final double dx;
    late final double dy;
    if (melee) {
      dx = target.actor.position.x - self.actor.position.x;
      dy = aligned ? 0.0 : (target.actor.position.y - self.actor.position.y);
    } else {
      final selfBox = self.actor.absoluteHitbox();
      final targetBox = target.actor.absoluteHitbox();
      final selfCenter = Offset(
        (selfBox.left + selfBox.right) / 2,
        (selfBox.top + selfBox.bottom) / 2,
      );
      final targetCenter = Offset(
        (targetBox.left + targetBox.right) / 2,
        (targetBox.top + targetBox.bottom) / 2,
      );
      dx = targetCenter.dx - selfCenter.dx;
      dy = targetCenter.dy - selfCenter.dy;
    }

    final dist = math.sqrt(dx * dx + dy * dy);
    final gap = engagementGap(self, target, rangeStat);

    // Only stop when within stop gap on a valid engagement line.
    // (Update loop handles attacking; this just prevents jitter once closed.)
    if (gap.isFinite && gap <= stopGap && (aligned || !melee)) {
      self.actor.setMoving(false);
      return;
    }
    if (dist < 0.001) {
      self.actor.setMoving(false);
      return;
    }

    self.actor.setMoving(true);
    final speed = self.model.moveSpeed * dt;
    final nx = dx / dist;
    final ny = dy / dist;

    // Off-line melee: full step to align. On-line: close remaining X gap.
    final step = (!gap.isFinite || (melee && !aligned)) ? speed : math.min(speed, math.max(0.0, gap - stopGap));
    self.actor.position.x += nx * step;
    final yScale = melee && !aligned ? 1.0 : 0.65;
    self.actor.position.y += ny * step * yScale;

    final minX = size.x * 0.06;
    final maxX = size.x * 0.94;
    final minY = battleTop + battleHeight * 0.28;
    final maxY = battleTop + battleHeight * 0.94;
    self.actor.position.x = self.actor.position.x.clamp(minX, maxX);
    self.actor.position.y = self.actor.position.y.clamp(minY, maxY);
  }

  Future<void> _performAttack(BattleUnit attacker, BattleUnit defender) async {
    if (!attacker.isAlive || !defender.isAlive || _battleOver) return;

    // Face target at swing start — damage requires still facing + same line.
    attacker.actor.setFacingRight(
      defender.actor.position.x >= attacker.actor.position.x,
    );

    // Ranged monsters (e.g. flying demon) fire their projectile on basics too.
    final rangedSkill = _rangedProjectileSkill(attacker);
    if (rangedSkill != null) {
      final vfx = skillVfxOf(rangedSkill.definition.id)!;
      if (!inAttackRange(attacker, defender)) return;
      _launchProjectileAttack(
        caster: attacker,
        primary: defender,
        skill: rangedSkill,
        vfx: vfx,
      );
      return;
    }

    await attacker.actor.playAttack();
    if (!attacker.isAlive || !defender.isAlive || _battleOver) return;

    // Must still be in range, on the same line, and facing after the swing.
    if (!inAttackRange(attacker, defender)) return;

    final atk = attacker.model.attack + (attacker.model.stats.finalOf(StatId.magicAttack) * 0.35);
    final dmg = _rollDamage(atk, defender.model.defense);
    _applyDamageWithReaction(
      defender,
      dmg,
      poiseDamage: _poiseFromDamage(dmg),
    );

    if (_isKnightAttacker(attacker)) {
      unawaited(_spawnMeleeHitVfx(defender));
    }

    _pushHud(
      status: '${attacker.model.name} → ${defender.model.name}  ${dmg.toStringAsFixed(0)}',
    );

    if (!defender.model.isAlive) {
      await _handleDeath(defender);
    }
  }

  /// First offensive projectile skill on this unit (ranged basic-attack fallback).
  SkillInstance? _rangedProjectileSkill(BattleUnit u) {
    for (final skill in u.model.skills) {
      if (skill.isPassive) continue;
      final vfx = skillVfxOf(skill.definition.id);
      if (vfx?.delivery == SkillDelivery.projectile) return skill;
    }
    return null;
  }

  /// HP always applies; hurt / stagger / CC go through [CombatantActor.applyHitReaction].
  void _applyDamageWithReaction(
    BattleUnit victim,
    double dmg, {
    required double poiseDamage,
    Vector2? launchOrigin,
    double knockBack = 0,
    double knockUp = 0,
    double skillStun = 0,
    double skillFreeze = 0,
  }) {
    victim.model.takeDamage(dmg);
    _syncUnitBars(victim);
    if (victim.actor.isMounted) {
      battleEffects.showDamage(
        amount: dmg,
        worldPosition: victim.actor.hitboxCenter.clone(),
      );
    }
    if (!victim.actor.isMounted) return;
    victim.actor.applyHitReaction(
      poiseDamage: poiseDamage,
      launchOrigin: launchOrigin,
      knockBack: knockBack,
      knockUp: knockUp,
      skillStun: skillStun,
      skillFreeze: skillFreeze,
    );
  }

  double _poiseFromDamage(double dmg, {double mult = 0.45}) => math.max(8, dmg * mult);

  bool _isKnightAttacker(BattleUnit attacker) {
    final model = attacker.model;
    return model is HeroModel && model.heroClass == HeroClass.tank;
  }

  Future<void> _spawnMeleeHitVfx(BattleUnit defender) async {
    if (!defender.actor.isMounted) return;
    battleEffects.playHitEffect(
      entry: _meleeHitEffect,
      worldPosition: defender.actor.hitboxCenter.clone(),
      displaySize: Vector2(56, 56),
    );
  }

  Future<void> _performSkill(
    BattleUnit caster,
    BattleUnit target,
    SkillInstance skill,
  ) async {
    if (!caster.isAlive || _battleOver || caster.casting) return;

    final vfx = skillVfxOf(skill.definition.id);
    if (vfx == null) {
      if (target.isAlive) await _performAttack(caster, target);
      return;
    }

    if (vfx.delivery == SkillDelivery.selfBuff || _isSelfSkill(skill)) {
      await _performSelfSkill(caster, skill);
      return;
    }

    if (vfx.delivery == SkillDelivery.channelSpin) {
      await _performSpinChannel(caster, skill, vfx);
      return;
    }

    if (!target.isAlive) return;

    if (!inAttackRange(caster, target, rangeStat: skill.definition.range)) {
      return;
    }
    if (caster.model.currentMana < skill.manaCost) return;

    caster.actor.setFacingRight(
      target.actor.position.x >= caster.actor.position.x,
    );

    caster.casting = true;
    caster.model.spendMana(skill.manaCost);
    skill.startCooldown(cooldownReduction: caster.model.cooldownReduction);
    _syncUnitBars(caster);

    // Projectile: body anim + spawn on optional release frame.
    // Melee / strike / instant: wait for swing so hit lands on contact frame.
    if (vfx.delivery == SkillDelivery.projectile) {
      _launchProjectileAttack(
        caster: caster,
        primary: target,
        skill: skill,
        vfx: vfx,
      );
      caster.casting = false;
      return;
    }

    await caster.actor.playAttack();
    if (!caster.isAlive || !target.isAlive || _battleOver) {
      caster.casting = false;
      return;
    }

    // Launch VFX without waiting — wizard can cast again immediately.
    final beams = _pickBeamTargets(
      caster,
      target,
      count: skill.definition.beamCount,
      rangeStat: skill.definition.range,
    );

    switch (vfx.delivery) {
      case SkillDelivery.projectile:
        break;
      case SkillDelivery.strikeDown:
        for (var i = 0; i < beams.length; i++) {
          unawaited(
            _spawnStrikeDownSkill(
              caster,
              beams[i],
              skill,
              vfx,
              isPrimaryBeam: i == 0,
            ),
          );
        }
      case SkillDelivery.instant:
        for (final beamTarget in beams) {
          unawaited(_applySkillDamage(caster, beamTarget, skill));
        }
      case SkillDelivery.selfBuff:
      case SkillDelivery.channelSpin:
        break;
    }
    caster.casting = false;
  }

  /// Play attack anim and spawn projectile(s) at [SkillVfxSpec.projectileSpawnFrame].
  void _launchProjectileAttack({
    required BattleUnit caster,
    required BattleUnit primary,
    required SkillInstance skill,
    required SkillVfxSpec vfx,
  }) {
    final beams = _pickBeamTargets(
      caster,
      primary,
      count: skill.definition.beamCount,
      rangeStat: skill.definition.range,
    );

    void spawnAll() {
      if (!caster.isAlive || _battleOver) return;
      for (var i = 0; i < beams.length; i++) {
        final beam = beams[i];
        if (!beam.isAlive) continue;
        unawaited(
          _spawnProjectileSkill(
            caster,
            beam,
            skill,
            vfx,
            spawnIndex: i,
            spawnTotal: beams.length,
          ),
        );
      }
    }

    final releaseFrame = vfx.projectileSpawnFrame;
    if (releaseFrame == null) {
      unawaited(caster.actor.playAttack());
      spawnAll();
      return;
    }

    var launched = false;
    unawaited(
      caster.actor.playAttack(
        onFrame: (frame) {
          if (launched || frame < releaseFrame) return;
          launched = true;
          spawnAll();
        },
      ),
    );
  }

  /// Knight Whirlwind — loop attack4 for 5s, tick AOE damage around caster.
  Future<void> _performSpinChannel(
    BattleUnit caster,
    SkillInstance skill,
    SkillVfxSpec vfx,
  ) async {
    if (!caster.isAlive || _battleOver || caster.casting) return;
    if (caster.model.currentMana < skill.manaCost) return;

    final castAnim = vfx.castAnim;
    if (castAnim == null) return;

    final duration = skill.definition.channelDuration <= 0 ? 5.0 : skill.definition.channelDuration;
    // Tick every 0.2s (~25 hits over 5s).
    const tickInterval = 0.2;
    final aoeRadius = skill.definition.aoeRadius > 0 ? skill.definition.aoeRadius : 1.6;

    caster.casting = true;
    caster.model.spendMana(skill.manaCost);
    skill.startCooldown(cooldownReduction: caster.model.cooldownReduction);
    caster.actor.setMoving(false);
    caster.actor.attackRangePx = attackReachPx(aoeRadius);
    _syncUnitBars(caster);

    _pushHud(
      status: '${caster.model.name} [${skill.definition.name}] spinning!',
    );

    final channelAnim = caster.actor.playChannel(
      castAnim,
      durationSec: duration,
    );

    var elapsed = 0.0;
    while (elapsed < duration && caster.isAlive && !_battleOver) {
      await _applySpinTick(caster, skill, vfx, aoeRadius);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      elapsed += tickInterval;
    }

    await channelAnim;
    if (caster.actor.isMounted) {
      caster.actor.attackRangePx = attackReachPx(caster.model.range);
    }
    caster.casting = false;
  }

  Future<void> _applySpinTick(
    BattleUnit caster,
    SkillInstance skill,
    SkillVfxSpec vfx,
    double aoeRadius,
  ) async {
    if (!caster.isAlive || !caster.actor.isMounted || _battleOver) return;

    final epicenter = caster.actor.hitboxCenter;
    final victims = _enemiesInCircle(caster, epicenter, aoeRadius);
    if (victims.isEmpty) return;

    final atk = skill.power + caster.model.attack * 0.35;
    final hitNames = <String>[];

    for (final victim in victims) {
      if (!victim.isAlive) continue;
      final dmg = _rollDamage(atk, victim.model.defense);
      _applyDamageWithReaction(
        victim,
        dmg,
        poiseDamage: _poiseFromDamage(dmg, mult: 0.35),
      );
      hitNames.add('${victim.model.name} ${dmg.toStringAsFixed(0)}');

      if (vfx.hitEffect != null && victim.actor.isMounted) {
        battleEffects.playHitEffect(
          entry: vfx.hitEffect!,
          worldPosition: victim.actor.hitboxCenter.clone(),
          displaySize: Vector2(vfx.splashWidth, vfx.splashHeight),
        );
      }
    }

    if (hitNames.isNotEmpty) {
      _pushHud(
        status:
            '${caster.model.name} [${skill.definition.name}] → '
            '${hitNames.join(', ')}',
      );
    }

    for (final victim in List<BattleUnit>.from(victims)) {
      if (!victim.model.isAlive) {
        await _handleDeath(victim);
      }
    }
  }

  /// Knight Guard etc. — play buff anim, spawn aura VFX, apply shield.
  Future<void> _performSelfSkill(
    BattleUnit caster,
    SkillInstance skill,
  ) async {
    if (!caster.isAlive || _battleOver || caster.casting) return;

    final vfx = skillVfxOf(skill.definition.id);
    if (vfx == null) return;
    if (caster.model.currentMana < skill.manaCost) return;

    caster.casting = true;
    caster.model.spendMana(skill.manaCost);
    skill.startCooldown(cooldownReduction: caster.model.cooldownReduction);
    _syncUnitBars(caster);

    // powerup1 for knights; falls back to attack if kit has no buff.
    if (caster.actor.hasBuffAnim) {
      await caster.actor.playBuff();
    } else {
      await caster.actor.playAttack();
    }

    if (!caster.isAlive || _battleOver) {
      caster.casting = false;
      return;
    }

    final shieldPower = caster.model.stats.finalOf(StatId.shieldPower);
    final amount = skill.power * (1 + shieldPower);
    caster.model.addShield(amount);
    _syncUnitBars(caster);

    if (caster.actor.isMounted && amount > 0) {
      battleEffects.showShield(
        amount: amount,
        worldPosition: caster.actor.hitboxCenter.clone(),
      );
    }

    await caster.actor.add(SelfBuffEffect(vfx: vfx));

    _pushHud(
      status:
          '${caster.model.name} [${skill.definition.name}] '
          '+${amount.toStringAsFixed(0)} shield',
    );
    caster.casting = false;
  }

  /// Distinct enemies in cast range for multi-beam skills (falls back to primary).
  List<BattleUnit> _pickBeamTargets(
    BattleUnit caster,
    BattleUnit primary, {
    required int count,
    required double rangeStat,
  }) {
    final n = count.clamp(1, 8);
    final reach = attackReachPx(rangeStat);
    final ranked = <({BattleUnit unit, double dist})>[];
    for (final other in units) {
      if (!other.isAlive || other.isHero == caster.isHero) continue;
      final d = engagementGap(caster, other, rangeStat);
      if (d <= reach * 1.15) {
        ranked.add((unit: other, dist: d));
      }
    }
    ranked.sort((a, b) => a.dist.compareTo(b.dist));

    final picked = <BattleUnit>[];
    for (final entry in ranked) {
      if (picked.length >= n) break;
      picked.add(entry.unit);
    }
    if (picked.isEmpty && primary.isAlive) {
      picked.add(primary);
    }
    // Not enough distinct targets — reuse existing picks for remaining beams.
    var i = 0;
    while (picked.length < n && picked.isNotEmpty) {
      picked.add(picked[i % picked.length]);
      i++;
    }
    return picked.take(n).toList();
  }

  Future<void> _spawnProjectileSkill(
    BattleUnit caster,
    BattleUnit target,
    SkillInstance skill,
    SkillVfxSpec vfx, {
    int spawnIndex = 0,
    int spawnTotal = 1,
  }) async {
    final spawn = caster.actor.projectileSpawnPoint.clone();
    // Fan multi-beams slightly so they don't stack perfectly.
    if (spawnTotal > 1) {
      final t = spawnIndex - (spawnTotal - 1) / 2;
      spawn.y += t * 14;
      spawn.x += t.abs() * 4;
    }
    final projectile = IceProjectile(
      vfx: vfx,
      spawn: spawn,
      target: target.actor,
      onImpact: () {
        if (_battleOver) return;
        unawaited(_applySkillDamage(caster, target, skill));
      },
    );
    await add(projectile);
  }

  Future<void> _spawnStrikeDownSkill(
    BattleUnit caster,
    BattleUnit target,
    SkillInstance skill,
    SkillVfxSpec vfx, {
    bool isPrimaryBeam = true,
  }) async {
    final effect = ThunderStrikeEffect(
      vfx: vfx,
      target: target.actor,
      onImpact: () {
        if (_battleOver) return;
        // AOE damage resolves once from the primary beam epicenter.
        if (skill.definition.isAoe && !isPrimaryBeam) return;
        unawaited(_applySkillDamage(caster, target, skill));
      },
    );
    await add(effect);

    // Extra decorative pillars inside the AOE circle (spectacle only).
    if (isPrimaryBeam && skill.definition.isAoe && skill.definition.resolvedAoeParticles > 1) {
      _spawnAoeParticles(skill, vfx, target.actor.absolutePosition.clone());
    }
  }

  void _spawnAoeParticles(
    SkillInstance skill,
    SkillVfxSpec vfx,
    Vector2 epicenterFeet,
  ) {
    final count = skill.definition.resolvedAoeParticles;
    final radiusPx = attackReachPx(skill.definition.aoeRadius);
    final offsets = aoeParticleOffsets(
      count: count,
      radiusPx: radiusPx,
      rng: _rng,
    );
    // Skip index 0 — main strike already plays on the primary target.
    for (var i = 1; i < offsets.length; i++) {
      final pos = epicenterFeet + offsets[i];
      add(
        WorldBurstEffect(
          vfx: vfx,
          worldPosition: pos,
          sizeScale: 0.55 + _rng.nextDouble() * 0.25,
          startDelay: 0.04 * i + _rng.nextDouble() * 0.08,
          drawPriority: 510 + i,
        ),
      );
    }
  }

  Future<void> _applySkillDamage(
    BattleUnit caster,
    BattleUnit primary,
    SkillInstance skill,
  ) async {
    if (_battleOver) return;

    final epicenter = primary.actor.isMounted ? primary.actor.hitboxCenter : primary.actor.position.clone();

    final victims = skill.definition.isAoe && skill.definition.aoeRadius > 0
        ? _enemiesInCircle(caster, epicenter, skill.definition.aoeRadius)
        : [
            if (primary.isAlive) primary,
          ];

    if (victims.isEmpty) return;

    final magic = caster.model.stats.finalOf(StatId.magicAttack);
    final power = skill.power + magic * 0.55;
    final hitNames = <String>[];

    for (final victim in victims) {
      if (!victim.isAlive) continue;
      final dmg = _rollDamage(power, victim.model.defense);
      final launchOrigin = skill.definition.hasLaunch ? (skill.definition.isAoe ? epicenter : (caster.actor.isMounted ? caster.actor.hitboxCenter : caster.actor.position.clone())) : null;
      _applyDamageWithReaction(
        victim,
        dmg,
        poiseDamage: _poiseFromDamage(
          dmg,
          mult: skill.definition.hasLaunch || skill.definition.hasStun ? 0.7 : 0.5,
        ),
        launchOrigin: launchOrigin,
        knockBack: skill.definition.knockBack,
        knockUp: skill.definition.knockUp,
        skillStun: skill.definition.stunDuration,
        skillFreeze: skill.definition.freezeDuration,
      );
      final ccMark = skill.definition.hasFreeze
          ? ' ❄'
          : skill.definition.hasStun
          ? ' ⚡'
          : '';
      hitNames.add(
        '${victim.model.name} ${dmg.toStringAsFixed(0)}$ccMark',
      );
    }

    final aoeTag = skill.definition.aoeRadius > 0 ? ' AOE×${victims.length}' : '';
    _pushHud(
      status:
          '${caster.model.name} [${skill.definition.name}]$aoeTag → '
          '${hitNames.join(', ')}',
    );

    for (final victim in List<BattleUnit>.from(victims)) {
      if (!victim.model.isAlive) {
        await _handleDeath(victim);
      }
    }
  }

  /// Enemies whose hitbox center lies inside a circle around [center].
  List<BattleUnit> _enemiesInCircle(
    BattleUnit caster,
    Vector2 center,
    double radiusStat,
  ) {
    final radiusPx = attackReachPx(radiusStat);
    final radiusSq = radiusPx * radiusPx;
    final hits = <BattleUnit>[];
    for (final other in units) {
      if (!other.isAlive || other.isHero == caster.isHero) continue;
      if (!other.actor.isMounted) continue;
      final c = other.actor.hitboxCenter;
      final dx = c.x - center.x;
      final dy = c.y - center.y;
      if (dx * dx + dy * dy <= radiusSq) {
        hits.add(other);
      }
    }
    return hits;
  }

  Future<void> _handleDeath(BattleUnit unit) async {
    if (unit.removing) return;
    unit.removing = true;
    unit.actor.setMoving(false);
    if (!unit.isHero && unit.model is MonsterModel) {
      _killedThisFloor.add(unit.model as MonsterModel);
    }
    await unit.actor.playDead();
    _pushHud(status: '${unit.model.name} fell');
    _checkBattleEnd();
    // Corpse stays briefly, then clears so the field stays readable.
    unawaited(_removeCorpseAfterDelay(unit));
  }

  static const Duration corpseLinger = Duration(seconds: 5);

  Future<void> _removeCorpseAfterDelay(BattleUnit unit) async {
    await Future<void>.delayed(corpseLinger);
    if (!unit.actor.isMounted) return;
    // Living heroes / active units may have been cleaned already.
    if (units.contains(unit) && unit.isAlive) return;
    unit.actor.removeFromParent();
  }

  void _checkBattleEnd() {
    if (_battleOver) return;
    final heroesAlive = units.where((u) => u.isHero && u.isAlive).length;
    final monstersAlive = units.where((u) => !u.isHero && u.isAlive).length;
    if (heroesAlive == 0 || monstersAlive == 0) {
      _battleOver = true;
      for (final u in units) {
        u.actor.setMoving(false);
      }
      final won = monstersAlive == 0 && heroesAlive > 0;
      if (won) {
        dungeon.onBattleVictory(
          heroes: _livingHeroModels(),
          killedMonsters: List<MonsterModel>.of(_killedThisFloor),
        );
        _pushHud(status: 'Floor cleared — pick an upgrade');
      } else {
        dungeon.onBattleDefeat();
        _pushHud(status: 'Defeat…');
      }
    }
  }

  double _rollDamage(double attack, double defense) {
    final mitigated = attack * (100 / (100 + defense.clamp(0, 500)));
    final variance = 0.9 + _rng.nextDouble() * 0.2;
    return (mitigated * variance).clamp(1, 99999);
  }

  void _syncUnitBars(BattleUnit unit) {
    if (!unit.actor.isLoaded) return;
    unit.actor.updateBars(
      hp: unit.model.currentHp,
      maxHp: unit.model.maxHp,
      shield: unit.model.currentShield,
      mana: unit.model.currentMana,
      maxMana: unit.model.maxMana,
    );
  }

  void _pushHud({String? status}) {
    final heroes = units.where((u) => u.isHero);
    final monsters = units.where((u) => !u.isHero);
    hud.value = CombatHudState(
      heroesAlive: heroes.where((u) => u.isAlive).length,
      heroesTotal: heroes.length,
      monstersAlive: monsters.where((u) => u.isAlive).length,
      monstersTotal: monsters.length,
      currentFloor: dungeon.floor,
      phase: switch (dungeon.phase) {
        DungeonPhase.battling => CombatHudPhase.battling,
        DungeonPhase.choosing => CombatHudPhase.choosing,
        DungeonPhase.defeat => CombatHudPhase.defeat,
      },
      pendingChoices: dungeon.pendingChoices
          .map(
            (c) => FloorChoiceHud(
              id: c.id,
              title: c.title,
              description: c.description,
              rarity: c.rarity.name,
              rarityLabel: c.rarity.label,
              accentArgb: c.rarity.accentArgb,
              fillArgb: c.rarity.fillArgb,
              iconAsset: c.iconAsset,
            ),
          )
          .toList(),
      statusMessage: status ?? hud.value.statusMessage,
    );
  }

  /// Alias kept for older callers / hot-reload.
  Future<void> restart() => retryRun();

  void setDebugFlags(CombatDebugFlags flags) {
    debugFlags.value = flags;
  }

  void toggleDebugAction() => debugFlags.value = debugFlags.value.copyWith(action: !debugFlags.value.action);

  void toggleDebugHitbox() => debugFlags.value = debugFlags.value.copyWith(hitbox: !debugFlags.value.hitbox);

  void toggleDebugCollision() => debugFlags.value = debugFlags.value.copyWith(
    collision: !debugFlags.value.collision,
  );

  /// Master switch — on if any overlay is off; off if all are on.
  void toggleAllDebug() {
    final f = debugFlags.value;
    debugFlags.value = f.anyOn ? CombatDebugFlags.allOff : CombatDebugFlags.allOn;
  }
}

@immutable
class CombatDebugFlags {
  const CombatDebugFlags({
    this.action = false,
    this.hitbox = false,
    this.collision = false,
  });

  final bool action;
  final bool hitbox;
  final bool collision;

  static const allOn = CombatDebugFlags(
    action: true,
    hitbox: true,
    collision: true,
  );

  static const allOff = CombatDebugFlags();

  bool get anyOn => action || hitbox || collision;
  bool get allEnabled => action && hitbox && collision;

  CombatDebugFlags copyWith({
    bool? action,
    bool? hitbox,
    bool? collision,
  }) {
    return CombatDebugFlags(
      action: action ?? this.action,
      hitbox: hitbox ?? this.hitbox,
      collision: collision ?? this.collision,
    );
  }
}
