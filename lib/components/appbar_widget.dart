import 'package:flutter/material.dart';

import '../res/export_res.dart';
import 'back_button_widget.dart';

typedef BackPressCallback = Function()?;

class AppbarWidget extends AppBar {
  final String name;
  final BackPressCallback onBackPressed;
  final bool showBackButton;
  final Color? backColor;

  AppbarWidget(this.name,
      {super.key,
      this.onBackPressed,
      super.actions,
      super.backgroundColor,
      this.backColor,
      this.showBackButton = true,
      super.systemOverlayStyle,
      super.scrolledUnderElevation = 0, // set 0 to remove shadow
      super.surfaceTintColor // for appbar color on scroll
      })
      : super(
            title: Text(name),
            leading: showBackButton
                ? BackButtonWidget(
                    onClick: onBackPressed,
                    color: backColor ?? War9aColors.primaryColor,
                  )
                : null);
}
