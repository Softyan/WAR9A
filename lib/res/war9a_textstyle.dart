import 'package:flutter/material.dart';

import 'export_res.dart';

class War9aTextstyle {
  War9aTextstyle._();

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.normal, fontSize: 14)
  static const TextStyle normal = TextStyle(
      fontFamily: FontFamily.poppins,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.black);

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.w600, fontSize: 10)
  static TextStyle primaryW600Font10 = TextStyle(
      fontFamily: FontFamily.poppins,
      fontWeight: FontWeight.w600,
      fontSize: 10,
      color: War9aColors.primaryColor);

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.w600, fontSize: 16)
  static TextStyle blackW600Font16 = const TextStyle(
      fontFamily: FontFamily.poppins,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.black);

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.w500, fontSize: 13)
  static TextStyle blackW500Font13 = const TextStyle(
      fontFamily: FontFamily.poppins,
      fontWeight: FontWeight.w500,
      fontSize: 13,
      color: Colors.black);

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.w700, fontSize: 18)
  static TextStyle w700_18 =
      normal.copyWith(fontWeight: FontWeight.w700, fontSize: 18);

  /// TextStyle(fontFamily: FontFamily.poppins, fontWeight: FontWeight.w600, fontSize: 30)
  static TextStyle title =
      normal.copyWith(fontWeight: FontWeight.w600, fontSize: 30);
}
