import 'package:dart_mappable/dart_mappable.dart';

import 'enums/jenis_kelamin.dart';
import 'enums/steps.dart';

part 'pengajuan_surat.mapper.dart';

@MappableClass(ignoreNull: true, caseStyle: CaseStyle.snakeCase)
class PengajuanSurat with PengajuanSuratMappable {
  final int id;
  final String name;
  final String tempat;
  final DateTime? birthDate;
  final JenisKelamin jenisKelamin;
  final String agama;
  final String pekerjaan;
  final String nik;
  final String alamat;
  final String keperluan;
  final String noSurat;
  final DateTime? createdAt;
  final int rt;
  final String from;
  final Steps steps;
  final String ttdRt;
  final String ttdRw;
  final String nameRt;
  final String nameRw;
  final String idRt;
  final String idRw;

  const PengajuanSurat(
      {this.id = 0,
      this.name = '',
      this.tempat = '',
      this.birthDate,
      this.jenisKelamin = JenisKelamin.man,
      this.agama = '',
      this.pekerjaan = '',
      this.nik = '',
      this.alamat = '',
      this.keperluan = '',
      this.noSurat = '',
      this.createdAt,
      this.rt = 0,
      this.from = '',
      this.steps = Steps.pengajuan,
      this.ttdRt = "",
      this.ttdRw = "",
      this.nameRt = "",
      this.nameRw = "",
      this.idRt = "",
      this.idRw = ""});

  factory PengajuanSurat.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return PengajuanSuratMapper.fromMap(json);
    if (json is String) return PengajuanSuratMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }

  Map<String, dynamic> get insertTtdRT => {
        'ttd_rt': ttdRt,
        'no_surat': noSurat,
        'steps': steps.toValue(),
        'id_rt': idRt,
        'name_rt': nameRt
      };

  Map<String, dynamic> get insertTtdRW => {
        'ttd_rw': ttdRw,
        'steps': steps.toValue(),
        'id_rw': idRw,
        'name_rw': nameRw
      };

  Map<String, dynamic> get insertPengajuanSurat => {
        'name': name,
        'tempat': tempat,
        'birth_date': birthDate?.toIso8601String(),
        'jenis_kelamin': jenisKelamin.toValue(),
        'agama': agama,
        'pekerjaan': pekerjaan,
        'nik': nik,
        'alamat': alamat,
        'keperluan': keperluan,
        'rt': rt,
        'from': from,
        'steps': steps.toValue()
      };
}
