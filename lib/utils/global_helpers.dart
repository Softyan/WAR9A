import '../models/enums/jenis_kelamin.dart';

class GlobalHelpers {
  String genderMapping(JenisKelamin gender) {
    return switch (gender) {
      JenisKelamin.man => "Laki - Laki",
      JenisKelamin.women => "Perempuan"
    };
  }
}
