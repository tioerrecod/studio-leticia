-- 001_extensions.sql
-- Extensões PostgreSQL necessárias para o Studio Letícia Experience

-- uuid-ossp: geração de UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- pgcrypto: criptografia e hash
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- btree_gist: índices GiST para prevenção de conflito de agenda
CREATE EXTENSION IF NOT EXISTS btree_gist;
