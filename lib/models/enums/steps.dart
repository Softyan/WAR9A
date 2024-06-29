import 'package:dart_mappable/dart_mappable.dart';

part 'steps.mapper.dart';

@MappableEnum()
enum JenisKelamin {
  @MappableValue('Pengajuan')
  pengajuan,
  @MappableValue('Tanda Tangan RT')
  ttdRt,
  @MappableValue('Tanda Tangan RW')
  ttdRw,
  @MappableValue('Diterima')
  selesai
}