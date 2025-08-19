import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendy/services/api_service.dart';
import 'package:trendy/models/movie.dart';
import 'package:trendy/widgets/movie_card.dart';
import 'package:trendy/widgets/movie_detail_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<Movie> movies = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies({String? category, String? search}) async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final response = await ApiService.getMovies(
        category: category == 'All' ? null : category,
        search: search,
      );

      if (!mounted) return;
      setState(() {
        movies = (response['movies'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
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

  Future<void> _refreshMovies() async {
    await _loadMovies(category: selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMovies,
          ),
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
              onPressed: _refreshMovies,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No movies found'),
            ElevatedButton(
              onPressed: _refreshMovies,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMovies,
      child: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieCard(
                  movie: movies[index],
                  onTap: () => _navigateToMovieDetail(movies[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('All'),
              selected: selectedCategory == 'All',
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategory = 'All';
                    _loadMovies();
                  });
                }
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Action'),
              selected: selectedCategory == 'Action',
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategory = 'Action';
                    _loadMovies(category: 'Action');
                  });
                }
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Comedy'),
              selected: selectedCategory == 'Comedy',
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategory = 'Comedy';
                    _loadMovies(category: 'Comedy');
                  });
                }
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Drama'),
              selected: selectedCategory == 'Drama',
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategory = 'Drama';
                    _loadMovies(category: 'Drama');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMovieDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
    );
  }
}
