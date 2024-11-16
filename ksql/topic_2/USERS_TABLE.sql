CREATE TABLE USERS_TABLE (
    userid VARCHAR PRIMARY KEY,
    registertime BIGINT,
    regionid VARCHAR,
    gender VARCHAR,
    interests ARRAY<STRING>,
    contactInfo MAP<STRING, STRING>)
WITH (
    kafka_topic='Users_',
    value_format='AVRO');