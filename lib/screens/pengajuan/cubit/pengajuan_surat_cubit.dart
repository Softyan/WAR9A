import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/pengajuan_surat.dart';
import '../../../repository/pengajuan_surat_repository.dart';

part 'pengajuan_surat_state.dart';
part 'pengajuan_surat_cubit.mapper.dart';

@injectable
class PengajuanSuratCubit extends Cubit<PengajuanSuratState> {
  final PengajuanSuratRepository _pengajuanSuratRepository;
  PengajuanSuratCubit(this._pengajuanSuratRepository)
      : super(const PengajuanSuratState());

  void getPengajuanSurat() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _pengajuanSuratRepository.getListPengajuanSurat();

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.idle, pengajuanSurats: data),
      error: (message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }
}
