import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/status_auth.dart';
import '../../di/injection.dart';
import '../../res/assets.gen.dart';
import '../../res/war9a_colors.dart';
import '../../utils/export_utils.dart';
import '../form/personal_form_screen.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashCubit _splashCubit;

  @override
  void initState() {
    super.initState();
    _splashCubit = getIt<SplashCubit>();
    Future.delayed(const Duration(seconds: 3), () {
      _splashCubit.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: War9aColors.primaryColor,
        body: BlocListener<SplashCubit, SplashState>(
          bloc: _splashCubit,
          listener: (context, state) {
            mapAuthState(state.statusAuth);
          },
          child: Center(
            child: Assets.images.logo.image(),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _splashCubit.close();
  }

  Future<void> mapAuthState(StatusAuth statusAuth) {
    if (statusAuth == StatusAuth.loggedIn) {
      return AppRoute.clearAll(const HomeScreen());
    }
    if (statusAuth == StatusAuth.preFillForm) {
      return AppRoute.clearAll(const PersonalFormScreen(fromSplashScreen: true,));
    }

    return AppRoute.clearAll(const LoginScreen());
  }
}
