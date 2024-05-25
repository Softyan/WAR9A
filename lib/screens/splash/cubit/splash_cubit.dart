import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../data/status_auth.dart';
import '../../../repository/auth_repository.dart';

part 'splash_state.dart';
part 'splash_cubit.mapper.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final AuthRepository _authRepository;

  SplashCubit(this._authRepository) : super(const SplashState());

  void init() {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = _authRepository.checkStatusAuth();

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.success, statusAuth: data),
      error: (message) => state.copyWith(
          message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
