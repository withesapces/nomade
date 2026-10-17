import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../engine/engine.dart';
import '../engine/models.dart';
import 'end_screen.dart';
import 'gauges.dart';
import 'swipe_card.dart';
import 'theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameEngine _engine;
  late GameCard _card;
  int _cardSerial = 0;

  double _drag = 0;
  Map<Stat, int> _flash = const {};
  Timer? _flashTimer;

  // Écran de conséquence entre deux cartes.
  String? _resultText;
  List<String> _events = const [];

  @override
  void initState() {
    super.initState();
    _engine = GameEngine();
    _card = _engine.drawNext();
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  GameState get _s => _engine.state;

  void _onSwipe(bool right) {
    HapticFeedback.lightImpact();
    final res = _engine.choose(right: right);

    _flashTimer?.cancel();
    setState(() {
      _drag = 0;
      _flash = res.deltas;
    });
    _flashTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _flash = const {});
    });

    if (res.ending != null) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => EndScreen(
              ending: res.ending!,
              days: _s.day,
              lastWords: res.text,
            ),
            transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
          ),
        );
      });
      setState(() => _resultText = res.text ?? '…');
      return;
    }

    if (res.text != null || res.events.isNotEmpty) {
      setState(() {
        _resultText = res.text;
        _events = res.events;
      });
    } else {
      _next();
    }
  }

  void _next() {
    setState(() {
      _resultText = null;
      _events = const [];
      _card = _engine.drawNext();
      _cardSerial++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showingResult = _resultText != null || _events.isNotEmpty;
    final choice = _drag > 0.15 ? _card.right : (_drag < -0.15 ? _card.left : null);
    final preview = (!showingResult && choice != null) ? choice.preview(_s) : const <Stat, int>{};

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            GaugesBar(
              values: _s.stats,
              preview: preview,
              previewRisky: choice?.isRisky ?? false,
              flash: _flash,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: showingResult ? _buildResult() : _buildCard(),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Padding(
      key: ValueKey('card$_cardSerial'),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Center(
              child: Text(
                _card.textFor(_s),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, height: 1.35),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: SwipeCard(
                key: ValueKey('swipe$_cardSerial'),
                who: _card.who,
                leftLabel: _card.left.label,
                rightLabel: _card.right.label,
                onDrag: (t) {
                  if ((t - _drag).abs() > 0.05 || t == 0) setState(() => _drag = t);
                },
                onSwipe: _onSwipe,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _card.who.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Palette.sunset),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return GestureDetector(
      key: const ValueKey('result'),
      behavior: HitTestBehavior.opaque,
      onTap: _next,
      onHorizontalDragEnd: (_) => _next(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_resultText != null)
              Text(
                _resultText!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, height: 1.4, fontStyle: FontStyle.italic),
              ),
            for (final e in _events) ...[
              const SizedBox(height: 16),
              Text(e, textAlign: TextAlign.center, style: const TextStyle(color: Palette.sunset, fontSize: 16)),
            ],
            const SizedBox(height: 40),
            const Text('Touche pour continuer', style: TextStyle(color: Palette.dust, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final s = _s;
    final badges = <String>[
      if (s.has('chien')) '🐕',
      if (s.has('solaire')) '☀️',
      if (s.has('chauffage')) '🔥',
      if (s.has('freelance')) '💻',
      if (s.has('starlink')) '📡',
      if (s.has('insta')) '📸',
      if (s.has('duo')) '💞',
      if (s.has('amour') && s.has('solo')) '💌',
      if (s.has('convoi')) '🚌',
      if (s.has('objectif_nord')) '🧭',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        children: [
          if (badges.isNotEmpty)
            Text(badges.join('  '), style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 6),
          Text(
            'Jour ${s.day}  ·  ${s.season.label}  ·  ${s.region.label}',
            style: const TextStyle(color: Palette.dust, fontSize: 13, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}
