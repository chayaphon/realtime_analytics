CREATE TABLE USER_TRANSFORMED_TABLE AS
SELECT 
    ut.userid,
    TIMESTAMPTOSTRING(ut.registertime, 'yyyy-MM-dd HH:mm:ss') AS registertime,
    ut.gender,
    ut.regionid,
    rt.region_name,
    ut.interests[1] AS interests_1,
    ut.interests[2] AS interests_2,
    ut.contactinfo['phone'] AS phone,
    ut.contactinfo['city'] AS city,
    ut.contactinfo['state'] AS state,
    ut.contactinfo['zipcode'] AS zipcode
FROM USERS_TABLE ut
LEFT JOIN REGION_TABLE rt ON ut.regionid = rt.region_id;