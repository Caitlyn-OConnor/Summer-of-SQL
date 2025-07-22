with cte1 as(
select 
        case online_or_in_person
            when 1 then 'Online'
            when 2 then 'In-Person'
            else null
            end as online_or_in_person
        , quarter(try_to_date(split_part(transaction_date, ' ', 1), 'dd/mm/yyyy')) as qtr
        , sum(value) over (partition by online_or_in_person, quarter(try_to_date(split_part(transaction_date, ' ', 1), 'dd/mm/yyyy'))) as value
from pd2023_wk01
where split_part(transaction_code,'-',1) = 'DSB'
),

cte2 as(
select 
    online_or_in_person
    ,to_double(qtr) as qtr
    ,target
from (
    select 'Online' as online_or_in_person, 72500 as "1", 70000 as "2", 60000 as "3", 60000 as "4"
    union all 
    select 'In-Person', 75000, 70000, 70000, 60000
    )
unpivot ( target for qtr in ("1","2","3","4"))
)

select 
    cte1.online_or_in_person
    ,cte1.qtr as quarter
    ,cte1.value 
    ,cte2.target as quarterly_targets
    ,cte1.value - cte2.target as variance_to_target
from cte1
left join cte2 
    on cte1.online_or_in_person = cte2.online_or_in_person
    and cte1.qtr = cte2.qtr

