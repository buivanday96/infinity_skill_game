import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/ui/aseprite_animation.dart';

class AnimationChainPage extends StatefulWidget {
  const AnimationChainPage({super.key, required this.entries});

  final List<AsepriteEntry> entries;

  @override
  State<AnimationChainPage> createState() => _AnimationChainPageState();
}

class _AnimationChainPageState extends State<AnimationChainPage> {
  late final Images _images;
  int _stepIndex = 0;
  int _playKey = 0;
  bool _completed = false;
  Future<SpriteAnimation>? _animFuture;

  @override
  void initState() {
    super.initState();
    _images = Images()..prefix = 'assets/';
    _prepareCurrent();
  }

  @override
  void dispose() {
    _images.clearCache();
    super.dispose();
  }

  AsepriteEntry get _current => widget.entries[_stepIndex];

  void _prepareCurrent() {
    _animFuture = loadAsepriteAnimation(
      entry: _current,
      images: _images,
      loop: false,
    ).then((r) => r.animation);
  }

  void _replayChain() {
    setState(() {
      _stepIndex = 0;
      _playKey++;
      _completed = false;
      _prepareCurrent();
    });
  }

  void _onStepComplete() {
    if (!mounted || _completed) return;

    if (_stepIndex >= widget.entries.length - 1) {
      setState(() => _completed = true);
      return;
    }

    setState(() {
      _stepIndex++;
      _playKey++;
      _prepareCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chainLabel = widget.entries.map((e) => e.name).join(' → ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Chain'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              chainLabel,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < widget.entries.length; i++)
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: i == _stepIndex ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                      foregroundColor: i == _stepIndex ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                      child: Text('${i + 1}'),
                    ),
                    label: Text(widget.entries[i].name),
                    side: BorderSide(
                      color: i == _stepIndex ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: FutureBuilder<SpriteAnimation>(
                    key: ValueKey('$_playKey:$_stepIndex'),
                    future: _animFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Icon(
                          Icons.broken_image_outlined,
                          color: theme.colorScheme.error,
                          size: 48,
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }

                      final animation = snapshot.data!;
                      return SpriteAnimationWidget(
                        animation: animation,
                        animationTicker: animation.createTicker(),
                        anchor: Anchor.center,
                        playing: !_completed,
                        onComplete: _onStepComplete,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              _completed ? 'Chain complete' : 'Playing: ${_current.name} (${_stepIndex + 1}/${widget.entries.length})',
              style: theme.textTheme.titleMedium,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: FilledButton.icon(
                onPressed: _replayChain,
                icon: const Icon(Icons.replay),
                label: const Text('Replay chain'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
