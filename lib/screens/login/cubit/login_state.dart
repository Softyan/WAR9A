part of 'login_cubit.dart';

@MappableClass()
class LoginState extends BaseState with LoginStateMappable {
  final String message;

  const LoginState({this.message = "", super.statusState})
      : super(errorMessage: message);
}
