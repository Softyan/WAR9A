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
  final BorderSide? borderStyle;
  Button(
    this.text,{
    super.key,
    this.newStyle,
    this.elevation,
    this.width,
    this.height,
    this.borderRadius = 10,
    required super.onPressed,
    this.textStyle,
    this.backgroundColor,
    this.borderStyle
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
                    fixedSize: width != null || height != null ? Size(width ?? 100, height ?? 50) : null,
                    shape: RoundedRectangleBorder(
                        side: borderStyle ?? BorderSide.none,
                        borderRadius: BorderRadius.circular(borderRadius))));
}
