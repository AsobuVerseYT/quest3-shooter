# Quest 3 Shooter — projet Godot (build APK 100% automatisé via GitHub Actions)

Jeu de tir VR pour Meta Quest 3 : des cibles rouges apparaissent devant toi et
se déplacent, tu les abats avec le pistolet tenu dans ta main droite (gâchette
de la manette), score + minuteur de 60 secondes affichés en 3D devant toi.

## Pourquoi GitHub Actions et pas un .apk livré directement ?

Je tourne dans un bac à sable cloud dont le pare-feu bloque les téléchargements
du SDK Android (`dl.google.com`, dépôts Ubuntu, Maven) — impossible d'y
compiler et signer un .apk. GitHub Actions, lui, a un accès réseau complet :
le fichier `.github/workflows/build-quest-apk.yml` fourni ici fait tout le
travail — télécharge Godot, le SDK Android, compile et signe l'APK — dès que
tu pousses ce projet sur GitHub. Tu n'as **aucun logiciel à installer**.

## Étapes (10 minutes, une seule fois)

1. Crée un compte GitHub gratuit si tu n'en as pas : https://github.com/signup
2. Crée un nouveau repository (bouton vert "New") — public ou privé, peu importe.
3. Pousse ce dossier dedans. Le plus simple si tu n'as pas Git installé :
   sur la page du repo vide, clique "uploading an existing file" et glisse-
   déposes tout le contenu de ce zip (garde la structure des dossiers).
   Si tu as Git :
   ```
   git init
   git add .
   git commit -m "Quest 3 shooter"
   git branch -M main
   git remote add origin https://github.com/TON-COMPTE/TON-REPO.git
   git push -u origin main
   ```
4. Va dans l'onglet **Actions** du repo sur GitHub → tu devrais voir le
   workflow "Build Quest 3 APK" → clique **"Run workflow"** (bouton à droite)
   → laisse tourner (~8-12 minutes la première fois).
5. Une fois vert ✅, ouvre le run terminé → section **Artifacts** en bas de
   page → télécharge `quest3-shooter-apk` (contient `quest3-shooter.apk`).

## Installer l'APK sur ton Quest 3

1. Active le mode développeur sur ton compte Meta (app Meta Horizon sur ton
   téléphone → ton casque → Paramètres → Mode développeur → Activer).
2. Le plus simple : installe **SideQuest** (https://sidequestvr.com), connecte
   le Quest 3 en USB, glisse le fichier `.apk` téléchargé dans SideQuest.
3. L'app apparaît dans Bibliothèque → Sources inconnues sur le casque.

(L'APK généré est signé en mode "debug" — parfait pour tester sur ton propre
casque via sideload. Pas besoin de compte développeur Meta payant pour ça.)

## Si le build GitHub Actions échoue au premier essai

Le duo Godot + Android + XR est connu pour être pointilleux même pour des
devs expérimentés — je n'ai pas pu exécuter ce workflow moi-même pour le
tester en conditions réelles (je n'ai ni compte GitHub ni casque Quest dans
ce bac à sable). Si le run est rouge ❌ :

1. Ouvre le log de l'étape qui a échoué (clique dessus dans l'onglet Actions).
2. Copie-colle-moi le message d'erreur — je peux corriger le fichier
   `.github/workflows/build-quest-apk.yml` ou `export_presets.cfg` à partir
   de ça.
3. Filet de sécurité : tu peux toujours ouvrir ce même projet dans
   **Godot Engine 4.3** (gratuit, https://godotengine.org/download, pas de
   licence à activer contrairement à Unity) sur ton PC, et faire
   Project → Export → Meta Quest 3 → Export Project toi-même en 2 clics —
   le projet est structuré pour marcher aussi bien en local qu'en CI.

## Contenu du projet

- `scripts/game_manager.gd` — score, minuteur, fin de partie (autoload)
- `scripts/shooter_weapon.gd` — tir via la gâchette de la manette droite
- `scripts/projectile.gd` — comportement de la balle
- `scripts/target.gd` — cible mobile qui encaisse des dégâts
- `scripts/target_spawner.gd` — fait apparaître les cibles, difficulté croissante
- `scripts/hud.gd` / `scripts/main.gd` — affichage score/timer, démarrage OpenXR
- `scenes/main.tscn`, `scenes/target.tscn`, `scenes/projectile.tscn` — la scène jouable
- `export_presets.cfg` — préréglage d'export Android/Meta Quest 3 (OpenXR, arm64)
- `.github/workflows/build-quest-apk.yml` — le build automatique

## Idées d'amélioration une fois que ça tourne

- Vie du joueur / cibles qui ripostent
- Plusieurs armes, rechargement manuel
- Sons et particules d'impact
- High-score local
- Mode passthrough (jouer dans ta vraie pièce)
