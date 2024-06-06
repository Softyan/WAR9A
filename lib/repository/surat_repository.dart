import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/surat.dart';
import '../utils/export_utils.dart';

abstract class SuratRepository {
  Future<BaseResult<List<Surat>>> getListPengajuanSurat({int page});
}

@Injectable(as: SuratRepository)
class SuratRepositoryImpl implements SuratRepository {
  final SupabaseClient _supabaseClient;

  SuratRepositoryImpl(this._supabaseClient);

  @override
  Future<BaseResult<List<Surat>>> getListPengajuanSurat({int page = 1}) async {
    try {
      final response = await _supabaseClient
          .from(Constants.table.surat)
          .select()
          .range((page - 1) * 10, page * 10)
          .limit(10);
      final surats =
          response.map((element) => Surat.fromJson(element)).toList();
      return DataResult(surats);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
