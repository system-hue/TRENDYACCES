import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;
  static String? _currentTrackUrl;
  static Duration _duration = Duration.zero;
  static Duration _position = Duration.zero;

  static AudioPlayer get player => _audioPlayer;

  static Future<void> play(String url) async {
    _currentTrackUrl = url;
    await _audioPlayer.play(UrlSource(url));
    _isPlaying = true;
  }

  static Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  static Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  static Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentTrackUrl = null;
  }

  static bool get isPlaying => _isPlaying;
  static String? get currentTrackUrl => _currentTrackUrl;
  static Duration get duration => _duration;
  static Duration get position => _position;

  static Stream<Duration> get onDurationChanged =>
      _audioPlayer.onDurationChanged;
  static Stream<Duration> get onPositionChanged =>
      _audioPlayer.onPositionChanged;
  static Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

  static void dispose() {
    _audioPlayer.dispose();
  }
}
