import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

/// Initializes Flutter bindings and platform-specific orientation.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS / desktop: Flutter orientation API is enough.
  // Android: do NOT call setPreferredOrientations — Flutter maps both
  // landscapes to USER_LANDSCAPE, which blocks L↔R when auto-rotate is off.
  // Android uses sensorLandscape in AndroidManifest / MainActivity instead.
  if (!kIsWeb && !Platform.isAndroid) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
