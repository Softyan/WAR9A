part of 'login_cubit.dart';

@MappableClass()
class LoginState extends BaseState with LoginStateMappable {
  final StatusAuth statusAuth;

  const LoginState({super.message, super.statusState, this.statusAuth = StatusAuth.register, });
}
