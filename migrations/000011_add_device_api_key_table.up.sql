CREATE TABLE device.api_key (
    id             SERIAL PRIMARY KEY,
    user_id        UUID                      NOT NULL,
    api_key        VARCHAR(32) UNIQUE        NOT NULL,
    device_info_id uuid                      NOT NULL,
    title          VARCHAR(255)              NOT NULL,
    description    TEXT,
    created_at     TIMESTAMPTZ DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_device_info_id FOREIGN KEY (device_info_id) REFERENCES device.device_info (id) ON DELETE NO ACTION,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE NO ACTION
);

-- 인덱스

CREATE INDEX IF NOT EXISTS idx_device_api_key_device_info_id ON device.api_key (device_info_id);