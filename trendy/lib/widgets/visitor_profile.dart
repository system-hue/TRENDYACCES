import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:trendy/widgets/animated_background.dart';

class VisitorProfile extends StatefulWidget {
  final bool isVip;

  const VisitorProfile({super.key, this.isVip = false});

  @override
  State<VisitorProfile> createState() => _VisitorProfileState();
}

class _VisitorProfileState extends State<VisitorProfile> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio();
  }

  void _playAudio() async {
    if (widget.isVip) {
      await _audioPlayer.play(
        UrlSource(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        ),
      );
    } else {
      await _audioPlayer.play(
        UrlSource(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        ),
      );
    }
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.isVip
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Pulse Reaction'),
              icon: const Icon(Icons.favorite),
            )
          : FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Follow'),
              icon: const Icon(Icons.add),
            ),
      body: Stack(
        children: [
          const AnimatedBackground(),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView(
                    children: [
                      Image.network(
                        'https://i.imgur.com/3oEJMlB.png',
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://i.imgur.com/3oEJMlB.png',
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://i.imgur.com/3oEJMlB.png',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ListTile(
                    leading: Icon(
                      Icons.music_note,
                      color: widget.isVip ? Colors.amber : null,
                    ),
                    title: Text(
                      'Floating Hubs',
                      style: TextStyle(
                        color: widget.isVip ? Colors.amber : null,
                        fontWeight: widget.isVip ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.bubble_chart),
                    title: Text('Personality Bubble'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Followers Orbit'),
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
