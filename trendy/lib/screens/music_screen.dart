import 'package:flutter/material.dart';
import 'package:trendy/services/api_service.dart';
import 'package:trendy/widgets/song_card.dart';
import 'package:trendy/services/audio_player_service.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<dynamic> music = [];
  List<String> genres = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String selectedGenre = 'All';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMusic();
    _loadGenres();
  }

  Future<void> _loadMusic({String? genre, String? search}) async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final response = await ApiService.getMusic(
        genre: genre == 'All' ? null : genre,
        search: search,
      );

      if (!mounted) return;
      setState(() {
        music = response['music'] as List<dynamic>;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadGenres() async {
    try {
      final genresList = await ApiService.getMusicGenres();
      if (!mounted) return;
      setState(() {
        genres = ['All', ...genresList];
      });
    } catch (e) {
      print('Error loading genres: $e');
    }
  }

  Future<void> _refreshMusic() async {
    await _loadMusic(genre: selectedGenre);
  }

  void _playSong(dynamic song) {
    AudioPlayerService.play(song['audio_url']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshMusic),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $errorMessage'),
            ElevatedButton(
              onPressed: _refreshMusic,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (music.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No music found'),
            ElevatedButton(
              onPressed: _refreshMusic,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMusic,
      child: Column(
        children: [
          _buildSearchBar(),
          _buildGenreFilter(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              controller: _scrollController,
              itemCount: music.length,
              itemBuilder: (context, index) {
                final song = music[index];
                return SongCard(song: song, onTap: () => _playSong(song));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search music...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _loadMusic();
            },
          ),
        ),
        onSubmitted: (query) {
          _loadMusic(search: query);
        },
      ),
    );
  }

  Widget _buildGenreFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: genres.map((genre) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(genre),
                selected: selectedGenre == genre,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      selectedGenre = genre;
                      _loadMusic(genre: genre);
                    });
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
