CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS auth;

-- 사용자
CREATE TABLE IF NOT EXISTS auth.users (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    password   VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ      DEFAULT NOW(),
    updated_at TIMESTAMPTZ      DEFAULT NOW(),
    deleted_at TIMESTAMPTZ      DEFAULT NULL
);

-- 인증 토큰
CREATE TABLE IF NOT EXISTS auth.tokens (
    user_id       UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
    refresh_token VARCHAR(255) NOT NULL,
    expires_at    TIMESTAMPTZ  NOT NULL,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- 역할
CREATE TABLE IF NOT EXISTS auth.roles (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- 사용자 - 역할 관계
CREATE TABLE IF NOT EXISTS auth.user_roles (
    user_id UUID REFERENCES auth.users (id) ON DELETE CASCADE,
    role_id INTEGER REFERENCES auth.roles (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- 로그인 이력
CREATE TABLE IF NOT EXISTS auth.login_log (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID        REFERENCES auth.users (id) ON DELETE SET NULL,
    ip_address INET,
    user_agent TEXT,
    status     VARCHAR(20) NOT NULL,
    created_at timestamptz      DEFAULT NOW()
);

-- ## 뷰
-- 유저+권한 조회 뷰
CREATE OR REPLACE VIEW auth.user_with_role AS
SELECT u.id,
       u.email,
       u.password,
       u.name,
       r.name AS role_name
FROM auth.users u
         JOIN auth.user_roles ur ON u.id = ur.user_id
         JOIN auth.roles r ON ur.role_id = r.id
WHERE u.deleted_at IS NULL;

-- ## 인덱스
-- 인증 토큰 빠른 검색
CREATE INDEX IF NOT EXISTS idx_auth_tokens_user_id ON auth.tokens (user_id);
-- 로그인 이력 빠른 검색
CREATE INDEX IF NOT EXISTS idx_login_attempts_user_id ON auth.login_log (user_id);
-- 이메일 검색 최적화
CREATE INDEX IF NOT EXISTS idx_users_email ON auth.users (email);

-- 기본 권한 추가
INSERT INTO auth.roles(name, description)
VALUES ('admin', '관리자 입니다.'),
       ('device', '장치 등록 사용자 입니다.'),
       ('user', '일반 사용자 입니다.');