import 'package:dart_mappable/dart_mappable.dart';

import 'enums/role.dart';

part 'notification.mapper.dart';

@MappableClass(ignoreNull: true, caseStyle: CaseStyle.snakeCase)
class Notification with NotificationMappable {
  final String id;
  final String from;
  final String to;
  final String message;
  final bool isRead;
  final DateTime? createdAt;
  @MappableField(key: 'type')
  final NotifType notifType;
  final Map<String, dynamic>? data;
  final Role? userType;

  Notification({
    this.id = '',
    this.from = '',
    this.to = '',
    this.message = '',
    this.isRead = false,
    this.notifType = NotifType.info,
    this.createdAt,
    this.data,
    this.userType,
  });

  Map<String, dynamic> get insertNotif => {
        'from': from,
        'to': to,
        'message': message,
        'is_read': isRead,
        'type': notifType.toValue(),
        'data': data,
        'user_type': userType?.toValue()
      };

  factory Notification.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return NotificationMapper.fromMap(json);
    if (json is String) return NotificationMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}

@MappableEnum()
enum NotifType { success, info, error }
