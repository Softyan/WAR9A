import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enums/role.dart';
import '../models/user.dart';
import '../utils/export_utils.dart';

abstract class SharedPreferenceRepository {
  User? getCurrentUser();
  Role getRole();
}

@Injectable(as: SharedPreferenceRepository)
class SharedPreferenceRepositoryImpl implements SharedPreferenceRepository {
  final SharedPreferences _sharedPreferences;
  SharedPreferenceRepositoryImpl(this._sharedPreferences);

  @override
  User? getCurrentUser() {
    try {
      final json =
          _sharedPreferences.getString(Constants.sharedPreferences.user);
      if (json == null || json.isEmpty) return null;
      return User.fromJson(json);
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
  
  @override
  Role getRole() {
    final user = getCurrentUser();
    return user?.role ?? Role.warga;
  }
}
