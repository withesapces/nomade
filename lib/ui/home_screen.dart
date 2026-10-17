import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: [
            AspectRatio(
              aspectRatio: 342 / 200,
              child: SvgPicture.asset('assets/home.svg', semanticsLabel: 'Un van roule vers le soleil couchant'),
            ),
            const SizedBox(height: 20),
            Text('NOMADE', textAlign: TextAlign.center, style: display(56, color: Palette.sunset, spacing: 6)),
            const SizedBox(height: 10),
            const Text(
              'Swipe à gauche, swipe à droite. Garde ton van, ton moral, ton argent et tes liens en équilibre.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Palette.dust, height: 1.45, fontSize: 15),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _play,
              style: FilledButton.styleFrom(
                backgroundColor: Palette.sunset,
                foregroundColor: Palette.asphalt,
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                textStyle: const TextStyle(fontFamily: 'Instrument', fontSize: 18, fontWeight: FontWeight.w600),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text('Prendre la route', overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 10),
                  NIcon('fleche', size: 22, color: Palette.asphalt),
                ],
              ),
            ),
            const SizedBox(height: 28),
            if (p != null) ...[
              Row(
                children: [
                  _Stat(label: 'Record', value: '${p.bestDays} j'),
                  const SizedBox(width: 8),
                  _Stat(label: 'Parties', value: '${p.games}'),
                  const SizedBox(width: 8),
                  _Stat(label: 'Fins', value: '${p.endings.length}/${endings.length}'),
                ],
              ),
              const SizedBox(height: 28),
              const Text('FINS DÉCOUVERTES', style: TextStyle(color: Palette.dust, letterSpacing: 2, fontSize: 12)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in endings) _EndingChip(unlocked: p.endings.contains(e.id), title: e.title),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: Palette.asphaltLight, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value, style: display(24)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Palette.dust, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _EndingChip extends StatelessWidget {
  final bool unlocked;
  final String title;
  const _EndingChip({required this.unlocked, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Palette.asphaltLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: unlocked ? Palette.chipBorder : Colors.transparent),
      ),
      child: unlocked
          ? Text(title, style: const TextStyle(color: Palette.cream, fontSize: 13))
          : const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NIcon('cadenas', size: 13, color: Palette.dust, label: 'Fin non découverte'),
                SizedBox(width: 6),
                Text('???', style: TextStyle(color: Palette.dust, fontSize: 13)),
              ],
            ),
    );
  }
}
