part of 'data_surat_cubit.dart';

@MappableClass()
class DataSuratState extends BaseState with DataSuratStateMappable {
  final List<Surat> surats;
  const DataSuratState(
      {super.message, super.statusState, this.surats = const []});
}
