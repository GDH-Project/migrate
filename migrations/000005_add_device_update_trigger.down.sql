-- device 스키마 등록된 trg_{테이블명}_updated_at 트리거 제거
DO
$$
    DECLARE
        trigger_record RECORD;
        drop_query     TEXT;
    BEGIN
        FOR trigger_record IN
            SELECT trigger_name,      -- 트리거 명
                   event_object_table -- 트리거가 바인딩된 테이블명
            FROM information_schema.triggers
            WHERE trigger_schema = 'device'
              AND trigger_name LIKE 'trg\_%\_updated_at'
            LOOP
                drop_query := FORMAT('DROP TRIGGER IF EXISTS %I ON device.%I',
                                     trigger_record.trigger_name,
                                     trigger_record.event_object_table);

                EXECUTE drop_query;

                RAISE NOTICE 'Dropped trigger % from table device.%.',
                    trigger_record.trigger_name,
                    trigger_record.event_object_table;
            END LOOP;
    END
$$;


