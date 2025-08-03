set selected_date = '2023-02-01';

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
),

output as (
select 
    account_number
    ,transaction_date as balance_date
    ,transaction_value 
    ,SUM(COALESCE(transaction_value,0)) OVER(PARTITION BY account_number ORDER BY transaction_date, transaction_value DESC) + balance as balance
from cte 
order by account_number,transaction_date, transaction_value desc
),

daily_trans as(
select 
    account_number
    ,balance_date
    ,sum(transaction_value) as transaction_value
from output
group by account_number, balance_date
),

daily_balance as(
select *
    , row_number() over (partition by account_number, balance_date order by transaction_value asc) as row_no
from output
),

daily_output as (
select 
    t.account_number
    ,t.balance_date
    ,t.transaction_value
    ,b.balance
from daily_trans t
inner join daily_balance b on t.account_number = b.account_number and t.balance_date = b.balance_date
where row_no = 1
),

accountnos AS (
SELECT DISTINCT 
account_number
FROM daily_output
),

dates AS (
SELECT '2023-01-31'::date as days,
account_number
FROM accountnos

UNION ALL

select DATEADD('day',1,days),
account_number
FROM dates 
WHERE days < '2023-02-14'::date
),

joiningcte as(
select 
    dates.account_number
    ,dates.days as transaction_date
    ,o.transaction_value
    ,o.balance as incorrect
    ,b.balance_date
    ,b.balance
    ,ROW_NUMBER() OVER(PARTITION BY dates.account_number, dates.days ORDER BY DATEDIFF('day',b.balance_date,dates.days)) as row_no
from dates
left join daily_output o on dates.days = o.balance_date and dates.account_number = o.account_number
inner join daily_balance b on b.account_number = dates.account_number and dates.days >= b.balance_date
order by o.account_number, dates.days
)

select  
    account_number
    ,transaction_date
    ,balance
    ,transaction_value
from joiningcte
where row_no =1
and transaction_date = $selected_date
