import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as client;

import '../data/data_result.dart';
import '../models/enums/role.dart';
import '../models/filter_warga.dart';
import '../models/user.dart';
import '../utils/export_utils.dart';
import 'shared_preference_repository.dart';

abstract class WargaRepository {
  Future<BaseResult<List<User>>> getDataWarga(
      String? search, FilterWarga? filter,
      {int page});
}

@Injectable(as: WargaRepository)
class WargaRepositoryImpl implements WargaRepository {
  final client.SupabaseClient _supabase;
  final SharedPreferenceRepository _sharedPreferenceRepository;
  WargaRepositoryImpl(this._supabase, this._sharedPreferenceRepository);

  @override
  Future<BaseResult<List<User>>> getDataWarga(
      String? search, FilterWarga? filter,
      {int page = 1}) async {
    if (search != null && search.length <= 3) {
      return ErrorResult("Masukkan pencarian lebih dari 3 huruf");
    }
    try {
      final savedUser = _sharedPreferenceRepository.getCurrentUser();
      final role = _sharedPreferenceRepository.getRole();
      if (savedUser == null) {
        return ErrorResult("User is Empty");
      }

      final User(:id, :rt) = savedUser;

      /// Base query
      var query = _supabase.from(Constants.table.user).select().neq('id', id);

      /// Filter by role & rt
      if (role == Role.rt) {
        query = query.eq('rt', rt);
      }

      /// Search with name or nik
      if (search != null && search.isNotEmpty && search.length > 3) {
        query = query.ilike(
          search.isDigitOnly() ? 'nik' : 'name',
          '%$search%',
        );
      }

      /// Filter
      if (filter != null) {
        final FilterWarga(:rt, :isStay) = filter;
        if (rt != null) query = query.eq('rt', rt);
        if (isStay != null) query = query.eq('is_stay', isStay);
      }

      /// Pagination
      final response = await query.range((page - 1) * 10, page * 10).limit(10);

      /// Mapping & response
      final users = response.map((element) => User.fromJson(element)).toList();

      return DataResult(users);
    } on client.PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
