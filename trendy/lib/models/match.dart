class Match {
  final int id;
  final Team homeTeam;
  final Team awayTeam;
  final int homeScore;
  final int awayScore;
  final DateTime date;
  final String league;

  Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.date,
    required this.league,
  });
}

class Team {
  final String name;
  final String logoUrl;

  Team({required this.name, required this.logoUrl});
}
