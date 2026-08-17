import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/skill_tree_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.images.prefix = 'assets/';
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinity Skill Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A8ACA),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SkillTreeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
