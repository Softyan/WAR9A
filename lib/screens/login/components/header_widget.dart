import 'package:flutter/material.dart';

import '../../../res/assets.gen.dart';
import '../../../res/war9a_colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: War9aColors.primaryColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(700, 150),
              bottomRight: Radius.elliptical(700, 150))),
      child: Center(child: Assets.images.logo2White.svg()),
    );
  }
}
