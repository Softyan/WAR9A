import 'package:dart_mappable/dart_mappable.dart';

import 'step_surat.dart';

part 'surat.mapper.dart';

@MappableClass(ignoreNull: true, caseStyle: CaseStyle.snakeCase)
class Surat with SuratMappable {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> suratUrls;
  final String noSurat;
  final String title;
  final String keperluan;
  final String from;
  final List<StepSurat> steps;
  final String category;

  const Surat({
    this.id = 0,
    this.createdAt,
    this.updatedAt,
    this.suratUrls = const [],
    this.noSurat = '',
    this.title = '',
    this.keperluan = '',
    this.from = '',
    this.steps = const [],
    this.category = '',
  });

  factory Surat.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return SuratMapper.fromMap(json);
    if (json is String) return SuratMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}

@MappableEnum()
enum CategorySurat { pembuatanKtp }
