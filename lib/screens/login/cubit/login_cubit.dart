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

    LoginState newState = _checkPrefillForm();
    emit(newState);
    if (newState.statusAuth == StatusAuth.preFillForm) return;

    emit(await _loginUser(email, password));

    emit(await _checkUserDb());
  }

  LoginState _checkPrefillForm() {
    final resultCheckAuth = _authRepository.checkStatusAuth();
    return resultCheckAuth.when(
        result: (data) => state.copyWith(
              statusState: data == StatusAuth.preFillForm
                  ? StatusState.failure
                  : StatusState.loading,
              statusAuth: data,
              message: "You must pre-fill your personal data first",
            ),
        error: (message) =>
            state.copyWith(message: message, statusState: StatusState.failure));
  }

  Future<LoginState> _loginUser(String email, String password) async {
    final result = await _authRepository.login(email, password);

    return result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.loading, message: data),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
  }

  Future<LoginState> _checkUserDb() async {
    final result = await _authRepository.checkUserDb();
    return result.when(
      result: (data) => state.copyWith(
          statusState: data == null ? StatusState.failure : StatusState.success,
          statusAuth:
              data == null ? StatusAuth.preFillForm : StatusAuth.loggedIn,
          message: data == null
              ? "You must pre-fill your personal data first"
              : state.message),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
  }
}
