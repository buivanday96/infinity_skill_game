import 'dart:convert';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class AsepriteEntry {
  const AsepriteEntry({
    required this.name,
    required this.category,
    required this.jsonAssetPath,
    this.loop = true,
  });

  final String name;
  final String category;
  final String jsonAssetPath;
  final bool loop;

  AsepriteEntry copyWith({bool? loop}) {
    return AsepriteEntry(
      name: name,
      category: category,
      jsonAssetPath: jsonAssetPath,
      loop: loop ?? this.loop,
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

  final meta = json['meta'] as Map<String, dynamic>;
  final sheetFileName = meta['image'] as String;

  final dir = entry.jsonAssetPath.replaceFirst('assets/', '').split('/')
    ..removeLast();
  final sheetPath = '${dir.join('/')}/$sheetFileName';

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

  final firstFrame =
      (framesJson.first as Map<String, dynamic>)['frame'] as Map<String, dynamic>;
  final frameSize = Vector2(
    (firstFrame['w'] as num).toDouble(),
    (firstFrame['h'] as num).toDouble(),
  );
  final metaText =
      '${framesJson.length}f · '
      '${frameSize.x.toInt()}×${frameSize.y.toInt()} · '
      '${stepTime}s';

  return AsepriteLoadResult(
    animation: SpriteAnimation.spriteList(
      sprites,
      stepTime: stepTime,
      loop: loop ?? entry.loop,
    ),
    meta: metaText,
    frameSize: frameSize,
  );
}
