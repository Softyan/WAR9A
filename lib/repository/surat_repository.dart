import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/surat.dart';
import '../utils/export_utils.dart';

abstract class SuratRepository {
  Future<BaseResult<List<Surat>>> getDataSurat(
      {int page, bool isSuratMasuk, String? search});
  Future<BaseResult<Surat>> addSurat(Surat surat);
}

@Injectable(as: SuratRepository)
class SuratRepositoryImpl implements SuratRepository {
  final SupabaseClient _supabaseClient;

  SuratRepositoryImpl(this._supabaseClient);

  static const String suratMasukCol = "is_surat_masuk";
  static const String noSurat = "no_surat";
  static const String from = "from";
  static const String title = "title";
  static const String suratUrls = "surat_urls";
  static const String id = "id";

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

  @override
  Future<BaseResult<Surat>> addSurat(Surat surat) async {
    try {
      /// insert new surat
      final insertedSurat = await _supabaseClient
          .from(Constants.table.surat)
          .insert(surat.toInsertSurat)
          .select();
      var newSurat = Surat.fromJson(insertedSurat.first);

      /// upload surat image
      final File imageFile = File(surat.suratUrls.first);
      final String imageId =
          DateTime.now().formattedDate(pattern: "ddMMyyHHmm");
      final String uploadPath =
          "surat/surat${newSurat.id}_$imageId${p.extension(surat.suratUrls.first)}";
      await _supabaseClient.storage
          .from(Constants.table.surat)
          .upload(uploadPath, imageFile);

      /// get surat image url
      final String imageUrl = _supabaseClient.storage
          .from(Constants.table.surat)
          .getPublicUrl(uploadPath);

      /// update surat image
      final result = await _supabaseClient
          .from(Constants.table.surat)
          .update({
            suratUrls: [imageUrl]
          })
          .eq(id, newSurat.id)
          .select()
          .single();

      newSurat = Surat.fromJson(result);

      return DataResult(newSurat);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
