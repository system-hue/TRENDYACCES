import 'package:flutter/material.dart';
import 'package:trendy/api_service.dart';
import 'package:trendy/models/song.dart';

class MusicLibraryScreen extends StatefulWidget {
  const MusicLibraryScreen({super.key});

  @override
  State<MusicLibraryScreen> createState() => _MusicLibraryScreenState();
}

class _MusicLibraryScreenState extends State<MusicLibraryScreen> {
  late Future<List<Song>> _newReleases;

  @override
  void initState() {
    super.initState();
    _newReleases = ApiService().getNewReleases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Library'),
      ),
      body: FutureBuilder<List<Song>>(
        future: _newReleases,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final song = snapshot.data![index];
                return ListTile(
                  title: Text(song.name),
                  subtitle: Text(song.artists.first.name),
                  leading: song.album.imageUrl.isNotEmpty
                      ? Image.network(song.album.imageUrl)
                      : null,
                  onTap: () {
                    Navigator.pop(context, song);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
