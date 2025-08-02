import 'package:flutter/material.dart';

class SavedPostsView extends StatelessWidget {
  const SavedPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ExpansionTile(
          title: Text('Music'),
          children: [
            ListTile(
              title: Text('Bohemian Rhapsody'),
            ),
            ListTile(
              title: Text('Stairway to Heaven'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Movies'),
          children: [
            ListTile(
              title: Text('The Shawshank Redemption'),
            ),
            ListTile(
              title: Text('The Godfather'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Football'),
          children: [
            ListTile(
              title: Text('Manchester United vs. Chelsea'),
            ),
            ListTile(
              title: Text('Real Madrid vs. Barcelona'),
            ),
          ],
        ),
      ],
    );
  }
}
