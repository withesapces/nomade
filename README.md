# Nomade

Jeu de cartes à swiper façon Reigns, sur la vie en van. Flutter, Android.

## Lancer le projet

Le dossier contient le code du jeu, pas les fichiers natifs Android. Flutter les génère :

```bash
cd nomade
flutter create . --project-name nomade --platforms android
flutter pub get
flutter test        # 8 tests moteur + 1 test d'écran, affiche aussi des stats d'équilibrage
flutter run         # téléphone branché en USB (débogage USB activé) ou émulateur
```

`flutter create .` ne touche pas aux fichiers existants : il ajoute seulement le dossier `android/`.

APK à installer : `flutter build apk --release`, fichier dans `build/app/outputs/flutter-apk/app-release.apk`.

## Règles

Quatre jauges : Argent, Moral, Van, Liens. Glisse la carte à gauche ou à droite.
Si une jauge tombe à 0 ou monte à 100, la partie s'arrête. Trop d'argent ou trop de moral finit mal aussi.
En glissant, un point apparaît au-dessus des jauges touchées : petit = effet léger, gros = effet fort, cercle creux = résultat incertain.

13 fins : 8 liées aux jauges, 5 scénarisées (dont une victoire au Cap Nord).

## Ce qui rend le jeu « intelligent »

| Système | Où | Effet |
|---|---|---|
| Directeur de tension | `engine.dart` `_directorWeight` | Les cartes qui touchent une jauge en danger (<25 ou >75) sortent 1,8× plus souvent : chaque crise devient un vrai dilemme. Évite deux fois le même personnage. |
| Suites d'histoire | `Followup` | Ignorer un bruit de roue programme une panne 4 tours plus tard. Une story géolocalisée amène un cambriolage. |
| Issues aléatoires | `Outcome` | Les choix risqués se tirent au sort, avec un texte de conséquence. |
| Mémoire | flags et compteurs | Le chien, le panneau solaire, les PV accumulés, les appels ignorés à ta mère changent les cartes disponibles. |
| Monde vivant | `_passive` | Coût de la vie par région (Scandinavie ×2, Maroc ×0,5), usure du van, hiver sans chauffage, revenus du freelance. |
| Saisons et régions | `seasons`, `regions` | Vendanges en automne, neige dans les Alpes, Guardia Civil en Espagne. 8 régions. |
| Texte dynamique | `dynamicText` | Les personnages réagissent à l'état du van, à la saison, au pays. |

## Ajouter une carte

Dans `lib/data/cards.dart` :

```dart
GameCard(
  id: 'ma_carte',
  who: gerard,
  condition: (s) => s[van] < 40 && s.has('chien'),
  text: 'Ta question ici.',
  left: Choice('Non', effects: {mor: -5}),
  right: Choice('Oui', effects: {arg: -10, van: 15}, followups: [Followup('suite', delay: 3)]),
),
```

Lance `flutter test` après : il vérifie que chaque suite et chaque fin pointe vers quelque chose qui existe.
