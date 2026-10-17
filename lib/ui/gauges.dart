import 'package:flutter/material.dart';

import '../engine/models.dart';
import 'theme.dart';

/// Les quatre jauges en haut d'écran. Pas de chiffres, comme dans Reigns :
/// on voit le niveau, et un point au-dessus quand une carte va la toucher.
class GaugesBar extends StatelessWidget {
  final Map<Stat, int> values;
  final Map<Stat, int> preview; // ampleur absolue de l'effet à venir
  final bool previewRisky;
  final Map<Stat, int> flash; // dernier delta appliqué (couleur)

  const GaugesBar({
    super.key,
    required this.values,
    this.preview = const {},
    this.previewRisky = false,
    this.flash = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final s in Stat.values)
          _Gauge(
            stat: s,
            value: values[s] ?? 50,
            previewMagnitude: preview[s],
            risky: previewRisky,
            flash: flash[s] ?? 0,
          ),
      ],
    );
  }
}

class _Gauge extends StatelessWidget {
  final Stat stat;
  final int value;
  final int? previewMagnitude;
  final bool risky;
  final int flash;

  const _Gauge({
    required this.stat,
    required this.value,
    required this.previewMagnitude,
    required this.risky,
    required this.flash,
  });

  @override
  Widget build(BuildContext context) {
    final danger = value < 20 || value > 80;
    final fillColor = flash > 0
        ? Palette.sage
        : flash < 0
            ? Palette.ember
            : danger
                ? Palette.danger
                : Palette.sunset;

    final mag = previewMagnitude;
    final dotSize = mag == null || mag == 0 ? 0.0 : (mag >= 10 ? 12.0 : 7.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: risky ? Colors.transparent : Palette.cream,
                border: risky ? Border.all(color: Palette.cream, width: 2) : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 52,
          height: 64,
          decoration: BoxDecoration(
            color: Palette.asphaltLight,
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(end: value / 100),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                builder: (_, f, __) => FractionallySizedBox(
                  heightFactor: f.clamp(0.0, 1.0),
                  widthFactor: 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    color: fillColor.withValues(alpha: 0.85),
                  ),
                ),
              ),
              Center(child: Text(stat.icon, style: const TextStyle(fontSize: 26))),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(stat.label, style: const TextStyle(fontSize: 11, color: Palette.dust)),
      ],
    );
  }
}
