import 'package:dart_mappable/dart_mappable.dart';

part 'role.mapper.dart';

@MappableEnum()
enum Role {
  @MappableValue('RT')
  rt,
  @MappableValue('RW')
  rw,
  @MappableValue('Warga')
  warga,
  @MappableValue('Sekretaris')
  sekretaris
}