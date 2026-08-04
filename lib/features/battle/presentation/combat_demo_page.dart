import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_skill_game/game/combat_demo_game.dart';
import 'package:infinity_skill_game/features/battle/presentation/combat_hud_state.dart';

/// Fullscreen dungeon run — floor loop, choices, floating back only.
class CombatDemoPage extends StatefulWidget {
  const CombatDemoPage({super.key});

  @override
  State<CombatDemoPage> createState() => _CombatDemoPageState();
}

class _CombatDemoPageState extends State<CombatDemoPage> {
  late final ValueNotifier<CombatHudState> _hud;
  late final CombatDemoGame _game;

  @override
  void initState() {
    super.initState();
    _hud = ValueNotifier(CombatHudState.empty);
    _game = CombatDemoGame(hud: _hud);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _game.pauseEngine();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _game.debugFlags.dispose();
    _hud.dispose();
    super.dispose();
  }

  void _goBack() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12100E),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(game: _game),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: _FloatBackButton(onPressed: _goBack),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: ValueListenableBuilder<CombatHudState>(
                    valueListenable: _hud,
                    builder: (_, state, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _FloorChip(floor: state.currentFloor),
                        const SizedBox(height: 6),
                        _ScoreChip(state: state),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _DebugFab(game: _game),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 16,
                  child: ValueListenableBuilder<CombatHudState>(
                    valueListenable: _hud,
                    builder: (_, state, _) {
                      if (state.statusMessage.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Text(
                              state.statusMessage,
                              style: const TextStyle(
                                color: Color(0xFFE8F0E9),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder<CombatHudState>(
                  valueListenable: _hud,
                  builder: (_, state, _) {
                    if (state.isChoosing) {
                      return _FloorChoiceOverlay(
                        floor: state.currentFloor,
                        choices: state.pendingChoices,
                        onPick: _game.pickFloorChoice,
                      );
                    }
                    if (state.isDefeat) {
                      return _BattleOverOverlay(
                        onRetry: () => _game.retryRun(),
                        onExit: _goBack,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatBackButton extends StatelessWidget {
  const _FloatBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        tooltip: 'Back',
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
      ),
    );
  }
}

/// Center-right floating debug control: master toggle + action/hitbox/collision.
class _DebugFab extends StatelessWidget {
  const _DebugFab({required this.game});

  final CombatDemoGame game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CombatDebugFlags>(
      valueListenable: game.debugFlags,
      builder: (_, flags, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _DebugToggleChip(
              label: 'Action',
              tooltip: 'Attack range rings',
              icon: Icons.radar,
              activeColor: const Color(0xFFFFEB3B),
              on: flags.action,
              onPressed: game.toggleDebugAction,
            ),
            const SizedBox(height: 6),
            _DebugToggleChip(
              label: 'Hitbox',
              tooltip: 'Body hitboxes',
              icon: Icons.crop_square,
              activeColor: const Color(0xFF69F0AE),
              on: flags.hitbox,
              onPressed: game.toggleDebugHitbox,
            ),
            const SizedBox(height: 6),
            _DebugToggleChip(
              label: 'Collision',
              tooltip: 'Sprite bounds',
              icon: Icons.fullscreen,
              activeColor: const Color(0xFF80D8FF),
              on: flags.collision,
              onPressed: game.toggleDebugCollision,
            ),
            const SizedBox(height: 8),
            Material(
              color: Colors.black.withValues(alpha: 0.55),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              child: IconButton(
                tooltip: flags.anyOn ? 'Disable all debug' : 'Enable all debug',
                onPressed: game.toggleAllDebug,
                icon: Icon(
                  flags.anyOn ? Icons.bug_report : Icons.bug_report_outlined,
                  color: flags.allEnabled
                      ? const Color(0xFF69F0AE)
                      : flags.anyOn
                      ? const Color(0xFFFFEB3B)
                      : Colors.white70,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DebugToggleChip extends StatelessWidget {
  const _DebugToggleChip({
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.activeColor,
    required this.on,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final IconData icon;
  final Color activeColor;
  final bool on;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: on ? activeColor : Colors.white54,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: on ? activeColor : Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloorChip extends StatelessWidget {
  const _FloorChip({required this.floor});

  final int floor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3D7A4A)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          'Floor $floor',
          style: const TextStyle(
            color: Color(0xFF8FBC8F),
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.state});

  final CombatHudState state;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          'Heroes ${state.heroesAlive}/${state.heroesTotal}'
          '   ·   '
          'Monsters ${state.monstersAlive}/${state.monstersTotal}',
          style: const TextStyle(
            color: Color(0xFFE8F0E9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FloorChoiceOverlay extends StatelessWidget {
  const _FloorChoiceOverlay({
    required this.floor,
    required this.choices,
    required this.onPick,
  });

  final int floor;
  final List<FloorChoiceHud> choices;
  final void Function(String choiceId) onPick;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.55),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Floor $floor Cleared',
                style: const TextStyle(
                  color: Color(0xFF8FBC8F),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pick one — rarer rolls hit harder',
                style: TextStyle(
                  color: Color(0xFFC5D4C8),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 168,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final row = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < choices.length; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          _ChoiceCard(
                            choice: choices[i],
                            onTap: () => onPick(choices[i].id),
                          ),
                        ],
                      ],
                    );
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: math.max(0, constraints.maxWidth - 40),
                        ),
                        child: Center(child: row),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({required this.choice, required this.onTap});

  final FloorChoiceHud choice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(choice.accentArgb);
    final fill = Color(choice.fillArgb);

    final iconAsset = choice.iconAsset;

    return SizedBox(
      width: 148,
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accent, width: 1.6),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.22),
                  blurRadius: 10,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.55),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        child: Text(
                          choice.rarityLabel.toUpperCase(),
                          style: TextStyle(
                            color: accent,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.auto_awesome, size: 14, color: accent),
                  ],
                ),
                const SizedBox(height: 10),
                if (iconAsset != null)
                  Center(
                    child: Image.asset(
                      iconAsset,
                      width: 44,
                      height: 44,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.auto_awesome,
                        size: 36,
                        color: accent,
                      ),
                    ),
                  )
                else
                  Center(
                    child: Icon(Icons.auto_awesome, size: 36, color: accent),
                  ),
                const Spacer(),
                Text(
                  choice.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BattleOverOverlay extends StatelessWidget {
  const _BattleOverOverlay({
    required this.onRetry,
    required this.onExit,
  });

  final VoidCallback onRetry;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF13261C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3D7A4A)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Defeat',
                  style: TextStyle(
                    color: Color(0xFFE07070),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3D7A4A),
                  ),
                  child: const Text('Retry from Floor 1'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onExit,
                  child: const Text('Back to menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
