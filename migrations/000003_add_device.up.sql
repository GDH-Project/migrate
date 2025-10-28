CREATE SCHEMA IF NOT EXISTS device;

-- 작물 정보
CREATE TABLE IF NOT EXISTS device.crop (
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(50) UNIQUE        NOT NULL,
    description TEXT,

    created_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL
);


-- 장치 업데이트 사이클
CREATE TABLE IF NOT EXISTS device.update_cycle (
    id          SERIAL PRIMARY KEY,
    interval    INT UNIQUE                NOT NULL,
    description TEXT,

    created_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 센서 데이터 종류
CREATE TABLE IF NOT EXISTS device.sensor (
    id               SERIAL PRIMARY KEY,
    title            VARCHAR(50) UNIQUE        NOT NULL,
    eng_title        VARCHAR(50) UNIQUE        NOT NULL,
    description      TEXT                      NOT NULL,
    unit             VARCHAR(20),
    unit_description TEXT,

    created_at       TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at       TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE IF NOT EXISTS device.address_state (
    id    SERIAL PRIMARY KEY,
    title VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS device.address_city (
    id               SERIAL PRIMARY KEY,
    address_state_id SERIAL      NOT NULL,
    title            VARCHAR(50) NOT NULL,

    CONSTRAINT fk_device_address_state FOREIGN KEY (address_state_id) REFERENCES device.address_state (id) ON DELETE NO ACTION
);


-- 장치 정보
CREATE TABLE IF NOT EXISTS device.device_info (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title            VARCHAR(255)                   NOT NULL,
    device_name      VARCHAR(255),
    user_id          UUID                           NOT NULL,
    crop_id          SERIAL                         NOT NULL,
    update_cycle_id  SERIAL                         NOT NULL,
    address_state_id SERIAL                         NOT NULL, -- 도 (경기도, 서울특별시 등)
    address_city_id  SERIAL                         NOT NULL, -- 시군구 (안양시 동안구 등)

    created_at       TIMESTAMPTZ      DEFAULT NOW() NOT NULL,
    updated_at       TIMESTAMPTZ      DEFAULT NOW() NOT NULL,
    deleted_at       TIMESTAMPTZ      DEFAULT NULL,

    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE NO ACTION,
    CONSTRAINT fk_crop_id FOREIGN KEY (crop_id) REFERENCES device.crop (id) ON DELETE NO ACTION,
    CONSTRAINT fk_update_cycle_id FOREIGN KEY (update_cycle_id) REFERENCES device.update_cycle (id) ON DELETE NO ACTION,
    CONSTRAINT fk_address_state_id FOREIGN KEY (address_state_id) REFERENCES device.address_state (id) ON DELETE NO ACTION,
    CONSTRAINT fk_address_city_id FOREIGN KEY (address_city_id) REFERENCES device.address_city (id) ON DELETE NO ACTION
);

-- 장치의 req json key와 sensor 헤더 바인딩 스키마 1:many (device : 해당 테이블)
CREATE TABLE IF NOT EXISTS device.req_to_sensor (
    id         BIGSERIAL PRIMARY KEY,
    key        VARCHAR(50)               NOT NULL,
    device_id  UUID                      NOT NULL,
    sensor_id  SERIAL                    NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_device_id FOREIGN KEY (device_id) REFERENCES device.device_info (id) ON DELETE NO ACTION,
    CONSTRAINT fk_sensor_id FOREIGN KEY (sensor_id) REFERENCES device.sensor (id) ON DELETE NO ACTION
);


-- 디바이스에서 전송된 데이터 jsonb 파싱 테이블
CREATE TABLE IF NOT EXISTS device.device_data (
    time      TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    device_id UUID                      NOT NULL,
    data      JSONB                     NOT NULL,

    CONSTRAINT fk_device_id FOREIGN KEY (device_id) REFERENCES device.device_info (id) ON DELETE NO ACTION
);


-- 디바이스에서 전송된 데이터 jsonb 파싱 후 캐싱 테이블 ( interval에 맞춰서 device.device_data 로 insert)
CREATE TABLE IF NOT EXISTS device.device_data_temp (
    time      TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    device_id UUID UNIQUE               NOT NULL,
    data      JSONB                     NOT NULL,

    CONSTRAINT fk_device_id FOREIGN KEY (device_id) REFERENCES device.device_info (id) ON DELETE NO ACTION
);


-- 인덱스
-- csv 파싱 헤더 검색 by deviceID
CREATE INDEX IF NOT EXISTS idx_device_req_to_sensor_device_id ON device.req_to_sensor (device_id);
-- 장비 데이터 겁색 by deviceID
CREATE INDEX IF NOT EXISTS idx_device_device_data_device_id ON device.device_data (device_id);
-- 장비 정보 검색 by Crop
CREATE INDEX IF NOT EXISTS idx_device_info_crop_id ON device.device_info (crop_id);
-- 장비 정보 검색 by UserID
CREATE INDEX IF NOT EXISTS idx_device_info_user_id ON device.device_info (user_id);
-- 장비 정보 검색 by AddressStateID
CREATE INDEX IF NOT EXISTS idx_device_info_address_state_id ON device.device_info (address_state_id);
-- 장비 정보 검색 by AddressStateID and AddressCityID
CREATE INDEX IF NOT EXISTS idx_device_info_address_state_id_and_city_id ON device.device_info (address_state_id, address_city_id);
-- 장비 정보 검색 by UpdateCycleID
CREATE INDEX IF NOT EXISTS idx_device_info_update_cycle_id ON device.device_info (update_cycle_id);
-- 장비 정보 검색 by Title
CREATE INDEX IF NOT EXISTS idx_device_info_title ON device.device_info (title);