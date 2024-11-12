--What are the top 5 brands by receipts scanned for most recent month?
--How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
/*
Currently, the data is too bad to get a useful answer to these two questions.  In a real scenario, I would want to get a 
table that has good brand data for every one of the barcodes being tracked. If that were not available, I would first want to go through and create my own by parsing descriptions to get brands and creating my own brand dimension table.  But if I had that data on the brands table, the query to answer these questions 
would look something like this:
*/

WITH receipt_brands AS (
    SELECT
        c.brandcode
        , date_trunc('month', b.createDate) createMonth
        , count(distinct a.receipt_id) receipts
    FROM receipt_items a
    INNER JOIN receipts b on a.receipt_id = b._id and createDate >= '2021-01-01' and createDate < '2021-03-01'
    LEFT JOIN brands c on a.barcode = c.barcode
    GROUP BY 1, 2
), brand_ranks AS (
    SELECT
        brandcode
        , createMonth
        , receipts
        , row_number() over (partition by createMonth order by receipts desc, brandcode asc) brand_rank
    FROM receipt_brands
)
SELECT
    brandcode
    , createMonth
    , receipts
    , brand_rank
FROM brand_ranks
WHERE brand_rank <= 5
ORDER BY createMonth DESC, brand_rank

--When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
--When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
/*
There is no status of 'Accepted' so 'Rejected would have the greater amount for both of these but if I instead look at 'Finished', that group is higher than 'Rejected' across the board, including the bonus columns I included.
*/
SELECT
    rewardsReceiptStatus
    , count(rewardsReceiptStatus) status_count
    , avg(totalSpent) avg_spent
    , sum(totalSpent) total_spent
    , avg(purchasedItemCount) avg_items_purchased
    , sum(purchasedItemCount) total_items_purchased
FROM receipts
GROUP BY rewardsReceiptStatus

--Which brand has the most spend among users who were created within the past 6 months?
--Which brand has the most transactions among users who were created within the past 6 months?
/*
These two questions have the same issues as the first two questions but this is how I might answer it:
*/
SET var_today = '2021-03-02'; --since the last created date was 3/1/2021
SET var_6_mo_ago = DATEADD('month',-6,$var_today);

SELECT
    d.brandcode
    , sum(a.finalprice) total_spend
    , count(distinct a.receipt_id) total_transactions
FROM receipt_items a
INNER JOIN receipts b on a.receipt_id = b._id
INNER JOIN users c on b.userid = c._id and c.createddate >= $var_6_mo_ago
LEFT JOIN brands d on a.barcode = d.barcode
GROUP BY 1

