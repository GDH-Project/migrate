DELETE
FROM auth.roles;

DROP INDEX IF EXISTS auth.idx_users_email;
DROP INDEX IF EXISTS auth.idx_login_attempts_user_id;
DROP INDEX IF EXISTS auth.idx_auth_tokens_user_id;

DROP VIEW IF EXISTS auth.user_with_role;

DROP TABLE IF EXISTS auth.login_log;
DROP TABLE IF EXISTS auth.user_roles;
DROP TABLE IF EXISTS auth.roles;
DROP TABLE IF EXISTS auth.tokens;
DROP TABLE IF EXISTS auth.users;

DROP SCHEMA IF EXISTS auth;

CREATE EXTENSION IF NOT EXISTS pgcrypto;




