import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../data/base_state.dart';
import '../../../models/user.dart';
import '../../../repository/auth_repository.dart';

part 'register_cubit.mapper.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  RegisterCubit(this._authRepository) : super(const RegisterState());

  void register(User user) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _authRepository.register(user);
    final newState = result.when(
      result: (data) => state.copyWith(
          statusState: StatusState.success,
          message: data),
      error: (message) => state.copyWith(
          message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
