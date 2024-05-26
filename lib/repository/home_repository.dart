import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/news.dart';
import '../utils/export_utils.dart';

abstract class HomeRepository {
  Future<BaseResult<List<News>>> getNews();
}

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _supabase;
  HomeRepositoryImpl(this._supabase);

  @override
  Future<BaseResult<List<News>>> getNews() async {
    try {
      final response = await _supabase.from(Constants.table.news).select();
      final news = response.map((element) => News.fromJson(element)).toList();
      return DataResult(news);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
