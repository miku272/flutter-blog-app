int calculateReadingTime(String content) {
  final words = content.split(RegExp(r'\s+'));
  final wordCount = words.length;
  final readingTime = (wordCount / 200).ceil();
  return readingTime;
}
