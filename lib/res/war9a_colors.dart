import 'package:flutter/material.dart';

class War9aColors {
  War9aColors._();

  static Color primaryColor = HexColor('#00639B');
  static Color blueInfo = HexColor('#D4F5FF');
  static Color blueTextInfo = HexColor('#0092DC');
  static Color grey = HexColor('#E2E2E2');
  static Color grey2 = HexColor('#F2F2F2');
  
  static MaterialColor primary = MaterialColor(
    primaryColor.value,
    const <int, Color>{
      50: Color.fromRGBO(0, 99, 155, 0.1),
      100: Color.fromRGBO(0, 99, 155, 0.2),
      200: Color.fromRGBO(0, 99, 155, 0.3),
      300: Color.fromRGBO(0, 99, 155, 0.4),
      400: Color.fromRGBO(0, 99, 155, 0.5),
      500: Color.fromRGBO(0, 99, 155, 0.6),
      600: Color.fromRGBO(0, 99, 155, 0.7),
      700: Color.fromRGBO(0, 99, 155, 0.6),
      800: Color.fromRGBO(0, 99, 155, 0.8),
      900: Color.fromRGBO(0, 99, 155, 0.9),
    },
  );
}

class HexColor extends Color {
  HexColor(String hexColor) : super(getColorFromHex(hexColor));

  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    return int.parse(hexColor, radix: 16);
  }
}
