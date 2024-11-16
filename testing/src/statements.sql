CREATE STREAM USER_DATA (
    registertime BIGINT,
    userid VARCHAR,
    regionid VARCHAR,
    gender VARCHAR,
    interests ARRAY<VARCHAR>,
    contactinfo STRUCT<
        zipcode VARCHAR,
        state VARCHAR,
        phone VARCHAR,
        city VARCHAR>
) WITH (
    KAFKA_TOPIC = 'User_',
    VALUE_FORMAT = 'AVRO',
    TIMESTAMP = 'registertime'
);

CREATE TABLE USERS_PER_REGION AS
    SELECT regionid,
           COUNT(*) AS USER_COUNT
    FROM USER_DATA
    GROUP BY regionid
    EMIT CHANGES;
