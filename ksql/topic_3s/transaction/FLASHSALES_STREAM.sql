CREATE STREAM FLASHSALES_STREAM (
  sale_id BIGINT,
  customer_id BIGINT,
  province_id INT,
  region_id STRING,
  product_id STRING,
  discount DECIMAL(5, 2),
  original_price DECIMAL(10, 2),
  sale_price DECIMAL(10, 2),
  quantity INT,
  sale_datetime BIGINT
) WITH (KAFKA_TOPIC='MysqlSource-flash_sales', VALUE_FORMAT='AVRO');