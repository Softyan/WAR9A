import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/data_result.dart';
import '../models/enums/jenis_kelamin.dart';
import 'export_utils.dart';

class GlobalHelpers {
  String genderMapping(JenisKelamin gender) {
    return switch (gender) {
      JenisKelamin.man => "Laki - Laki",
      JenisKelamin.women => "Perempuan"
    };
  }

  /// Pick File image only 1 picked file with type image
  Future<BaseResult<String>> pickFile({double maxFileSize = 2.0}) async {
    try {
      logger.d("Awaiting pick image");

      if (Platform.isAndroid) {
        bool permissionStatus;
        final deviceInfo = await DeviceInfoPlugin().androidInfo;

        if (deviceInfo.version.sdkInt > 32) {
          permissionStatus = await Permission.photos.request().isGranted;
        } else {
          permissionStatus = await Permission.storage.request().isGranted;
        }

        if (!permissionStatus) {
          return ErrorResult("Permission denied");
        }
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ["jpg", "png", "jpeg"]);

      if (result == null) return ErrorResult("Canceled pick image");

      final String? path = result.files.first.path;
      if (path == null || path.isEmpty) {
        return ErrorResult("Path image is empty");
      }

      final file = File(path);
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > maxFileSize) {
        return ErrorResult("Image is bigger than 2 MB");
      }
      return DataResult(path);
    } catch (e) {
      return ErrorResult(e.toString());
    }
  }
}
