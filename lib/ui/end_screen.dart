import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight),
              child: IntrinsicHeight(
                child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(e.asset, width: 240, height: 180, semanticsLabel: e.title),
              const SizedBox(height: 20),
              Text(e.title.toUpperCase(), textAlign: TextAlign.center, style: display(32, color: Palette.sunset, spacing: 3)),
              if (_isNew) ...[
                const SizedBox(height: 8),
                const Text('Nouvelle fin découverte', style: TextStyle(color: Palette.sage, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              Text(
                e.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, height: 1.55),
              ),
              const SizedBox(height: 24),
              Text('${widget.days}', style: display(40)),
              const Text('jours sur la route', style: TextStyle(fontSize: 15)),
              if (_record == true)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Palette.asphaltLight, borderRadius: BorderRadius.circular(999)),
                  child: const Text('Nouveau record', style: TextStyle(color: Palette.sage, fontSize: 13)),
                ),
              const SizedBox(height: 8),
              Text('$_found / ${allEndings.length} fins', style: const TextStyle(color: Palette.dust, fontSize: 13)),
              const SizedBox(height: 24),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Palette.sunset,
                  foregroundColor: Palette.asphalt,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  textStyle: const TextStyle(fontFamily: 'Instrument', fontSize: 17, fontWeight: FontWeight.w600),
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
          ),
        ),
      ),
    );
  }
}
