import 'package:flutter/material.dart';

import '../../res/export_res.dart';

class Button extends ElevatedButton {
  final String text;
  final ButtonStyle? newStyle;
  final double? elevation;
  final double? width;
  final double? height;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  Button(
    this.text, {
    super.key,
    this.newStyle,
    this.elevation,
    this.width,
    this.height = 50,
    this.borderRadius = 10,
    required super.onPressed,
    this.textStyle,
    this.backgroundColor,
  }) : super(
            child: Text(
              text,
              style: textStyle ?? War9aTextstyle.textButton,
            ),
            style: newStyle ??
                ElevatedButton.styleFrom(
                    elevation: elevation,
                    backgroundColor:
                        backgroundColor ?? War9aColors.primaryColor,
                    fixedSize: width != null && height != null
                        ? Size(width, height)
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius))));
}
