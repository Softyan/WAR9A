part of 'pengajuan_surat_cubit.dart';

@MappableClass()
class PengajuanSuratState extends BaseState with PengajuanSuratStateMappable {
  final List<Surat> listSurat;
  const PengajuanSuratState(
      {this.listSurat = const [], super.message, super.statusState});
}
