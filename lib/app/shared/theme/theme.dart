import 'package:flutter/material.dart';

class AppTheme {
  // * Cores padrões do app
  static const Color primaryColor = Color(0xFFed543b); // Padrão do cliente
  static const Color accentColor = Color(0xFFf9bb10);

  // * Defalut app
  static const Color cinza = Color(0xFFebebeb);
  static const Color cinzaClaro = Color.fromRGBO(240, 242, 247, 1);

  static const TextStyle textStyleNegrito16 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  static const TextStyle textStyleNegrito14 = TextStyle(
      fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600);

  static ThemeData customTheme() {
    return ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: primaryColor,
        accentColor: accentColor,
        focusColor: primaryColor,
        cursorColor: primaryColor,
        // fontFamily: GoogleFonts.roboto().fontFamily,
        // textTheme: GoogleFonts.robotoTextTheme(),
        scaffoldBackgroundColor: cinza,
        buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.normal,
            height: 50,
            buttonColor: primaryColor));
  }
}
