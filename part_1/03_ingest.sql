-- run block by block in SnowSQL/CLI

PUT file://C:\Users\Austin\Downloads\receipts_cleaned.json @fetch_stage AUTO_COMPRESS=TRUE;

COPY INTO receipts(_id, bonusPointsEarned, bonusPointsEarnedReason, createDate, dateScanned, finishedDate, modifyDate, pointsAwardedDate, pointsEarned, purchaseDate, purchasedItemCount, rewardsReceiptItemList, rewardsReceiptStatus, totalSpent, userId
)
   FROM (
        SELECT
            $1:_id:"$oid"::VARCHAR(50),
            $1:bonusPointsEarned::DECIMAL(10,2),
            $1:bonusPointsEarnedReason::VARCHAR(500),
            DATEADD(millisecond, $1:createDate:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            DATEADD(millisecond, $1:dateScanned:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            DATEADD(millisecond, $1:finishedDate:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            DATEADD(millisecond, $1:modifyDate:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            DATEADD(millisecond, $1:pointsAwardedDate:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            $1:pointsEarned::DECIMAL(10,2),
            DATEADD(millisecond, $1:purchaseDate:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            $1:purchasedItemCount::INT,
            $1:rewardsReceiptItemList::VARIANT,
            $1:rewardsReceiptStatus::VARCHAR(50),
            $1:totalSpent::DECIMAL(10,2),
            $1:userId::VARCHAR(50)
        FROM @fetch_stage/receipts.json.gz
    )
    ON_ERROR = 'ABORT_STATEMENT';


PUT file://C:\Users\Austin\Downloads\users.json @fetch_stage AUTO_COMPRESS=TRUE;

COPY INTO users(_id, state, createdDate, lastLogin, role, active, signUpSource)
   FROM (
        SELECT
            $1:_id:"$oid"::VARCHAR(50),
            $1:state::VARCHAR(2),
            DATEADD(millisecond, $1:createdDate:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            DATEADD(millisecond, $1:lastLogin:"$date"::NUMBER, '1970-01-01'::TIMESTAMP_NTZ),
            $1:role::VARCHAR(20),
            $1:active::BOOLEAN,
            $1:signUpSource::VARCHAR(20),
        FROM @fetch_stage/users.json.gz
    )
    ON_ERROR = 'ABORT_STATEMENT';

PUT file://C:\Users\Austin\Downloads\brands.json.gz @fetch_stage AUTO_COMPRESS=TRUE;

COPY INTO brands(_id, barcode, brandCode, category, categoryCode, cpg_id, cpg_ref, topBrand, name)
   FROM (
        SELECT
            $1:_id:"$oid"::VARCHAR(50),
            $1:barcode::VARCHAR(50),
            $1:brandCode::VARCHAR(50),
            $1:category::VARCHAR(50),
            $1:categoryCode::VARCHAR(50),
            $1:cpg:"$id":"$oid"::VARCHAR(50) as cpg_test,
            $1:cpg:"$ref"::varchar(20) as cpg_ref,
            $1:topBrand::BOOLEAN,
            $1:name::VARCHAR(100)
        FROM @fetch_stage/brands.json.gz
    )
    ON_ERROR = 'ABORT_STATEMENT';