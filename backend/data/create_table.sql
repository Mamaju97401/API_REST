/*Création des table pour L'API REST */

BEGIN;

DROP TABLE IF EXISTS "user,project,task,comment,attachment";

--User
CREATE TABLE"user" (
    "id"INTEGER PRIMARY KEY AUTOINCREMENT,
    "name"VARCHAR(100) NOT NULL,
    "email"VARCHAR(100) UNIQUE NOT NULL,
    "password" VARCHAR(255) NOT NULL ,     -- hashé avec bcrypt
    "role"ENUM ('user', 'admin') DEFAULT 'user',
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Project
CREATE TABLE "project" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "title" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "status" ENUM('en_cours', 'termine', 'annule') DEFAULT 'en_cours',
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,
    FOREIGN KEY ("userId") REFERENCES "user" ("id") ON DELETE CASCADE
);

--Task
CREATE TABLE "task" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "title" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "status" ENUM('à_faire', 'en_cours', 'termine') DEFAULT 'à_faire',
    "priority"  ENUM('basse', 'moyenne', 'haute') DEFAULT 'moyenne',
    "dueDate" DATE,
    "projectId"INTEGER     NOT NULL REFERENCES Project(id) ON DELETE CASCADE,
    "assignedTo"INTEGER     REFERENCES User(id),
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "projectId" INTEGER NOT NULL,
    FOREIGN KEY ("projectId") REFERENCES "project" ("id") ON DELETE CASCADE
);

--Comment
CREATE TABLE "comment" (
    "id"INTEGER PRIMARY KEY AUTOINCREMENT,
    "content"TEXT NOT NULL,
    "type"ENUM('text', 'image', 'code', 'file') DEFAULT 'text',
    "isEdited"BOOLEAN DEFAULT false,
    "isVisible"BOOLEAN DEFAULT true,-- true = visible, false = masqué
    "parentId"INTEGER REFERENCES Comment(id) ON DELETE CASCADE,
    "mentions"TEXT[],-- Tableau d’identifiants ou d’emails (logique à gérer)
    "userId"INTEGER NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    "taskId"INTEGER NOT NULL REFERENCES Task(id) ON DELETE CASCADE,
    "createdAt"TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt"TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Attachment
CREATE TABLE "attachment" (
    "id"INTEGER PRIMARY KEY AUTOINCREMENT,
    "filePath"VARCHAR(255) NOT NULL, -- lien vers le fichier (cloud/local)
    "fileType"ENUM('image', 'document', 'video', 'audio') DEFAULT 'document',
    "size"INTEGER NOT NULL,
    "commentId" INTEGER NOT NULL REFERENCES Comment(id) ON DELETE CASCADE,
    "userId"INTEGER NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    "taskId"INTEGER NOT NULL REFERENCES Task(id) ON DELETE CASCADE,
    "createdAt"TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt"TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMIT;