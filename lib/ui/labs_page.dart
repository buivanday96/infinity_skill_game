import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:infinity_skill_game/game/dungeon_game.dart';
import 'package:infinity_skill_game/ui/effects_gallery_page.dart';
import 'package:infinity_skill_game/ui/ice_skill_demo_page.dart';

class LabsPage extends StatelessWidget {
  const LabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Labs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Game'),
              Tab(text: 'Effects'),
              Tab(text: 'Ice Skill'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GameWidget(game: DungeonGame()),
            const EffectsGalleryPage(),
            const IceSkillDemoPage(),
          ],
        ),
      ),
    );
  }
}
