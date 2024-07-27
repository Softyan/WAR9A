import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../data/data_result.dart';
import '../../../models/enums/role.dart';
import '../../../models/enums/steps.dart';
import '../../../models/pengajuan_surat.dart';
import '../../../repository/pengajuan_surat_repository.dart';
import '../../../repository/profile_repository.dart';
import '../../../utils/export_utils.dart';

part 'signature_state.dart';
part 'signature_cubit.mapper.dart';

@injectable
class SignatureCubit extends Cubit<SignatureState> {
  final GlobalHelpers _globalHelpers;
  final ProfileRepository _profileRepository;
  final PengajuanSuratRepository _pengajuanSuratRepository;
  SignatureCubit(
    this._globalHelpers,
    this._profileRepository,
    this._pengajuanSuratRepository,
  ) : super(const SignatureState());

  void init(PengajuanSurat pengajuanSurat) async {
    emit(state.copyWith(statusState: StatusState.loading, filePaths: []));

    final pengajuanSuratId = pengajuanSurat.id;

    if (pengajuanSuratId <= 0) {
      emit(
        state.copyWith(
            message: "Pengajuan Surat Tidak Valid",
            statusState: StatusState.failure),
      );
      return;
    }

    var newPengajuanSurat = pengajuanSurat;

    // getting pengajuan surat from server
    final result =
        await _pengajuanSuratRepository.getPengajuanSurat(pengajuanSuratId);

    var newState = result.when(
      result: (data) {
        newPengajuanSurat = data;
        return state.copyWith(
            pengajuanSurat: data, statusState: StatusState.loading);
      },
      error: (message) => state.copyWith(
          message: message, statusState: StatusState.failure, filePaths: []),
    );

    emit(newState);

    if (result is ErrorResult) return;

    logger.d("newPengajuanSurat: $newPengajuanSurat");

    // check step
    final status = newPengajuanSurat.steps;
    if (status == Steps.diterima) {
      emit(newState.copyWith(statusState: StatusState.idle));
      return;
    }

    // getting current user
    final resultUser = await _profileRepository.getCurrentUser(getOnline: true);

    newState = resultUser.when(
      result: (data) {
        final role = data.role;

        if (role == Role.rt && status == Steps.pengajuan) {
          newPengajuanSurat = newPengajuanSurat.copyWith(
              nameRt: data.name, idRt: data.id, steps: Steps.ttdRt);
        }

        if (role == Role.rw && status == Steps.ttdRt) {
          newPengajuanSurat = pengajuanSurat.copyWith(
              nameRw: data.name, idRw: data.id, steps: Steps.ttdRw);
        }
        return state.copyWith(
            statusState: StatusState.idle,
            filePaths: data.ttd.isNotEmpty ? [data.ttd] : [],
            role: data.role,
            pengajuanSurat: newPengajuanSurat);
      },
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }

  void pickSignature() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _globalHelpers.pickFile();

    logger.d(result);

    final newState = result.when(
      result: (data) => state.copyWith(
          statusState: StatusState.idle,
          filePaths: data.isNotEmpty ? [data] : []),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
