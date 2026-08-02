import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/game/ice_skill_demo_game.dart';

class IceSkillDemoPage extends StatefulWidget {
  const IceSkillDemoPage({super.key});

  @override
  State<IceSkillDemoPage> createState() => _IceSkillDemoPageState();
}

class _IceSkillDemoPageState extends State<IceSkillDemoPage> {
  late final IceSkillDemoGame _game;
  String _phase = 'Loading…';

  @override
  void initState() {
    super.initState();
    _game = IceSkillDemoGame(
      onPhaseChanged: (phase) {
        if (mounted) setState(() => _phase = phase);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Ice → knight: hurt → dying → powerup+buff3  ·  Buff: wizard aura',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _phase,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GameWidget(game: _game),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _game.castSkill(),
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Cast ice'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _game.castBuff(),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Buff'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _game.reset(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
