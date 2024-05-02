import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../data/data_result.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<BaseResult<String>> register(User user);
  Future<BaseResult<String>> login(String email, String password);
  Future<void> logOut();
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth);
  final supabase.GoTrueClient _auth;

  @override
  Future<BaseResult<String>> register(User newUser) async {
    final User(:email, :password) = newUser;
    if (email.isEmpty) return ErrorResult('Email cant be empty');
    if (password.isEmpty) return ErrorResult('Password cant be empty');
    try {
      final supabase.AuthResponse(:user) =
          await _auth.signUp(email: email, password: password);
      if (user == null) return ErrorResult('User not created');
      newUser = newUser.copyWith(id: user.id);
      return DataResult(newUser.name);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<String>> login(String email, String password) async {
    if (email.isEmpty) return ErrorResult('Email cant be empty');
    if (password.isEmpty) return ErrorResult('Password cant be empty');
    try {
      final supabase.AuthResponse(:user) =
          await _auth.signInWithPassword(password: password, email: email);
      if (user == null) return ErrorResult('User not found');
      // TODO : return data
      return DataResult("");
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<void> logOut() async => await _auth.signOut();
}
