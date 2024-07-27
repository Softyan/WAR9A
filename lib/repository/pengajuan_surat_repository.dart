import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/data_result.dart';
import '../models/enums/role.dart';
import '../models/enums/steps.dart';
import '../models/notification.dart';
import '../models/notification_data.dart';
import '../models/pengajuan_surat.dart';
import '../models/user.dart' as model;
import '../screens/preview_pengajuan/surat_pengajuan_template.dart';
import '../utils/export_utils.dart';
import 'notification_repository.dart';
import 'shared_preference_repository.dart';

abstract class PengajuanSuratRepository {
  Future<BaseResult<List<PengajuanSurat>>> getListPengajuanSurat({int page});
  Future<BaseResult<PengajuanSurat>> ajukanSuratPengajuan(
      PengajuanSurat pengajuanSurat);
  Future<BaseResult<PengajuanSurat>> updateTtdPengajuan(
      PengajuanSurat pengajuanSurat);
  Future<BaseResult<PengajuanSurat>> finishPengajuan(
      PengajuanSurat pengajuanSurat);
  Future<BaseResult<void>> downloadPengajuan(PengajuanSurat pengajuanSurat);
}

@Injectable(as: PengajuanSuratRepository)
class PengajuanSuratRepositoryImpl implements PengajuanSuratRepository {
  PengajuanSuratRepositoryImpl(this._supabase, this._notificationRepository,
      this._pengajuanTemplate, this._sharedPreferenceRepository);
  final SupabaseClient _supabase;
  final NotificationRepository _notificationRepository;
  final SuratPengajuanTemplate _pengajuanTemplate;
  final SharedPreferenceRepository _sharedPreferenceRepository;

  String pengajuanSuratTable = Constants.table.pengajuaSurat;
  String userTable = Constants.table.user;

  @override
  Future<BaseResult<List<PengajuanSurat>>> getListPengajuanSurat(
      {int page = 1}) async {
    try {
      final role = _sharedPreferenceRepository.getRole();
      final user = _sharedPreferenceRepository.getCurrentUser();

      if (user == null) {
        return ErrorResult("User not found");
      }

      var query = _supabase.from(pengajuanSuratTable).select();

      if (role == Role.warga) {
        query = query.eq('from', user.id);
      }

      if (role == Role.rt) {
        query = query.eq('rt', user.rt);
      }

      final response = await query
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

  @override
  Future<BaseResult<PengajuanSurat>> updateTtdPengajuan(
      PengajuanSurat pengajuanSurat) async {
    try {
      /// check current user
      model.User? currentUser = _sharedPreferenceRepository.getCurrentUser();
      if (currentUser == null) return ErrorResult("User tidak ditemukan");
      final numRt = currentUser.rt;

      // upload ttd if empty or if not urlscheme
      final currentRole = _sharedPreferenceRepository.getRole();
      String sourceTtd = switch (currentRole) {
        Role.rt => pengajuanSurat.ttdRt,
        Role.rw => pengajuanSurat.ttdRw,
        _ => "",
      };

      if (sourceTtd.isEmpty) {
        return ErrorResult("Tanda tangan tidak boleh kosong");
      }

      if (!sourceTtd.isUrl()) {
        final File ttdFile = File(sourceTtd);
        final String role = switch (currentRole) {
          Role.rt => "RT",
          Role.rw => "RW",
          _ => "",
        };

        /// upload ttd
        final String ttdId =
            DateTime.now().formattedDate(pattern: "ddMMyyHHmm");
        final String uploadPath =
            "ttd/${role}_$numRt-$ttdId${p.extension(sourceTtd)}";

        await _supabase.storage.from(userTable).upload(uploadPath, ttdFile);

        /// get cover image url
        sourceTtd = _supabase.storage.from(userTable).getPublicUrl(uploadPath);
      }

      logger.d(sourceTtd);

      if (!sourceTtd.isUrl()) {
        return ErrorResult("Gagal upload tanda tangan");
      }

      final updateTtdUserMap = {'ttd': sourceTtd};

      logger.d("updateTtdUserMap: $updateTtdUserMap | id: ${currentUser.id}");

      // update ttd
      final responseUser = await _supabase
          .from(userTable)
          .update(updateTtdUserMap)
          .eq('id', currentUser.id)
          .select()
          .single();
      logger.d("responseUser: $responseUser");

      currentUser = model.User.fromJson(responseUser);

      _sharedPreferenceRepository.setCurrentUser(currentUser);

      // update ttd inside pengajuan
      var bodyUpdatePengajuan = {};
      if (currentRole == Role.rw) {
        pengajuanSurat = pengajuanSurat.copyWith(
            ttdRw: sourceTtd, idRw: currentUser.id, nameRw: currentUser.name);
        bodyUpdatePengajuan = pengajuanSurat.insertTtdRW;
      }

      if (currentRole == Role.rt) {
        pengajuanSurat = pengajuanSurat.copyWith(
            ttdRt: sourceTtd, idRt: currentUser.id, nameRt: currentUser.name);
        bodyUpdatePengajuan = pengajuanSurat.insertTtdRT;
      }

      logger.d("bodyUpdatePengajuan: $bodyUpdatePengajuan");

      // update pengajuan
      final response = await _supabase
          .from(pengajuanSuratTable)
          .update(bodyUpdatePengajuan)
          .eq('id', pengajuanSurat.id)
          .select()
          .single();

      logger.d("response: $response");

      // send notification to rw
      // TODO : send notification to rw
      return DataResult(PengajuanSurat.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e("Postgrest Exception: ${e.message}");
      return ErrorResult(e.message);
    } on StorageException catch (e) {
      logger.e("Storage Exception: ${e.message}");
      return ErrorResult(e.message);
    } catch (e) {
      logger.e(e.toString());
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<void>> downloadPengajuan(
      PengajuanSurat pengajuanSurat) async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        late final PermissionStatus status;

        if (androidInfo.version.sdkInt <= 32) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.photos.request();
        }

        if (status.isDenied) {
          return ErrorResult("Permission Storage Denied");
        }
      }

      final response = await _pengajuanTemplate.downloadPdf(pengajuanSurat);
      return DataResult(response);
    } catch (e) {
      logger.e(e.toString());
      return ErrorResult(e.toString());
    }
  }

  @override
  Future<BaseResult<PengajuanSurat>> finishPengajuan(
      PengajuanSurat pengajuanSurat) async {
    final PengajuanSurat(:id, :steps) = pengajuanSurat;
    try {
      final response = await _supabase
          .from(pengajuanSuratTable)
          .update({'steps': steps.toValue()})
          .eq('id', id)
          .select()
          .single();

      logger.d("response: $response");
      return DataResult(PengajuanSurat.fromJson(response));
    } on PostgrestException catch (e) {
      return ErrorResult(e.message);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
