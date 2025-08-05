with cte as(
select *
    , address_long/ (180/pi()) as new_address_long
    , address_lat/ (180/pi()) as new_address_lat
    , branch_long/ (180/pi()) as new_branch_long
    , branch_lat/ (180/pi()) as new_branch_lat
from pd2023_wk11_dsb_customer_locations cross join pd2023_wk11_dsb_branches
order by customer
),

cte2 as(
select *
    ,round(
    3963 * acos((sin(new_address_lat) * sin(new_branch_lat)) + cos(new_address_lat) * cos(new_branch_lat) * cos(new_branch_long - new_address_long)),2) as distance
    , min(round(
    3963 * acos((sin(new_address_lat) * sin(new_branch_lat)) + cos(new_address_lat) * cos(new_branch_lat) * cos(new_branch_long - new_address_long)),2)) over (partition by customer) as closest_branch
from cte
)

select 
    customer
    ,branch
    ,branch_lat
    ,branch_long
    ,distance
    ,rank() over (partition by branch order by distance asc) as customer_priority
    ,address_lat
    ,address_long
from cte2 
where distance = closest_branch
