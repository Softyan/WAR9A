import 'package:dart_mappable/dart_mappable.dart';

part 'notification_data.mapper.dart';

@MappableClass()
class NotificationData with NotificationDataMappable {
  final NotificationDataType? type;
  final dynamic id;

  const NotificationData({
    this.type,
    this.id,
  });

  factory NotificationData.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return NotificationDataMapper.fromMap(json);
    }
    if (json is String) return NotificationDataMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}

@MappableEnum()
enum NotificationDataType { pengajuan, surat }
