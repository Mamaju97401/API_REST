/**
 * Connexion à PostgreSQL.
 *
 * Expose un « pool » de connexions partagé par toute l'application,
 * et une fonction pour vérifier la connexion au démarrage du serveur.
 * Seule la couche d'accès aux données doit importer ce fichier.
 */

const { Pool } = require('pg');

/*
 * Un pool garde quelques connexions ouvertes et les prête à chaque requête,
 * au lieu d'ouvrir et fermer une connexion à chaque appel (lent et coûteux).
 * L'adresse de la base vient de .env : aucun mot de passe dans le code.
 */
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

/*
 * Une connexion inactive du pool peut tomber (base redémarrée, réseau coupé).
 * Sans ce gestionnaire, l'erreur ferait planter tout le serveur.
 */
pool.on('error', (error) => {
  console.error('Connexion PostgreSQL inactive perdue :', error.message);
});

/**
 * Vérifie que la base répond, en lançant une requête minimale.
 *
 * À appeler au démarrage : mieux vaut que le serveur refuse de démarrer
 * plutôt qu'il accepte des requêtes qui échoueront toutes.
 *
 * @returns {Promise<void>} Se résout si la base répond.
 * @throws {Error} Si DATABASE_URL est absente ou si la base est injoignable.
 */
async function checkConnection() {
  if (!process.env.DATABASE_URL) {
    throw new Error('DATABASE_URL est absente du fichier .env');
  }
  await pool.query('SELECT 1');
}

module.exports = { pool, checkConnection };
