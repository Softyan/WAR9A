extension StringExt on String? {
  /// Check if string is digit only
  bool isDigitOnly() {
    final value = this;
    if (value == null) return false;
    return RegExp(r'^\d+$').hasMatch(value);
  }

  /// If string is null or empty, return default text
  String ifEmpty({String defaultText = "-", bool replaceEmpty = true}) {
    final value = this;

    if (value != null) {
      if (value.isNotEmpty) {
        return value;
      } else {
        return !replaceEmpty ? value : defaultText;
      }
    }
    return defaultText;
  }

  /// Capitalize first letter
  String? capitalize() {
    final value = this;
    if (value == null || value.isEmpty) return value;
    return value.trim()[0].toUpperCase() + value.substring(1);
  }

  /// Capitalize each word
  String? capitalEachWord() {
    final value = this;
    if (value == null || value.isEmpty) return value;
    return value.trim().split(' ').map((e) => e.capitalize()).join(' ');
  }
}
