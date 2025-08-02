import 'package:trendy/models/song.dart';
import 'package:trendy/models/movie.dart';
import 'package:trendy/models/match.dart';

class Post {
  final dynamic item;
  final PostType type;

  Post({required this.item, required this.type});
}

enum PostType {
  song,
  movie,
  match,
}

final List<Post> dummyPosts = [
  Post(
    item: Song(
      id: '1',
      name: 'Bohemian Rhapsody',
      artists: [Artist(name: 'Queen')],
      album: Album(name: 'A Night at the Opera', imageUrl: ''),
      durationMs: 354000,
      explicit: false,
    ),
    type: PostType.song,
  ),
  Post(
    item: Movie(
      id: 550,
      title: 'Fight Club',
      overview: 'A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.',
      posterPath: '/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg',
      releaseDate: '1999-10-15',
      voteAverage: 8.4,
      genres: [Genre(id: 18, name: 'Drama')],
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
