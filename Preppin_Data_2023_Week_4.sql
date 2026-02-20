with cte as(
select '01' as month, *  from pd2023_wk04_january
union all
select '02', * from pd2023_wk04_february
union all
select '03', * from pd2023_wk04_march
union all
select '04', * from pd2023_wk04_april
union all
select '05', * from pd2023_wk04_may
union all
select '06', * from pd2023_wk04_june
union all
select '07', * from pd2023_wk04_july
union all
select '08', * from pd2023_wk04_august
union all
select '09', * from pd2023_wk04_september
union all
select '10', * from pd2023_wk04_october
union all
select '11', * from pd2023_wk04_november
union all
select '12', * from pd2023_wk04_december
),

cte2 as(
select 
    id
    ,demographic
    ,value
    ,min(try_to_date(concat(joining_day,' ',month,' ','2023'),'dd mm yyyy')) as joining_date
from cte
group by id, demographic, value
)

select *
from (
    select id, joining_date, demographic, value
    from cte2
)
pivot (
    min(value) for demographic in (SELECT DISTINCT demographic FROM cte2))


