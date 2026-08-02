import 'dart:developer';

import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/ui/animation_chain_page.dart';
import 'package:infinity_skill_game/ui/aseprite_animation.dart';

class EffectsGalleryPage extends StatefulWidget {
  const EffectsGalleryPage({super.key});

  @override
  State<EffectsGalleryPage> createState() => _EffectsGalleryPageState();
}

class _EffectsGalleryPageState extends State<EffectsGalleryPage> {
  late final Images _images;
  String _filter = 'all';
  List<AsepriteEntry> filteredEntries = [];
  final List<AsepriteEntry> _selected = [];

  static const _categories = [
    'all',
    'fire',
    'ice',
    'wind',
    'thunder',
    'water',
    'buff1',
    'wizzard',
  ];

  static const _entries = <AsepriteEntry>[
    AsepriteEntry(
      name: 'explosion_1',
      category: 'fire',
      jsonAssetPath: 'assets/sprites/effects/fire/explosion_1.json',
    ),
    AsepriteEntry(
      name: 'explosion_2',
      category: 'fire',
      jsonAssetPath: 'assets/sprites/effects/fire/explosion_2.json',
    ),
    AsepriteEntry(
      name: 'hit_1',
      category: 'ice',
      jsonAssetPath: 'assets/sprites/effects/ice/hit_1.json',
    ),
    AsepriteEntry(
      name: 'ice2_active',
      category: 'ice',
      jsonAssetPath: 'assets/sprites/effects/ice/ice2_active.json',
    ),
    AsepriteEntry(
      name: 'ice2_ending',
      category: 'ice',
      jsonAssetPath: 'assets/sprites/effects/ice/ice2_ending.json',
    ),
    AsepriteEntry(
      name: 'ice2_start',
      category: 'ice',
      jsonAssetPath: 'assets/sprites/effects/ice/ice2_start.json',
    ),
    AsepriteEntry(
      name: 'repeatable_1',
      category: 'ice',
      jsonAssetPath: 'assets/sprites/effects/ice/repeatable_1.json',
    ),
    AsepriteEntry(
      name: 'start_1',
      category: 'ice',
      jsonAssetPath: 'assets/sprites/effects/ice/start_1.json',
    ),
    AsepriteEntry(
      name: 'breath',
      category: 'wind',
      jsonAssetPath: 'assets/sprites/effects/wind/breath.json',
    ),
    AsepriteEntry(
      name: 'hit',
      category: 'wind',
      jsonAssetPath: 'assets/sprites/effects/wind/hit.json',
    ),
    AsepriteEntry(
      name: 'projectile',
      category: 'wind',
      jsonAssetPath: 'assets/sprites/effects/wind/projectile.json',
    ),
    AsepriteEntry(
      name: 'splash_w',
      category: 'thunder',
      jsonAssetPath: 'assets/sprites/effects/thunder/splash_w.json',
    ),
    AsepriteEntry(
      name: 'splash_wo',
      category: 'thunder',
      jsonAssetPath: 'assets/sprites/effects/thunder/splash_wo.json',
    ),
    AsepriteEntry(
      name: 'strike_w',
      category: 'thunder',
      jsonAssetPath: 'assets/sprites/effects/thunder/strike_w.json',
    ),
    AsepriteEntry(
      name: 'strike_wo',
      category: 'thunder',
      jsonAssetPath: 'assets/sprites/effects/thunder/strike_wo.json',
    ),
    AsepriteEntry(
      name: 'blast',
      category: 'water',
      jsonAssetPath: 'assets/sprites/effects/water/blast.json',
    ),
    AsepriteEntry(
      name: 'blast_end',
      category: 'water',
      jsonAssetPath: 'assets/sprites/effects/water/blast_end.json',
    ),
    AsepriteEntry(
      name: 'waterball',
      category: 'water',
      jsonAssetPath: 'assets/sprites/effects/water/waterball.json',
    ),
    AsepriteEntry(
      name: 'waterball_end',
      category: 'water',
      jsonAssetPath: 'assets/sprites/effects/water/waterball_end.json',
    ),
    AsepriteEntry(
      name: 'buff3',
      category: 'buff1',
      jsonAssetPath: 'assets/sprites/effects/buff1/buff3.json',
    ),
    AsepriteEntry(
      name: 'buff4',
      category: 'buff1',
      jsonAssetPath: 'assets/sprites/effects/buff1/buff4.json',
    ),
    AsepriteEntry(
      name: 'buff5',
      category: 'buff1',
      jsonAssetPath: 'assets/sprites/effects/buff1/buff5.json',
    ),
    AsepriteEntry(
      name: 'buff6',
      category: 'buff1',
      jsonAssetPath: 'assets/sprites/effects/buff1/buff6.json',
    ),
    AsepriteEntry(
      name: 'Attack1',
      category: 'wizzard',
      jsonAssetPath: 'assets/sprites/characters/wizzard/Attack1.json',
    ),
    AsepriteEntry(
      name: 'Attack2',
      category: 'wizzard',
      jsonAssetPath: 'assets/sprites/characters/wizzard/Attack2.json',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _images = Images()..prefix = 'assets/';
    filteredEntries.addAll(_entries);
  }

  @override
  void dispose() {
    _images.clearCache();
    super.dispose();
  }

  List<AsepriteEntry> _filteredEntriesList() {
    if (_filter == 'all') return _entries;
    return _entries.where((e) => e.category == _filter).toList(growable: false);
  }

  int? _selectionOrder(AsepriteEntry entry) {
    final index = _selected.indexWhere(
      (e) => e.jsonAssetPath == entry.jsonAssetPath,
    );
    return index < 0 ? null : index + 1;
  }

  void _toggleSelect(AsepriteEntry entry) {
    setState(() {
      final index = _selected.indexWhere(
        (e) => e.jsonAssetPath == entry.jsonAssetPath,
      );
      if (index >= 0) {
        _selected.removeAt(index);
      } else {
        _selected.add(entry);
      }
    });
  }

  void _clearSelection() => setState(() => _selected.clear());

  void _openChainPage() {
    if (_selected.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnimationChainPage(entries: List.of(_selected)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selected.isEmpty
                          ? 'Tap effects to build a chain'
                          : 'Chain: ${_selected.map((e) => e.name).join(' → ')}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_selected.isNotEmpty)
                    TextButton(
                      onPressed: _clearSelection,
                      child: const Text('Clear'),
                    ),
                  Text(
                    '${filteredEntries.length} effects',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  for (final category in _categories)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: _filter == category,
                        onSelected: (_) => setState(() {
                          _filter = category;
                          filteredEntries
                            ..clear()
                            ..addAll(_filteredEntriesList());

                          for (final entry in filteredEntries) {
                            log('entry: ${entry.name}');
                          }
                        }),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: filteredEntries.length,
                itemBuilder: (context, index) {
                  final entry = filteredEntries[index];
                  return _EffectTile(
                    entry: entry,
                    images: _images,
                    selectionOrder: _selectionOrder(entry),
                    onToggleSelect: () => _toggleSelect(entry),
                  );
                },
              ),
            ),
          ],
        ),
        if (_selected.isNotEmpty)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: _openChainPage,
              icon: const Icon(Icons.play_arrow),
              label: Text('Run chain (${_selected.length})'),
            ),
          ),
      ],
    );
  }
}

class _EffectTile extends StatefulWidget {
  const _EffectTile({
    required this.entry,
    required this.images,
    required this.selectionOrder,
    required this.onToggleSelect,
  });

  final AsepriteEntry entry;
  final Images images;
  final int? selectionOrder;
  final VoidCallback onToggleSelect;

  @override
  State<_EffectTile> createState() => _EffectTileState();
}

class _EffectTileState extends State<_EffectTile> {
  int _replayKey = 0;
  Future<SpriteAnimation>? _animFuture;
  String _meta = '';

  void _replay() => setState(() {
        _replayKey++;
        _animFuture = null;
      });

  Future<SpriteAnimation> _load() => _animFuture ??= () async {
        final result = await loadAsepriteAnimation(
          entry: widget.entry,
          images: widget.images,
        );
        _meta = result.meta;
        return result.animation;
      }();

  @override
  void didUpdateWidget(covariant _EffectTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.jsonAssetPath != widget.entry.jsonAssetPath) {
      _replayKey++;
      _animFuture = null;
      _meta = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;
    final selected = widget.selectionOrder != null;

    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onToggleSelect,
        onLongPress: _replay,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: FutureBuilder<SpriteAnimation>(
                        key: ValueKey('${entry.name}:$_replayKey'),
                        future: _load(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return _previewFrame(theme, _errorIcon(theme));
                          }
                          if (!snapshot.hasData) {
                            return _previewFrame(
                              theme,
                              _loadingIndicator(context),
                            );
                          }
                          final animation = snapshot.data!;
                          return _previewFrame(
                            theme,
                            SpriteAnimationWidget(
                              animation: animation,
                              animationTicker: animation.createTicker(),
                              anchor: Anchor.center,
                              playing: true,
                            ),
                          );
                        },
                      ),
                    ),
                    if (selected)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          child: Text(
                            '${widget.selectionOrder}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        iconSize: 18,
                        tooltip: 'Replay preview',
                        onPressed: _replay,
                        icon: const Icon(Icons.replay),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.name,
                style: theme.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                entry.category,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _meta,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _loadingIndicator(BuildContext _) => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );

  static Widget _errorIcon(ThemeData theme) => Icon(
        Icons.broken_image_outlined,
        color: theme.colorScheme.error,
      );
}

Widget _previewFrame(ThemeData theme, Widget preview) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFF1A1F2A),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.colorScheme.outlineVariant),
    ),
    child: Center(
      child: SizedBox(width: 96, height: 96, child: preview),
    ),
  );
}
