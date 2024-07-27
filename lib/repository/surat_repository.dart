import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/enums/role.dart';
import '../models/surat.dart';
import '../models/user.dart' as model;
import '../utils/export_utils.dart';
import 'shared_preference_repository.dart';

abstract class SuratRepository {
  Future<BaseResult<List<Surat>>> getDataSurat(
      {int page, bool isSuratMasuk, String? search});
  Future<BaseResult<Surat>> addSurat(Surat surat);
  Future<BaseResult<Surat>> updateSurat(Surat surat);
  Future<BaseResult<String>> deleteSurat(int id);
}

@Injectable(as: SuratRepository)
class SuratRepositoryImpl implements SuratRepository {
  final SupabaseClient _supabaseClient;
  final SharedPreferenceRepository _preferenceRepository;

  SuratRepositoryImpl(this._supabaseClient, this._preferenceRepository);

  final String suratTable = Constants.table.surat;
  static const String suratMasukCol = "is_surat_masuk";
  static const String noSurat = "no_surat";
  static const String from = "from";
  static const String title = "title";
  static const String suratUrls = "surat_urls";
  static const String idCol = "id";
  static const String roleCol = "role";
  static const String rt = "rt";

  @override
  Future<BaseResult<List<Surat>>> getDataSurat(
      {int page = 1, bool isSuratMasuk = true, String? search}) async {
    try {
      final role = _preferenceRepository.getRole();
      final currentUser = _preferenceRepository.getCurrentUser();

      if (currentUser == null) {
        return ErrorResult("User not found");
      }

      var query = _supabaseClient
          .from(suratTable)
          .select()
          .eq(suratMasukCol, isSuratMasuk);

      if (role == Role.rt) {
        query = query.eq(rt, currentUser.rt);
      }

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
      final currentUser = _preferenceRepository.getCurrentUser();
      if (currentUser == null) {
        return ErrorResult("User not found");
      }

      final model.User(:role, :rt) = currentUser;

      surat = surat.copyWith(role: role, rt: rt);

      /// insert new surat
      final insertedSurat = await _supabaseClient
          .from(suratTable)
          .insert(surat.toInsertSurat)
          .select();
      var newSurat = Surat.fromJson(insertedSurat.first);

      /// upload surat image
      if (suratUrls.isEmpty) {
        return ErrorResult("File surat not found");
      }
      final imageUrl = await _uploadNewSurat(newSurat.id, surat.suratUrls);

      /// update surat image
      final result = await _supabaseClient
          .from(suratTable)
          .update({
            suratUrls: [imageUrl]
          })
          .eq(idCol, newSurat.id)
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

  @override
  Future<BaseResult<String>> deleteSurat(int id) async {
    try {
      if (id <= 0) {
        return ErrorResult("Surat not found");
      }
      await _supabaseClient.from(suratTable).delete().eq(idCol, id);
      return DataResult("Surat deleted successfully");
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<Surat>> updateSurat(Surat surat) async {
    try {
      final Surat(:id, :suratUrls) = surat;
      if (id <= 0) {
        return ErrorResult("Surat not found");
      }

      /// check surat
      if (suratUrls.isEmpty) {
        return ErrorResult("File surat not found");
      }

      /// upload surat if file changed
      if (!suratUrls.first.startsWith("http")) {
        final imageUrl = await _uploadNewSurat(id, surat.suratUrls);
        surat = surat.copyWith(suratUrls: [imageUrl]);
      }

      /// update surat
      final response = await _supabaseClient
          .from(suratTable)
          .update(surat.toMap())
          .eq(idCol, id)
          .select()
          .single();
      final newSurat = Surat.fromJson(response);
      return DataResult(newSurat);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  Future<String> _uploadNewSurat(int id, List<String> suratUrls) async {
    final File imageFile = File(suratUrls.first);
    final String imageId = DateTime.now().formattedDate(pattern: "ddMMyyHHmm");
    final String uploadPath =
        "surat/surat${id}_$imageId${p.extension(suratUrls.first)}";
    await _supabaseClient.storage
        .from(suratTable)
        .upload(uploadPath, imageFile);

    /// get surat image url
    final String imageUrl =
        _supabaseClient.storage.from(suratTable).getPublicUrl(uploadPath);
    return imageUrl;
  }
}
