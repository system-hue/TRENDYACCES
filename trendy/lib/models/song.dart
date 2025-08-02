class Song {
  final String id;
  final String name;
  final List<Artist> artists;
  final Album album;
  final int? durationMs;
  final bool? explicit;
  final String? previewUrl;

  Song({
    required this.id,
    required this.name,
    required this.artists,
    required this.album,
    this.durationMs,
    this.explicit,
    this.previewUrl,
  });

  factory Song.fromSpotify(Map<String, dynamic> json) {
    final List<dynamic> artistsJson = json['artists'];
    final List<Artist> artists = artistsJson.map((artist) => Artist.fromSpotify(artist)).toList();
    final Map<String, dynamic> albumJson = json;
    final Album album = Album.fromSpotify(albumJson);

    return Song(
      id: json['id'],
      name: json['name'],
      artists: artists,
      album: album,
    );
  }
}

class Artist {
  final String name;

  Artist({required this.name});

  factory Artist.fromSpotify(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
    );
  }
}

class Album {
  final String name;
  final String imageUrl;

  Album({required this.name, required this.imageUrl});

  factory Album.fromSpotify(Map<String, dynamic> json) {
    final List<dynamic> images = json['images'];
    return Album(
      name: json['name'],
      imageUrl: images.isNotEmpty ? images.first['url'] : '',
    );
  }
}
