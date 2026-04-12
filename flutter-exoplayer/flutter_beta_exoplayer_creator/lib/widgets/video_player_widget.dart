import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'dart:io'; // Import to use File class
import 'package:media3_exoplayer_creator/utils/permission_utils.dart'; // Import permission_utils.dart for permission handling
import 'package:keep_screen_on/keep_screen_on.dart'; // Import keep_screen_on
import '../utils/web_vtt.dart'; // Import web_vtt.dart for subtitle handling

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String filePath;
  final String subtitleUrl;
  final String subtitleFilePath;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.filePath,
    required this.subtitleUrl,
    required this.subtitleFilePath,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late List<WebVttCue> _subtitles;
  String? _currentSubtitle;
  bool _isLoading = true;
  double _playbackSpeed = 1.0;
  bool _controlsVisible = true; // Keep track of control visibility

  @override
  void initState() {
    super.initState();

    // Request permission for subtitle files if needed
    if (widget.subtitleFilePath.isNotEmpty) {
      requestPermissionIfNeeded(widget.subtitleFilePath, context);
    }

    // Initialize the video player controller based on video URL or file path
    if (widget.filePath.isNotEmpty) {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.filePath));
    } else {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    }

    // Initialize the Chewie controller for video playback
    _initializeChewieController();

    // Load subtitles if needed
    _loadSubtitles();

    // Keep the screen on while the video is playing
    KeepScreenOn.turnOn();

    // Listen to video position changes to update subtitles
    _videoPlayerController.addListener(_updateCurrentSubtitle);

    // Apply immersive mode once the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyImmersiveMode();
    });

    // Initialize the video player
    _initializeVideoPlayer();
  }

  void _applyImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _initializeChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      allowPlaybackSpeedChanging: false,
      // Disable built-in playback speed dropdown
      customControls: MaterialControls(
        // Custom controls if needed
      ),
      showControlsOnInitialize: true, // Show controls on initialization
    );
  }

  @override
  void dispose() {
    KeepScreenOn.turnOff();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: SystemUiOverlay.values);

    _videoPlayerController.removeListener(_updateCurrentSubtitle);
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _loadSubtitles() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.subtitleFilePath.isNotEmpty) {
      try {
        final file = File(widget.subtitleFilePath);
        final subtitleData = await file.readAsString();
        setState(() {
          _subtitles = parseWebVtt(subtitleData);
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error loading subtitle file: $e');
      }
    } else if (widget.subtitleUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(widget.subtitleUrl));
        if (response.statusCode == 200) {
          setState(() {
            _subtitles = parseWebVtt(response.body);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          print('Failed to load subtitle from URL: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error loading subtitle from URL: $e');
      }
    }
  }

  void _updateCurrentSubtitle() {
    final currentTime = _videoPlayerController.value.position;

    for (var cue in _subtitles) {
      if (currentTime >= cue.start && currentTime <= cue.end) {
        setState(() {
          _currentSubtitle = cue.text;
        });
        return;
      }
    }

    setState(() {
      _currentSubtitle = '';
    });
  }

  void _initializeVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _videoPlayerController.setPlaybackSpeed(speed);

      // Reapply immersive mode after speed change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyImmersiveMode();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _applyImmersiveMode(); // Reapply immersive mode on back press
        return true; // Allow the back action to proceed
      },
      child: Scaffold(
        body: Stack(
          children: [
            // This GestureDetector is now the topmost widget in the stack
            GestureDetector(
              onTap: () {
                setState(() {
                  _controlsVisible = !_controlsVisible; // Toggle controls visibility on tap anywhere
                });
                _applyImmersiveMode(); // Reapply immersive mode
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Chewie(controller: _chewieController),
                    ),
                  ),
                ],
              ),
            ),
            // Loading Indicator
            if (_isLoading)
              Center(child: CircularProgressIndicator()),

            // Subtitle display
            if (_currentSubtitle != null && _currentSubtitle!.isNotEmpty && !_isLoading)
              Positioned(
                bottom: 70,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.black.withOpacity(0.7),
                  child: Text(
                    _currentSubtitle!,
                    style: TextStyle(fontSize: 19, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Custom playback speed control button
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedOpacity(
                opacity: _controlsVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                // Adjust duration for fade effect
                child: IconButton(
                  icon: SizedBox.shrink(), // No icon, just an empty space
                  onPressed: () {
                    _applyImmersiveMode(); // Reapply immersive mode
                    _showPlaybackSpeedDialog();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaybackSpeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Playback Speed",
            style: TextStyle(
              fontSize: 20, // Keep the title size consistent
              color: Theme
                  .of(context)
                  .brightness == Brightness.light
                  ? Colors.grey
                  : Colors.grey
            ),
          ),
          content: SingleChildScrollView( // Wrap content with SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0].map((
                  speed) {
                return ListTile(
                  title: Text(
                    "${speed}x",
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.color ??
                          Colors.grey, // Dynamic text color based on theme
                    ),
                  ),
                  onTap: () {
                    _changePlaybackSpeed(speed);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
