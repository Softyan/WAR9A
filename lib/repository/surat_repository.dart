import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/surat.dart';
import '../utils/export_utils.dart';

abstract class SuratRepository {
  
  Future<BaseResult<List<Surat>>> getDataSurat(
      {int page, bool isSuratMasuk, String? search});
}

@Injectable(as: SuratRepository)
class SuratRepositoryImpl implements SuratRepository {
  final SupabaseClient _supabaseClient;

  SuratRepositoryImpl(this._supabaseClient);

  static const String suratMasukCol = "is_surat_masuk";
  static const String noSurat = "no_surat";
  static const String from = "from";
  static const String title = "title";

  @override
  Future<BaseResult<List<Surat>>> getDataSurat(
      {int page = 1, bool isSuratMasuk = true, String? search}) async {
    try {
      var query = _supabaseClient
          .from(Constants.table.surat)
          .select()
          .eq(suratMasukCol, isSuratMasuk);

      if (search != null && search.isNotEmpty && search.length > 3) {
        query = query
            .textSearch(noSurat, search, type: TextSearchType.plain)
            .textSearch(from, search, type: TextSearchType.plain)
            .textSearch(title, search, type: TextSearchType.plain);
      }

      final response = await query.range((page - 1) * 10, page * 10).limit(10);

      final results =
          response.map((element) => Surat.fromJson(element)).toList();

      return DataResult(results);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
