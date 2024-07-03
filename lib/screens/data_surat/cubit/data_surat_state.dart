part of 'data_surat_cubit.dart';

@MappableClass()
class DataSuratState extends BaseState with DataSuratStateMappable {
  final List<Surat> surats;
  final Surat surat;
  final String pathImage;
  const DataSuratState(
      {super.message,
      super.statusState,
      this.surat = const Surat(),
      this.surats = const [],
      this.pathImage = ''});
}
