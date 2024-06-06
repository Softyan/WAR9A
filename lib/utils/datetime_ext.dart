import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// Format date with pattern
  String formattedDate({String? pattern}) {
    if (pattern == null) return formatDefault;
    return DateFormat(pattern).format(this);
  }

  /// Format date with default pattern
  /// dd MMMM yyyy hh:mm (01 January 2024 00:00)
  String get formatDefault => DateFormat('dd MMMM yyyy hh:mm').format(this);
}
