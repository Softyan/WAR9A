import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/surat.dart';
import '../../../repository/surat_repository.dart';

part 'data_surat_state.dart';
part 'data_surat_cubit.mapper.dart';

@injectable
class DataSuratCubit extends Cubit<DataSuratState> {
  final SuratRepository _suratRepository;
  DataSuratCubit(this._suratRepository) : super(const DataSuratState());

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
}
