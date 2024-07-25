extension StringExtension on String {
  String normalizeQuotes() {
    return replaceAll('"', "'");
  }
}
