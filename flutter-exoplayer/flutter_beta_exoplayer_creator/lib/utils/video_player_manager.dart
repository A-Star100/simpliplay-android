class VideoPlayerManager {
  static final VideoPlayerManager _instance = VideoPlayerManager._internal();

  bool _isPlaying = false;

  // Private constructor
  VideoPlayerManager._internal();

  factory VideoPlayerManager() {
    return _instance;
  }

  // To start playing the video
  void playVideo() {
    _isPlaying = true;
  }

  // To stop or pause the video
  void stopVideo() {
    _isPlaying = false;
  }

  // To check if video is playing
  bool get isPlaying => _isPlaying;
}
