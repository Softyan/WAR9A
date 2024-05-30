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

  void getUser() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _profileRepository.getCurrentUser();

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.idle, user: data),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
