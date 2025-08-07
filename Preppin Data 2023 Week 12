with cte as(
select 
    date
    ,bank_holiday
    ,last_value(nullif(year,'')ignore nulls) over (order by row_num rows between unbounded preceding and current row) as year
from pd2023_wk12_uk_bank_holidays
),

cte2 as(
select 
    bank_holiday
    , try_to_date(concat(date,'-',year),'dd-mon-yyyy') as date
from cte
where bank_holiday!=''
),

cte3 as(
select 
    try_to_date(nc.date,'dd/mm/yyyy') as date
    ,nc.new_customers
    ,cte2.bank_holiday
    ,cte2.date as bank_date
    , dayname(try_to_date(nc.date,'dd/mm/yyyy')) as day_of_week
    , case 
        when dayname(try_to_date(nc.date,'dd/mm/yyyy')) != 'Sat' and
        dayname(try_to_date(nc.date,'dd/mm/yyyy')) != 'Sun' 
        and cte2.bank_holiday is null
        then 1
        else 0
        end as reporting_flag
    
from pd2023_wk12_new_customers nc
left join cte2 on cte2.date = try_to_date(nc.date,'dd/mm/yyyy')
order by try_to_date(nc.date,'dd/mm/yyyy')
),

non_reporting_days as(
select
    distinct date as non_reporting_date
from cte3
where reporting_flag = 0
),

next_rep_days as(
select 
    rd.non_reporting_date
    ,min(cte3.date) as next_rep_date
from cte3
inner join non_reporting_days rd on cte3.date > rd.non_reporting_date
where cte3.reporting_flag = 1
group by  rd.non_reporting_date
),

cte4 as(
select 
    iff(reporting_flag = 0, next_rep_date, date) as reporting_date
    , sum(new_customers) as UK_new_customers
    ,max(iff(reporting_flag = 0, next_rep_date, date)) over (partition by 
    concat(monthname(iff(reporting_flag = 0, next_rep_date, date)),'-',year((iff(reporting_flag = 0, next_rep_date, date))))) as max_day
    
from cte3
left join next_rep_days nrd on cte3.date = nrd.non_reporting_date
group by iff(reporting_flag = 0, next_rep_date, date)
),

cte5 as(
select
    reporting_date
    ,UK_new_customers
    ,iff(reporting_date = max_day, concat(monthname(dateadd('month',1,reporting_date)),'-',year(dateadd('month',1,reporting_date))), concat(monthname(reporting_date),'-',year(reporting_date))) as reporting_month
from cte4
),

uk_reporting as(
select *
    ,row_number() over (partition by reporting_month order by reporting_date asc) as reporting_day
from cte5
order by reporting_date
),

roi_non_matching as(
select 
    try_to_date(roi.reporting_date,'dd/mm/yyyy') as roi_non_matching
    ,min(uk2.reporting_date) as roi_new_date
from pd2023_wk12_roi_new_customers roi 
left join uk_reporting uk1 on uk1.reporting_date=try_to_date(roi.reporting_date,'dd/mm/yyyy')
left join uk_reporting uk2 on uk2.reporting_date>try_to_date(roi.reporting_date,'dd/mm/yyyy')
where uk1.reporting_date is null
group by try_to_date(roi.reporting_date,'dd/mm/yyyy')
),

roi_reporting as(
select 
    iff(roi_new_date is null, try_to_date(roi.reporting_date,'dd/mm/yyyy'),roi_new_date) as roi_reporting_date
    ,sum(new_customers) as roi_new_customers
    ,row_number() over (partition by min(reporting_month) order by iff(roi_new_date is null, try_to_date(roi.reporting_date,'dd/mm/yyyy'),roi_new_date)  asc) as roi_reporting_day
    ,min(reporting_month) as roi_reporting_month
from pd2023_wk12_roi_new_customers roi
left join roi_non_matching rnon on try_to_date(roi.reporting_date,'dd/mm/yyyy') = rnon.roi_non_matching
group by  iff(roi_new_date is null, try_to_date(roi.reporting_date,'dd/mm/yyyy'),roi_new_date) 
)

select 
    iff(left(uk.reporting_month,3)=left(roi.roi_reporting_month,3),null, 'Misalignment') as misalignment_flag
    ,uk.reporting_month
    ,uk.reporting_day
    ,uk.reporting_date
    ,coalesce(uk.uk_new_customers,0) as uk_new_customers
    ,coalesce(roi.roi_new_customers,0) as roi_new_customers
    ,roi.roi_reporting_month
from uk_reporting uk
left join roi_reporting roi on roi.roi_reporting_date = uk.reporting_date
order by uk.reporting_date
