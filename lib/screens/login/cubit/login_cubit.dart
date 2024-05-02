import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../data/base_state.dart';
import '../../../repository/auth_repository.dart';
import '../../../utils/logger.dart';

part 'login_cubit.mapper.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  void login(String email, String password) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _authRepository.login(email, password);

    final newState = result.when(
      result: (data) {},
      error: (message) {},
    );
    emit(newState);
  }
}
