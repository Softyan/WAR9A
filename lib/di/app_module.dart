import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
@injectable
abstract class AppModule {
  @singleton
  SupabaseClient get supabase => Supabase.instance.client;

  @singleton
  GoTrueClient get auth => supabase.auth;

  @preResolve
  @singleton
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();
}
