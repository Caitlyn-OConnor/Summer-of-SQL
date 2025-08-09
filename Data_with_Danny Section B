// Section B Customer Transactions

// 1. What is the unique count and total amount for each transaction type?

-- select 
--     txn_type
--     ,count(*) as trans_cnt
--     ,sum(txn_amount) as total_amount
-- from customer_transactions
-- group by txn_type


-- 2.What is the average total historical deposit counts and amounts for all customers?

-- with cte as(
-- select 
--     customer_id
--     ,count(*) as trans_cnt
--     ,sum(txn_amount) as trans_amt
-- from customer_transactions
-- where txn_type = 'deposit'
-- group by customer_id
-- )

-- select
--     avg(trans_cnt) as avg_total_dep_cnt
--     ,avg(trans_amt) as avg_tot_dep_amt
-- from cte


-- 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

-- with cte as(
-- select 
--     date_trunc('month',txn_date) as month
--     ,customer_id
--     ,count(*) as trans_cnt
--     , sum(iff(txn_type='deposit',1,0)) as deposit_cnt
--     ,sum(iff(txn_type!='deposit',1,0)) other_cnt
-- from customer_transactions
-- group by date_trunc('month',txn_date), customer_id
-- order by customer_id, date_trunc('month',txn_date)
-- )

-- select 
--     month
--     ,count(customer_id)
-- from cte
-- where deposit_cnt>1 and other_cnt=1
-- group by month



-- 4.  What is the closing balance for each customer at the end of the month?

-- with cte as(
-- select
--     customer_id
--     ,txn_date
--     ,date_trunc('month',txn_date) as month
--     ,max(txn_date) over (partition by customer_id,date_trunc('month',txn_date) ) as last_monthly_trans
--     ,txn_type
--     ,iff(txn_type='deposit',txn_amount,-txn_amount) as new_txn_amt
-- from customer_transactions
-- ),

-- cte2 as(
-- select *
--     ,last_monthly_trans = txn_date as flag
--     ,sum(new_txn_amt) over (partition by customer_id order by txn_date asc) as balance
-- from cte
-- order by customer_id,txn_date)

-- select 
--     customer_id
--     ,DATEADD('day',-1,DATEADD('month',1,month)) as end_of_month
--     ,min(balance) as closing_balance
-- from cte2
-- where flag = true
-- group by customer_id,month
-- order by customer_id



-- 5. What is the percentage of customers who increase their closing balance by more than 5%?

with cte as(
select
    customer_id
    ,txn_date
    ,date_trunc('month',txn_date) as month
    ,max(txn_date) over (partition by customer_id,date_trunc('month',txn_date) ) as last_monthly_trans
    ,txn_type
    ,iff(txn_type='deposit',txn_amount,-txn_amount) as new_txn_amt
from customer_transactions
),

cte2 as(
select *
    ,iff(last_monthly_trans = txn_date,true,false) as flag
    ,sum(new_txn_amt) over (partition by customer_id order by txn_date asc) as balance
from cte
order by customer_id,txn_date
),

closing_trans as(
select 
    customer_id
    ,DATEADD('day',-1,DATEADD('month',1,month)) as end_of_month
    ,min(balance) as closing_balance
from cte2
where flag = true
group by customer_id,month
order by customer_id
),

goalcte as(
select *
    , lead(closing_balance,1) over (partition by customer_id order by end_of_month asc) as next_balance
    ,iff(closing_balance>0,closing_balance*1.05,closing_balance*0.95) as goal
    ,(select count(distinct customer_id) from closing_trans) as tot_cust
    ,iff(iff(closing_balance>0,closing_balance*1.05,closing_balance*0.95)<next_balance,true,false) as flag 
from closing_trans
)

select 
    round((count(customer_id)/max(tot_cust))*100,2) as perc_increased_cust
from goalcte
where flag = true
