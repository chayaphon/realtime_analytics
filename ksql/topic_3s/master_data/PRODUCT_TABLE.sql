CREATE TABLE PRODUCT_TABLE (
    product_id VARCHAR PRIMARY KEY,
    product_group VARCHAR,
    product_name VARCHAR
) WITH (KAFKA_TOPIC='MysqlSource-product', VALUE_FORMAT='AVRO');