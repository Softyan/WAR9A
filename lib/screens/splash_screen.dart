import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../di/injection.dart';
import '../res/assets.gen.dart';
import '../res/war9a_colors.dart';
import '../utils/app_route.dart';
import '../utils/logger.dart';
import 'home/home_screen.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      getIt<GoTrueClient>().onAuthStateChange.listen((authState) {
        logger.i("Auth state changed: ${authState.event}");
        if (authState.event == AuthChangeEvent.signedIn) {
          AppRoute.to(const HomeScreen());
        } else {
          AppRoute.to(const LoginScreen());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: War9aColors.primaryColor,
        body: Center(
          child: Assets.images.logo.svg(),
        ));
  }
}
