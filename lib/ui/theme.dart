import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  static const chipBorder = Color(0xFF7A5634);
}

/// Titres : Bricolage Grotesque (police variable, on fixe la graisse).
TextStyle display(double size, {Color color = Palette.cream, double weight = 800, double spacing = 0}) {
  return TextStyle(
    fontFamily: 'Bricolage',
    fontSize: size,
    color: color,
    letterSpacing: spacing,
    height: 1.05,
    fontVariations: [FontVariation('wght', weight)],
  );
}

/// Icône SVG monochrome du dossier assets/icons, recoloriée.
class NIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color color;
  final String? label;
  const NIcon(this.name, {super.key, this.size = 22, this.color = Palette.cream, this.label});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      semanticsLabel: label,
      excludeFromSemantics: label == null,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

ThemeData buildTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Instrument',
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
      fontFamily: 'Instrument',
    ),
  );
}
