import 'dart:io';

import 'package:file_picker/file_picker.dart';

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
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

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
