// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkillNode _$SkillNodeFromJson(Map<String, dynamic> json) => _SkillNode(
  id: $enumDecode(_$UpgradeEnumMap, json['id']),
  position: _vector2FromJson(json['position'] as Map<String, dynamic>),
  state:
      $enumDecodeNullable(_$NodeStateEnumMap, json['state']) ??
      NodeState.disabled,
  activationLevel:
      $enumDecodeNullable(_$ActivationLevelEnumMap, json['activationLevel']) ??
      ActivationLevel.hidden,
  connectedNodeIds:
      (json['connectedNodeIds'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UpgradeEnumMap, e))
          .toList() ??
      const [],
  currentLevel: (json['currentLevel'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SkillNodeToJson(_SkillNode instance) =>
    <String, dynamic>{
      'id': _$UpgradeEnumMap[instance.id]!,
      'position': _vector2ToJson(instance.position),
      'state': _$NodeStateEnumMap[instance.state]!,
      'activationLevel': _$ActivationLevelEnumMap[instance.activationLevel]!,
      'connectedNodeIds': instance.connectedNodeIds
          .map((e) => _$UpgradeEnumMap[e]!)
          .toList(),
      'currentLevel': instance.currentLevel,
    };

const _$UpgradeEnumMap = {
  Upgrade.arrow_tower_unlock: 'arrow_tower_unlock',
  Upgrade.slow_tower_unlock: 'slow_tower_unlock',
  Upgrade.starting_gems: 'starting_gems',
  Upgrade.starting_gems_2: 'starting_gems_2',
  Upgrade.arrow_tower_damage: 'arrow_tower_damage',
  Upgrade.arrow_tower_fire_rate: 'arrow_tower_fire_rate',
  Upgrade.arrow_tower_fire_rate_2: 'arrow_tower_fire_rate_2',
  Upgrade.arrow_tower_fire_rate_3: 'arrow_tower_fire_rate_3',
  Upgrade.arrow_tower_crit_chance: 'arrow_tower_crit_chance',
  Upgrade.arrow_tower_crit_damage: 'arrow_tower_crit_damage',
  Upgrade.arrow_tower_multicrit: 'arrow_tower_multicrit',
  Upgrade.arrow_tower_multicrit_2: 'arrow_tower_multicrit_2',
  Upgrade.arrow_tower_multicrit_combustion: 'arrow_tower_multicrit_combustion',
  Upgrade.arrow_tower_build_cost_damage_multiplier:
      'arrow_tower_build_cost_damage_multiplier',
  Upgrade.arrow_tower_upgrade_cost_damage_multiplier:
      'arrow_tower_upgrade_cost_damage_multiplier',
  Upgrade.arrow_tower_poison: 'arrow_tower_poison',
  Upgrade.arrow_tower_more_poison: 'arrow_tower_more_poison',
  Upgrade.arrow_tower_poison_on_shields: 'arrow_tower_poison_on_shields',
  Upgrade.arrow_tower_poison_pool: 'arrow_tower_poison_pool',
  Upgrade.arrow_tower_fire_rate_increase_damage_decrease:
      'arrow_tower_fire_rate_increase_damage_decrease',
  Upgrade.arrow_tower_leveling_fire_rate_2: 'arrow_tower_leveling_fire_rate_2',
  Upgrade.arrow_tower_crit_poison: 'arrow_tower_crit_poison',
  Upgrade.arrow_tower_poison_vulnerable: 'arrow_tower_poison_vulnerable',
  Upgrade.arrow_tower_poison_charge_add_stacks:
      'arrow_tower_poison_charge_add_stacks',
  Upgrade.arrow_tower_heavy: 'arrow_tower_heavy',
  Upgrade.arrow_tower_range: 'arrow_tower_range',
  Upgrade.arrow_tower_crit_chance_2: 'arrow_tower_crit_chance_2',
  Upgrade.arrow_tower_crit_damage_2: 'arrow_tower_crit_damage_2',
  Upgrade.arrow_tower_multicrit_leveled: 'arrow_tower_multicrit_leveled',
  Upgrade.arrow_tower_damage_at_range: 'arrow_tower_damage_at_range',
  Upgrade.arrow_tower_unharmed_crit_chance: 'arrow_tower_unharmed_crit_chance',
  Upgrade.arrow_tower_damage_2: 'arrow_tower_damage_2',
  Upgrade.arrow_tower_damage_3: 'arrow_tower_damage_3',
  Upgrade.arrow_tower_pierce_shield: 'arrow_tower_pierce_shield',
  Upgrade.arrow_tower_disable: 'arrow_tower_disable',
  Upgrade.status_effect_count_increase_damage:
      'status_effect_count_increase_damage',
  Upgrade.status_effect_count_increase_damage_extra:
      'status_effect_count_increase_damage_extra',
  Upgrade.tower_upgrade_unlock: 'tower_upgrade_unlock',
  Upgrade.tower_demolish_unlock: 'tower_demolish_unlock',
  Upgrade.gem_convert: 'gem_convert',
  Upgrade.gem_drops: 'gem_drops',
  Upgrade.basic_token_drops: 'basic_token_drops',
  Upgrade.gem_cannon: 'gem_cannon',
  Upgrade.early_spawn: 'early_spawn',
  Upgrade.auto_start_wave: 'auto_start_wave',
  Upgrade.arrow_tower_multishot: 'arrow_tower_multishot',
  Upgrade.arrow_tower_multishot_increased_damage:
      'arrow_tower_multishot_increased_damage',
  Upgrade.arrow_tower_multishot_triple_when_leveled:
      'arrow_tower_multishot_triple_when_leveled',
  Upgrade.targetting: 'targetting',
  Upgrade.gem_shot: 'gem_shot',
  Upgrade.early_spawn_gem_bonus: 'early_spawn_gem_bonus',
  Upgrade.early_spawn_charge: 'early_spawn_charge',
  Upgrade.early_spawn_charge_extra: 'early_spawn_charge_extra',
  Upgrade.accelerated_enemy_basic_token_bonus:
      'accelerated_enemy_basic_token_bonus',
  Upgrade.time_challenge_unlock: 'time_challenge_unlock',
  Upgrade.slow_tower_damage_link: 'slow_tower_damage_link',
  Upgrade.slow_tower_damage_link_increase: 'slow_tower_damage_link_increase',
  Upgrade.slow_tower_damage_link_share_sources:
      'slow_tower_damage_link_share_sources',
  Upgrade.targetting_auto: 'targetting_auto',
  Upgrade.vulnerable_damage_multiplier: 'vulnerable_damage_multiplier',
  Upgrade.slow_amount: 'slow_amount',
  Upgrade.slow_vulnerable: 'slow_vulnerable',
  Upgrade.slow_tower_fire_rate: 'slow_tower_fire_rate',
  Upgrade.slow_duration: 'slow_duration',
  Upgrade.slow_duration_2: 'slow_duration_2',
  Upgrade.slow_tower_charge_buff: 'slow_tower_charge_buff',
  Upgrade.slow_damage_bonus: 'slow_damage_bonus',
  Upgrade.charge_amount: 'charge_amount',
  Upgrade.charge_amount_2: 'charge_amount_2',
  Upgrade.charge_damage_bonus: 'charge_damage_bonus',
  Upgrade.charge_damage_stacking: 'charge_damage_stacking',
  Upgrade.slow_zone: 'slow_zone',
  Upgrade.explosive_grunts_chance: 'explosive_grunts_chance',
  Upgrade.explosive_runners_chance: 'explosive_runners_chance',
  Upgrade.explosive_damage: 'explosive_damage',
  Upgrade.explosive_damage_2: 'explosive_damage_2',
  Upgrade.explosive_grunts: 'explosive_grunts',
  Upgrade.explosive_bosses: 'explosive_bosses',
  Upgrade.explosive_bosses_2: 'explosive_bosses_2',
  Upgrade.explosive_elites: 'explosive_elites',
  Upgrade.explosive_elites_2: 'explosive_elites_2',
  Upgrade.explosion_range_increase: 'explosion_range_increase',
  Upgrade.explosion_tower_charge: 'explosion_tower_charge',
  Upgrade.explosion_tower_charge_extra: 'explosion_tower_charge_extra',
  Upgrade.explosion_chance_to_create_pool: 'explosion_chance_to_create_pool',
  Upgrade.explosion_fireball: 'explosion_fireball',
  Upgrade.explosion_fireball_chance: 'explosion_fireball_chance',
  Upgrade.explosion_fireball_burn_damage: 'explosion_fireball_burn_damage',
  Upgrade.explosion_fireball_explosion_damage:
      'explosion_fireball_explosion_damage',
  Upgrade.explosion_fireball_double_chance: 'explosion_fireball_double_chance',
  Upgrade.tower_upgrade_auto: 'tower_upgrade_auto',
  Upgrade.gem_cannon_damage: 'gem_cannon_damage',
  Upgrade.gem_cannon_damage_extra: 'gem_cannon_damage_extra',
  Upgrade.gem_cannon_fire_rate: 'gem_cannon_fire_rate',
  Upgrade.gem_cannon_shot_reimbursement_chance:
      'gem_cannon_shot_reimbursement_chance',
  Upgrade.gem_cannon_crit_chance: 'gem_cannon_crit_chance',
  Upgrade.auto_collect_gems: 'auto_collect_gems',
  Upgrade.gem_cannon_damage_expensive: 'gem_cannon_damage_expensive',
  Upgrade.gem_cannon_damage_expensive_extra:
      'gem_cannon_damage_expensive_extra',
  Upgrade.gem_cannon_auto_shoot: 'gem_cannon_auto_shoot',
  Upgrade.demolish_unrestricted: 'demolish_unrestricted',
  Upgrade.demolish_refund_amount: 'demolish_refund_amount',
  Upgrade.demolish_refund_amount_2: 'demolish_refund_amount_2',
  Upgrade.demolish_explosion: 'demolish_explosion',
  Upgrade.core_health: 'core_health',
  Upgrade.core_health_2: 'core_health_2',
  Upgrade.core_health_3: 'core_health_3',
  Upgrade.core_lost_health_increase_damage: 'core_lost_health_increase_damage',
  Upgrade.core_burn_pulse: 'core_burn_pulse',
  Upgrade.core_burn_pulse_damage: 'core_burn_pulse_damage',
  Upgrade.core_burn_pulse_range: 'core_burn_pulse_range',
  Upgrade.core_burn_combust: 'core_burn_combust',
  Upgrade.core_killed_enemy_reward: 'core_killed_enemy_reward',
  Upgrade.core_killed_enemy_reward_coins: 'core_killed_enemy_reward_coins',
  Upgrade.core_apply_wave_burn: 'core_apply_wave_burn',
  Upgrade.core_charge: 'core_charge',
  Upgrade.core_charge_extra: 'core_charge_extra',
  Upgrade.core_heal: 'core_heal',
  Upgrade.core_heal_extra: 'core_heal_extra',
  Upgrade.burn_damage: 'burn_damage',
  Upgrade.burn_damage_fire_tower: 'burn_damage_fire_tower',
  Upgrade.burn_damage_extra: 'burn_damage_extra',
  Upgrade.burn_damage_extra_for_reduced_tick_rate:
      'burn_damage_extra_for_reduced_tick_rate',
  Upgrade.burn_ticks: 'burn_ticks',
  Upgrade.burn_ticks_extra: 'burn_ticks_extra',
  Upgrade.burn_crit: 'burn_crit',
  Upgrade.burn_stacking_damage: 'burn_stacking_damage',
  Upgrade.burn_spreading: 'burn_spreading',
  Upgrade.burn_spread_chance: 'burn_spread_chance',
  Upgrade.burn_spread_to_burning: 'burn_spread_to_burning',
  Upgrade.burn_concentration: 'burn_concentration',
  Upgrade.fire_tower_unlock: 'fire_tower_unlock',
  Upgrade.burn_crit_add_tick: 'burn_crit_add_tick',
  Upgrade.burn_tick_rate: 'burn_tick_rate',
  Upgrade.burn_tick_crit_chance: 'burn_tick_crit_chance',
  Upgrade.burn_pool_apply_burn: 'burn_pool_apply_burn',
  Upgrade.burn_pool_apply_burn_extra: 'burn_pool_apply_burn_extra',
  Upgrade.burn_tick_rate_accelerated_enemies:
      'burn_tick_rate_accelerated_enemies',
  Upgrade.burn_tick_rate_accelerated_enemies_extra:
      'burn_tick_rate_accelerated_enemies_extra',
  Upgrade.lightning_tower_unlock: 'lightning_tower_unlock',
  Upgrade.lightning_tower_spread_status: 'lightning_tower_spread_status',
  Upgrade.lightning_tower_jumps: 'lightning_tower_jumps',
  Upgrade.lightning_tower_extra_jumps: 'lightning_tower_extra_jumps',
  Upgrade.lightning_tower_damage: 'lightning_tower_damage',
  Upgrade.lightning_tower_damage_extra: 'lightning_tower_damage_extra',
  Upgrade.lightning_tower_speed: 'lightning_tower_speed',
  Upgrade.lightning_tower_extra_speed: 'lightning_tower_extra_speed',
  Upgrade.lightning_tower_crit_chance: 'lightning_tower_crit_chance',
  Upgrade.lightning_tower_crit_charge: 'lightning_tower_crit_charge',
  Upgrade.lightning_tower_charge_extra_jumps:
      'lightning_tower_charge_extra_jumps',
  Upgrade.lightning_tower_overkill_damage: 'lightning_tower_overkill_damage',
  Upgrade.lightning_tower_overkill_damage_extra:
      'lightning_tower_overkill_damage_extra',
  Upgrade.lightning_tower_overkill_retrigger_chance:
      'lightning_tower_overkill_retrigger_chance',
  Upgrade.lightning_tower_jump_damage_reduction:
      'lightning_tower_jump_damage_reduction',
  Upgrade.lightning_tower_chance_to_jump_again:
      'lightning_tower_chance_to_jump_again',
  Upgrade.lightning_tower_chance_to_jump_again_extra:
      'lightning_tower_chance_to_jump_again_extra',
  Upgrade.lightning_tower_apply_shock: 'lightning_tower_apply_shock',
  Upgrade.lightning_tower_shock_stun_duration:
      'lightning_tower_shock_stun_duration',
  Upgrade.lightning_tower_shock_stun_duration_extra:
      'lightning_tower_shock_stun_duration_extra',
  Upgrade.lightning_tower_stun_increase_damage:
      'lightning_tower_stun_increase_damage',
  Upgrade.lightning_tower_stun_increase_damage_extra:
      'lightning_tower_stun_increase_damage_extra',
  Upgrade.lightning_tower_discharge_combust:
      'lightning_tower_discharge_combust',
  Upgrade.lightning_tower_jump_range: 'lightning_tower_jump_range',
  Upgrade.level_challenge_unlock: 'level_challenge_unlock',
  Upgrade.increased_vulnerable_damage_undamaged_enemies:
      'increased_vulnerable_damage_undamaged_enemies',
  Upgrade.boss_defeat_partial_token: 'boss_defeat_partial_token',
  Upgrade.boss_damage_taken_basic_token_increase:
      'boss_damage_taken_basic_token_increase',
  Upgrade.economy_damage_increase_by_coins: 'economy_damage_increase_by_coins',
  Upgrade.economy_gem_interest: 'economy_gem_interest',
  Upgrade.economy_enemy_defeat_upgrade_discount:
      'economy_enemy_defeat_upgrade_discount',
  Upgrade.economy_uncapped_levels: 'economy_uncapped_levels',
  Upgrade.bank_tower_unlock: 'bank_tower_unlock',
  Upgrade.bank_tower_chance_to_spawn_coin: 'bank_tower_chance_to_spawn_coin',
  Upgrade.bank_tower_number_coins: 'bank_tower_number_coins',
  Upgrade.bank_tower_add_vulnerable: 'bank_tower_add_vulnerable',
  Upgrade.bank_tower_vulnerable_duration: 'bank_tower_vulnerable_duration',
  Upgrade.bank_tower_pool: 'bank_tower_pool',
  Upgrade.bank_tower_tokens: 'bank_tower_tokens',
  Upgrade.bank_tower_basic_tokens_multiplier:
      'bank_tower_basic_tokens_multiplier',
  Upgrade.bank_tower_damage: 'bank_tower_damage',
  Upgrade.bank_tower_damage_extra: 'bank_tower_damage_extra',
  Upgrade.bank_tower_accelerated_enemies: 'bank_tower_accelerated_enemies',
  Upgrade.artifacts_unlock: 'artifacts_unlock',
  Upgrade.fire_artifact_unlock: 'fire_artifact_unlock',
  Upgrade.light_artifact_unlock: 'light_artifact_unlock',
  Upgrade.earth_artifact_unlock: 'earth_artifact_unlock',
  Upgrade.wind_artifact_unlock: 'wind_artifact_unlock',
  Upgrade.ice_artifact_unlock: 'ice_artifact_unlock',
  Upgrade.fire_artifact_2_unlock: 'fire_artifact_2_unlock',
  Upgrade.light_artifact_2_unlock: 'light_artifact_2_unlock',
  Upgrade.earth_artifact_2_unlock: 'earth_artifact_2_unlock',
  Upgrade.wind_artifact_2_unlock: 'wind_artifact_2_unlock',
  Upgrade.ice_artifact_2_unlock: 'ice_artifact_2_unlock',
  Upgrade.build_presets_unlock: 'build_presets_unlock',
};

const _$NodeStateEnumMap = {
  NodeState.disabled: 'disabled',
  NodeState.enabled: 'enabled',
  NodeState.active: 'active',
  NodeState.upgraded: 'upgraded',
};

const _$ActivationLevelEnumMap = {
  ActivationLevel.hidden: 'hidden',
  ActivationLevel.discovered: 'discovered',
  ActivationLevel.revealed: 'revealed',
  ActivationLevel.available: 'available',
  ActivationLevel.leveled: 'leveled',
  ActivationLevel.maxed: 'maxed',
};
