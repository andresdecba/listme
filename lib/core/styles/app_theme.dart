import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    const seedColor = Colors.deepPurple;

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      listTileTheme: const ListTileThemeData(iconColor: seedColor),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          //side: MaterialStateProperty.resolveWith<BorderSide>((states) => const BorderSide(color: Colors.white)),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => Colors.cyan),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
          }),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) => const TextStyle(color: Colors.white)),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) => Colors.white),
        ),
      ),
    );
  }
}
