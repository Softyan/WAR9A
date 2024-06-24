extension StringExt on String? {
  /// Check if string is digit only
  bool isDigitOnly() {
    final value = this;
    if (value == null) return false;
    return RegExp(r'^\d+$').hasMatch(value);
  }

  /// If string is null or empty, return default text
  String ifEmpty({String defaultText = "-"}) {
    final value = this;
    if (value != null && value.isNotEmpty) return value;
    return value ?? defaultText;
  }
}
