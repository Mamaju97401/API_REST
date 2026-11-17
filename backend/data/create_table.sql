/*
 * Création des tables de l'API REST (PostgreSQL).
 *
 * Le script peut être relancé : il supprime d'abord les tables existantes,
 * ce qui efface toutes leurs données. À n'utiliser qu'en développement.
 *
 * Lancement : psql -d api_rest -f data/create_table.sql
 */

BEGIN;

-- Suppression dans l'ordre inverse des dépendances.
-- CASCADE retire aussi les contraintes et triggers qui dépendent de ces tables.
DROP TABLE IF EXISTS "attachment", "comment", "task", "project", "user" CASCADE;
DROP FUNCTION IF EXISTS set_updated_at();

-- Fonction partagée : met "updatedAt" à l'heure actuelle à chaque UPDATE.
-- Sans elle, la valeur par défaut ne s'applique qu'à l'INSERT et "updatedAt" ne bougerait jamais.
CREATE FUNCTION set_updated_at() RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- User
-- "user" est un mot réservé en PostgreSQL : il doit toujours être écrit entre guillemets.
CREATE TABLE "user" (
    "id"        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "name"      VARCHAR(100) NOT NULL,
    "email"     VARCHAR(255) NOT NULL UNIQUE,
    "password"  VARCHAR(255) NOT NULL,  -- hash bcrypt, jamais le mot de passe en clair
    "role"      TEXT NOT NULL DEFAULT 'user' CHECK ("role" IN ('user', 'admin')),
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Project
CREATE TABLE "project" (
    "id"          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "title"       VARCHAR(150) NOT NULL,
    "description" TEXT,
    "status"      TEXT NOT NULL DEFAULT 'en_cours' CHECK ("status" IN ('en_cours', 'termine', 'annule')),
    "userId"      INTEGER NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE,
    "createdAt"   TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updatedAt"   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Task
CREATE TABLE "task" (
    "id"          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "title"       VARCHAR(150) NOT NULL,
    "description" TEXT,
    "status"      TEXT NOT NULL DEFAULT 'a_faire' CHECK ("status" IN ('a_faire', 'en_cours', 'termine')),
    "priority"    TEXT NOT NULL DEFAULT 'moyenne' CHECK ("priority" IN ('basse', 'moyenne', 'haute')),
    "dueDate"     DATE,
    "projectId"   INTEGER NOT NULL REFERENCES "project" ("id") ON DELETE CASCADE,
    -- Si l'utilisateur assigné est supprimé, la tâche reste mais n'est plus assignée.
    "assignedTo"  INTEGER REFERENCES "user" ("id") ON DELETE SET NULL,
    "createdAt"   TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updatedAt"   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Comment
CREATE TABLE "comment" (
    "id"        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "content"   TEXT NOT NULL,
    "type"      TEXT NOT NULL DEFAULT 'text' CHECK ("type" IN ('text', 'image', 'code', 'file')),
    "isEdited"  BOOLEAN NOT NULL DEFAULT false,
    "isVisible" BOOLEAN NOT NULL DEFAULT true,  -- false = commentaire masqué
    "mentions"  TEXT[],                         -- identifiants ou e-mails mentionnés (logique gérée par l'API)
    "parentId"  INTEGER REFERENCES "comment" ("id") ON DELETE CASCADE,  -- NULL = commentaire racine
    "userId"    INTEGER NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE,
    "taskId"    INTEGER NOT NULL REFERENCES "task" ("id") ON DELETE CASCADE,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Attachment
-- La tâche se retrouve via le commentaire : pas de colonne "taskId" ici,
-- sinon une pièce jointe pourrait pointer vers une autre tâche que celle de son commentaire.
CREATE TABLE "attachment" (
    "id"        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "filePath"  VARCHAR(255) NOT NULL,  -- lien vers le fichier (cloud ou local)
    "fileType"  TEXT NOT NULL DEFAULT 'document' CHECK ("fileType" IN ('image', 'document', 'video', 'audio')),
    "size"      BIGINT NOT NULL CHECK ("size" >= 0),  -- en octets ; BIGINT car INTEGER plafonne à 2 Go
    "commentId" INTEGER NOT NULL REFERENCES "comment" ("id") ON DELETE CASCADE,
    "userId"    INTEGER NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Mise à jour automatique de "updatedAt" sur chaque table.
CREATE TRIGGER "user_set_updated_at"       BEFORE UPDATE ON "user"       FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER "project_set_updated_at"    BEFORE UPDATE ON "project"    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER "task_set_updated_at"       BEFORE UPDATE ON "task"       FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER "comment_set_updated_at"    BEFORE UPDATE ON "comment"    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER "attachment_set_updated_at" BEFORE UPDATE ON "attachment" FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMIT;
