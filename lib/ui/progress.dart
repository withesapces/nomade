import 'package:shared_preferences/shared_preferences.dart';

/// Progression sauvegardée entre les parties : record, fins découvertes.
class Progress {
  int bestDays;
  int games;
  final Set<String> endings;

  Progress(this.bestDays, this.games, this.endings);

  static const _kBest = 'best_days';
  static const _kGames = 'games';
  static const _kEndings = 'endings';

  static Future<Progress> load() async {
    final p = await SharedPreferences.getInstance();
    return Progress(
      p.getInt(_kBest) ?? 0,
      p.getInt(_kGames) ?? 0,
      (p.getStringList(_kEndings) ?? const []).toSet(),
    );
  }

  /// Retourne true si c'est un nouveau record.
  Future<bool> record({required String endingId, required int days}) async {
    final p = await SharedPreferences.getInstance();
    games++;
    endings.add(endingId);
    final isRecord = days > bestDays;
    if (isRecord) bestDays = days;
    await p.setInt(_kBest, bestDays);
    await p.setInt(_kGames, games);
    await p.setStringList(_kEndings, endings.toList());
    return isRecord;
  }
}
