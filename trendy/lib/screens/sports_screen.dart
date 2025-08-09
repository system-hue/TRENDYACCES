import 'package:flutter/material.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Football'),
            Tab(text: 'Basketball'),
            Tab(text: 'More Sports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_FootballTab(), _BasketballTab(), _MoreSportsTab()],
      ),
    );
  }
}

class _FootballTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('Live Scores'),
        _buildLiveScores(),
        const SizedBox(height: 24),
        _buildSectionTitle('Upcoming Matches'),
        _buildUpcomingMatches(),
        const SizedBox(height: 24),
        _buildSectionTitle('League Tables'),
        _buildLeagueTables(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLiveScores() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMatchCard('Manchester United', 'Liverpool', '2-1', '75\''),
            const SizedBox(height: 8),
            _buildMatchCard('Arsenal', 'Chelsea', '1-0', '68\''),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(
    String team1,
    String team2,
    String score,
    String time,
  ) {
    return ListTile(
      title: Text('$team1 vs $team2'),
      subtitle: Text('Score: $score • Time: $time'),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildUpcomingMatches() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUpcomingMatch('Real Madrid', 'Barcelona', 'Today, 20:00'),
            const SizedBox(height: 8),
            _buildUpcomingMatch('Bayern Munich', 'PSG', 'Tomorrow, 19:30'),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingMatch(String team1, String team2, String time) {
    return ListTile(
      title: Text('$team1 vs $team2'),
      subtitle: Text(time),
      trailing: const Icon(Icons.notifications),
    );
  }

  Widget _buildLeagueTables() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLeagueRow('1', 'Manchester City', '78 pts'),
            _buildLeagueRow('2', 'Arsenal', '75 pts'),
            _buildLeagueRow('3', 'Liverpool', '72 pts'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueRow(String position, String team, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(position, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(child: Text(team)),
          Text(points, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _BasketballTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Basketball content coming soon...'));
  }
}

class _MoreSportsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('More sports content coming soon...'));
  }
}
