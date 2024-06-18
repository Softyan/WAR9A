extension StringExt on String {
  /// Check if string is digit only
  bool get isDigitOnly => RegExp(r'^\d+$').hasMatch(this);
}
