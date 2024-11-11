/*All the sql I am using is being run using Snowflake.  
I will note which parts were run in the Snowsight UI vs. what was run on the command line with SnowSQL

*/
--snowsight
CREATE OR REPLACE DATABASE fetch;

CREATE OR REPLACE SCHEMA fetch.stg;

CREATE OR REPLACE FILE FORMAT my_json_format
  TYPE = JSON;

CREATE OR REPLACE STAGE fetch_stage
 FILE_FORMAT = my_json_format;

CREATE OR REPLACE TABLE receipts (
    _id VARCHAR(50),
    bonusPointsEarned DECIMAL(10,2),
    bonusPointsEarnedReason VARCHAR(500),
    createDate TIMESTAMP_NTZ,
    dateScanned TIMESTAMP_NTZ,
    finishedDate TIMESTAMP_NTZ,
    modifyDate TIMESTAMP_NTZ,
    pointsAwardedDate TIMESTAMP_NTZ,
    pointsEarned DECIMAL(10,2),
    purchaseDate TIMESTAMP_NTZ,
    purchasedItemCount INT,
    rewardsReceiptItemList VARIANT,
    rewardsReceiptStatus VARCHAR(50),
    totalSpent DECIMAL(10,2),
    userId VARCHAR(50)
);

CREATE OR REPLACE TABLE users (
    _id VARCHAR(50),
    state VARCHAR(2),
    createdDate TIMESTAMP_NTZ,
    lastLogin TIMESTAMP_NTZ,
    role VARCHAR(20),
    active BOOLEAN,
    signUpSource VARCHAR(20)
);

CREATE OR REPLACE TABLE brands (
    _id VARCHAR(50),
    barcode VARCHAR(50),
    brandCode VARCHAR(50),
    category VARCHAR(50),
    categoryCode VARCHAR(50),
    cpg_id varchar(50),
    cpg_ref varchar(20),
    topBrand BOOLEAN,
    name VARCHAR(100)
);

