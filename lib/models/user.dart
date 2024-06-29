import 'package:dart_mappable/dart_mappable.dart';

import 'enums/jenis_kelamin.dart';
import 'enums/role.dart';

part 'user.mapper.dart';

@MappableClass(ignoreNull: true, caseStyle: CaseStyle.snakeCase)
class User with UserMappable {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String alamat;
  final JenisKelamin? jenisKelamin;
  final Role role;
  final DateTime? createdAt;
  final DateTime? birthDate;
  final String nik;
  final int rt;
  final bool isActiveWarga;

  const User(
      {this.id = '',
      this.email = '',
      this.password,
      this.name = '',
      this.alamat = '',
      this.jenisKelamin,
      this.role = Role.warga,
      this.createdAt,
      this.birthDate,
      this.nik = '',
      this.rt = 0,
      this.isActiveWarga = true});

  factory User.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return UserMapper.fromMap(json);
    if (json is String) return UserMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}
