import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/surat.dart';
import '../../../repository/surat_repository.dart';
import '../../../utils/export_utils.dart';

part 'data_surat_state.dart';
part 'data_surat_cubit.mapper.dart';

@injectable
class DataSuratCubit extends Cubit<DataSuratState> {
  final SuratRepository _suratRepository;
  final GlobalHelpers _globalHelpers;
  DataSuratCubit(this._suratRepository, this._globalHelpers)
      : super(const DataSuratState());

  void initial(Surat? newSurat) {
    emit(state.copyWith(surat: newSurat, pathImage: newSurat?.suratUrls.first));
  }

  void getDataSurat({bool isSuratMasuk = true, String? query}) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _suratRepository.getDataSurat(
        isSuratMasuk: isSuratMasuk, search: query);

    final newState = result.when(
      result: (data) =>
          state.copyWith(surats: data, statusState: StatusState.idle),
      error: (message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );

    emit(newState);
  }

  void addSurat(Surat surat) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _suratRepository.addSurat(surat);
    final newState = result.when(
      result: (data) => state.copyWith(
          surat: data,
          statusState: StatusState.success,
          message: "Surat has been added"),
      error: (message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }

  void pickImageSurat() async {
    emit(state.copyWith(statusState: StatusState.loading));
    final result = await _globalHelpers.pickFile();

    final newState = result.when(
        result: (String data) =>
            state.copyWith(pathImage: data, statusState: StatusState.idle),
        error: (String message) =>
            state.copyWith(statusState: StatusState.failure, message: message));

    emit(newState);
  }

  void deleteSurat(int id) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _suratRepository.deleteSurat(id);
    final newState = result.when(
        result: (String data) =>
            state.copyWith(statusState: StatusState.success, message: data),
        error: (String message) =>
            state.copyWith(statusState: StatusState.failure, message: message));
    emit(newState);
  }

  void updateSurat(Surat surat) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _suratRepository.updateSurat(surat);
    final newState = result.when(
        result: (Surat data) => state.copyWith(
            statusState: StatusState.success,
            surat: data,
            message: "Surat updated"),
        error: (String message) =>
            state.copyWith(statusState: StatusState.failure, message: message));
    emit(newState);
  }
}
