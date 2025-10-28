-- device 스키마에 updated_at 컬럼이 있는 경우 updated_at 갱신 트리거 적용
DO
$$
    DECLARE
        tbl_record   RECORD;
        query_string TEXT;
    BEGIN
        FOR tbl_record IN SELECT t.table_name
                          FROM information_schema.tables AS t
                                   JOIN information_schema.columns AS c
                                        ON t.table_name = c.table_name
                                            AND t.table_schema = c.table_schema
                          WHERE t.table_schema = 'device'    -- device 스키마에 서
                            AND c.column_name = 'updated_at' -- updated_at이 있는 테이블을 기준으로
                            AND t.table_type = 'BASE TABLE' -- 뷰가 아닌 실제 테이블 필터링
            LOOP
                query_string := FORMAT('CREATE OR REPLACE TRIGGER trg_%I_updated_at
                                        BEFORE UPDATE
                                        ON device.%I
                                        FOR EACH ROW
                                    EXECUTE FUNCTION trg_fn.fn_updated_at();',
                                       tbl_record.table_name,
                                       tbl_record.table_name);
                EXECUTE query_string;

                -- 진행 상황 출력
                RAISE NOTICE 'Trigger created for table: %I', tbl_record.table_name;
            END LOOP;
    END
$$;
