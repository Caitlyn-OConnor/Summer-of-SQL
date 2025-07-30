WITH outgoings AS (
    SELECT 
        ai.account_number,
        -td.value AS transaction_value,
        ai.balance,
        'outgoing' AS direction
        ,td.transaction_date
    FROM pd2023_wk07_account_information ai
    INNER JOIN pd2023_wk07_transaction_path tp ON tp.account_from = ai.account_number
    INNER JOIN pd2023_wk07_transaction_detail td ON td.transaction_id = tp.transaction_id
    WHERE td.cancelled_ != 'Y' 
      AND DATE_PART('day', TO_DATE(balance_date, 'yyyy-mm-dd')) = 31
      AND DATE_PART('month', TO_DATE(balance_date, 'yyyy-mm-dd')) = 1
),

incoming AS (
    SELECT 
        ai.account_number,
        td.value AS transaction_value,
        ai.balance,
        'incoming' AS direction
        ,td.transaction_date
    FROM pd2023_wk07_account_information ai
    INNER JOIN pd2023_wk07_transaction_path tp ON tp.account_to = ai.account_number
    INNER JOIN pd2023_wk07_transaction_detail td ON td.transaction_id = tp.transaction_id
    WHERE td.cancelled_ != 'Y' 
      AND DATE_PART('day', TO_DATE(balance_date, 'yyyy-mm-dd')) = 31
      AND DATE_PART('month', TO_DATE(balance_date, 'yyyy-mm-dd')) = 1
),

cte as(
SELECT *
FROM outgoings
UNION ALL
SELECT * FROM incoming
union all
select 
    account_number
    ,null as transaction_value
    ,balance
    ,null as direction
    ,balance_date as transaction_date
from pd2023_wk07_account_information
)

select 
    account_number
    ,transaction_date
    ,transaction_value
    ,SUM(COALESCE(transaction_value,0)) OVER(PARTITION BY account_number ORDER BY transaction_date, transaction_value DESC) + balance as balance
from cte 
order by account_number,transaction_date, transaction_value desc
