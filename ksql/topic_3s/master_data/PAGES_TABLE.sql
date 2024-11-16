CREATE TABLE PAGES_TABLE (
    page_id VARCHAR PRIMARY KEY,
    page_group VARCHAR,
    page_name VARCHAR
) WITH (KAFKA_TOPIC='MysqlSource-pages', VALUE_FORMAT='AVRO');