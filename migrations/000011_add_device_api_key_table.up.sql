CREATE TABLE device.api_key (
    id             VARCHAR(32) PRIMARY KEY,
    device_info_id uuid                      NOT NULL,
    title          VARCHAR(255)              NOT NULL,
    description    TEXT,
    created_at     TIMESTAMPTZ DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_device_info_id FOREIGN KEY (device_info_id) REFERENCES device.device_info (id) ON DELETE NO ACTION
);

-- 인덱스

CREATE INDEX IF NOT EXISTS idx_device_api_key_device_info_id ON device.api_key (device_info_id);