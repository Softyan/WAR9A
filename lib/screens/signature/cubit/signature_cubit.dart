import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/enums/role.dart';
import '../../../models/enums/steps.dart';
import '../../../models/pengajuan_surat.dart';
import '../../../repository/profile_repository.dart';
import '../../../utils/export_utils.dart';

part 'signature_state.dart';
part 'signature_cubit.mapper.dart';

@injectable
class SignatureCubit extends Cubit<SignatureState> {
  final GlobalHelpers _globalHelpers;
  final ProfileRepository _profileRepository;
  SignatureCubit(
    this._globalHelpers,
    this._profileRepository,
  ) : super(const SignatureState());

  void init(PengajuanSurat pengajuanSurat) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _profileRepository.getCurrentUser(getOnline: true);

    final newState = result.when(
      result: (data) {
        final role = data.role;
        var newPengajuanSurat = pengajuanSurat;

        if (role == Role.rt) {
          newPengajuanSurat = newPengajuanSurat.copyWith(
              nameRt: data.name, idRt: data.id, steps: Steps.ttdRt);
        }

        if (role == Role.rw) {
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
