import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nomade/data/cards.dart';
import 'package:nomade/data/endings.dart';
import 'package:nomade/engine/engine.dart';
import 'package:nomade/engine/models.dart';

void main() {
  group('Intégrité du deck', () {
    final ids = allCards.map((c) => c.id).toSet();

    test('identifiants uniques', () {
      expect(ids.length, allCards.length);
    });

    test('toutes les suites pointent vers une carte existante', () {
      for (final c in allCards) {
        for (final ch in [c.left, c.right]) {
          final fups = [...ch.followups, for (final o in ch.outcomes) ...o.followups];
          for (final f in fups) {
            expect(ids, contains(f.cardId), reason: '${c.id} -> ${f.cardId}');
          }
        }
      }
    });

    test('toutes les fins spéciales existent', () {
      for (final c in allCards) {
        for (final ch in [c.left, c.right]) {
          final e = [ch.ending, for (final o in ch.outcomes) o.ending].whereType<String>();
          for (final id in e) {
            expect(specialEndings.keys, contains(id), reason: c.id);
          }
        }
      }
    });

    test('chaque carte a un texte', () {
      final s = GameState(rng: Random(1));
      for (final c in allCards) {
        expect(c.textFor(s).trim(), isNotEmpty, reason: c.id);
      }
    });
  });

  group('Moteur', () {
    test('la partie commence par le prologue', () {
      final e = GameEngine(rng: Random(3));
      expect(e.drawNext().id, 'intro');
    });

    test('les jauges restent dans 0..100 et le temps avance', () {
      final e = GameEngine(rng: Random(5));
      for (var i = 0; i < 30; i++) {
        e.drawNext();
        final r = e.choose(right: i.isEven);
        for (final st in Stat.values) {
          expect(e.state[st], inInclusiveRange(0, 100));
        }
        if (r.ending != null) break;
      }
      expect(e.state.day, greaterThan(0));
    });

    test('une suite programmée arrive au bon moment', () {
      final e = GameEngine(rng: Random(7));
      e.drawNext(); // intro
      e.choose(right: false); // solo -> intro2 au tour suivant
      expect(e.drawNext().id, 'intro2');
    });

    test('simulation : 2 000 parties sans plantage, durée raisonnable', () {
      final rng = Random(42);
      final endings = <String, int>{};
      var totalTurns = 0;
      const games = 2000;
      for (var g = 0; g < games; g++) {
        final e = GameEngine(rng: Random(rng.nextInt(1 << 30)));
        TurnResult? r;
        var turns = 0;
        while (turns < 600) {
          e.drawNext();
          r = e.choose(right: rng.nextBool());
          turns++;
          if (r.ending != null) break;
        }
        totalTurns += turns;
        final id = r?.ending?.id ?? 'aucune';
        endings[id] = (endings[id] ?? 0) + 1;
      }
      final avg = totalTurns / games;
      // ignore: avoid_print
      print('Tours moyens : ${avg.toStringAsFixed(1)}  Fins : $endings');
      expect(avg, greaterThan(15));
      expect(endings.length, greaterThanOrEqualTo(6));
    });
  });
}
