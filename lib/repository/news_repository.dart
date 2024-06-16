import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/news.dart';
import '../utils/export_utils.dart';

abstract class NewsRepository {
  Future<BaseResult<List<News>>> getNews({int page = 1, String? search});
  Future<BaseResult<News>> addNews(News news);
}

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final SupabaseClient _supabase;
  NewsRepositoryImpl(this._supabase);

  @override
  Future<BaseResult<List<News>>> getNews({int page = 1, String? search}) async {
    try {
      var query = _supabase.from(Constants.table.news).select();

      if (search != null && search.isNotEmpty && search.length > 3) {
        query = query.textSearch('title', search, type: TextSearchType.plain);
      }

      final response = await query.range((page - 1) * 10, page * 10).limit(10);

      final news = response.map((element) => News.fromJson(element)).toList();
      // final news = List.generate(10, (i) => i + 1)
      //     .map(
      //       (e) => News(
      //           id: e,
      //           title:
      //               "News Title $e News Title $e News Title $e News Title $e",
      //           contents: [
      //             "1. lorem ipsum dolor sit amet",
      //             "2. lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet",
      //             "3. lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet"
      //           ],
      //           image:
      //               "https://plus.unsplash.com/premium_photo-1714051661316-4432704b02f8?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
      //     )
      //     .toList();
      return DataResult(news);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<News>> addNews(News news) async {
    try {
      /// insert new news
      final insertedNews = await _supabase
          .from(Constants.table.news)
          .insert(news.toInsertNews)
          .select();
      var newNews = News.fromJson(insertedNews.first);

      /// upload cover news
      final File imageFile = File(news.image);
      final String imageId =
          DateTime.now().formattedDate(pattern: "ddMMyyHHmm");
      final String uploadPath = "cover/news_$imageId${p.extension(news.image)}";
      await _supabase.storage
          .from(Constants.table.news)
          .upload(uploadPath, imageFile);

      /// get cover image url
      final String imageUrl =
          _supabase.storage.from(Constants.table.news).getPublicUrl(uploadPath);

      /// update cover image
      final result = await _supabase
          .from(Constants.table.news)
          .update({"image": imageUrl})
          .eq('id', newNews.id)
          .select();

      newNews = News.fromJson(result.first);

      return DataResult(newNews);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
