CREATE TABLE PAGEVIEWS_BY_REGION_TABLE AS 
SELECT 
  rt.region_name as key,
  CAST(rt.region_name AS STRING) AS region_name,
  COUNT(pvs.viewtime) AS count_view
  FROM pageviews_stream pvs
  LEFT JOIN user_transformed_table ut ON ut.userid = pvs.userid
  LEFT JOIN region_table rt ON rt.region_id = ut.regionid
  GROUP BY rt.region_name
EMIT CHANGES;