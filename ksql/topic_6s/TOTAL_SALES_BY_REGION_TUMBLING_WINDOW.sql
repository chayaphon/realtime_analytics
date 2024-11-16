CREATE TABLE TOTAL_SALES_BY_REGION_TUMBLING_WINDOW AS
SELECT 
  region_name AS key,
  CAST(region_name AS STRING) AS region_name,
  SUM(sale_price * quantity) AS total_sales,
  SUM(quantity) AS total_quantity,
  COUNT(*) AS sales_count,
  TIMESTAMPTOSTRING(WINDOWSTART, 'yyyy-MM-dd HH:mm:ss', 'UTC') AS window_start,
  TIMESTAMPTOSTRING(WINDOWEND, 'yyyy-MM-dd HH:mm:ss', 'UTC') AS window_end
FROM EXTENTED_FLASHSALES_STREAM
WINDOW TUMBLING (SIZE 1 HOUR)
GROUP BY region_name
EMIT CHANGES;