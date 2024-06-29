import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/enums/role.dart';
import '../models/notification.dart';
import '../models/notification_data.dart';
import '../models/pengajuan_surat.dart';
import '../models/user.dart' as model;
import '../utils/export_utils.dart';
import 'notification_repository.dart';

abstract class PengajuanSuratRepository {
  Future<BaseResult<List<PengajuanSurat>>> getListPengajuanSurat({int page});
  Future<BaseResult<PengajuanSurat>> ajukanSuratPengajuan(
      PengajuanSurat pengajuanSurat);
}

@Injectable(as: PengajuanSuratRepository)
class PengajuanSuratRepositoryImpl implements PengajuanSuratRepository {
  PengajuanSuratRepositoryImpl(this._supabase, this._notificationRepository);
  final SupabaseClient _supabase;
  final NotificationRepository _notificationRepository;

  String pengajuanSuratTable = Constants.table.pengajuaSurat;

  @override
  Future<BaseResult<List<PengajuanSurat>>> getListPengajuanSurat(
      {int page = 1}) async {
    try {
      final response = await _supabase
          .from(pengajuanSuratTable)
          .select()
          .order('created_at', ascending: false)
          .range((page - 1) * 10, page * 10)
          .limit(10);
      final surats =
          response.map((element) => PengajuanSurat.fromJson(element)).toList();
      return DataResult(surats);
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<PengajuanSurat>> ajukanSuratPengajuan(
      PengajuanSurat pengajuanSurat) async {
    try {
      logger.d("pengajuanSurat: ${pengajuanSurat.insertPengajuanSurat}");
      // pengajuan surat
      final response = await _supabase
          .from(pengajuanSuratTable)
          .insert(pengajuanSurat.insertPengajuanSurat)
          .select()
          .single();
      logger.d("response: $response");
      final newPengajuanSurat = PengajuanSurat.fromJson(response);

      // get reciver
      final userResponse = await _supabase
          .from(Constants.table.user)
          .select()
          .eq('role', Role.rt.toValue())
          .eq('rt', newPengajuanSurat.rt);
      logger.d(userResponse);
      if (userResponse.isEmpty) return DataResult(newPengajuanSurat);
      final receiver = model.User.fromJson(userResponse.first);
      logger.d("reciver => $userResponse");

      // send notification
      final notifData = NotificationData(
          type: NotificationDataType.pengajuan, id: newPengajuanSurat.id);
      final notif = Notification(
          from: newPengajuanSurat.from,
          to: receiver.id,
          message: "Pengajuan Surat Baru",
          userType: Role.rt,
          data: notifData.toMap());

      logger.d("notif: $notif");

      final notifResponse =
          await _notificationRepository.createNotification(notif);

      logger.d("notifResponse: $notifResponse");

      if (notifResponse is ErrorResult) {
        return ErrorResult(notifResponse.onErrorResult);
      }

      return DataResult(newPengajuanSurat);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return ErrorResult(e.message);
    } catch (e) {
      logger.e("Error $e");
      return ErrorResult(e.toString());
    }
  }
}
