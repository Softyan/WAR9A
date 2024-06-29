import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/user.dart' as model;
import '../utils/export_utils.dart';

typedef Body = Map<String, dynamic>;

abstract class ProfileRepository {
  Future<BaseResult<model.User>> getCurrentUser();
  Future<BaseResult<model.User>> updateWarga(String id, {Body? data});
  Future<BaseResult<void>> logOut();
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

  @override
  Future<BaseResult<void>> logOut() async {
    try {
      final response = await _auth.signOut();
      _preferences.clear();
      return DataResult(response);
    } on AuthException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<model.User>> updateWarga(String id,
      {Map<String, dynamic>? data}) async {
    const idKey = "id";

    if (data == null) {
      return ErrorResult("Updated data cant be empty");
    }

    logger.d("Update Warga $id => $data");

    try {
      final response = await _supabase
          .from(Constants.table.user)
          .update(data)
          .eq(idKey, id)
          .select();

      logger.d(response);

      if (response.isEmpty) {
        return ErrorResult("User not found");
      }

      final newUser = model.User.fromJson(response.first);
      logger.d("Update Warga => $newUser");

      return DataResult(newUser);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return ErrorResult(e.message);
    } catch (e) {
      logger.e("Error Update Warga => $e");
      return ErrorResult("Error can't update user");
    }
  }
}
