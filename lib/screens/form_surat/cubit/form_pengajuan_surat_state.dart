part of 'form_pengajuan_surat_cubit.dart';

@MappableClass()
class FormPengajuanSuratState extends BaseState
    with FormPengajuanSuratStateMappable {
  final PengajuanSurat? pengajuanSurat;
  const FormPengajuanSuratState({super.message, super.statusState, this.pengajuanSurat, });
}
