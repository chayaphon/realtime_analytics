CREATE STREAM EXTENTED_FLASHSALES_STREAM AS
SELECT 
  fs.sale_id,
  fs.customer_id,
  fs.province_id,
  fs.region_id,
  fs.product_id,
  rt.region_name,
  pt.product_group,
  pt.product_name,
  CAST(fs.sale_price AS DOUBLE) AS sale_price,
  CAST(fs.quantity AS DOUBLE) AS quantity,
  CAST(fs.sale_price * fs.quantity AS DOUBLE) AS sales_amount,
  CAST(fs.discount AS DOUBLE) AS discount,
  fs.sale_datetime
FROM flashSales_stream fs
LEFT JOIN product_table pt ON pt.product_id = fs.product_id
LEFT JOIN region_table rt ON rt.region_id = fs.region_id
EMIT CHANGES;