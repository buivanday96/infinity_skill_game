import 'dart:convert';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class AsepriteEntry {
  const AsepriteEntry({
    required this.name,
    required this.category,
    required this.jsonAssetPath,
    this.sheetAssetPath,
    this.loop = true,
    this.holdFirstFrame = false,
  });

  final String name;
  final String category;
  final String jsonAssetPath;

  /// Optional PNG sheet path (with or without `assets/` prefix).
  /// Used when Aseprite JSON omits `meta.image`.
  final String? sheetAssetPath;
  final bool loop;

  /// Use only the first sheet frame (e.g. knight idle from attack pose).
  final bool holdFirstFrame;

  AsepriteEntry copyWith({
    bool? loop,
    String? sheetAssetPath,
    bool? holdFirstFrame,
  }) {
    return AsepriteEntry(
      name: name,
      category: category,
      jsonAssetPath: jsonAssetPath,
      sheetAssetPath: sheetAssetPath ?? this.sheetAssetPath,
      loop: loop ?? this.loop,
      holdFirstFrame: holdFirstFrame ?? this.holdFirstFrame,
    );
  }
}

class AsepriteLoadResult {
  const AsepriteLoadResult({
    required this.animation,
    required this.meta,
    required this.frameSize,
  });

  final SpriteAnimation animation;
  final String meta;

  /// Native width × height of the first frame (source pixels).
  final Vector2 frameSize;
}

Future<AsepriteLoadResult> loadAsepriteAnimation({
  required AsepriteEntry entry,
  required Images images,
  bool? loop,
}) async {
  final jsonStr = await rootBundle.loadString(entry.jsonAssetPath);
  final json = jsonDecode(jsonStr) as Map<String, dynamic>;

  final framesRaw = json['frames'];
  final List<dynamic> framesJson;
  if (framesRaw is List<dynamic>) {
    framesJson = framesRaw;
  } else if (framesRaw is Map) {
    framesJson = framesRaw.values.toList();
  } else {
    throw FormatException(
      'Unsupported Aseprite frames type in ${entry.jsonAssetPath}',
    );
  }

  final meta = json['meta'] as Map<String, dynamic>?;
  final sheetPath = _resolveSheetPath(
    jsonAssetPath: entry.jsonAssetPath,
    metaImage: meta?['image'] as String?,
    sheetAssetPath: entry.sheetAssetPath,
  );

  final sheetImage = await images.load(sheetPath);

  final sprites = <Sprite>[];
  double stepTime = 0.1;

  for (final f in framesJson) {
    final frameData = f as Map<String, dynamic>;
    final frame = frameData['frame'] as Map<String, dynamic>;
    final x = (frame['x'] as num).toDouble();
    final y = (frame['y'] as num).toDouble();
    final w = (frame['w'] as num).toDouble();
    final h = (frame['h'] as num).toDouble();
    final duration = (frameData['duration'] as num).toDouble();
    stepTime = duration / 1000.0;

    sprites.add(
      Sprite(
        sheetImage,
        srcPosition: Vector2(x, y),
        srcSize: Vector2(w, h),
      ),
    );
  }

  final firstFrame = (framesJson.first as Map<String, dynamic>)['frame'] as Map<String, dynamic>;
  final frameSize = Vector2(
    (firstFrame['w'] as num).toDouble(),
    (firstFrame['h'] as num).toDouble(),
  );

  final useLoop = loop ?? entry.loop;
  final List<Sprite> animSprites;
  final double animStep;
  if (entry.holdFirstFrame && sprites.isNotEmpty) {
    animSprites = [sprites.first];
    animStep = 1.0;
  } else {
    animSprites = sprites;
    animStep = stepTime;
  }

  final metaText =
      '${animSprites.length}f · '
      '${frameSize.x.toInt()}×${frameSize.y.toInt()} · '
      '${animStep}s';

  return AsepriteLoadResult(
    animation: SpriteAnimation.spriteList(
      animSprites,
      stepTime: animStep,
      loop: useLoop,
    ),
    meta: metaText,
    frameSize: frameSize,
  );
}

/// Resolves sheet path relative to Flame [Images] prefix (`assets/`).
String _resolveSheetPath({
  required String jsonAssetPath,
  required String? metaImage,
  required String? sheetAssetPath,
}) {
  String stripAssets(String path) => path.startsWith('assets/') ? path.substring('assets/'.length) : path;

  if (sheetAssetPath != null && sheetAssetPath.isNotEmpty) {
    return stripAssets(sheetAssetPath);
  }

  if (metaImage != null && metaImage.isNotEmpty) {
    final dir = stripAssets(jsonAssetPath).split('/')..removeLast();
    return '${dir.join('/')}/$metaImage';
  }

  throw FormatException(
    'Missing sheet image for $jsonAssetPath '
    '(no meta.image and no sheetAssetPath)',
  );
}
