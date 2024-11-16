CREATE TABLE PAGEVIEWS_BY_PAGEGROUP_TABLE AS 
SELECT 
  pt.page_group as key,
  CAST(pt.page_group AS STRING) AS page_group,
  COUNT(pvs.viewtime) AS count_view
FROM pageviews_stream pvs
LEFT JOIN pages_table pt ON pt.page_id = pvs.pageid
GROUP BY pt.page_group
EMIT CHANGES;
