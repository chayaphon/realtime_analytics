CREATE TABLE TOTAL_SALES_BY_PRODUCTGROUP_TUMBLING_WINDOW AS
SELECT 
  product_group AS key,
  CAST(product_group AS STRING) AS product_group,
  SUM(sale_price * quantity) AS total_sales,
  SUM(quantity) AS total_quantity,
  COUNT(*) AS sales_count,
  TIMESTAMPTOSTRING(WINDOWSTART, 'yyyy-MM-dd HH:mm:ss', 'UTC') AS window_start,
  TIMESTAMPTOSTRING(WINDOWEND, 'yyyy-MM-dd HH:mm:ss', 'UTC') AS window_end
FROM EXTENTED_FLASHSALES_STREAM
WINDOW TUMBLING (SIZE 1 HOUR)
GROUP BY product_group
EMIT CHANGES;
