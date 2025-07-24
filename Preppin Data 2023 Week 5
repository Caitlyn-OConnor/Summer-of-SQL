with cte as(
select 
    split_part(transaction_code,'-',1) as bank
    , monthname(try_to_date(transaction_date, 'dd/mm/yyyy 00:00:00')) as month
    , sum(value) as value
    ,rank() over (partition by monthname(try_to_date(transaction_date, 'dd/mm/yyyy 00:00:00')) order by sum(value) desc) as bank_rank_per_month
from pd2023_wk01
group by bank, month
)

select *
    , avg(bank_rank_per_month) over (partition by bank) as avg_rank_per_bank
    , avg(value) over (partition by bank_rank_per_month) as avg_transaction_value_per_rank
from cte
