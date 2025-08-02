import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:trendy/models/song.dart';
import 'package:trendy/views/post_creation/music_library_screen.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({super.key});

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  Song? _selectedSong;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProImageEditor.network(
        'https://picsum.photos/id/237/2000',
        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (bytes) async {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final selectedSong = await Navigator.push<Song>(
                context,
                MaterialPageRoute(
                  builder: (context) => const MusicLibraryScreen(),
                ),
              );
              if (selectedSong != null) {
                setState(() {
                  _selectedSong = selectedSong;
                });
              }
            },
            child: const Icon(Icons.music_note),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This is an AI-generated caption!'),
                ),
              );
            },
            child: const Icon(Icons.text_fields),
          ),
        ],
      ),
      bottomSheet: _selectedSong != null
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.music_note),
                  const SizedBox(width: 16),
                  Text(_selectedSong!.name),
                ],
              ),
            )
          : null,
    );
  }
}
