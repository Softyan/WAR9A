import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../data/base_state.dart';
import '../../../data/status_auth.dart';
import '../../../repository/auth_repository.dart';

part 'login_cubit.mapper.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  void login(String email, String password) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final resultCheckAuth = _authRepository.checkStatusAuth();

    LoginState newState = resultCheckAuth.when(
        result: (data) => state.copyWith(
              statusState: data == StatusAuth.preFillForm
                  ? StatusState.failure
                  : StatusState.loading,
              statusAuth: data,
              message: "You must pre-fill your personal data first",
            ),
        error: (message) =>
            state.copyWith(message: message, statusState: StatusState.failure));

    emit(newState);
    if (newState.statusAuth == StatusAuth.preFillForm) return;

    final result = await _authRepository.login(email, password);

    newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.success, message: data),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
