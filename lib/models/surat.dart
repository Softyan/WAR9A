import 'package:dart_mappable/dart_mappable.dart';

import 'enums/role.dart';

part 'surat.mapper.dart';

@MappableClass(ignoreNull: true, caseStyle: CaseStyle.snakeCase)
class Surat with SuratMappable {
  final int id;
  final DateTime? createdAt;
  final List<String> suratUrls;
  final String noSurat;
  final String perihal;
  final String from;
  final bool isSuratMasuk;
  final Role role;
  final int rt;

  const Surat(
      {this.id = 0,
      this.createdAt,
      this.suratUrls = const [],
      this.noSurat = '',
      this.from = '',
      this.perihal = '',
      this.isSuratMasuk = true,
      this.role = Role.warga,
      this.rt = 0});

  Map<String, dynamic> get toInsertSurat => {
        'surat_urls': suratUrls,
        'no_surat': noSurat,
        'perihal': perihal,
        'from': from,
        'is_surat_masuk': isSuratMasuk,
        'role': role.toValue(),
        'rt': rt
      };

  factory Surat.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return SuratMapper.fromMap(json);
    if (json is String) return SuratMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}
