import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/enums/jenis_kelamin.dart';
import '../../../models/pengajuan_surat.dart';
import '../../../repository/pengajuan_surat_repository.dart';
import '../../../repository/shared_preference_repository.dart';
import '../../../utils/logger.dart';

part 'form_pengajuan_surat_state.dart';
part 'form_pengajuan_surat_cubit.mapper.dart';

@injectable
class FormPengajuanSuratCubit extends Cubit<FormPengajuanSuratState> {
  final PengajuanSuratRepository _pengajuanSuratRepository;
  final SharedPreferenceRepository _preferenceRepository;
  FormPengajuanSuratCubit(
      this._pengajuanSuratRepository, this._preferenceRepository)
      : super(const FormPengajuanSuratState());

  void initial(PengajuanSurat? pengajuan) async {
    if (pengajuan != null) {
      emit(state.copyWith(pengajuanSurat: pengajuan));
      return;
    }

    final result = _preferenceRepository.getCurrentUser();
    logger.d("result: $result");
    final PengajuanSurat pengajuanSurat = PengajuanSurat(
        name: result?.name ?? "",
        birthDate: result?.birthDate,
        jenisKelamin: result?.jenisKelamin ?? JenisKelamin.man,
        nik: result?.nik ?? "",
        alamat: result?.alamat ?? "",
        rt: result?.rt ?? 0,
        from: result?.id ?? '');
    emit(state.copyWith(pengajuanSurat: pengajuanSurat));
  }

  void ajukanSuratPengajuan(PengajuanSurat pengajuanSurat) async {
    emit(state.copyWith(statusState: StatusState.loading));
    logger.d(pengajuanSurat);
    final result =
        await _pengajuanSuratRepository.ajukanSuratPengajuan(pengajuanSurat);
    final newState = result.when(
      result: (data) => state.copyWith(
          statusState: StatusState.success,
          message: "Berhasil mengajukan surat"),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
