# CLAUDE.md

Instructions pour Claude sur ce projet. Réponses en français.

## 🎯 Projet

- **Description** : API REST de gestion de projets, de tâches et de commentaires (avec pièces jointes), pour des utilisateurs qui ont un rôle `user` ou `admin`.
- **Stack et versions** : Node.js 22 ou plus (nécessaire pour `node --watch`), Express 5, PostgreSQL 16, `pg` (node-postgres), dotenv. SQL écrit à la main, sans ORM.
- **Commandes** (toutes depuis `backend/`) :
  - Installer : `npm install`, puis `cp .env.example .env` et remplir les valeurs
  - Créer les tables : `psql -d api_rest -f data/create_table.sql` (⚠️ efface les données)
  - Lancer en dev : `npm run dev`
  - Lancer : `npm start`
  - Tests : `npm test` (Jest + Supertest, à mettre en place)
- **Structure des dossiers** :

  ```text
  backend/
  ├── index.js            → point d'entrée : config, vérification de la base, démarrage
  ├── data/               → scripts SQL
  └── app/
      ├── database.js     → pool pg partagé (seule la couche models l'importe)
      ├── router.js       → regroupe les routes
      ├── routes/         → définition des routes uniquement
      ├── controllers/    → réception de la requête et envoi de la réponse
      ├── services/       → logique métier
      ├── models/         → requêtes SQL
      └── middlewares/    → auth, erreurs, validation
  ```

- **Ordre de travail** : `user` (CRUD) → authentification JWT → `project` → `task` → `comment` → `attachment`.

## 🧭 Façon de travailler

- Une tâche à la fois. Traiter les fichiers un par un, de manière séquentielle.
- Pas d'agents en parallèle ni de tâches en arrière-plan.
- Résumer brièvement ce qui a été fait à chaque étape.
- Découper le travail en tâches courtes, faisables dans une session d'environ 2 h.
- Si une demande contredit une décision ou une leçon de ce fichier, le signaler avant d'agir.
- Proposer les mises à jour de ce fichier ; je valide avant qu'elles soient écrites.

## 🎓 Mode d'accompagnement

- Expliquer brièvement les choix techniques en fin de réponse.
- Proposer avant d'implémenter quand plusieurs approches sont possibles.
- Signaler les mauvaises pratiques repérées dans le code existant.

## 📐 Séparation des responsabilités

- Une couche = une responsabilité (routes → controllers → services → models).
- Aucune logique métier dans les routes ni dans l'affichage.
- L'accès aux données se fait uniquement dans la couche dédiée (`models/`).
- Un fichier = un rôle. Des fonctions courtes qui font une seule chose.

## 💬 Commentaires du code

- Chaque fonction a un bloc JSDoc : description, paramètres, retour, erreurs levées.
- Chaque fichier commence par un commentaire d'en-tête décrivant son rôle.
- Commentaires rédigés en français.
- Expliquer le **pourquoi**, pas seulement le quoi.

## 🏷️ Nommage

- Noms explicites en anglais.
- camelCase pour les variables et fonctions, PascalCase pour les classes.
- Noms de fichiers cohérents par rôle : `user.routes.js`, `user.controller.js`, `user.service.js`, `user.model.js`.

## ⚠️ Gestion des erreurs

- Toujours gérer les erreurs (try/catch ou équivalent).
- Gestion centralisée dans un middleware d'erreur. Express 5 y transmet tout seul les erreurs des fonctions `async` : pas besoin de `express-async-handler`.
- Messages clairs pour l'utilisateur, sans détails techniques ni trace d'erreur.
- Forme de réponse unique pour les erreurs : `{ "error": "message" }`.

## 🔒 Sécurité

- Aucun secret dans le code : tout passe par `.env` (jamais commité).
- Tenir `.env.example` à jour à chaque nouvelle variable.
- Valider toutes les données entrantes.
- Requêtes en base toujours paramétrées (`$1`, `$2`…), jamais de concaténation.
- Mots de passe hashés (bcrypt) et jamais renvoyés : la colonne `"password"` est exclue de tous les `SELECT` qui servent une réponse.

## 🗄️ Base de données

- Pas d'ORM ni de query builder : SQL écrit à la main avec `pg`.
- Toutes les requêtes passent par le `pool` de `app/database.js`.
- `"user"` est un mot réservé en PostgreSQL : toujours l'écrire entre guillemets.
- Les colonnes sont en camelCase (`"userId"`, `"createdAt"`) : toujours les mettre entre guillemets, sinon PostgreSQL les passe en minuscules et la requête échoue.
- Valeurs autorisées en français et sans accent (`a_faire`, `en_cours`, `termine`, `annule`, `basse`, `moyenne`, `haute`) : elles doivent rester identiques entre le SQL et la validation de l'API.
- Plusieurs écritures liées (un commentaire et sa pièce jointe, par exemple) se font dans une transaction (`BEGIN`/`COMMIT`/`ROLLBACK`).
- `create_table.sql` supprime toutes les données : à lancer uniquement sur une base de dev ou de test, et jamais sans me demander.

## 🔌 Conventions de l'API

- Routes au pluriel, sous le préfixe `/api` : `/api/users/:id`, `/api/projects/:id/tasks`.
- Codes HTTP : 200 (OK), 201 (création), 204 (suppression), 400 (validation), 401 (non connecté), 403 (interdit), 404 (introuvable), 409 (conflit, ex : e-mail déjà pris), 500 (erreur serveur).
- Droits : seuls le propriétaire de la ressource et un `admin` peuvent la modifier ou la supprimer. La vérification se fait dans un middleware ou un service, jamais dans la route.

## 🧪 Tests

- Chaque nouvelle fonctionnalité a au moins un test : un cas qui fonctionne et un cas d'erreur.
- Jest + Supertest, sur une base de test séparée (`DATABASE_URL` dans `.env.test`), jamais la base de dev.
- Relancer `create_table.sql` sur la base de test avant les tests, pour partir d'une base propre.

## 🌿 Workflow Git

- Jamais de commit direct sur `main` : une branche puis une PR.
- Branches : `feature/<nom>`, `fix/<nom>`, `docs/<nom>`.
- Commits au format Conventional Commits : `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.
- Un commit = un changement logique.

## 🚫 Interdits

- Ne pas ajouter de dépendance sans demander.
- Ne pas supprimer de fichiers sans demander.
- Pas de `console.log` de debug ni de code commenté mort dans le code final.

## 📌 Décisions

Choix déjà tranchés, à ne pas remettre en cause sans me demander. Format : date — décision — pourquoi.

- 2026-11-04 — SQL écrit à la main, pas de Sequelize — apprendre le SQL et garder le contrôle des requêtes.
- 2026-11-04 — `node --watch` à la place de nodemon — intégré à Node 22, une dépendance en moins.
- 2026-11-17 — Connexion avec un pool `pg` configuré par une seule variable `DATABASE_URL` — plus rapide qu'une connexion par requête, et c'est le format attendu par Render et Railway.
- 2026-11-17 — Le serveur refuse de démarrer si la base ne répond pas — mieux qu'un serveur qui accepte des requêtes qui échoueront toutes.

## 🧠 Leçons apprises

Chaque bug résolu après une vraie recherche devient une règle, pour qu'il ne se reproduise pas. À la fin d'une session où un tel bug a été résolu, proposer une ligne ; je valide avant qu'elle soit ajoutée. Format : règle — pourquoi.

- (aucune pour l'instant)
