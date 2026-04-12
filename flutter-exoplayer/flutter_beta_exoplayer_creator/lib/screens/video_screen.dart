import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/video_player_widget.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String _videoUrl = '';
  String _filePath = '';
  String _subtitleUrl = '';
  String _subtitleFilePath = '';
  final bool _isDarkMode = false; // Store the manual theme preference

  // Function to pick the file after choosing the type
  Future<void> _pickFile(FileType type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type, // File type selected by user
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path!;
        _videoUrl = ''; // Clear video URL if file is picked
      });
    }
  }

  // Show the dialog to choose file type
  Future<void> _showFileTypeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('What kind of file would you like to pick?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Audio'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickFile(FileType.audio); // Pick video files
              },
            ),
            TextButton(
              child: const Text('Video'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickFile(FileType.video); // Pick audio files
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(), // Cancel action
            ),
          ],
        );
      },
    );
  }

  // Show the dialog to enter video URL
  Future<void> _showVideoURLDialog() async {
    final TextEditingController videoController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Media URL'),
          content: TextField(
            controller: videoController,
            decoration: const InputDecoration(hintText: 'Enter a valid media URL'),
            keyboardType: TextInputType.url,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _videoUrl = videoController.text;
                  _filePath = '';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show the subtitle dialog
  Future<void> _showSubtitleDialog() async {
    final TextEditingController subtitleController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Subtitle URL'),
          content: TextField(
            controller: subtitleController,
            decoration: const InputDecoration(hintText: 'Enter a valid subtitle URL'),
            keyboardType: TextInputType.url,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _subtitleUrl = subtitleController.text;
                  _subtitleFilePath = ''; // Clear file path when URL is used
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Play the video
  void _playMedia() {
    setState(() {
      // Switch to the VideoPlayerWidget screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Custom back button behavior
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.system,
        // Respect system theme
        theme: _lightTheme(),
        darkTheme: _darkTheme(),
        home: Scaffold(
          appBar: _videoUrl.isNotEmpty || _filePath.isNotEmpty
              ? null // Hide AppBar when video is playing
              : AppBar(
            title: const Text('SimpliPlay Neo'),
          ),
          body: Center(
            child: _videoUrl.isEmpty && _filePath.isEmpty
                ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Central Buttons (Enter Video URL, Choose File, Add Subtitle)
                  _buildButtonRow(),
                  SizedBox(height: 20),
                  // Play Button - This only appears if a file or URL is chosen
                ],
              ),
            )
                : WillPopScope(
              onWillPop: () async {
                // Show confirmation dialog before exiting VideoPlayerWidget
                return (await _showExitConfirmation()) ?? false;
              },
              child: VideoPlayerWidget(
                videoUrl: _videoUrl,
                filePath: _filePath,
                subtitleUrl: _subtitleUrl,
                subtitleFilePath: _subtitleFilePath,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Row containing the buttons
  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCentralButton(
          icon: Icons.link,
          label: 'Enter Media URL',
          onPressed: _showVideoURLDialog,
        ),
        SizedBox(width: 20),
        _buildCentralButton(
          icon: Icons.video_library,
          label: 'Choose File',
          onPressed: _showFileTypeDialog, // Show the file type dialog
        ),
        SizedBox(width: 20),
        _buildCentralButton(
          icon: Icons.subtitles,
          label: 'Enter Subtitle URL',
          onPressed: _showSubtitleDialog,
        ),
      ],
    );
  }

  // Central button widget
  Widget _buildCentralButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 50),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    // If the video is not playing (i.e., file or URL is empty), exit the app
    if (_videoUrl.isEmpty && _filePath.isEmpty) {
      return true; // Exit the app
    }

    // If the video is playing, show the confirmation dialog
    return (await _showExitConfirmation()) ?? false;
  }

  // Show the exit confirmation dialog
  Future<bool?> _showExitConfirmation() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // Stay on current screen
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Navigate back to VideoScreen
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => VideoScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  // Light theme
  ThemeData _lightTheme() {
    return ThemeData(
      primaryColor: Colors.lightBlue,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue)
          .copyWith(secondary: Colors.lightBlue),
      appBarTheme: AppBarTheme(
        color: Colors.lightBlue,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black, // Black icons for light mode
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        // White background for dialog in light mode
        titleTextStyle: TextStyle(
            color: Colors.black), // Black text in light mode
      ),
    );
  }

  // Dark theme
  ThemeData _darkTheme() {
    return ThemeData(
      primaryColor: Colors.blue,
      // Primary color for the theme
      scaffoldBackgroundColor: Colors.black,
      // Black background for the scaffold
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
          .copyWith(secondary: Colors.blue),
      appBarTheme: AppBarTheme(
        color: Colors.blue, // Blue AppBar background
        titleTextStyle: TextStyle(
          color: Colors.white, // White text on AppBar
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white, // White icons for dark mode
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color(0xFF333333),
        // Dark background for dialog in dark mode
        titleTextStyle: TextStyle(
            color: Colors.white), // White text in dark mode
      ),
    );
  }
}
