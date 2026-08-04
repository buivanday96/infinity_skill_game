import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/features/catalog/data/sprite_catalog.dart';
import 'package:infinity_skill_game/shared/animation/aseprite_animation.dart';

class SpriteCatalogPage extends StatefulWidget {
  const SpriteCatalogPage({super.key});

  @override
  State<SpriteCatalogPage> createState() => _SpriteCatalogPageState();
}

class _SpriteCatalogPageState extends State<SpriteCatalogPage> {
  late final Images _images;
  SpriteKind _kind = SpriteKind.character;
  String _groupFilter = 'all';

  @override
  void initState() {
    super.initState();
    _images = Images()..prefix = 'assets/';
  }

  @override
  void dispose() {
    _images.clearCache();
    super.dispose();
  }

  void _selectKind(SpriteKind kind) {
    if (_kind == kind) return;
    setState(() {
      _kind = kind;
      _groupFilter = 'all';
    });
  }

  List<SpriteCatalogEntry> get _filtered {
    final all = spritesForKind(_kind);
    if (_groupFilter == 'all') return all;
    return all.where((e) => e.group == _groupFilter).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = groupsForKind(_kind);
    final entries = _filtered;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _SidePanel(
              kind: _kind,
              groupFilter: _groupFilter,
              groups: groups,
              spriteCount: entries.length,
              onBack: () => Navigator.of(context).maybePop(),
              onKindSelected: _selectKind,
              onGroupSelected: (group) => setState(() => _groupFilter = group),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.05,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return _SpriteTile(
                    entry: entries[index],
                    images: _images,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Narrow left rail: back, kind switch, group filters — keeps grid tall.
class _SidePanel extends StatelessWidget {
  const _SidePanel({
    required this.kind,
    required this.groupFilter,
    required this.groups,
    required this.spriteCount,
    required this.onBack,
    required this.onKindSelected,
    required this.onGroupSelected,
  });

  final SpriteKind kind;
  final String groupFilter;
  final List<String> groups;
  final int spriteCount;
  final VoidCallback onBack;
  final ValueChanged<SpriteKind> onKindSelected;
  final ValueChanged<String> onGroupSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 148,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 8, 0),
            child: Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Back',
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, size: 20),
                ),
                Expanded(
                  child: Text(
                    'Sprites',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$spriteCount items',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonFormField<SpriteKind>(
              initialValue: kind,
              isExpanded: true,
              isDense: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: SpriteKind.character,
                  child: Text('Characters'),
                ),
                DropdownMenuItem(
                  value: SpriteKind.monster,
                  child: Text('Monsters'),
                ),
                DropdownMenuItem(
                  value: SpriteKind.effect,
                  child: Text('Effects'),
                ),
              ],
              onChanged: (value) {
                if (value != null) onKindSelected(value);
              },
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              children: [
                _GroupTile(
                  label: 'all',
                  selected: groupFilter == 'all',
                  onTap: () => onGroupSelected('all'),
                ),
                for (final group in groups)
                  _GroupTile(
                    label: group,
                    selected: groupFilter == group,
                    onTap: () => onGroupSelected(group),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected ? theme.colorScheme.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpriteTile extends StatefulWidget {
  const _SpriteTile({required this.entry, required this.images});

  final SpriteCatalogEntry entry;
  final Images images;

  @override
  State<_SpriteTile> createState() => _SpriteTileState();
}

class _SpriteTileState extends State<_SpriteTile> {
  int _replayKey = 0;
  Future<SpriteAnimation>? _animFuture;
  String _meta = '';

  void _replay() => setState(() {
    _replayKey++;
    _animFuture = null;
  });

  Future<SpriteAnimation> _loadAnimation() => _animFuture ??= () async {
    final jsonPath = widget.entry.jsonAssetPath!;
    final result = await loadAsepriteAnimation(
      entry: AsepriteEntry(
        name: widget.entry.name,
        category: widget.entry.group,
        jsonAssetPath: jsonPath,
        sheetAssetPath: widget.entry.imageAssetPath,
      ),
      images: widget.images,
    );
    if (mounted) {
      setState(() => _meta = result.meta);
    }
    return result.animation;
  }();

  @override
  void didUpdateWidget(covariant _SpriteTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.imageAssetPath != widget.entry.imageAssetPath) {
      _animFuture = null;
      _meta = '';
      _replayKey = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;
    final tooltip = entry.isAnimated
        ? '${entry.name} · ${entry.group}'
              '${_meta.isEmpty ? '' : ' · $_meta'}'
        : '${entry.name} · ${entry.group} · static';

    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: entry.isAnimated ? _replay : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F2A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    // Tight bounds are required: Flame's SpriteAnimationWidget
                    // uses CustomPaint with no intrinsic size, so loose Center
                    // constraints collapse it to 0×0 and nothing plays.
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox.expand(
                        child: entry.isAnimated
                            ? FutureBuilder<SpriteAnimation>(
                                key: ValueKey(
                                  '${entry.jsonAssetPath}:$_replayKey',
                                ),
                                future: _loadAnimation(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Icon(
                                      Icons.broken_image_outlined,
                                      size: 20,
                                      color: theme.colorScheme.error,
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  }
                                  final animation = snapshot.data!;
                                  return SpriteAnimationWidget(
                                    animation: animation,
                                    animationTicker: animation.createTicker(),
                                    anchor: Anchor.center,
                                    playing: true,
                                  );
                                },
                              )
                            : Image.asset(
                                entry.imageAssetPath,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (_, error, stackTrace) => Icon(
                                  Icons.broken_image_outlined,
                                  size: 20,
                                  color: theme.colorScheme.error,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
