CREATE TABLE device.api_key (
    id             VARCHAR(32) PRIMARY KEY,
    device_info_id uuid NOT NULL,

    CONSTRAINT fk_device_info_id FOREIGN KEY (device_info_id) REFERENCES device.device_info (id) ON DELETE NO ACTION
)