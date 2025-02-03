class WebVttCue {
  final Duration start;
  final Duration end;
  final String text;

  WebVttCue({
    required this.start,
    required this.end,
    required this.text,
  });
}

// Subtitle parsing logic (WebVTT format)
List<WebVttCue> parseWebVtt(String subtitleData) {
  final cuePattern = RegExp(r'(\d{2}:\d{2}:\d{2}.\d{3}) --> (\d{2}:\d{2}:\d{2}.\d{3})\n(.*?)\n\n', dotAll: true);
  final List<WebVttCue> cues = [];

  for (final match in cuePattern.allMatches(subtitleData)) {
    final start = _parseTime(match.group(1)!);
    final end = _parseTime(match.group(2)!);
    final text = match.group(3)!;
    cues.add(WebVttCue(start: start, end: end, text: text));
  }

  return cues;
}

// Helper method to parse time string to Duration
Duration _parseTime(String time) {
  final parts = time.split(':');
  final secondsParts = parts[2].split('.');
  return Duration(
    hours: int.parse(parts[0]),
    minutes: int.parse(parts[1]),
    seconds: int.parse(secondsParts[0]),
    milliseconds: int.parse(secondsParts[1]),
  );
}
