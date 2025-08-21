import 'package:flutter/material.dart';
import 'package:trendy/screens/movies_screen.dart';
import 'package:trendy/screens/music_screen.dart';
import 'package:trendy/screens/photography_screen.dart';
import 'package:trendy/screens/sports_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Music'),
            Tab(text: 'Movies'),
            Tab(text: 'Photos'),
            Tab(text: 'Sports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MusicScreen(),
          MoviesScreen(),
          PhotographyScreen(),
          SportsScreen(),
        ],
      ),
    );
  }
}
