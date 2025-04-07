# 🛠️ API REST - Node.js + Express + Sequelize + PostgreSQL

Ce projet est une API RESTful construite avec **Node.js**, **Express**, **Sequelize**, et **PostgreSQL**. Elle sert de base pour des applications backend scalables avec gestion de base de données relationnelle.

## 📁 Structure du projet

## mon-projet-api

├── config/             # Configuration Sequelize  
├── migrations/         # Fichiers de migration Sequelize  
├── models/             # Modèles de données Sequelize  
├── seeders/            # Données de test (facultatif)  
├── node_modules/  
├── index.js            # Point d'entrée principal de l'application  
├── package.json  
└── README.md  

## 🚀 Installation

   Clone le repo :

```bash
git clone https://github.com/ton-utilisateur/mon-projet-api.git
cd mon-projet-api
```

   Installe les dépendances :
```bash
npm install
```

   Crée un fichier `.env` (optionnel si tu veux une config séparée) ou configure `config/config.json` avec tes infos PostgreSQL :
```json
{
  "development": {
    "username": "postgres",
    "password": "mot_de_passe",
    "database": "nom_de_la_base",
    "host": "127.0.0.1",
    "dialect": "postgres"
  }
}
```

1. Initialise la base de données :
```bash
npx sequelize-cli db:migrate
```

## 🧑‍💻 Lancement du serveur

```bash
node index.js
```

Le serveur tourne par défaut sur :  
📍 `http://localhost:3000`

## 🔌 Endpoints disponibles (exemple `User`)

| Méthode | Route               | Description               |
|--------:|--------------------|---------------------------|
| GET     | `/api/users`       | Liste des utilisateurs    |
| GET     | `/api/users/:id`   | Détail d'un utilisateur   |
| POST    | `/api/users`       | Créer un utilisateur      |
| PUT     | `/api/users/:id`   | Modifier un utilisateur   |
| DELETE  | `/api/users/:id`   | Supprimer un utilisateur  |

## 🧱 Stack utilisée

- [Node.js](https://nodejs.org/)
- [Express.js](https://expressjs.com/)
- [Sequelize](https://sequelize.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Sequelize CLI](https://sequelize.org/docs/v6/other-topics/migrations/)

## 📌 TODO / Évolution

- [ ] Ajouter authentification JWT
- [ ] Ajouter modèles `Task`, `Project`, etc.
- [ ] Ajouter des tests (Jest, Supertest)
- [ ] Mise en production (Heroku, Render...)

## 🧑‍💼 Auteur

> Ce projet a été développé par [Ton Nom / Pseudo] dans le cadre de la construction de mon portfolio en tant que développeur backend Node.js débutant.

## 💬 Licence

Ce projet est open-source — tu peux l'utiliser, le modifier et le partager librement.