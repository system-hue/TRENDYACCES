import 'package:flutter/material.dart';
import 'package:trendy/create_screen.dart';
import 'package:trendy/fusion_screen.dart';
import 'package:trendy/launchpad_screen.dart';
import 'package:trendy/live_arenas_screen.dart';
import 'package:trendy/mic_drop_screen.dart';
import 'package:trendy/moments_screen.dart';
import 'package:trendy/private_world_screen.dart';
import 'package:trendy/profile_screen.dart';
import 'package:trendy/rise_mode_screen.dart';
import 'package:trendy/trend_blocks_screen.dart';
import 'package:trendy/trendy_ai_screen.dart';
import 'package:trendy/vibe_room_screen.dart';
import 'package:trendy/viral_dimension_screen.dart';
import 'package:trendy/widgets/animated_background.dart';
import 'package:trendy/widgets/interactive_orb.dart';
import 'package:trendy/widgets/universe_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ViralDimensionScreen(),
            ),
          );
        } else if (details.primaryVelocity != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivateWorldScreen()),
          );
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RiseModeScreen()),
          );
        } else if (details.primaryVelocity != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateScreen()),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedBackground(),
            GridView.count(
              crossAxisCount: 3,
              children: const [
                UniverseTile(
                  title: 'Moments',
                  icon: Icons.movie,
                  screen: MomentsScreen(),
                ),
                UniverseTile(
                  title: 'Trendy AI',
                  icon: Icons.lightbulb,
                  screen: TrendyAiScreen(),
                ),
                UniverseTile(
                  title: 'Vibe Room',
                  icon: Icons.music_note,
                  screen: VibeRoomScreen(),
                ),
                UniverseTile(
                  title: 'Launchpad',
                  icon: Icons.rocket_launch,
                  screen: LaunchpadScreen(),
                ),
                UniverseTile(
                  title: 'Live Arenas',
                  icon: Icons.sports_soccer,
                  screen: LiveArenasScreen(),
                ),
                UniverseTile(
                  title: 'TrendBlocks',
                  icon: Icons.view_quilt,
                  screen: TrendBlocksScreen(),
                ),
                UniverseTile(
                  title: 'MicDrop',
                  icon: Icons.mic,
                  screen: MicDropScreen(),
                ),
                UniverseTile(
                  title: 'Fusion',
                  icon: Icons.merge_type,
                  screen: FusionScreen(),
                ),
                UniverseTile(
                  title: 'DreamSpace',
                  icon: Icons.person,
                  screen: ProfileScreen(isOwner: true),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Image.network(
                'https://i.imgur.com/3oEJMlB.png',
                width: 100,
                height: 100,
              ),
            ),
            const InteractiveOrb(initialX: 50, initialY: 100),
            const InteractiveOrb(initialX: 150, initialY: 200),
            const InteractiveOrb(initialX: 250, initialY: 300),
          ],
        ),
      ),
    );
  }
}
