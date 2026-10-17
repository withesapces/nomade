import 'dart:math';

/// Les quatre jauges. Comme dans Reigns, aucune ne doit toucher 0 ni 100.
enum Stat { argent, moral, van, liens }

extension StatInfo on Stat {
  String get label => switch (this) {
        Stat.argent => 'Argent',
        Stat.moral => 'Moral',
        Stat.van => 'Van',
        Stat.liens => 'Liens',
      };

  String get icon => switch (this) {
        Stat.argent => '💶',
        Stat.moral => '🔥',
        Stat.van => '🚐',
        Stat.liens => '🫂',
      };
}

enum Season { printemps, ete, automne, hiver }

extension SeasonInfo on Season {
  String get label => switch (this) {
        Season.printemps => 'Printemps',
        Season.ete => 'Été',
        Season.automne => 'Automne',
        Season.hiver => 'Hiver',
      };
}

enum Region { normandie, bretagne, pyrenees, alpes, espagne, portugal, maroc, scandinavie }

extension RegionInfo on Region {
  String get label => switch (this) {
        Region.normandie => 'Normandie',
        Region.bretagne => 'Bretagne',
        Region.pyrenees => 'Pyrénées',
        Region.alpes => 'Alpes',
        Region.espagne => 'Espagne',
        Region.portugal => 'Portugal',
        Region.maroc => 'Maroc',
        Region.scandinavie => 'Scandinavie',
      };

  /// Multiplicateur du coût de la vie quotidienne (gasoil, courses).
  double get costFactor => switch (this) {
        Region.scandinavie => 2.0,
        Region.alpes || Region.bretagne || Region.normandie => 1.0,
        Region.pyrenees => 0.9,
        Region.espagne => 0.8,
        Region.portugal => 0.7,
        Region.maroc => 0.5,
      };

  bool get abroad => switch (this) {
        Region.espagne || Region.portugal || Region.maroc || Region.scandinavie => true,
        _ => false,
      };
}

typedef Cond = bool Function(GameState s);
typedef TextFn = String Function(GameState s);

/// Une carte à piocher plus tard (suite d'histoire).
class Followup {
  final String cardId;
  final int delay; // en tours
  const Followup(this.cardId, {this.delay = 1});
}

/// Issue aléatoire d'un choix risqué.
class Outcome {
  final double chance; // poids relatif
  final Map<Stat, int> effects;
  final String text;
  final Set<String> setFlags;
  final Set<String> clearFlags;
  final List<Followup> followups;
  final Map<String, int> counters;
  final Region? moveTo;
  final String? ending;

  const Outcome({
    required this.chance,
    this.effects = const {},
    required this.text,
    this.setFlags = const {},
    this.clearFlags = const {},
    this.followups = const [],
    this.counters = const {},
    this.moveTo,
    this.ending,
  });
}

class Choice {
  final String label;
  final Map<Stat, int> effects;
  final Set<String> setFlags;
  final Set<String> clearFlags;
  final Map<String, int> counters; // incréments de compteurs
  final List<Followup> followups;
  final List<Outcome> outcomes; // si non vide : tirage
  final Region? moveTo;
  final String? result; // phrase affichée après le choix
  final String? ending; // fin spéciale déclenchée directement

  /// Modificateur contextuel optionnel : retourne des effets en plus
  /// selon l'état (ex. réparation moins chère si Gérard est un ami).
  final Map<Stat, int> Function(GameState s)? dynamicEffects;

  const Choice(
    this.label, {
    this.effects = const {},
    this.setFlags = const {},
    this.clearFlags = const {},
    this.counters = const {},
    this.followups = const [],
    this.outcomes = const [],
    this.moveTo,
    this.result,
    this.ending,
    this.dynamicEffects,
  });

  bool get isRisky => outcomes.isNotEmpty;

  /// Jauges touchées et ampleur max, pour l'aperçu façon Reigns.
  Map<Stat, int> preview(GameState s) {
    final out = <Stat, int>{};
    void add(Map<Stat, int> m) {
      m.forEach((k, v) {
        final a = v.abs();
        if (a > (out[k] ?? 0)) out[k] = a;
      });
    }

    add(effects);
    if (dynamicEffects != null) add(dynamicEffects!(s));
    for (final o in outcomes) {
      add(o.effects);
    }
    return out;
  }
}

class Character {
  final String name;
  final String emoji;
  final int color; // ARGB
  final String art; // nom du fichier dans assets/characters/
  const Character(this.name, this.emoji, this.color, {required this.art});

  String get asset => 'assets/characters/$art.svg';
}

class GameCard {
  final String id;
  final Character who;
  final String text;
  final TextFn? dynamicText;
  final Choice left;
  final Choice right;

  final Cond? condition;
  final double weight;
  final bool once;
  final int cooldown; // tours avant de pouvoir revenir
  final bool chainOnly; // n'apparaît que via une suite
  final Set<Season>? seasons;
  final Set<Region>? regions;
  final int minTurn;

  const GameCard({
    required this.id,
    required this.who,
    required this.text,
    this.dynamicText,
    required this.left,
    required this.right,
    this.condition,
    this.weight = 1,
    this.once = false,
    this.cooldown = 12,
    this.chainOnly = false,
    this.seasons,
    this.regions,
    this.minTurn = 0,
  });

  String textFor(GameState s) => dynamicText?.call(s) ?? text;

  Set<Stat> get touchedStats => {
        ...left.effects.keys,
        ...right.effects.keys,
        for (final o in [...left.outcomes, ...right.outcomes]) ...o.effects.keys,
      };
}

class Ending {
  final String id;
  final String title;
  final String text;
  final String emoji;
  const Ending(this.id, this.title, this.emoji, this.text);

  String get asset => 'assets/endings/$id.svg';
}

class PendingCard {
  final String cardId;
  final int dueTurn;
  PendingCard(this.cardId, this.dueTurn);
}

class GameState {
  final Map<Stat, int> stats;
  int turn = 0;
  int day = 0;
  Region region = Region.normandie;
  final Set<String> flags = {};
  final Map<String, int> counters = {};
  final Map<String, int> lastSeen = {};
  final Set<String> usedOnce = {};
  final List<PendingCard> queue = [];
  String? lastCharacter;
  final Random rng;

  GameState({Random? rng, int start = 50})
      : rng = rng ?? Random(),
        stats = {for (final s in Stat.values) s: start};

  int operator [](Stat s) => stats[s]!;
  bool has(String f) => flags.contains(f);
  int count(String c) => counters[c] ?? 0;

  Season get season {
    // On démarre au printemps. 90 jours par saison.
    return Season.values[(day ~/ 90) % 4];
  }

  int get year => day ~/ 360 + 1;
}

class TurnResult {
  final Map<Stat, int> deltas;
  final String? text;
  final Ending? ending;
  final List<String> events; // effets passifs notables
  TurnResult(this.deltas, this.text, this.ending, this.events);
}
