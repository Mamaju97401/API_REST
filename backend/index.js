/**
 * Point d'entrée de l'API : charge la configuration, vérifie la base
 * de données, puis démarre le serveur Express.
 */

// dotenv doit être chargé en premier : database.js lit DATABASE_URL dès son import.
require('dotenv').config();
const express = require('express');
const { checkConnection } = require('./app/database');

const PORT = process.env.PORT || 3000;

const app = express();

// Permet de lire le corps JSON des requêtes (req.body).
app.use(express.json());

/**
 * Démarre le serveur seulement si la base de données répond.
 *
 * @returns {Promise<void>}
 */
async function start() {
  try {
    await checkConnection();
    app.listen(PORT, () => {
      console.log(`Server is running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('Impossible de se connecter à PostgreSQL :', error.message);
    process.exit(1);
  }
}

start();
