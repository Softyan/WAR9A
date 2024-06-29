import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/enums/profile_type.dart';
import '../../../models/user.dart';
import '../../../repository/profile_repository.dart';
import '../../../utils/export_utils.dart';

part 'profile_state.dart';
part 'profile_cubit.mapper.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  ProfileCubit(this._profileRepository) : super(const ProfileState());

  void getUser({User? user}) async {
    emit(state.copyWith(statusState: StatusState.loading));

    if (user != null) {
      final profileType = _setProfileType(user);
      final newState = state.copyWith(
          statusState: StatusState.idle, user: user, profileType: profileType);
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

  void changeStatusDataWarga(User? user) async {
    if (user == null) return;
    emit(state.copyWith(statusState: StatusState.loading));
    final User(:id, :isActiveWarga) = user;
    final result = await _profileRepository
        .updateWarga(id, data: {'is_active_warga': !isActiveWarga});

    final newState = result.when(
      result: (data) {
        logger.d("Updated User => $data");
        final profileType = _setProfileType(data);
        logger.d(profileType);
        return state.copyWith(
            statusState: StatusState.success,
            user: data,
            profileType: profileType,
            message: 'Data warga berhasil diubah');
      },
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

  ProfileType _setProfileType(User? user) {
    if (user == null) return ProfileType.logOut;
    if (user.isActiveWarga) {
      return ProfileType.deactive;
    } else {
      return ProfileType.active;
    }
  }
}
