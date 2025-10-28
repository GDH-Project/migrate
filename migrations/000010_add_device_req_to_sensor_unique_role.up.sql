ALTER TABLE device.req_to_sensor
    ADD CONSTRAINT unique_device_id_and_key UNIQUE (device_id, key);