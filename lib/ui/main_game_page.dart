import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/game/parallax_main_game.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({super.key});

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  late final ParallaxMainGame _game = ParallaxMainGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play'),
      ),
      body: GameWidget(game: _game),
    );
  }
}
