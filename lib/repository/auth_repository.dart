import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../data/status_auth.dart';
import '../models/user.dart' as model;
import '../utils/export_utils.dart';

abstract class AuthRepository {
  Future<BaseResult<String>> register(model.User user);
  Future<BaseResult<String>> login(String email, String password);
  Future<BaseResult<model.User>> insertUser(model.User user);
  BaseResult<StatusAuth> checkStatusAuth();
  Future<void> logOut();
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth, this._supabase, this._preferences);
  final GoTrueClient _auth;
  final SupabaseClient _supabase;
  final SharedPreferences _preferences;

  @override
  Future<BaseResult<String>> register(model.User newUser) async {
    final model.User(:email, :password) = newUser;
    if (email.isEmpty) return ErrorResult('Email cant be empty');
    if (password == null || password.isEmpty) {
      return ErrorResult('Password cant be empty');
    }
    try {
      final AuthResponse(:user) =
          await _auth.signUp(email: email, password: password);
      if (user == null) return ErrorResult('Can\'t register user');

      newUser = newUser.copyWith(id: user.id, password: null);

      await _preferences.setBool(
          Constants.sharedPreferences.isPersonalForm, true);
      await _preferences.setString(
          Constants.sharedPreferences.tempUserRegister, newUser.toJson());

      return DataResult("Berhasil menambahkan user");
    } on AuthException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<String>> login(String email, String password) async {
    if (email.isEmpty) return ErrorResult('Email cant be empty');
    if (password.isEmpty) return ErrorResult('Password cant be empty');
    try {
      final AuthResponse(:user) =
          await _auth.signInWithPassword(password: password, email: email);
      if (user == null) return ErrorResult('User not found');
      return DataResult("Login success");
    } on AuthException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<model.User>> insertUser(model.User user) async {
    try {
      final savedUser =
          _preferences.getString(Constants.sharedPreferences.tempUserRegister);

      if (savedUser == null || savedUser.isEmpty) {
        return ErrorResult("UserId is Empty");
      }

      final model.User(:id, :email) = model.User.fromJson(savedUser);

      user = user.copyWith(id: id, email: email);

      final result = await _supabase
          .from(Constants.table.user)
          .insert(user.toMap())
          .select();

      final userResult = model.User.fromJson(result[0]);

      await _preferences.remove(Constants.sharedPreferences.isPersonalForm);
      await _preferences.remove(Constants.sharedPreferences.tempUserRegister);

      await logOut();
      return DataResult(userResult);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } on AuthException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<void> logOut() => _auth.signOut();

  @override
  BaseResult<StatusAuth> checkStatusAuth() {
    try {
      Session? session = _auth.currentSession;
      final user = _auth.currentUser;

      bool? isPersonalForm =
          _preferences.getBool(Constants.sharedPreferences.isPersonalForm);
      String? tempUserRegister =
          _preferences.getString(Constants.sharedPreferences.tempUserRegister);

      if ((isPersonalForm != null && isPersonalForm) &&
          (tempUserRegister != null && tempUserRegister.isNotEmpty)) {
        return DataResult(StatusAuth.preFillForm);
      }

      if (session != null && user != null) {
        return DataResult(StatusAuth.loggedIn);
      }

      return DataResult(StatusAuth.register);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
