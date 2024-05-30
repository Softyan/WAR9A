import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/user.dart' as model;
import '../utils/export_utils.dart';

abstract class ProfileRepository {
  Future<BaseResult<model.User>> getCurrentUser();
}

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabase;
  final GoTrueClient _auth;
  final SharedPreferences _preferences;

  ProfileRepositoryImpl(this._supabase, this._auth, this._preferences);

  @override
  Future<BaseResult<model.User>> getCurrentUser() async {
    try {
      final savedUser =
          _preferences.getString(Constants.sharedPreferences.user);

      if (savedUser != null && savedUser.isNotEmpty) {
        final user = model.User.fromJson(savedUser);
        return DataResult(user);
      }

      final session = _auth.currentSession;
      final currentUser = _auth.currentUser;
      if (session == null || currentUser == null) {
        return ErrorResult('User not found');
      }

      final response = await _supabase
          .from(Constants.table.user)
          .select()
          .eq('id', currentUser.id)
          .maybeSingle();

      if (response == null || response.isEmpty) {
        return ErrorResult('User not found');
      }

      final user = model.User.fromJson(response);
      return DataResult(user);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } on AuthException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
