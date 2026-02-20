--Section A

select *
from subscriptions s
left join plans p on p.plan_id = s.plan_id

-- Section B

-- Question 1
select
    count(distinct customer_id)
from subscriptions


--Question 2

select 
    date_trunc('month',s.start_date) as month
    ,count(distinct s.customer_id) as no_customers
from subscriptions s
left join plans p on p.plan_id = s.plan_id
where p.plan_name='trial'
group by date_trunc('month',s.start_date)


-- Question 3
select 
    p.plan_name
    ,count(*) as cnt
from subscriptions s
left join plans p on p.plan_id = s.plan_id
where date_part('year',s.start_date)> 2020
group by p.plan_name


-- Question 4

select 
    count(distinct customer_id) over () as tot
    ,round(((count(distinct customer_id) over ())/(select count(distinct customer_id) from subscriptions))*100,1) as percent_of_tot
    ,(select count(distinct customer_id) from subscriptions) as overall
from subscriptions 
where plan_id=4

-- Question 5

-- with cte as (
select *
    ,lead(plan_id) over (partition by customer_id order by customer_id, start_date)  as next_plan
    ,case when plan_id=0 and lead(plan_id) over (partition by customer_id order by customer_id, start_date) =4 then 1 else null end as churned
    ,(select count(distinct customer_id) from subscriptions) as tot
from subscriptions
)

select 
    round(( count(churned)/min(tot) )*100,0) as cust_percent_churned
    ,count(churned) as no_churned_cust
from cte


-- Question 6

with cte as(
select *
    ,lead(p.plan_name) over (partition by customer_id order by customer_id, start_date)  as next_plan
    ,case 
        when p.plan_id=0 and lead(p.plan_name) over (partition by customer_id order by customer_id, start_date) !='trial' 
        then 1 else null end as cust_planned
    ,(select count(distinct customer_id) from subscriptions) as tot
from subscriptions s
left join plans p on p.plan_id = s.plan_id
)

select 
    next_plan
    ,count(cust_planned) as no_cust_planned
    ,round((count(cust_planned)/min(tot))*100,1) as perc_planned
from cte
group by next_plan


--Question 7

with cte as (
select *
    ,row_number() over (partition by customer_id order by start_date desc) as row_no
from subscriptions
where start_date<='2020-12-31'
)

select 
    plan_name
    ,count(distinct customer_id) as no_cust
    , round((count(distinct customer_id)/(select count(distinct customer_id) from cte))*100,1) as perc_cust
from cte
inner join plans p on cte.plan_id=p.plan_id
where row_no =1
group by plan_name


-- Question 8

select 
    count(distinct customer_id) as no_annual_upgrades
from subscriptions
where date_part('year',start_date)='2020'
    and plan_id = 3


Question 9
with cte as(
select 
    customer_id
    ,datediff('day', (min(start_date) over (partition by customer_id)),(case when plan_id='3' then start_date end)) as dif
from subscriptions
)

select round(avg(dif),0) as avg_days_to_annual
from cte


-- Question 10

with cte as(
select 
    customer_id
    ,datediff('day', (min(start_date) over (partition by customer_id)),(case when plan_id='3' then start_date end)) as dif
from subscriptions
)

select
    case 
    when dif<=30 then '0-30 days'
    when dif>30 and dif<=60 then '31-60 days'
    when dif>60 and dif<=90 then '61-90 days'
    when dif>90 and dif<=120 then '91-120 days'
    when dif>120 and dif<=150 then '120-150 days'
    when dif>150 and dif<=180 then '150-180 days'
--     -- etc...
    end as bins
    , count(distinct customer_id)
from cte
where bins is not null
group by bins


--  Question 11

with cte as (
select *
    , lead(plan_id) over (partition by customer_id order by start_date asc) as next_plan
from subscriptions
where date_part('year',start_date)='2020'
)

select count(distinct customer_id) as no_cust_downgraded
from cte
where plan_id = 2 and next_plan = 1






