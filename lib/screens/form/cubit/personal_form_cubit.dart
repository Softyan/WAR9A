import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../data/base_state.dart';
import '../../../models/user.dart';
import '../../../repository/auth_repository.dart';

part 'personal_form_state.dart';
part 'personal_form_cubit.mapper.dart';

class PersonalFormCubit extends Cubit<PersonalFormState> {
  final AuthRepository _authRepository;
  PersonalFormCubit(this._authRepository) : super(const PersonalFormState());

  void addUser(User user) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _authRepository.insertUser(user);
    final newState = result.when(
      result: (data) => state.copyWith(
        statusState: StatusState.success,
        message: "Personal data added successfully",
      ),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}
