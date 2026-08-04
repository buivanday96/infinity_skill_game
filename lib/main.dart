import 'package:flutter/material.dart';
import 'package:infinity_skill_game/app/app.dart';
import 'package:infinity_skill_game/app/bootstrap.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const MainApp());
}
