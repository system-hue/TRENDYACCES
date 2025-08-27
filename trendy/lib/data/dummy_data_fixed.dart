import 'package:trendy/models/song.dart';
import 'package:trendy/models/movie.dart';
import 'package:trendy/models/match.dart';

class Post {
  final dynamic item;
  final PostType type;

  Post({required this.item, required this.type});
}

enum PostType { song, movie, match }

final List<Post> dummyPosts = [
  Post(
    item: Song(
      id: '1',
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      imageUrl: '',
      audioUrl: '',
      duration: 354,
      explicit: false,
      album: 'A Night at the Opera',
      createdAt: DateTime.now(),
      likes: 1000,
      plays: 5000,
    ),
    type: PostType.song,
  ),
  Post(
    item: Movie(
      id: '550',
      title: 'Fight Club',
      description:
          'A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.',
      imageUrl: '/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg',
      backdropPath: '/jSziioSwPVrOy9Yow3Xh极WIBDjq极1.jpg',
      releaseDate: DateTime.parse('1999-10-15'),
      voteAverage: 8.4,
      genres: ['Drama'],
      runtime: 139,
      director: 'David Fincher',
      cast: ['Brad Pitt', 'Edward Norton', 'Helena Bonham Carter'],
      createdAt: DateTime.now(),
      likes: 2000,
      views: 10000,
      category: 'Drama',
      comments: 0,
      user: {'username': 'user1', 'avatar_url': 'url_to_avatar'},
    ),
    type: PostType.movie,
  ),
  Post(
    item: Match(
      id: 215662,
      homeTeam: Team(name: 'Manchester United', logoUrl: ''),
      awayTeam: Team(name: 'Chelsea', logoUrl: ''),
      homeScore: 0,
      awayScore: 2,
      date: DateTime.now(),
      league: 'Premier League',
    ),
    type: PostType.match,
  ),
];
