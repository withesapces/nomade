import 'package:flutter/material.dart';

/// Palette « bitume au coucher du soleil ».
class Palette {
  static const asphalt = Color(0xFF1C1916);
  static const asphaltLight = Color(0xFF2A2521);
  static const sunset = Color(0xFFF2A65A);
  static const ember = Color(0xFFE76F51);
  static const cream = Color(0xFFF4EDE4);
  static const dust = Color(0xFFA89F94);
  static const sage = Color(0xFF8AB17D);
  static const danger = Color(0xFFE63946);
}

ThemeData buildTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.sunset,
      brightness: Brightness.dark,
      surface: Palette.asphalt,
    ),
    scaffoldBackgroundColor: Palette.asphalt,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: Palette.cream,
      displayColor: Palette.cream,
    ),
  );
}
