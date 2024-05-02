import 'package:flutter/material.dart';

extension AppContext on BuildContext {
  Size get mediaSize => MediaQuery.of(this).size;
  ScaffoldMessengerState get snackbar => ScaffoldMessenger.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}
