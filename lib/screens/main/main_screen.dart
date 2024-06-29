import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../data/status_auth.dart';
import '../../di/injection.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import '../notif/notification_screen.dart';
import '../profile/profile_screen.dart';
import 'cubit/main_screen_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainScreenCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<MainScreenCubit>();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MainScreenCubit, MainScreenState>(
          bloc: _cubit,
          builder: (context, state) => _pages.elementAt(state.selectedIndex),
          listener: (context, state) {
            if (state.statusAuth == StatusAuth.register) {
              context.snackbar.showSnackBar(
                  SnackbarWidget(state.message, state: SnackbarState.error));
              AppRoute.clearAll(const LoginScreen());
            }
          }),
      bottomNavigationBar: BlocSelector<MainScreenCubit, MainScreenState, int>(
        bloc: _cubit,
        selector: (state) => state.selectedIndex,
        builder: (context, state) {
          return NavigationBar(
            selectedIndex: state,
            indicatorColor: War9aColors.primaryColor.withOpacity(0.6),
            destinations: _destinations,
            onDestinationSelected: _cubit.selectedTab,
          );
        },
      ),
    );
  }

  List<Widget> get _pages =>
      const [HomeScreen(), NotificationScreen(), ProfileScreen()];

  List<NavigationDestination> get _destinations => [
        NavigationDestination(
            icon: Assets.icons.icHome.svg(),
            selectedIcon: Assets.icons.icHome.svg(
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
            label: "Home"),
        NavigationDestination(
            icon: Assets.icons.icNotif.svg(),
            selectedIcon: Assets.icons.icNotif.svg(
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
            label: "Notifikasi"),
        NavigationDestination(
            icon: Assets.icons.icAkun.svg(),
            selectedIcon: Assets.icons.icAkun.svg(
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
            label: "Akun"),
      ];

  @override
  void dispose() async {
    super.dispose();
    await _cubit.close();
  }
}
