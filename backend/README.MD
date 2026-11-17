# 🛠️ API REST - Node.js + Express + PostgreSQL

API RESTful de gestion de **projets**, **tâches**, **commentaires** et **pièces jointes**, construite avec **Node.js**, **Express** et **PostgreSQL**.

La base de données est gérée avec des **scripts SQL écrits à la main** (pas d'ORM pour le moment).

> 🚧 Projet en cours de construction : le serveur Express démarre, mais aucune route n'est encore disponible.

## 📁 Structure du projet

```text
API_REST/
└── backend/
    ├── app/
    │   ├── database.js        # Connexion à PostgreSQL (à écrire)
    │   └── router.js          # Définition des routes (à écrire)
    ├── data/
    │   └── create_table.sql   # Script de création des tables
    ├── index.js               # Point d'entrée : démarre le serveur Express
    ├── package.json
    └── README.MD
```

## 🗄️ Modèle de données

| Table        | Rôle                                         | Liée à                    |
|--------------|----------------------------------------------|---------------------------|
| `user`       | Utilisateurs (rôle `user` ou `admin`)        | —                         |
| `project`    | Projets créés par un utilisateur             | `user`                    |
| `task`       | Tâches d'un projet, assignables à un user    | `project`, `user`         |
| `comment`    | Commentaires sur une tâche (avec réponses)   | `task`, `user`, `comment` |
| `attachment` | Fichiers joints à un commentaire             | `comment`, `user`         |

## ✅ Prérequis

- [Node.js](https://nodejs.org/) 22 ou plus récent (pour `node --watch`)
- [PostgreSQL](https://www.postgresql.org/) installé, avec l'outil en ligne de commande `psql`

## 🚀 Installation

1. Cloner le dépôt et aller dans le dossier `backend` :

   ```bash
   git clone git@github.com:Mamaju97401/API_REST.git
   cd API_REST/backend
   ```

2. Installer les dépendances :

   ```bash
   npm install
   ```

3. Créer un fichier `.env` dans `backend/` :

   ```env
   PORT=3000
   ```

## 🗃️ Base de données

1. Créer la base (ici nommée `api_rest`) :

   ```bash
   createdb api_rest
   ```

2. Créer les tables avec le script SQL :

   ```bash
   psql -d api_rest -f data/create_table.sql
   ```

> ⚠️ Le script supprime puis recrée toutes les tables : relancé, il efface les données existantes. À n'utiliser qu'en développement.

## 🧑‍💻 Lancement du serveur

```bash
npm run dev    # développement, redémarre à chaque modification (`node --watch`)
npm start      # lancement simple
```

Le serveur tourne par défaut sur 📍 `http://localhost:3000` (modifiable avec `PORT` dans `.env`).

## 🔌 Endpoints

Aucun endpoint n'est encore disponible. Prévu pour la ressource `user` :

| Méthode | Route            | Description              |
|--------:|------------------|--------------------------|
| GET     | `/api/users`     | Liste des utilisateurs   |
| GET     | `/api/users/:id` | Détail d'un utilisateur  |
| POST    | `/api/users`     | Créer un utilisateur     |
| PUT     | `/api/users/:id` | Modifier un utilisateur  |
| DELETE  | `/api/users/:id` | Supprimer un utilisateur |

Les ressources `project`, `task`, `comment` et `attachment` suivront le même modèle.

## 🧱 Stack utilisée

- [Node.js](https://nodejs.org/)
- [Express 5](https://expressjs.com/)
- [PostgreSQL](https://www.postgresql.org/) avec des scripts SQL écrits à la main
- [dotenv](https://github.com/motdotla/dotenv) pour les variables d'environnement

## 📌 TODO / Évolution

- [x] Corriger `create_table.sql` pour PostgreSQL
- [ ] Connexion à la base dans `app/database.js`
- [ ] Routes et contrôleurs CRUD (`user`, `project`, `task`, `comment`, `attachment`)
- [ ] Authentification JWT et mots de passe hashés (bcrypt)
- [ ] Tests (Jest, Supertest)
- [ ] Mise en production (Render, Railway...)

## 🧑‍💼 Auteur

> Projet développé par BOUGET Mathieu / MAMAju97401 dans le cadre de la construction de mon portfolio en tant que développeur backend Node.js débutant.

## 💬 Licence

Ce projet est sous licence ISC : tu peux l'utiliser, le modifier et le partager librement.
