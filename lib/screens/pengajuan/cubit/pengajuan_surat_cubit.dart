import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/surat.dart';
import '../../../repository/surat_repository.dart';

part 'pengajuan_surat_state.dart';
part 'pengajuan_surat_cubit.mapper.dart';

@injectable
class PengajuanSuratCubit extends Cubit<PengajuanSuratState> {
  final SuratRepository _suratRepository;
  PengajuanSuratCubit(this._suratRepository)
      : super(const PengajuanSuratState());

  void getPengajuanSurat() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _suratRepository.getListPengajuanSurat();

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.idle, listSurat: data),
      error: (message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }
}
