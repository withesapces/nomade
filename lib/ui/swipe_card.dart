import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../engine/models.dart';
import 'theme.dart';

/// Carte que l'on fait glisser. Pendant le glissement, le libellé du choix
/// apparaît en haut de la carte et le parent reçoit la direction (-1..1)
/// pour afficher l'aperçu sur les jauges.
class SwipeCard extends StatefulWidget {
  final Character who;
  final String leftLabel;
  final String rightLabel;
  final ValueChanged<double> onDrag;
  final ValueChanged<bool> onSwipe; // true = droite

  const SwipeCard({
    super.key,
    required this.who,
    required this.leftLabel,
    required this.rightLabel,
    required this.onDrag,
    required this.onSwipe,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> with SingleTickerProviderStateMixin {
  static const _threshold = 90.0;
  late final AnimationController _ctrl;
  double _dx = 0;
  bool _gone = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _animateTo(double target, {VoidCallback? done}) {
    final start = _dx;
    final anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    void tick() => setState(() => _dx = start + (target - start) * anim.value);
    _ctrl.addListener(tick);
    _ctrl.forward(from: 0).whenCompleteOrCancel(() {
      _ctrl.removeListener(tick);
      done?.call();
    });
  }

  void _commit(bool right) {
    if (_gone) return;
    _gone = true;
    final w = MediaQuery.of(context).size.width;
    _animateTo(right ? w * 1.4 : -w * 1.4, done: () => widget.onSwipe(right));
  }

  @override
  Widget build(BuildContext context) {
    final t = (_dx / _threshold).clamp(-1.0, 1.0);
    final label = t > 0.15
        ? widget.rightLabel
        : t < -0.15
            ? widget.leftLabel
            : null;

    return GestureDetector(
      onHorizontalDragStart: (_) => _ctrl.stop(),
      onHorizontalDragUpdate: (d) {
        if (_gone) return;
        setState(() => _dx += d.delta.dx);
        widget.onDrag((_dx / _threshold).clamp(-1.0, 1.0));
      },
      onHorizontalDragEnd: (d) {
        if (_gone) return;
        final v = d.primaryVelocity ?? 0;
        if (_dx.abs() > _threshold || v.abs() > 900) {
          _commit(v.abs() > 900 ? v > 0 : _dx > 0);
        } else {
          widget.onDrag(0);
          _animateTo(0);
        }
      },
      child: Transform.translate(
        offset: Offset(_dx, _dx.abs() * 0.08),
        child: Transform.rotate(
          angle: _dx / 900 * math.pi / 2,
          child: AspectRatio(
            aspectRatio: 290 / 354,
            child: Container(
              decoration: BoxDecoration(
                color: Color(widget.who.color),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, 12)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture.asset(
                    widget.who.asset,
                    fit: BoxFit.cover,
                    semanticsLabel: widget.who.name,
                  ),
                  // Voile sombre + libellé du choix en haut
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 120),
                    opacity: label == null ? 0 : 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [Color(0xEE141210), Color(0x00141210)],
                        ),
                      ),
                      alignment: t > 0 ? Alignment.topRight : Alignment.topLeft,
                      padding: const EdgeInsets.all(22),
                      child: Text(
                        label ?? '',
                        textAlign: t > 0 ? TextAlign.right : TextAlign.left,
                        style: display(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
