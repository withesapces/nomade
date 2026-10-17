// Le deck. Chaque carte = un personnage, une situation, deux choix.
// Les cartes `chainOnly` n'arrivent que comme suite d'un choix précédent.
import '../engine/models.dart';

const arg = Stat.argent;
const mor = Stat.moral;
const van = Stat.van;
const lie = Stat.liens;

const france = {Region.normandie, Region.bretagne, Region.pyrenees, Region.alpes};
const littoral = {Region.normandie, Region.bretagne};

// --- Personnages -----------------------------------------------------------
const toi = Character('Toi', '🧭', 0xFF8D6E63, art: 'toi');
const momo = Character('Momo, garagiste', '🔧', 0xFF607D8B, art: 'momo');
const depanneur = Character('Dépanneur', '🪝', 0xFFFF5722, art: 'depanneur');
const gerard = Character('Gérard, retraité en camping-car', '👴', 0xFF795548, art: 'gerard');
const maman = Character('Maman', '📞', 0xFFE57373, art: 'maman');
const soeur = Character('Ta sœur', '👩', 0xFFBA68C8, art: 'soeur');
const gendarme = Character('Gendarme', '👮', 0xFF3F51B5, art: 'gendarme');
const police = Character('Police municipale', '🚓', 0xFF5C6BC0, art: 'police');
const chienErrant = Character('Chien errant', '🐕', 0xFFA1887F, art: 'chienErrant');
const veto = Character('Vétérinaire', '🩺', 0xFF4DB6AC, art: 'veto');
const voisin = Character('Voisin de spot', '🏕️', 0xFF66BB6A, art: 'voisin');
const lila = Character('Lila, influenceuse', '📸', 0xFFF06292, art: 'lila');
const marque = Character('Une marque', '🏷️', 0xFFFF8A65, art: 'marque');
const story = Character('Ta story', '📱', 0xFF7E57C2, art: 'story');
const commentaires = Character('Les commentaires', '🗯️', 0xFF9575CD, art: 'commentaires');
const manager = Character('Un manager', '🕴️', 0xFF455A64, art: 'manager');
const client = Character('Un client', '💻', 0xFF26A69A, art: 'client');
const vendeur = Character('Vendeur', '📡', 0xFF5E35B1, art: 'vendeur');
const lea = Character('Léa, vanlifeuse', '🚌', 0xFFFFB74D, art: 'lea');
const festival = Character('Orga du festival', '🎪', 0xFFAB47BC, art: 'festival');
const message = Character('Un message', '💌', 0xFFEC407A, art: 'message');
const sam = Character('Sam', '💞', 0xFFEF5350, art: 'sam');
const tiago = Character('Tiago, surfeur', '🏄', 0xFF29B6F6, art: 'tiago');
const guardia = Character('Guardia Civil', '🛂', 0xFF388E3C, art: 'guardia');
const douanier = Character('Douanier', '🛃', 0xFF2E7D32, art: 'douanier');
const rachid = Character('Rachid, mécano', '🛠️', 0xFFFF7043, art: 'rachid');
const guide = Character('Guide', '🐪', 0xFFFFCA28, art: 'guide');
const yves = Character('Yves, agriculteur', '🍎', 0xFF9CCC65, art: 'yves');
const meteo = Character('Météo', '⛈️', 0xFF78909C, art: 'meteo');
const appli = Character('Appli de spots', '📍', 0xFF42A5F5, art: 'appli');
const ados = Character('Des ados', '🔊', 0xFFFFEE58, art: 'ados');
const banque = Character('Ta banque', '🏦', 0xFF546E7A, art: 'banque');
const pote = Character('Karim, ton pote', '🤙', 0xFF8BC34A, art: 'pote');
const galere = Character('Un vanlifer en galère', '🆘', 0xFFFFA726, art: 'galere');
const whatsapp = Character('Groupe WhatsApp', '💬', 0xFF4CAF50, art: 'whatsapp');
const collectionneur = Character('Collectionneur', '🧐', 0xFF6D4C41, art: 'collectionneur');
const casse = Character('La casse', '♻️', 0xFF757575, art: 'casse');
const amie = Character('Une vieille amie', '✉️', 0xFFCE93D8, art: 'amie');
const viticulteur = Character('Viticulteur', '🍇', 0xFF7B1FA2, art: 'viticulteur');
const ferme = Character('Ferme bio', '🌱', 0xFF43A047, art: 'ferme');
const marche = Character('Marché du dimanche', '🧺', 0xFFFFB300, art: 'marche');
const controleur = Character('Contrôleur technique', '📋', 0xFF90A4AE, art: 'controleur');
const stoppeur = Character('Auto-stoppeur', '👍', 0xFFA1887F, art: 'stoppeur');
const musicien = Character('Musicien de rue', '🎸', 0xFFD4E157, art: 'musicien');
const pecheur = Character('Pêcheur du coin', '🎣', 0xFF0097A7, art: 'pecheur');
const village = Character('Comité des fêtes', '🎉', 0xFFFF7043, art: 'village');

final List<GameCard> allCards = [
  // =========================================================================
  // PROLOGUE
  // =========================================================================
  GameCard(
    id: 'intro',
    who: toi,
    chainOnly: true,
    once: true,
    text: "Tu as rendu les clés de l'appart. Le van est chargé jusqu'au toit. "
        "Ce matin, tu pars. Mais avec qui ?",
    left: Choice('Seul·e',
        setFlags: {'solo'},
        effects: {mor: 5, lie: -5},
        followups: [Followup('intro2')],
        result: 'La liberté, la vraie. Et le silence.'),
    right: Choice('À deux',
        setFlags: {'duo'},
        effects: {lie: 8, arg: 7},
        followups: [Followup('intro2')],
        result: 'Sam a déjà réglé le GPS. Six mètres carrés à deux, ça va être sport.'),
  ),
  GameCard(
    id: 'intro2',
    who: appli,
    chainOnly: true,
    once: true,
    text: 'Première nuit. Camping à 25 € avec douches chaudes, '
        'ou spot gratuit au bord d\'un lac, noté 3 étoiles ?',
    left: Choice('Camping', effects: {arg: -4, mor: 4}, result: 'Douche chaude. Un peu triste quand même.'),
    right: Choice('Le lac', outcomes: [
      Outcome(chance: 70, effects: {mor: 10}, text: 'Coucher de soleil sur l\'eau. Tu sais pourquoi tu es parti.'),
      Outcome(chance: 30, effects: {mor: -8}, text: 'Toc toc toc à 2 h du matin. Lampe torche dans la vitre. Tu déménages en pyjama.'),
    ]),
  ),

  // =========================================================================
  // MÉCANIQUE
  // =========================================================================
  GameCard(
    id: 'bruit_roue',
    who: momo,
    condition: (s) => !s.has('bruit'),
    dynamicText: (s) => s[van] < 35
        ? 'Ouh là. Il y a un bruit côté roue avant, et franchement le reste n\'est pas mieux.'
        : 'Il y a un petit bruit bizarre côté roue avant. Roulement, sûrement.',
    text: '',
    left: Choice('Ça attendra',
        setFlags: {'bruit'},
        followups: [Followup('panne_roulement', delay: 4)],
        effects: {arg: 3},
        result: 'Tu montes le son de la radio.'),
    right: Choice('Répare-le', effects: {arg: -10, van: 12}),
  ),
  GameCard(
    id: 'panne_roulement',
    who: depanneur,
    chainOnly: true,
    condition: (s) => s.has('bruit'),
    text: 'Bande d\'arrêt d\'urgence, warnings, fumée. Le roulement a lâché. '
        'Je vous remorque ? C\'est 280 €.',
    left: Choice('Remorquez', effects: {arg: -15, van: 10}, clearFlags: {'bruit'}),
    right: Choice('Je bricole', clearFlags: {'bruit'}, outcomes: [
      Outcome(chance: 45, effects: {van: 5, mor: 10}, text: 'Tuto YouTube, colliers Serflex, fierté immense. Ça tient.'),
      Outcome(chance: 55, effects: {van: -18, mor: -8, arg: -7}, text: 'Ça ne tient pas. Tu paies la dépanneuse quand même, deux heures plus tard.'),
    ]),
  ),
  GameCard(
    id: 'vidange',
    who: toi,
    text: '15 000 km depuis la dernière vidange. L\'huile ressemble à du café.',
    left: Choice('Plus tard', effects: {van: -9, arg: 3}),
    right: Choice('Je la fais moi-même', effects: {arg: -3}, outcomes: [
      Outcome(chance: 70, effects: {van: 10, mor: 5}, text: 'Mains noires, moteur heureux.'),
      Outcome(chance: 30, effects: {van: 4, mor: -6}, text: 'Bouchon tombé dans le bac. De l\'huile jusqu\'aux coudes.'),
    ]),
  ),
  GameCard(
    id: 'controle_technique',
    who: controleur,
    minTurn: 10,
    cooldown: 35,
    dynamicText: (s) => s[van] < 40
        ? 'Contrôle technique. Je fronce déjà les sourcils depuis le parking.'
        : 'Contrôle technique à repasser. Simple formalité, normalement.',
    text: '',
    left: Choice('Rouler sans', outcomes: [
      Outcome(chance: 60, effects: {mor: 2}, text: 'Personne ne t\'arrête. Pour l\'instant.'),
      Outcome(chance: 40, effects: {arg: -13, mor: -5}, counters: {'pv': 1}, text: 'Contrôle routier. Amende. Le gendarme note ta plaque.'),
    ]),
    right: Choice('Le passer',
        dynamicEffects: (s) => s[van] < 40 ? {arg: -17, van: 18} : {arg: -4, van: 3}),
  ),
  GameCard(
    id: 'gerard',
    who: gerard,
    condition: (s) => !s.has('ami_gerard'),
    dynamicText: (s) => s[van] < 30
        ? 'Ton van fait peine à voir, petit. Laisse-moi regarder sous le capot.'
        : 'Je t\'ai vu galérer avec ta batterie ce matin. Tu veux que je te montre ?',
    text: '',
    left: Choice('Non merci', effects: {lie: -5, mor: 2}),
    right: Choice('Volontiers',
        setFlags: {'ami_gerard'},
        effects: {lie: 8, van: 6},
        result: 'Quarante ans de mécanique, et une Thermos de café.'),
  ),
  GameCard(
    id: 'gerard_freins',
    who: gerard,
    condition: (s) => s.has('ami_gerard') && s[van] < 45,
    text: 'Encore toi ! Tes freins couinent à 300 mètres. Je te les refais contre un apéro.',
    left: Choice('J\'ai ma fierté', effects: {mor: 3, van: -3}),
    right: Choice('Marché conclu', effects: {van: 18, arg: -2, lie: 5}),
  ),
  GameCard(
    id: 'casse',
    who: casse,
    condition: (s) => s[van] < 30,
    text: 'Pièces d\'occasion, tu démontes toi-même. Il y a un van comme le tien au fond.',
    left: Choice('Pas le courage', effects: {van: -3, mor: -2}),
    right: Choice('Clé de 13 en main', effects: {van: 15, arg: -4, mor: -3}),
  ),
  GameCard(
    id: 'collectionneur',
    who: collectionneur,
    condition: (s) => s[van] > 70,
    text: 'Superbe restauration. Je vous l\'achète 25 000 €, cash. Vous rachèterez plus petit.',
    left: Choice('Jamais', effects: {mor: 4, van: 2}),
    right: Choice('Vendre et racheter', effects: {arg: 35, van: -30, mor: -8}, result: 'Le nouveau sent le chien mouillé. Mais il roule.'),
  ),

  // =========================================================================
  // ÉNERGIE, CONFORT
  // =========================================================================
  GameCard(
    id: 'solaire',
    who: lea,
    condition: (s) => !s.has('solaire'),
    text: 'Je revends mon panneau solaire 200 W, 150 €. Avec ça tu ne branches plus jamais rien.',
    left: Choice('Pas besoin', effects: {lie: -2}),
    right: Choice('Je prends', setFlags: {'solaire'}, effects: {arg: -8, mor: 4}),
  ),
  GameCard(
    id: 'batterie_vide',
    who: toi,
    condition: (s) => !s.has('solaire'),
    weight: 1.2,
    text: 'Batterie auxiliaire à plat. Le frigo est tiède, le beurre coule.',
    left: Choice('Rouler pour recharger', effects: {arg: -4, van: -2}),
    right: Choice('Tant pis', effects: {mor: -7}),
  ),
  GameCard(
    id: 'toilettes',
    who: toi,
    text: 'La cassette des toilettes est pleine. Prochain point de vidange : 40 km.',
    left: Choice('Rouler', effects: {arg: -2, van: -2}),
    right: Choice('Euh... la nature', outcomes: [
      Outcome(chance: 70, effects: {mor: -2}, text: 'Pas fier. Mais discret.'),
      Outcome(chance: 30, effects: {lie: -8, mor: -6}, text: 'Un groupe de randonneurs. Tous t\'ont vu.'),
    ]),
  ),
  GameCard(
    id: 'hiver_froid',
    who: meteo,
    chainOnly: true,
    condition: (s) => !s.has('chauffage'),
    text: '-6 °C cette nuit. La buée gèle à l\'intérieur des vitres.',
    left: Choice('Chauffage diesel, 300 €', setFlags: {'chauffage'}, effects: {arg: -15, mor: 8}),
    right: Choice('Une couverture de plus', effects: {mor: -12, lie: 2}),
  ),
  GameCard(
    id: 'eau_gelee',
    who: toi,
    seasons: {Season.hiver},
    condition: (s) => !s.has('chauffage'),
    text: 'Les canalisations ont gelé. La pompe fait un bruit d\'agonie.',
    left: Choice('Je purge tout', effects: {van: 2, mor: -5}),
    right: Choice('Bouilloire et patience', effects: {mor: -3, van: -7}),
  ),
  GameCard(
    id: 'canicule',
    who: meteo,
    seasons: {Season.ete},
    regions: france,
    text: '39 °C dans le van à minuit. Le ventilo brasse de l\'air chaud.',
    left: Choice('Ventilo 12 V de plus', effects: {arg: -4, mor: 3}),
    right: Choice('Cap sur la montagne', moveTo: Region.alpes, effects: {van: -5, mor: 7, arg: -3}),
  ),
  GameCard(
    id: 'orage',
    who: meteo,
    seasons: {Season.printemps, Season.automne},
    text: 'Alerte orange orages. Tu es garé sous un énorme chêne.',
    left: Choice('Je bouge', effects: {mor: -3, van: -1}),
    right: Choice('Ça ira', outcomes: [
      Outcome(chance: 70, effects: {mor: 3}, text: 'Le spectacle des éclairs, bien au chaud.'),
      Outcome(chance: 30, effects: {van: -20, mor: -8}, text: 'Une branche sur le toit. Le lanterneau est en miettes.'),
    ]),
  ),
  GameCard(
    id: 'starlink',
    who: vendeur,
    condition: (s) => s.has('freelance') && !s.has('starlink'),
    text: 'Antenne satellite : internet n\'importe où. 450 € plus l\'abonnement.',
    left: Choice('Trop cher', effects: {arg: 3}),
    right: Choice('Je prends', setFlags: {'starlink'}, effects: {arg: -14, mor: 6}),
  ),

  // =========================================================================
  // ARGENT, TRAVAIL
  // =========================================================================
  GameCard(
    id: 'freelance',
    who: client,
    condition: (s) => !s.has('freelance'),
    text: 'Un site WordPress à refaire, trois semaines de boulot. Tu peux bosser depuis le van ?',
    left: Choice('Je suis en pause de ma vie', effects: {mor: 5, arg: -1}),
    right: Choice('Envoie le brief', setFlags: {'freelance'}, effects: {arg: 14, mor: -5}),
  ),
  GameCard(
    id: 'wifi',
    who: client,
    condition: (s) => s.has('freelance') && !s.has('starlink'),
    text: 'Visio dans 20 minutes, on présente la maquette. Tu as du réseau ?',
    left: Choice('Je fonce au McDo', effects: {van: -3, arg: -2, mor: -2}),
    right: Choice('Je la rate', outcomes: [
      Outcome(chance: 50, effects: {mor: 2}, text: '« Pas de souci, on décale. » Ouf.'),
      Outcome(chance: 50, effects: {arg: -7, mor: -5}, clearFlags: {'freelance'}, text: 'Il te retire le projet. Mail sec, pas de signature.'),
    ]),
  ),
  GameCard(
    id: 'burnout',
    who: toi,
    condition: (s) => s.has('freelance') && s[mor] < 40,
    text: 'Une semaine entière ordinateur sur les genoux. Le lac est à 50 mètres, tu ne l\'as pas vu.',
    left: Choice('Je coupe tout', clearFlags: {'freelance'}, effects: {mor: 15, arg: -4}),
    right: Choice('Encore une semaine', effects: {arg: 14, mor: -10}),
  ),
  GameCard(
    id: 'vendanges',
    who: viticulteur,
    seasons: {Season.automne},
    regions: france,
    text: 'Vendanges : trois semaines, payé au SMIC, logé dans le pré. Le dos en compote garanti.',
    left: Choice('Non merci', effects: {arg: -1}),
    right: Choice('Je signe', effects: {arg: 28, mor: -9, van: -2, lie: 5}),
  ),
  GameCard(
    id: 'woofing',
    who: ferme,
    text: 'Woofing : quatre heures de travail par jour, logé nourri, deux semaines.',
    left: Choice('Pas envie', effects: {mor: 2, arg: -2}),
    right: Choice('Je mets les bottes', effects: {arg: 13, lie: 6, mor: -4}),
  ),
  GameCard(
    id: 'marche',
    who: marche,
    text: 'Une place libre au marché ce dimanche. Tu pourrais vendre tes tirages photo.',
    left: Choice('Pas mon truc', effects: {mor: -1}),
    right: Choice('Je tente', outcomes: [
      Outcome(chance: 55, effects: {arg: 14, lie: 5}, text: 'Tout est parti. Une dame veut une commande.'),
      Outcome(chance: 45, effects: {arg: -2, mor: -5}, text: 'Trois heures sous la pluie, une vente. À ta tante, au téléphone.'),
    ]),
  ),
  GameCard(
    id: 'argent_bas',
    who: toi,
    condition: (s) => s[arg] < 25,
    weight: 1.5,
    text: 'Plus que 80 € sur le compte. Le plein en coûte 90.',
    left: Choice('Pâtes à l\'eau un mois', effects: {mor: -8, arg: 8}),
    right: Choice('Petits boulots via appli', effects: {arg: 17, mor: -4, lie: -2}),
  ),
  GameCard(
    id: 'galere',
    who: galere,
    condition: (s) => s[arg] > 65,
    text: 'Mon embrayage a lâché. Il me manque 300 € pour repartir. Je te rembourse, promis.',
    left: Choice('Désolé', effects: {lie: -6, mor: -3}),
    right: Choice('Tiens', outcomes: [
      Outcome(chance: 60, effects: {arg: -14, lie: 10, mor: 5}, text: 'Il t\'envoie une carte postale de Grèce. Pas l\'argent.'),
      Outcome(chance: 40, effects: {arg: -6, lie: 12, mor: 6}, text: 'Il te rembourse la moitié un mois plus tard. Avec un pot de miel.'),
    ]),
  ),
  GameCard(
    id: 'banque',
    who: banque,
    condition: (s) => s.region.abroad,
    text: 'Votre carte est bloquée : paiement inhabituel à l\'étranger.',
    left: Choice('Appeler la banque', effects: {mor: -6, arg: -1}),
    right: Choice('Faire avec le liquide', effects: {arg: -4, lie: -2}),
  ),

  // =========================================================================
  // LOI, STATIONNEMENT
  // =========================================================================
  GameCard(
    id: 'gendarme_nuit',
    who: gendarme,
    regions: france,
    text: 'Bonsoir. Le camping sauvage est interdit ici. Vous partez ce soir.',
    left: Choice('Négocier', outcomes: [
      Outcome(chance: 50, effects: {mor: 5}, text: '« Bon. Juste cette nuit. Et rien par terre. »'),
      Outcome(chance: 50, effects: {arg: -10, mor: -4}, counters: {'pv': 1}, text: 'Il sort le carnet. 135 €.'),
    ]),
    right: Choice('On part', effects: {mor: -6, van: -2}),
  ),
  GameCard(
    id: 'police_municipale',
    who: police,
    regions: france,
    text: 'Arrêté municipal : stationnement interdit aux véhicules aménagés de 22 h à 7 h.',
    left: Choice('Je reste', outcomes: [
      Outcome(chance: 60, effects: {mor: 3}, text: 'Personne ne passe. Nuit tranquille.'),
      Outcome(chance: 40, effects: {arg: -10}, counters: {'pv': 1}, text: 'PV sur le pare-brise au réveil.'),
    ]),
    right: Choice('Je bouge', effects: {mor: -4}),
  ),
  GameCard(
    id: 'pv_recidive',
    who: police,
    once: true,
    condition: (s) => s.count('pv') >= 2,
    weight: 3,
    text: 'Encore vous. Votre plaque est connue. Cette fois, c\'est la fourrière ou vous payez tout.',
    left: Choice('Je paie tout', effects: {arg: -18, mor: -6}),
    right: Choice('Je conteste', outcomes: [
      Outcome(chance: 40, effects: {mor: 10}, text: 'Vice de procédure. Le PV saute. Tu repars en sifflant.'),
      Outcome(chance: 60, effects: {}, ending: 'fourriere', text: 'La dépanneuse est déjà là.'),
    ]),
  ),
  GameCard(
    id: 'guardia',
    who: guardia,
    regions: {Region.espagne},
    text: 'Prohibido acampar. Multa de 200 euros.',
    left: Choice('Partir tout de suite', effects: {mor: -4}),
    right: Choice('Expliquer en espagnol', outcomes: [
      Outcome(chance: 50, effects: {mor: 6, lie: 3}, text: 'Ton accent les fait rire. Ils te laissent.'),
      Outcome(chance: 50, effects: {arg: -13}, text: 'Ton accent les fait rire. Ils te verbalisent quand même.'),
    ]),
  ),

  // =========================================================================
  // LE CHIEN
  // =========================================================================
  GameCard(
    id: 'chien',
    who: chienErrant,
    once: true,
    condition: (s) => !s.has('chien'),
    text: 'Un chien maigre te suit depuis la plage. Il s\'assoit devant la portière et attend.',
    left: Choice('Le chasser', effects: {mor: -6}),
    right: Choice('Monte',
        setFlags: {'chien'},
        effects: {arg: -4, mor: 12},
        followups: [Followup('chien_veto', delay: 4)],
        result: 'Tu l\'appelles Gasoil.'),
  ),
  GameCard(
    id: 'chien_veto',
    who: veto,
    chainOnly: true,
    condition: (s) => s.has('chien'),
    text: 'Vaccins, puce, passeport européen pour Gasoil : 180 €.',
    left: Choice('Trop cher', outcomes: [
      Outcome(chance: 65, effects: {mor: 1}, text: 'Il a l\'air en pleine forme.'),
      Outcome(chance: 35, effects: {arg: -15, mor: -8}, text: 'Il tombe malade la semaine suivante. Tu paies, et plus cher.'),
    ]),
    right: Choice('Je paie', effects: {arg: -10, mor: 3}),
  ),
  GameCard(
    id: 'chien_saucisson',
    who: voisin,
    condition: (s) => s.has('chien'),
    text: 'Ton chien vient de partir avec mon saucisson. Entier.',
    left: Choice('C\'est pas le mien', effects: {lie: -8, mor: 3}),
    right: Choice('Je rembourse en vin', effects: {arg: -4, lie: 9}),
  ),
  GameCard(
    id: 'chien_perdu',
    who: toi,
    once: true,
    minTurn: 15,
    condition: (s) => s.has('chien'),
    text: 'Gasoil a disparu dans la forêt ce matin. Il ne revient pas.',
    left: Choice('Je cherche toute la nuit', effects: {mor: -4}, outcomes: [
      Outcome(chance: 80, effects: {mor: 12}, text: 'Il était coincé dans un roncier. Il te lèche le visage pendant dix minutes.'),
      Outcome(chance: 20, effects: {mor: -18}, clearFlags: {'chien'}, text: 'Tu ne le retrouves pas.'),
    ]),
    right: Choice('Il reviendra', outcomes: [
      Outcome(chance: 50, effects: {mor: 6}, text: 'Il revient à l\'aube, couvert de boue, très content de lui.'),
      Outcome(chance: 50, effects: {mor: -22, lie: -4}, clearFlags: {'chien'}, text: 'Il ne revient pas.'),
    ]),
  ),

  // =========================================================================
  // INSTAGRAM (arc)
  // =========================================================================
  GameCard(
    id: 'lila',
    who: lila,
    once: true,
    condition: (s) => !s.has('insta'),
    text: 'Ton van est trop mignon ! On fait une collab ? Ouvre un compte, je te partage.',
    left: Choice('Pas mon truc', effects: {mor: 3}),
    right: Choice('Go',
        setFlags: {'insta'},
        effects: {lie: 5, mor: -2},
        followups: [Followup('insta_sponsor', delay: 4)]),
  ),
  GameCard(
    id: 'insta_sponsor',
    who: marque,
    chainOnly: true,
    text: 'On adorerait un post avec notre gourde isotherme. 300 €.',
    left: Choice('Je refuse', effects: {mor: 5}),
    right: Choice('Je pose avec la gourde',
        effects: {arg: 21, mor: -5},
        counters: {'insta': 1},
        followups: [Followup('insta_geotag', delay: 3)]),
  ),
  GameCard(
    id: 'insta_geotag',
    who: story,
    chainOnly: true,
    text: 'Ta story géolocalisée cartonne : 20 000 vues. Spot magnifique, très isolé.',
    left: Choice('Retirer la localisation', effects: {mor: -2}),
    right: Choice('Laisser, ça buzze',
        effects: {arg: 7},
        counters: {'insta': 1},
        followups: [Followup('cambriolage', delay: 3)]),
  ),
  GameCard(
    id: 'cambriolage',
    who: toi,
    chainOnly: true,
    text: 'Retour de rando : vitre arrière éclatée. L\'ordinateur a disparu.',
    left: Choice('Porter plainte', effects: {arg: -7, van: -8, mor: -10}),
    right: Choice('Enquêter via les commentaires', outcomes: [
      Outcome(chance: 35, effects: {mor: 15, lie: 8}, text: 'Tes abonnés retrouvent le voleur sur Leboncoin. Ordi récupéré.'),
      Outcome(chance: 55, effects: {van: -15, mor: -15}, text: 'Rien. Et la vitre coûte une fortune.'),
      Outcome(chance: 10, effects: {}, ending: 'vente_sauvage', text: 'Le lendemain, ils reviennent pour le reste.'),
    ]),
  ),
  GameCard(
    id: 'insta_haters',
    who: commentaires,
    condition: (s) => s.has('insta'),
    text: '« Encore un privilégié qui joue au pauvre dans un van à 40 000 €. » 3 000 likes.',
    left: Choice('Répondre', effects: {mor: -9, arg: 6}, counters: {'insta': 1}),
    right: Choice('Ignorer', effects: {mor: -3}),
  ),
  GameCard(
    id: 'insta_million',
    who: manager,
    once: true,
    weight: 3,
    condition: (s) => s.count('insta') >= 4,
    text: 'Une plateforme veut une émission sur toi. Contrat d\'exclusivité, cinq ans.',
    left: Choice('Je supprime le compte', clearFlags: {'insta'}, effects: {mor: 12, arg: -4}),
    right: Choice('Signer', ending: 'influenceur'),
  ),

  // =========================================================================
  // FAMILLE
  // =========================================================================
  GameCard(
    id: 'maman',
    who: maman,
    cooldown: 8,
    dynamicText: (s) => s.region.abroad
        ? 'Tu es où, là ? ${s.region.label} ?! Tu manges bien au moins ?'
        : 'Tu manges bien au moins ? Tu reviens quand ?',
    text: '',
    left: Choice('Pas le temps', effects: {lie: -7, mor: 2}, counters: {'maman_ignore': 1}),
    right: Choice('Une heure au téléphone', effects: {lie: 8, mor: -2}),
  ),
  GameCard(
    id: 'maman_inquiete',
    who: soeur,
    once: true,
    condition: (s) => s.count('maman_ignore') >= 2,
    weight: 2.5,
    text: 'Rappelle maman. Quatre messages vocaux. Elle s\'inquiète vraiment.',
    left: Choice('Plus tard', effects: {lie: -14}),
    right: Choice('Je rentre une semaine', moveTo: Region.normandie, effects: {lie: 15, arg: -7}),
  ),
  GameCard(
    id: 'maman_poignet',
    who: soeur,
    once: true,
    minTurn: 22,
    text: 'Maman s\'est cassé le poignet en jardinant. Elle dit que ça va. Elle dit toujours que ça va.',
    left: Choice('Elle dit que ça va', effects: {lie: -10, mor: -5}),
    right: Choice('Je rentre l\'aider',
        moveTo: Region.normandie,
        effects: {lie: 12, arg: -6},
        followups: [Followup('rester_famille', delay: 2)]),
  ),
  GameCard(
    id: 'rester_famille',
    who: soeur,
    chainOnly: true,
    text: 'Elle va mieux. Tu pourrais rester, tu sais. Il y a du travail ici, et ta chambre.',
    left: Choice('Je repars', effects: {mor: 8, lie: -5}),
    right: Choice('Je reste', ending: 'retour_famille'),
  ),

  // =========================================================================
  // RENCONTRES
  // =========================================================================
  GameCard(
    id: 'lea_convoi',
    who: lea,
    condition: (s) => !s.has('convoi'),
    text: 'On fait route ensemble jusqu\'au prochain spot ? On partage les courses.',
    left: Choice('Je préfère seul·e', effects: {lie: -4, mor: 2}),
    right: Choice('Convoi !',
        setFlags: {'convoi'},
        effects: {lie: 10, arg: 4},
        followups: [Followup('lea_depart', delay: 6)]),
  ),
  GameCard(
    id: 'lea_depart',
    who: lea,
    chainOnly: true,
    condition: (s) => s.has('convoi'),
    text: 'Je file vers les Alpes. Tu viens ?',
    left: Choice('Nos routes se séparent', clearFlags: {'convoi'}, effects: {lie: -6, mor: -3}),
    right: Choice('On te suit', clearFlags: {'convoi'}, moveTo: Region.alpes, effects: {lie: 8, arg: -6, van: -3}),
  ),
  GameCard(
    id: 'festival',
    who: festival,
    seasons: {Season.printemps, Season.ete},
    text: 'Bénévole sur le festival ce week-end ? Logé, nourri, bracelet backstage.',
    left: Choice('Trop de monde', effects: {mor: -2, lie: -3}),
    right: Choice('J\'y vais',
        effects: {lie: 11, mor: 7, van: -3},
        followups: [Followup('coup_de_foudre', delay: 2)]),
  ),
  GameCard(
    id: 'coup_de_foudre',
    who: message,
    chainOnly: true,
    once: true,
    condition: (s) => s.has('solo') && !s.has('amour'),
    text: '« On s\'est croisés au stand crêpes. Je pense encore à toi. On se revoit ? »',
    left: Choice('Pas d\'attache', effects: {mor: 2, lie: -3}),
    right: Choice('Oui', setFlags: {'amour'}, effects: {lie: 15, mor: 10}),
  ),
  GameCard(
    id: 'amour_choix',
    who: message,
    once: true,
    condition: (s) => s.has('amour') && s.has('solo'),
    minTurn: 12,
    text: 'On se voit entre deux trajets depuis des semaines. Je viens avec toi, dans le van ?',
    left: Choice('La route, seul·e', clearFlags: {'amour'}, effects: {mor: -10, lie: -10}),
    right: Choice('Monte', clearFlags: {'solo'}, setFlags: {'duo'}, effects: {lie: 10, mor: 6}),
  ),
  GameCard(
    id: 'pote',
    who: pote,
    text: 'Je pose une semaine de congés et je te rejoins ! Il y a de la place pour moi ?',
    left: Choice('Pas vraiment', effects: {lie: -8}),
    right: Choice('Ramène des chips', effects: {lie: 12, arg: -4, mor: 4, van: -2}),
  ),
  GameCard(
    id: 'stoppeur',
    who: stoppeur,
    text: 'Un auto-stoppeur trempé, pouce levé, sous une pluie battante.',
    left: Choice('Je passe', effects: {mor: -3}),
    right: Choice('Monte', outcomes: [
      Outcome(chance: 80, effects: {lie: 8, mor: 4}, text: 'Il raconte trois ans de voyage à pied. Tu ne vois pas passer la route.'),
      Outcome(chance: 20, effects: {arg: -6, mor: -6}, text: 'Il descend à la station. Ta boîte à gants est vide.'),
    ]),
  ),
  GameCard(
    id: 'amie',
    who: amie,
    condition: (s) => s[lie] < 30,
    weight: 1.5,
    text: 'Ça fait des mois... Tu es où en ce moment ? Tu me manques.',
    left: Choice('Laisser en vu', effects: {lie: -5, mor: -3}),
    right: Choice('L\'appeler', effects: {lie: 13, mor: 3}),
  ),
  GameCard(
    id: 'whatsapp',
    who: whatsapp,
    condition: (s) => s[lie] > 70,
    text: '214 messages non lus. « Et si on organisait le prochain rassemblement chez toi ? »',
    left: Choice('Quitter le groupe', effects: {lie: -12, mor: 5}),
    right: Choice('Organiser', effects: {lie: 5, arg: -6, mor: -4}),
  ),
  GameCard(
    id: 'fete_village',
    who: village,
    regions: france,
    seasons: {Season.ete, Season.printemps},
    text: 'C\'est la fête au village ! Viens à la buvette, on t\'offre la première.',
    left: Choice('Je reste au calme', effects: {mor: -2}),
    right: Choice('La deuxième, c\'est moi', effects: {lie: 10, arg: -4, mor: 5}),
  ),
  GameCard(
    id: 'ados',
    who: ados,
    text: 'Musique à fond sur le parking, il est 2 h du matin.',
    left: Choice('Aller leur parler', outcomes: [
      Outcome(chance: 60, effects: {lie: 4}, text: 'Ils baissent. Ils te proposent même une chips.'),
      Outcome(chance: 40, effects: {mor: -6}, text: 'Ils montent le son.'),
    ]),
    right: Choice('Changer de spot', effects: {van: -2, mor: -6}),
  ),
  GameCard(
    id: 'musicien',
    who: musicien,
    regions: {Region.espagne, Region.portugal},
    text: 'Je joue de la guitare tout le trajet si tu m\'emmènes jusqu\'à Lisbonne.',
    left: Choice('Non, désolé', effects: {lie: -3}),
    right: Choice('En voiture', moveTo: Region.portugal, effects: {lie: 9, mor: 6, arg: -2}),
  ),

  // =========================================================================
  // COUPLE (si duo)
  // =========================================================================
  GameCard(
    id: 'duo_vaisselle',
    who: sam,
    condition: (s) => s.has('duo'),
    text: 'Tu as encore laissé la vaisselle. Six mètres carrés, je te rappelle.',
    left: Choice('Je la fais', effects: {lie: 6, mor: -2}),
    right: Choice('C\'est ton tour', outcomes: [
      Outcome(chance: 50, effects: {lie: 3}, text: 'Sam éclate de rire. Vous la faites à deux.'),
      Outcome(chance: 50, effects: {lie: -12, mor: -5}, text: 'Silence glacial jusqu\'à Bordeaux.'),
    ]),
  ),
  GameCard(
    id: 'duo_espace',
    who: sam,
    condition: (s) => s.has('duo') && s[lie] < 45,
    text: 'J\'ai besoin d\'air. Je pars une semaine chez ma sœur.',
    left: Choice('Reste, on en parle', effects: {lie: 5, mor: -6}),
    right: Choice('Prends le temps',
        effects: {lie: -5, mor: 5},
        followups: [Followup('duo_retour', delay: 3)]),
  ),
  GameCard(
    id: 'duo_retour',
    who: sam,
    chainOnly: true,
    text: 'Je reviens. Mais il faut qu\'on change des choses. Un vrai rythme, des pauses.',
    left: Choice('Je ne change rien', effects: {lie: -12, mor: 3}),
    right: Choice('D\'accord', effects: {lie: 15, mor: 5, arg: -2}),
  ),
  GameCard(
    id: 'duo_nord',
    who: sam,
    once: true,
    condition: (s) => s.has('duo') && s[lie] > 55 && !s.has('objectif_nord'),
    text: 'Et si on montait jusqu\'au Cap Nord ? Le soleil de minuit, tous les deux.',
    left: Choice('Le Sud plutôt', moveTo: Region.espagne, effects: {mor: 5, arg: -6, van: -4}),
    right: Choice('Au Nord !',
        setFlags: {'objectif_nord'},
        moveTo: Region.scandinavie,
        effects: {mor: 10, arg: -8, van: -6},
        followups: [Followup('nord_route', delay: 3)]),
  ),

  // =========================================================================
  // VOYAGE, RÉGIONS
  // =========================================================================
  GameCard(
    id: 'carte_europe',
    who: toi,
    minTurn: 8,
    condition: (s) => !s.has('objectif_nord') && !s.region.abroad,
    text: 'Tu déplies la carte de l\'Europe sur le capot. Une idée folle : le Cap Nord.',
    left: Choice('Rester en France', effects: {mor: -2}),
    right: Choice('Cap au Nord',
        setFlags: {'objectif_nord'},
        moveTo: Region.scandinavie,
        effects: {mor: 8, arg: -10, van: -6},
        followups: [Followup('nord_route', delay: 3)]),
  ),
  GameCard(
    id: 'nord_route',
    who: toi,
    chainOnly: true,
    text: 'Norvège. Le plein coûte 2,40 € le litre et chaque virage est une carte postale.',
    left: Choice('Ralentir, économiser', effects: {arg: 6, mor: -5}, followups: [Followup('nord_ferry', delay: 3)]),
    right: Choice('Foncer', effects: {arg: -10, van: -8}, followups: [Followup('nordkapp', delay: 3)]),
  ),
  GameCard(
    id: 'nord_ferry',
    who: toi,
    chainOnly: true,
    text: 'Ferry côtier ou route des fjords, plus longue et plus raide ?',
    left: Choice('Ferry', effects: {arg: -8, mor: 3}, followups: [Followup('nordkapp', delay: 2)]),
    right: Choice('Les fjords', effects: {van: -12, mor: 12}, followups: [Followup('nordkapp', delay: 3)]),
  ),
  GameCard(
    id: 'nordkapp',
    who: meteo,
    chainOnly: true,
    regions: {Region.scandinavie},
    dynamicText: (s) => s.season == Season.hiver
        ? 'Cap Nord à 30 km. Nuit polaire, route verglacée, convoi derrière un chasse-neige.'
        : 'Cap Nord à 30 km. Une tempête arrive de la mer de Barents.',
    text: '',
    left: Choice('Attendre une fenêtre', effects: {mor: -5, arg: -4}, followups: [Followup('nordkapp', delay: 2)]),
    right: Choice('Y aller maintenant', outcomes: [
      Outcome(chance: 65, ending: 'cap_nord', text: 'Tu y es.'),
      Outcome(chance: 35, effects: {van: -22, mor: -10}, followups: [Followup('nordkapp', delay: 3)], text: 'Rafales à 110 km/h. Demi-tour, rétroviseur arraché.'),
    ]),
  ),
  GameCard(
    id: 'cap_sud',
    who: tiago,
    regions: france,
    condition: (s) => !s.has('objectif_nord'),
    dynamicText: (s) => s.season == Season.hiver || s.season == Season.automne
        ? 'Ici à Ericeira il fait 18 °C et les vagues sont parfaites. Tu descends ?'
        : 'Tu devrais descendre au Portugal. Le spot est désert hors saison, tu verras.',
    text: '',
    left: Choice('Je reste', effects: {mor: -3}),
    right: Choice('Cap au sud', moveTo: Region.portugal, effects: {arg: -8, van: -6, mor: 10}),
  ),
  GameCard(
    id: 'surf',
    who: tiago,
    regions: {Region.portugal},
    text: 'Cours de surf gratuits si tu m\'aides à refaire le site de mon école.',
    left: Choice('Je préfère le hamac', effects: {mor: 4}),
    right: Choice('Deal', effects: {lie: 8, mor: 8, arg: -1}),
  ),
  GameCard(
    id: 'tarifa',
    who: toi,
    regions: {Region.espagne},
    condition: (s) => !s.has('maroc_fait'),
    text: 'Tarifa. Le ferry pour Tanger part dans une heure. L\'Afrique est à 14 km.',
    left: Choice('Pas cette fois', effects: {mor: -2}),
    right: Choice('Embarquer',
        moveTo: Region.maroc,
        setFlags: {'maroc_fait'},
        effects: {arg: -7, mor: 12},
        followups: [Followup('douane', delay: 1)]),
  ),
  GameCard(
    id: 'portugal_vers_espagne',
    who: toi,
    regions: {Region.portugal},
    text: 'L\'Algarve est envahie de camping-cars. L\'Andalousie est à deux heures.',
    left: Choice('Je reste ici', effects: {mor: -3, lie: 3}),
    right: Choice('Andalousie', moveTo: Region.espagne, effects: {arg: -4, van: -3, mor: 5}),
  ),
  GameCard(
    id: 'douane',
    who: douanier,
    chainOnly: true,
    text: 'Fouille complète du véhicule. Ça va prendre un moment.',
    left: Choice('Patienter', effects: {mor: -8}),
    right: Choice('Proposer le café', outcomes: [
      Outcome(chance: 60, effects: {lie: 6, mor: 4}, text: 'Thé à la menthe partagé. On te conseille un spot.'),
      Outcome(chance: 40, effects: {mor: -10, arg: -4}, text: 'Mal pris. Deux heures de plus.'),
    ]),
  ),
  GameCard(
    id: 'rachid',
    who: rachid,
    regions: {Region.maroc},
    text: 'Je te refais la boîte de vitesses pour dix fois moins cher qu\'en France. Garanti.',
    left: Choice('Pas confiance', effects: {van: -3}),
    right: Choice('Vas-y', effects: {arg: -6}, outcomes: [
      Outcome(chance: 75, effects: {van: 25, lie: 4}, text: 'Travail d\'orfèvre. Il refuse le pourboire.'),
      Outcome(chance: 25, effects: {van: -10}, text: 'La troisième ne passe plus. « Garanti » avait un sens flou.'),
    ]),
  ),
  GameCard(
    id: 'desert',
    who: guide,
    regions: {Region.maroc},
    text: 'Une nuit dans le désert, sous les étoiles ? La piste est un peu sablonneuse.',
    left: Choice('Mon van déteste le sable', effects: {mor: -2}),
    right: Choice('Les étoiles', effects: {van: -10, mor: 15, lie: 4}),
  ),
  GameCard(
    id: 'retour_france',
    who: toi,
    condition: (s) => s.region.abroad && !s.has('objectif_nord'),
    minTurn: 6,
    text: 'Le mal du pays : une baguette, un fromage qui pue, une petite pluie fine.',
    left: Choice('Pas encore', effects: {mor: -4}),
    right: Choice('Remonter en Bretagne', moveTo: Region.bretagne, effects: {arg: -8, mor: 6, lie: 6, van: -4}),
  ),
  GameCard(
    id: 'pyrenees',
    who: toi,
    regions: france,
    condition: (s) => s.region != Region.pyrenees,
    text: 'Les Pyrénées sont à une journée de route. Lacs, cols, brebis.',
    left: Choice('Pas maintenant', effects: {mor: -1}),
    right: Choice('Go', moveTo: Region.pyrenees, effects: {arg: -4, van: -3, mor: 6}),
  ),
  GameCard(
    id: 'col',
    who: toi,
    regions: {Region.pyrenees, Region.alpes},
    text: 'Le col affiche 12 %. L\'aiguille de température grimpe.',
    left: Choice('Demi-tour', effects: {mor: -5}),
    right: Choice('Ça passe', outcomes: [
      Outcome(chance: 65, effects: {mor: 12}, text: 'Au sommet, un vautour plane à hauteur de ton pare-brise.'),
      Outcome(chance: 35, effects: {van: -18, mor: -4}, text: 'Joint de culasse fatigué. Descente au point mort.'),
    ]),
  ),
  GameCard(
    id: 'neige',
    who: meteo,
    regions: {Region.alpes, Region.pyrenees},
    seasons: {Season.hiver},
    text: 'Vingt centimètres de neige fraîche. Tu n\'as pas de chaînes.',
    left: Choice('Acheter des chaînes', effects: {arg: -6, van: 2}),
    right: Choice('Ça passe', outcomes: [
      Outcome(chance: 50, effects: {mor: 6}, text: 'Ça passe. Tu ris nerveusement.'),
      Outcome(chance: 50, effects: {van: -14, arg: -8}, text: 'Fossé. Dépanneuse. Facture.'),
    ]),
  ),
  GameCard(
    id: 'yves',
    who: yves,
    regions: littoral,
    text: 'Dors dans mon champ si tu veux. En échange, tu m\'aides à ramasser les pommes ?',
    left: Choice('Je passe', effects: {lie: -2}),
    right: Choice('Les pommes', effects: {lie: 8, mor: 5, arg: 4}),
  ),
  GameCard(
    id: 'maree',
    who: pecheur,
    regions: littoral,
    text: 'Tu t\'es garé sur la plage ? La marée monte vite, ici. Très vite.',
    left: Choice('Je fonce', outcomes: [
      Outcome(chance: 80, effects: {mor: 4}, text: 'Les roues patinent, puis accrochent. Ouf.'),
      Outcome(chance: 20, effects: {van: -18, arg: -7}, text: 'Ensablé. L\'eau arrive aux jantes.'),
    ]),
    right: Choice('Votre tracteur ?', effects: {arg: -4, lie: 6}),
  ),
  GameCard(
    id: 'spot_choix',
    who: appli,
    text: 'Un spot noté 4,9 avec 300 avis, ou ce chemin forestier jamais référencé ?',
    left: Choice('Le 4,9', outcomes: [
      Outcome(chance: 60, effects: {mor: -4, lie: 3}, text: 'Vingt-deux vans. Un type joue du djembé.'),
      Outcome(chance: 40, effects: {mor: 6}, text: 'Mérité. Vue incroyable.'),
    ]),
    right: Choice('L\'inconnu', outcomes: [
      Outcome(chance: 50, effects: {mor: 12}, text: 'Une clairière, un ruisseau, personne. Tu restes trois jours.'),
      Outcome(chance: 30, effects: {van: -10, mor: -3}, text: 'Boue jusqu\'aux essieux.'),
      Outcome(chance: 20, effects: {lie: -5, mor: -6}, text: 'Battue au sanglier à 7 h. Coups de fusil, chasseurs furieux.'),
    ]),
  ),

  // =========================================================================
  // INTROSPECTION, RÉGULATEURS
  // =========================================================================
  GameCard(
    id: 'pourquoi',
    who: toi,
    condition: (s) => s[mor] < 35,
    weight: 1.4,
    text: 'Assis sur le marchepied, tu te demandes pourquoi tu fais ça, déjà.',
    left: Choice('Pour la liberté', effects: {mor: 8, lie: -3}),
    right: Choice('Je ne sais plus', effects: {mor: -4, lie: 7}, result: 'Tu appelles quelqu\'un. Ça fait du bien.'),
  ),
  GameCard(
    id: 'trop_parfait',
    who: toi,
    condition: (s) => s[mor] > 72,
    weight: 1.4,
    text: 'Tout est parfait. Le café, la vue, le silence. Trop parfait ?',
    left: Choice('Savourer', effects: {mor: 6}),
    right: Choice('Se lancer un défi', effects: {mor: -10, arg: 6, van: -2}, result: 'Tu t\'inscris à un trail de 40 km. Tu le regretteras au km 12.'),
  ),
  GameCard(
    id: 'anniversaire',
    who: toi,
    chainOnly: true,
    once: true,
    dynamicText: (s) => 'Un an sur la route. Tu fêtes ça en ${s.region.label}, '
        '${s.has('chien') ? 'Gasoil à tes pieds' : 'seul avec un gâteau de station-service'}.',
    text: '',
    left: Choice('Encore un an', effects: {mor: 10, van: -4}),
    right: Choice('Rentrer, la tête pleine', ending: 'retour_famille'),
  ),
];
