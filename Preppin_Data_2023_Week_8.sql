with cte as (
select '01' as month, * from pd2023_wk08_01
union all
select '02' as month, * from pd2023_wk08_02
union all
select '03' as month, * from pd2023_wk08_03
union all
select '04' as month, * from pd2023_wk08_04
union all
select '05' as month, * from pd2023_wk08_05
union all
select '06' as month, * from pd2023_wk08_06
union all
select '07' as month, * from pd2023_wk08_07
union all
select '08' as month, * from pd2023_wk08_08
union all
select '09' as month, * from pd2023_wk08_09
union all
select '10' as month, * from pd2023_wk08_10
union all
select '11' as month, * from pd2023_wk08_11
union all
select '12' as month, * from pd2023_wk08_12
),

cte2 as(
select * 
    ,to_decimal(split_part(purchase_price,'$',2)) as purchase_price_new
    , case 
        when market_cap ='n/a' then null
        else 
        REGEXP_SUBSTR(market_cap, '[\\d.]+')* 
        CASE 
        WHEN UPPER(REGEXP_SUBSTR(market_cap, '[KMB]')) = 'K' THEN 1000
        WHEN UPPER(REGEXP_SUBSTR(market_cap, '[KMB]')) = 'M' THEN 1000000
        WHEN UPPER(REGEXP_SUBSTR(market_cap, '[KMB]')) = 'B' THEN 1000000000
        ELSE 1
        END
    end as market_capy
    , case 
        when split_part(purchase_price,'$',2)<25000 then 'Low'
        when split_part(purchase_price,'$',2)>=25000 and split_part(purchase_price,'$',2)<50000 then 'Medium'
        when split_part(purchase_price,'$',2)>=50000 and split_part(purchase_price,'$',2)<80000 then 'High'
        else 'Very High'
        end as purchase_price_cat
  from cte
  where market_cap != 'n/a'
),

cte3 as(
select 
    purchase_price_cat
    ,month
    ,ticker
    ,sector
    ,market
    ,stock_name
    ,purchase_price_new as purchase_price
    ,market_capy
    , case when market_capy < 100000000 then 'Small'
        when market_capy >= 100000000 and market_capy<1000000000 then 'Medium'
        when market_capy >= 1000000000 and market_capy<100000000000 then 'Large'
        else 'Huge'
        end as market_cap_cat
    , rank() over (partition by month, purchase_price_cat, (case when market_capy < 100000000 then 'Small'
        when market_capy >= 100000000 and market_capy<1000000000 then 'Medium'
        when market_capy >= 1000000000 and market_capy<100000000000 then 'Large'
        else 'Huge' end) order by purchase_price desc ) as rank
from cte2
)

select *
from cte3
where rank<6
