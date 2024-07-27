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
  Future<BaseResult<String>> deleteNews(int newsId);
  Future<BaseResult<News>> updateNews(News news);
}

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final SupabaseClient _supabase;
  NewsRepositoryImpl(this._supabase);

  final String newsTable = Constants.table.news;

  @override
  Future<BaseResult<List<News>>> getNews({int page = 1, String? search}) async {
    try {
      var query = _supabase.from(newsTable).select();

      if (search != null && search.isNotEmpty && search.length > 3) {
        query = query.textSearch('title', search, type: TextSearchType.plain);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range((page - 1) * 10, page * 10)
          .limit(10);

      final news = response.map((element) => News.fromJson(element)).toList();
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
      final imageUrl = await uploadCoverNews(newNews.image);

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

  @override
  Future<BaseResult<String>> deleteNews(int newsId) async {
    try {
      await _supabase.from(newsTable).delete().eq('id', newsId);
      return DataResult("News deleted successfully");
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<News>> updateNews(News news) async {
    try {
      final idNews = news.id;
      if (idNews <= 0) {
        return ErrorResult("News not found");
      }

      /// check image news
      final coverNews = news.image;
      if (coverNews.isEmpty) {
        return ErrorResult("Cover news not found");
      }

      /// upload cover news if file changed
      if (!coverNews.startsWith("http")) {
        final newCoverImg = await uploadCoverNews(coverNews);
        news = news.copyWith(image: newCoverImg);
      }

      final response = await _supabase
          .from(newsTable)
          .update(news.toMap())
          .eq('id', idNews)
          .select()
          .single();
      return DataResult(News.fromJson(response));
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  Future<String> uploadCoverNews(String imagePath) async {
    final File imageFile = File(imagePath);
    final String imageId = DateTime.now().formattedDate(pattern: "ddMMyyHHmm");
    final String uploadPath = "cover/news_$imageId${p.extension(imagePath)}";
    await _supabase.storage
        .from(Constants.table.news)
        .upload(uploadPath, imageFile);

    /// get cover image url
    final String imageUrl =
        _supabase.storage.from(newsTable).getPublicUrl(uploadPath);
    return imageUrl;
  }
}
