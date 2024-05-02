import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
@injectable
abstract class AppModule {

  @singleton
  GoTrueClient get auth => Supabase.instance.client.auth;
}
