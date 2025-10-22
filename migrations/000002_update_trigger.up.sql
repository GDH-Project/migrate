CREATE SCHEMA IF NOT EXISTS trg_fn;

-- update 트리거
CREATE OR REPLACE FUNCTION trg_fn.fn_updated_at()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- user update 트리거 바인딩
CREATE OR REPLACE TRIGGER trg_users_updated_at
    BEFORE UPDATE
    ON auth.users
    FOR EACH ROW
EXECUTE FUNCTION trg_fn.fn_updated_at();