import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../data/base_state.dart';
import '../../../models/filter_warga.dart';
import '../../../models/user.dart';
import '../../../repository/warga_repository.dart';

part 'data_warga_state.dart';
part 'data_warga_cubit.mapper.dart';

class DataWargaCubit extends Cubit<DataWargaState> {
  final WargaRepository _wargaRepository;
  DataWargaCubit(this._wargaRepository) : super(const DataWargaState());

  void getDataWarga({String? search, FilterWarga? filter}) async {
    emit(state.copyWith(statusState: StatusState.loading));

    if (search != null) {
      search = search.isNotEmpty ? search : null;
    }

    final result = await _wargaRepository.getDataWarga(search, filter);

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.idle, users: data),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
