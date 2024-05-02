import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final String id;
  final String name;
  final String email;
  final String password;

  const User(
    this.email,
    this.password, {
    this.id = '',
    this.name = '',
  });

  factory User.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return UserMapper.fromMap(json);
    if (json is String) return UserMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}
