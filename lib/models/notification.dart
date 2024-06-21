import 'package:dart_mappable/dart_mappable.dart';

part 'notification.mapper.dart';

@MappableClass(ignoreNull: true, caseStyle: CaseStyle.snakeCase)
class Notification with NotificationMappable {
  final String id;
  final String from;
  final String to;
  final String message;
  final bool isRead;
  final DateTime? createdAt;
  @MappableField(key: 'key')
  final NotifType notifType;
  final String? data;

  const Notification({
    this.id = '',
    this.from = '',
    this.to = '',
    this.message = '',
    this.isRead = false,
    this.notifType = NotifType.info,
    this.createdAt,
    this.data
  });

  factory Notification.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return NotificationMapper.fromMap(json);
    if (json is String) return NotificationMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}

@MappableEnum()
enum NotifType { success, info, error }
