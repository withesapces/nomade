import 'package:flutter/material.dart';

import '../data/endings.dart';
import 'game_screen.dart';
import 'progress.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Progress? _progress;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final p = await Progress.load();
    if (mounted) setState(() => _progress = p);
  }

  Future<void> _play() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final p = _progress;
    final endings = allEndings;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          children: [
            const Text('🚐', textAlign: TextAlign.center, style: TextStyle(fontSize: 72)),
            const SizedBox(height: 8),
            const Text(
              'NOMADE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                letterSpacing: 10,
                color: Palette.sunset,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Swipe à gauche, swipe à droite.\nGarde ton van, ton moral, ton argent et tes liens en équilibre.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Palette.dust, height: 1.4),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _play,
              style: FilledButton.styleFrom(
                backgroundColor: Palette.sunset,
                foregroundColor: Palette.asphalt,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              child: const Text('Prendre la route'),
            ),
            const SizedBox(height: 28),
            if (p != null) ...[
              Row(
                children: [
                  _Stat(label: 'Record', value: '${p.bestDays} j'),
                  _Stat(label: 'Parties', value: '${p.games}'),
                  _Stat(label: 'Fins', value: '${p.endings.length}/${endings.length}'),
                ],
              ),
              const SizedBox(height: 24),
              const Text('FINS DÉCOUVERTES',
                  style: TextStyle(color: Palette.dust, letterSpacing: 2, fontSize: 12)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final e in endings)
                    _EndingChip(
                      unlocked: p.endings.contains(e.id),
                      emoji: e.emoji,
                      title: e.title,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            const Text(
              'Aucune jauge ne doit toucher le fond, ni déborder. '
              'Trop d\'argent ou trop de moral, ça finit mal aussi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Palette.dust, fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Palette.dust, fontSize: 12)),
        ],
      ),
    );
  }
}

class _EndingChip extends StatelessWidget {
  final bool unlocked;
  final String emoji;
  final String title;
  const _EndingChip({required this.unlocked, required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Palette.asphaltLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: unlocked ? Palette.sunset.withValues(alpha: 0.5) : Colors.transparent),
      ),
      child: Text(
        unlocked ? '$emoji  $title' : '❔  ???',
        style: TextStyle(color: unlocked ? Palette.cream : Palette.dust, fontSize: 13),
      ),
    );
  }
}
