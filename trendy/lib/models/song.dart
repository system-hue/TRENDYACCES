class Song {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;
  final int duration;
  final bool explicit;
  final String album;
  final DateTime createdAt;
  final int likes;
  final int plays;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
    required this.explicit,
    required this.album,
    required this.createdAt,
    required this.likes,
    required this.plays,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['image_url'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      duration: json['duration'] ?? 0,
      explicit: json['explicit'] ?? false,
      album: json['album'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      likes: json['likes'] ?? 0,
      plays: json['plays'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'duration': duration,
      'explicit': explicit,
      'album': album,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'plays': plays,
    };
  }
}
