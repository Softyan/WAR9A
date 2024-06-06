import 'package:dart_mappable/dart_mappable.dart';

part 'step_surat.mapper.dart';

@MappableClass()
class StepSurat with StepSuratMappable {
  final Steps? step;
  final DateTime? createdAt;

  const StepSurat({
    this.step,
    this.createdAt,
  });

  factory StepSurat.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return StepSuratMapper.fromMap(json);
    if (json is String) return StepSuratMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}

@MappableEnum()
enum Steps {
  @MappableValue('Pengajuan')
  pengajuan,
  @MappableValue('Tanda Tangan RT')
  ttdRt,
  @MappableValue('Tanda Tangan RW')
  ttdRw,
  @MappableValue('Diterima')
  diterima
}
