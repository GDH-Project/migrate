ALTER TABLE device.req_to_sensor
    ADD CONSTRAINT unique_device_id_and_sensor_id UNIQUE (device_id, sensor_id);