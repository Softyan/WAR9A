import 'package:flutter/material.dart';

import '../res/war9a_colors.dart';

class Button extends ElevatedButton {
  final String text;
  final ButtonStyle? newStyle;
  final double? elevation;
  final double? width;
  final double? height;
  final double borderRadius;
  Button(
    this.text, {
    super.key,
    this.newStyle,
    this.elevation,
    this.width,
    this.height,
    this.borderRadius = 10,
    required super.onPressed,
  }) : super(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: newStyle ??
                ElevatedButton.styleFrom(
                    elevation: elevation,
                    backgroundColor: War9aColors.primaryColor,
                    fixedSize: Size(width ?? 100, height ?? 50),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)))));
}
