import 'package:flutter/material.dart';

import 'fonts.gen.dart';

class War9aTextstyle {
  War9aTextstyle._();

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.normal, fontSize: 14)
  static const TextStyle normal = TextStyle(
      fontFamily: FontFamily.poppins,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.black);

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.w600, fontSize: 30)
  static TextStyle title =
      normal.copyWith(fontWeight: FontWeight.w600, fontSize: 30);
}
