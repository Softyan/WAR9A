import 'package:flutter/material.dart';

import '../res/assets.gen.dart';
import '../res/war9a_colors.dart';

class HeaderWidget extends StatelessWidget {
  final double? height;
  const HeaderWidget({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: War9aColors.primaryColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(700, 150),
              bottomRight: Radius.elliptical(700, 150))),
      child: Center(child: Assets.images.logo2White.svg()),
    );
  }
}
