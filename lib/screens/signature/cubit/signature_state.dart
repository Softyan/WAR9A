part of 'signature_cubit.dart';

@MappableClass()
class SignatureState extends BaseState with SignatureStateMappable {
  final Role role;
  final List<String> filePaths;
  final PengajuanSurat pengajuanSurat;
  const SignatureState(
      {super.message,
      super.statusState = StatusState.loading,
      this.filePaths = const [],
      this.role = Role.warga,
      this.pengajuanSurat = const PengajuanSurat()});
}
