class Constants {
  Constants._();

  static const appName = "War9a";
  static const TableConstants table = TableConstants();
  static const SharedPreferencesConstants sharedPreferences = SharedPreferencesConstants();
}

class TableConstants {
  const TableConstants();
  final String user = "user";
  final String news = "news";
  final String surat = "surat";
  final String stepsSurat = "step_surat";
}

class SharedPreferencesConstants {
  const SharedPreferencesConstants();
  final String isPersonalForm = "is_personal_form";
  final String tempUserRegister = "temp_user_register";
  final String user = "user_json";
}
