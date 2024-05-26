part of 'main_screen_cubit.dart';

@MappableClass()
class MainScreenState extends BaseState with MainScreenStateMappable {
  final int selectedIndex;
  final StatusAuth statusAuth;

  const MainScreenState({
    super.message,
    super.statusState,
    this.selectedIndex = 0,
    this.statusAuth = StatusAuth.loggedIn,
  });
}
