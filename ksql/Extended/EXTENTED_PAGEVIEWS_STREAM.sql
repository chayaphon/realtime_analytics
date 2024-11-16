CREATE STREAM EXTENTED_PAGEVIEWS_STREAM
  AS SELECT
    ps.userid,
    ps.pageid,
    ut.regionid,
    pt.page_group,
    pt.page_name,
    rt.region_name,
    ut.gender,
    ut.interests_1,
    ut.interests_2,
    ut.phone,
    ut.city,
    ut.state,
    ut.zipcode
    FROM pageviews_stream ps
    LEFT JOIN user_transformed_table ut ON ps.userid = ut.userid
    LEFT JOIN pages_table pt ON pt.page_id = ps.pageid
    LEFT JOIN region_table rt ON rt.region_id = ut.regionid
EMIT CHANGES;