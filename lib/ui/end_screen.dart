import 'package:flutter/material.dart';

import '../data/endings.dart';
import '../engine/models.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import 'progress.dart';
import 'theme.dart';

class EndScreen extends StatefulWidget {
  final Ending ending;
  final int days;
  final String? lastWords;

  const EndScreen({super.key, required this.ending, required this.days, this.lastWords});

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  bool? _record;
  bool _isNew = false;
  int _found = 0;

  @override
  void initState() {
    super.initState();
    _save();
  }

  Future<void> _save() async {
    final p = await Progress.load();
    final isNew = !p.endings.contains(widget.ending.id);
    final rec = await p.record(endingId: widget.ending.id, days: widget.days);
    if (mounted) {
      setState(() {
        _record = rec;
        _isNew = isNew;
        _found = p.endings.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.ending;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(),
              Text(e.emoji, style: const TextStyle(fontSize: 88)),
              const SizedBox(height: 16),
              Text(
                e.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Palette.sunset,
                ),
              ),
              if (_isNew) ...[
                const SizedBox(height: 6),
                const Text('Nouvelle fin découverte', style: TextStyle(color: Palette.sage, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              Text(
                e.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, height: 1.5),
              ),
              const SizedBox(height: 28),
              Text(
                '${widget.days} jours sur la route',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              if (_record == true)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('Nouveau record', style: TextStyle(color: Palette.sage)),
                ),
              const SizedBox(height: 6),
              Text('$_found / ${allEndings.length} fins', style: const TextStyle(color: Palette.dust)),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Palette.sunset,
                  foregroundColor: Palette.asphalt,
                  minimumSize: const Size.fromHeight(56),
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                child: const Text('Repartir'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (_) => false,
                ),
                child: const Text('Menu', style: TextStyle(color: Palette.dust)),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
