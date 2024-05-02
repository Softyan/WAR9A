import 'package:flutter/material.dart';

class AppSpacer extends StatelessWidget {
  final double size;
  final bool isHorizontal;
  const AppSpacer(this.size, {super.key, this.isHorizontal = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isHorizontal ? 0 : size,
      width: isHorizontal ? size : 0,
    );
  }
}
