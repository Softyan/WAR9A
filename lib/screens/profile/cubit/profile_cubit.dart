import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/user.dart';
import '../../../repository/profile_repository.dart';

part 'profile_state.dart';
part 'profile_cubit.mapper.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  ProfileCubit(this._profileRepository) : super(const ProfileState());

  void getUser({User? user}) async {
    emit(state.copyWith(statusState: StatusState.loading));

    if (user != null) {
      final newState =
          state.copyWith(statusState: StatusState.idle, user: user);
      emit(newState);
      return;
    }
    final result = await _profileRepository.getCurrentUser();

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.idle, user: data),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }

  void hapusDataWarga(User user) async {
    emit(state.copyWith(statusState: StatusState.loading));
    final User(:id, :isActiveWarga) = user;
    final result = await _profileRepository
        .updateWarga(id, data: {'is_active_warga': !isActiveWarga});

    final newState = result.when(
      result: (data) => state.copyWith(
          statusState: StatusState.success,
          user: user,
          message: 'Data warga berhasil diubah'),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }

  void logOut() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _profileRepository.logOut();

    final newState = result.when(
      result: (data) => state.copyWith(statusState: StatusState.success),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
