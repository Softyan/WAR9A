import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as client;

import '../data/data_result.dart';
import '../models/user.dart';
import '../utils/export_utils.dart';

abstract class WargaRepository {
  Future<BaseResult<List<User>>> getDataWarga(String? search, {int page});
}

@Injectable(as: WargaRepository)
class WargaRepositoryImpl implements WargaRepository {
  final client.SupabaseClient _supabase;
  final SharedPreferences _preferences;
  WargaRepositoryImpl(this._supabase, this._preferences);

  @override
  Future<BaseResult<List<User>>> getDataWarga(String? search,
      {int page = 1}) async {
    if (search != null && search.length <= 3) {
      return ErrorResult("Masukkan pencarian lebih dari 3 huruf");
    }
    try {
      final savedUser =
          _preferences.getString(Constants.sharedPreferences.user);
      if (savedUser == null || savedUser.isEmpty) {
        return ErrorResult("User is Empty");
      }
      final User(:id) = User.fromJson(savedUser);

      var query = _supabase.from(Constants.table.user).select().neq('id', id);

      if (search != null && search.isNotEmpty && search.length > 3) {
        query = query.ilike(
          search.isDigitOnly ? 'nik' : 'name',
          '%$search%',
        );
      }

      final response = await query.range((page - 1) * 10, page * 10).limit(10);

      final users = response.map((element) => User.fromJson(element)).toList();

      return DataResult(users);
    } on client.PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
