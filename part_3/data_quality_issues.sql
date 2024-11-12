--Data quality issues
--This is by no means exhaustive but here are some examples:

--missing days of data: there is a gap between 2/12 and 2/26 with no data, which would be a red flag
SELECT
    createDate::date createDate
    , count(createDate) date_count
FROM receipts
GROUP BY 1 
ORDER BY 1 DESC 

--purchase date after create date: seems like this should be impossible
SELECT
    _id
    , createDate
    , purchaseDate
FROM receipts
WHERE purchaseDate > createDate

--userId does not exist in users table: this would be a red flag and could cause ingestion issues if userId is set up as a foreign key with a constraint that the value has to exist in the users table
SELECT
    a._id
FROM receipts a 
LEFT JOIN users b on a.userid = b._id
WHERE b._id is null

--barcodes with no brand info: as mentioned above, there should be a record for every barcode that is tracked
SELECT DISTINCT
    a.barcode
FROM receipt_items a
LEFT JOIN brands b on a.barcode = b.barcode
WHERE b.barcode is null

--test data in prod: a few records might not be a big deal but in general I would want internal testing records to be removed after use
SELECT
    _id
    , brandcode
    , name
FROM brands
WHERE brandcode like '%test%' or name like '%test%'

--amount spend or item count doesnt match between the figures on the receipts table and calclating based on all items on the receipt: theoretically these should match
WITH cte as (
    SELECT
        receipt_id
        , SUM(finalprice * quantitypurchased) total_spent
        , SUM(quantitypurchased) items_purchased
    FROM receipt_items
    GROUP BY receipt_id
)
SELECT
    _id
    , totalSpent
    , total_spent
    , purchaseditemcount
    , items_purchased
FROM receipts a 
INNER JOIN cte b on a._id = b.receipt_id
WHERE totalSpent != total_spent OR purchaseditemcount != items_purchased
