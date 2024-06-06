import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/env.dart';
import 'di/injection.dart';
import 'res/war9a_colors.dart';
import 'screens/splash/splash_screen.dart';

import 'utils/export_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.anonKey);
  await setupDI();
  await initializeDateFormatting('id_ID');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Constants.appName,
        navigatorKey: AppRoute.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: War9aColors.primary),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
