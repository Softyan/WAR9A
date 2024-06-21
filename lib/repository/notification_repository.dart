import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as client;

import '../data/data_result.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../utils/export_utils.dart';
import 'shared_preference_repository.dart';

abstract class NotificationRepository {
  Future<BaseResult<List<Notification>>> getListNotification({int page});
  Future<BaseResult<List<Notification>>> readAllNotification({int page});
  Future<BaseResult<void>> readNotification(String notificationId);
}

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final client.SupabaseClient _supabase;
  final SharedPreferenceRepository _sharedPreferenceRepository;
  NotificationRepositoryImpl(this._supabase, this._sharedPreferenceRepository);

  static const String toKey = "to";
  static const String idKey = "id";
  static const String createdAtKey = "created_at";
  static const String isReadKey = "is_read";

  @override
  Future<BaseResult<List<Notification>>> getListNotification(
      {int page = 1}) async {
    try {
      /// getting current user id
      final User? user = _sharedPreferenceRepository.getCurrentUser();

      if (user == null) return ErrorResult("User is Empty");
      final userId = user.id;

      if (userId.isEmpty) return ErrorResult("UserId is Empty");

      /// getting list notification
      final response = await _supabase
          .from(Constants.table.notification)
          .select()
          .eq(toKey, userId)
          .order(isReadKey, ascending: true)
          .order(createdAtKey, ascending: true)
          .range((page - 1) * 10, page * 10)
          .limit(10);
      final notifications =
          response.map((e) => Notification.fromJson(e)).toList();

      return DataResult(notifications);
    } on client.PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<List<Notification>>> readAllNotification(
      {int page = 1}) async {
    try {
      /// getting current user id
      final User? user = _sharedPreferenceRepository.getCurrentUser();

      if (user == null) return ErrorResult("User is Empty");
      final userId = user.id;

      if (userId.isEmpty) return ErrorResult("UserId is Empty");

      /// getting list notification again after read all updated
      final response = await _supabase
          .from(Constants.table.notification)
          .update({isReadKey: true})
          .eq(toKey, userId)
          .select()
          .order(isReadKey, ascending: true)
          .order(createdAtKey, ascending: true)
          .range((page - 1) * 10, page * 10)
          .limit(10);
      final notifications =
          response.map((e) => Notification.fromJson(e)).toList();

      notifications.sort((a, b) => a.id.compareTo(b.id));

      return DataResult(notifications);
    } on client.PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<void>> readNotification(String notificationId) async {
    try {
      if (notificationId.isEmpty) return ErrorResult("NotificationId is Empty");

      final response = await _supabase
          .from(Constants.table.notification)
          .update({isReadKey: true})
          .eq(idKey, notificationId)
          .select();

      if (response.isEmpty) return ErrorResult("Notification not found");

      return DataResult(null);
    } on client.PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
