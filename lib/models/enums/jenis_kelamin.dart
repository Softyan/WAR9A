import 'package:dart_mappable/dart_mappable.dart';

part 'jenis_kelamin.mapper.dart';

@MappableEnum()
enum JenisKelamin {
  @MappableValue('Laki-Laki')
  man,
  @MappableValue('Perempuan')
  women
}