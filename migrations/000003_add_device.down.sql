DROP INDEX IF EXISTS device.idx_device_info_update_cycle_id;
DROP INDEX IF EXISTS device.idx_device_info_address_state_id_and_city_id;
DROP INDEX IF EXISTS device.idx_device_info_address_state_id;
DROP INDEX IF EXISTS device.idx_device_info_user_id;
DROP INDEX IF EXISTS device.idx_device_info_crop_id;
DROP INDEX IF EXISTS device.idx_device_device_data_device_id;
DROP INDEX IF EXISTS device.idx_device_req_to_csv_header_device_id;

DROP TABLE IF EXISTS device.device_data_temp CASCADE;
DROP TABLE IF EXISTS device.device_data CASCADE;
DROP TABLE IF EXISTS device.req_to_sensor CASCADE;
DROP TABLE IF EXISTS device.device_info CASCADE;
DROP TABLE IF EXISTS device.address_state CASCADE;
DROP TABLE IF EXISTS device.address_city CASCADE;
DROP TABLE IF EXISTS device.device_req_binding_schema CASCADE;
DROP TABLE IF EXISTS device.sensor CASCADE;
DROP TABLE IF EXISTS device.update_cycle CASCADE;
DROP TABLE IF EXISTS device.crop CASCADE;


DROP SCHEMA IF EXISTS device CASCADE;

DROP SCHEMA IF EXISTS device;