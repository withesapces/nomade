import 'dart:math';

import 'models.dart';
import '../data/cards.dart';
import '../data/endings.dart';

/// Le moteur : il choisit la prochaine carte, applique les choix,
/// fait vivre le monde entre deux cartes (saisons, usure, région)
/// et détecte les fins.
class GameEngine {
  final GameState state;
  final List<GameCard> deck;
  final Map<String, GameCard> _byId;
  GameCard? current;

  GameEngine({Random? rng, List<GameCard>? deck})
      : state = GameState(rng: rng),
        deck = deck ?? allCards,
        _byId = {for (final c in (deck ?? allCards)) c.id: c} {
    // Toute partie démarre par le prologue.
    _enqueue('intro', 0);
  }

  static const daysPerTurn = 3;

  // ---------------------------------------------------------------------
  // Pioche
  // ---------------------------------------------------------------------

  GameCard drawNext() {
    final s = state;

    // 1. Les suites d'histoire arrivées à échéance passent en priorité.
    s.queue.sort((a, b) => a.dueTurn.compareTo(b.dueTurn));
    for (final p in List.of(s.queue)) {
      if (p.dueTurn > s.turn) break;
      final card = _byId[p.cardId];
      s.queue.remove(p);
      if (card != null && _eligible(card, ignoreChain: true)) {
        return _show(card);
      }
    }

    // 2. Sinon, tirage pondéré par un « directeur » qui crée de la tension.
    final candidates = <GameCard>[];
    final weights = <double>[];
    for (final c in deck) {
      if (c.chainOnly || !_eligible(c)) continue;
      final w = _directorWeight(c);
      if (w <= 0) continue;
      candidates.add(c);
      weights.add(w);
    }

    if (candidates.isEmpty) {
      // Filet de sécurité : on relâche les délais de réapparition.
      final fallback = deck.where((c) => !c.chainOnly && !c.once && _conditionsOk(c)).toList();
      return _show(fallback[s.rng.nextInt(fallback.length)]);
    }

    final total = weights.fold<double>(0, (a, b) => a + b);
    var r = s.rng.nextDouble() * total;
    for (var i = 0; i < candidates.length; i++) {
      r -= weights[i];
      if (r <= 0) return _show(candidates[i]);
    }
    return _show(candidates.last);
  }

  GameCard _show(GameCard c) {
    current = c;
    state.lastSeen[c.id] = state.turn;
    state.lastCharacter = c.who.name;
    if (c.once) state.usedOnce.add(c.id);
    return c;
  }

  bool _conditionsOk(GameCard c) {
    final s = state;
    if (c.seasons != null && !c.seasons!.contains(s.season)) return false;
    if (c.regions != null && !c.regions!.contains(s.region)) return false;
    if (s.turn < c.minTurn) return false;
    if (c.condition != null && !c.condition!(s)) return false;
    return true;
  }

  bool _eligible(GameCard c, {bool ignoreChain = false}) {
    final s = state;
    if (c.once && s.usedOnce.contains(c.id)) return false;
    if (!ignoreChain) {
      final seen = s.lastSeen[c.id];
      if (seen != null && s.turn - seen < c.cooldown) return false;
    }
    return _conditionsOk(c);
  }

  /// Le directeur : favorise les cartes qui touchent une jauge en danger
  /// (pour forcer un vrai dilemme), évite deux fois le même personnage,
  /// et donne un coup de pouce aux cartes jamais vues.
  double _directorWeight(GameCard c) {
    final s = state;
    var w = c.weight;

    final touched = c.touchedStats;
    for (final st in Stat.values) {
      final v = s[st];
      final danger = v < 25 || v > 75;
      if (danger && touched.contains(st)) w *= 1.8;
    }

    if (c.who.name == s.lastCharacter) w *= 0.15;
    if (!s.lastSeen.containsKey(c.id)) w *= 1.4;
    return w;
  }

  void _enqueue(String id, int delay) {
    state.queue.add(PendingCard(id, state.turn + delay));
  }

  // ---------------------------------------------------------------------
  // Résolution d'un choix
  // ---------------------------------------------------------------------

  TurnResult choose({required bool right}) {
    final card = current;
    if (card == null) throw StateError('Aucune carte en jeu');
    final choice = right ? card.right : card.left;
    final s = state;
    final deltas = <Stat, int>{};
    String? text = choice.result;
    String? endingId = choice.ending;

    void applyEffects(Map<Stat, int> m) {
      m.forEach((k, v) => deltas[k] = (deltas[k] ?? 0) + v);
    }

    applyEffects(choice.effects);
    if (choice.dynamicEffects != null) applyEffects(choice.dynamicEffects!(s));
    s.flags.addAll(choice.setFlags);
    s.flags.removeAll(choice.clearFlags);
    choice.counters.forEach((k, v) => s.counters[k] = s.count(k) + v);
    for (final f in choice.followups) {
      _enqueue(f.cardId, f.delay);
    }
    if (choice.moveTo != null) s.region = choice.moveTo!;

    if (choice.outcomes.isNotEmpty) {
      final o = _pick(choice.outcomes);
      applyEffects(o.effects);
      s.flags.addAll(o.setFlags);
      s.flags.removeAll(o.clearFlags);
      for (final f in o.followups) {
        _enqueue(f.cardId, f.delay);
      }
      o.counters.forEach((k, v) => s.counters[k] = s.count(k) + v);
      if (o.moveTo != null) s.region = o.moveTo!;
      text = o.text;
      endingId ??= o.ending;
    }

    _applyDeltas(deltas);

    // Le monde tourne : temps, saisons, usure, flags permanents.
    s.turn++;
    final seasonBefore = s.season;
    s.day += daysPerTurn;
    final events = <String>[];
    final passive = _passive(events);
    _applyDeltas(passive);
    passive.forEach((k, v) => deltas[k] = (deltas[k] ?? 0) + v);
    if (s.season != seasonBefore) {
      events.add('${s.season.label} arrive.');
      if (s.season == Season.hiver && !s.has('chauffage')) {
        _enqueue('hiver_froid', 1);
      }
    }

    // Jalons : un an sur la route.
    if (s.day >= 360 && !s.has('jalon_an')) {
      s.flags.add('jalon_an');
      _enqueue('anniversaire', 0);
    }

    final ending = endingId != null ? specialEndings[endingId] : _gaugeEnding();
    current = null;
    return TurnResult(deltas, text, ending, events);
  }

  Outcome _pick(List<Outcome> list) {
    final total = list.fold<double>(0, (a, o) => a + o.chance);
    var r = state.rng.nextDouble() * total;
    for (final o in list) {
      r -= o.chance;
      if (r <= 0) return o;
    }
    return list.last;
  }

  void _applyDeltas(Map<Stat, int> d) {
    d.forEach((k, v) {
      state.stats[k] = (state.stats[k]! + v).clamp(0, 100);
    });
  }

  /// Ce qui arrive tout seul entre deux cartes.
  Map<Stat, int> _passive(List<String> events) {
    final s = state;
    final d = <Stat, int>{};
    void add(Stat k, int v) => d[k] = (d[k] ?? 0) + v;

    // Coût de la vie, variable selon la région.
    final cost = s.region.costFactor;
    if (s.rng.nextDouble() < cost.clamp(0, 1)) add(Stat.argent, -1);
    if (cost > 1 && s.rng.nextDouble() < cost - 1) add(Stat.argent, -1);

    // Usure mécanique, un tour sur deux.
    if (s.turn.isEven) add(Stat.van, -1);

    // Saison.
    if (s.season == Season.hiver) {
      if (!s.has('chauffage')) add(Stat.moral, -1);
      if (s.region == Region.scandinavie) add(Stat.van, -1);
    }
    if (s.season == Season.ete && s.region.abroad) {
      if (s.turn % 3 == 0) add(Stat.moral, 1);
    }

    // Revenus et compagnie.
    if (s.has('freelance')) {
      add(Stat.argent, 2);
      if (s.turn % 3 == 0) add(Stat.moral, -1);
    }
    if (s.has('insta') && s.turn % 2 == 0) add(Stat.argent, 1);
    if (s.has('chien') && s.turn % 3 == 0) add(Stat.moral, 1);
    if (s.has('solaire') && s.turn % 4 == 0) add(Stat.argent, 1);

    // Solitude ou vie de couple dans 6 m².
    if (s.has('solo') && !s.has('amour') && s.turn % 3 == 0) add(Stat.liens, -1);
    if (s.has('duo') && s.turn % 5 == 0) add(Stat.liens, -1);

    return d;
  }

  Ending? _gaugeEnding() {
    for (final st in Stat.values) {
      final v = state[st];
      if (v <= 0) return gaugeEndings[(st, false)];
      if (v >= 100) return gaugeEndings[(st, true)];
    }
    return null;
  }
}
