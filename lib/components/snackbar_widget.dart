import 'package:flutter/material.dart';

class SnackbarWidget extends SnackBar {
  final SnackbarState state;
  final String message;
  final Color? textColor;
  SnackbarWidget(this.message,
      {super.key,
      this.state = SnackbarState.normal,
      this.textColor,
      super.action,
      super.dismissDirection,
      super.duration})
      : super(
            content: Text(
              message,
              style: TextStyle(color: textColor),
            ),
            backgroundColor: getBackgroundColor(state));

  static Color? getBackgroundColor(SnackbarState state) {
    return switch (state) {
      SnackbarState.success => Colors.green[700],
      SnackbarState.error => Colors.red[700],
      _ => null
    };
  }
}

enum SnackbarState { normal, success, error }
