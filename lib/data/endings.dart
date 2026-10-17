import '../engine/models.dart';

/// Fins déclenchées quand une jauge touche 0 (false) ou 100 (true).
final Map<(Stat, bool), Ending> gaugeEndings = {
  (Stat.argent, false): const Ending(
    'fauche',
    'À sec',
    '🪙',
    'Le compte affiche 3,12 €. Tu mets le van sur Leboncoin un mardi soir, '
        'un couple de jeunes l\'achète le jeudi avec des étoiles plein les yeux. '
        'Tu leur souhaites bonne route. Tu le penses à moitié.',
  ),
  (Stat.argent, true): const Ending(
    'rentier',
    'Rentier du bitume',
    '🏡',
    'L\'argent rentre tout seul. Un jour tu signes chez le notaire pour une '
        'longère avec terrain. Le van reste garé dans la cour, à côté de la tondeuse. '
        'Tu lui dis bonjour le matin.',
  ),
  (Stat.moral, false): const Ending(
    'blues',
    'Le blues du parking',
    '🌧️',
    'Troisième semaine de pluie sur un parking de supermarché. Tu appelles tes '
        'parents. Ta chambre d\'ado n\'a pas changé. Le poster non plus.',
  ),
  (Stat.moral, true): const Ending(
    'illumination',
    'Illumination',
    '🧘',
    'Un matin, face à la mer, tout devient limpide. Tu laisses les clés sur le '
        'contact avec un mot : « Prenez-en soin. » On te dit aujourd\'hui dans un '
        'monastère au Népal. Personne ne sait vraiment.',
  ),
  (Stat.van, false): const Ending(
    'moteur_mort',
    'Moteur mort',
    '💀',
    'Un claquement sec, une fumée bleue, puis plus rien. Le dépanneur secoue '
        'la tête : « Là, c\'est la casse. » Tu récupères le volant en souvenir.',
  ),
  (Stat.van, true): const Ending(
    'van_musee',
    'Van-musée',
    '✨',
    'Carrosserie refaite, moteur neuf, intérieur en noyer. Il est trop beau pour '
        'rouler sur les chemins. Tu ne le sors plus que pour les salons, sous une bâche.',
  ),
  (Stat.liens, false): const Ending(
    'ermite',
    'Ermite',
    '🌲',
    'Le téléphone ne sonne plus. Tu ne le rallumes plus. Des randonneurs parlent '
        'd\'un van couvert de mousse au fond d\'une forêt, et d\'une silhouette qui salue de loin.',
  ),
  (Stat.liens, true): const Ending(
    'communaute',
    'La communauté',
    '🏕️',
    'Tu t\'arrêtes « deux jours » dans un écovillage. Trois ans plus tard, le van '
        'est sur cales, il sert de chambre d\'amis. Tu ne le regrettes pas.',
  ),
};

/// Fins scénarisées, déclenchées par des cartes.
const Map<String, Ending> specialEndings = {
  'cap_nord': Ending(
    'cap_nord',
    'Soleil de minuit',
    '🌅',
    'Nordkapp, minuit, le soleil ne se couche pas. Tu as traversé un continent '
        'dans une boîte en tôle. Tu restes assis sur le capot jusqu\'à ce que '
        'la lumière remonte. Victoire.',
  ),
  'fourriere': Ending(
    'fourriere',
    'Fourrière',
    '🚓',
    'Troisième PV, et cette fois la dépanneuse est déjà là. Les frais de garde '
        'dépassent la valeur du van. Tu repars à pied, ton sac sur le dos.',
  ),
  'influenceur': Ending(
    'influenceur',
    'Le personnage',
    '📱',
    'Un million d\'abonnés. Tu ne vis plus en van, tu joues quelqu\'un qui vit en '
        'van. Une équipe de tournage te suit. Le vrai toi est resté sur une plage, '
        'quelque part en Galice.',
  ),
  'retour_famille': Ending(
    'retour_famille',
    'Retour au port',
    '⚓',
    'Tu rentres pour de bon auprès des tiens. Le van rejoint la grange. Tu sais '
        'que tu repartiras. Plus tard.',
  ),
  'vente_sauvage': Ending(
    'vente_sauvage',
    'Volé',
    '🫥',
    'Au réveil, plus rien. Le van, tes affaires, tout. La géolocalisation de ta '
        'dernière story n\'était peut-être pas une bonne idée.',
  ),
};

List<Ending> get allEndings => [...gaugeEndings.values, ...specialEndings.values];
