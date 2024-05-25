part of 'splash_cubit.dart';

@MappableClass()
class SplashState extends BaseState with SplashStateMappable {
  final StatusAuth statusAuth;
  const SplashState(
      {super.message,
      this.statusAuth = StatusAuth.register,
      super.statusState});
}
