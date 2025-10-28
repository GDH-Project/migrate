DELETE
FROM device.address_city;

DELETE
FROM device.address_state;

ALTER TABLE device.address_city
    DROP CONSTRAINT unique_city_in_state CASCADE;