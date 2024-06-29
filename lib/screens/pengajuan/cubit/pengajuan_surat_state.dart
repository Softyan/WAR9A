part of 'pengajuan_surat_cubit.dart';

@MappableClass()
class PengajuanSuratState extends BaseState with PengajuanSuratStateMappable {
  final List<PengajuanSurat> pengajuanSurats;
  const PengajuanSuratState(
      {this.pengajuanSurats = const [], super.message, super.statusState});
}
