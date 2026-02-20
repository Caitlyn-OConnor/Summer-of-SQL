select *
    , split_part(transaction_code,'-',1) as bank
    , case online_or_in_person
        when 1 then 'Online'
        when 2 then 'In-Person'
        else null
        end as online_or_in_person
    , dayname(try_to_date(split_part(transaction_date, ' ', 1), 'dd/mm/yyyy')) as transaction_date
    , sum(value) over (partition by split_part(transaction_code,'-',1)) as bank_total
    , sum(value) over (partition by split_part(transaction_code,'-',1), dayname(try_to_date(split_part(transaction_date, ' ', 1), 'dd/mm/yyyy')), online_or_in_person ) as day_bank_type_total
    , sum(value) over (partition by split_part(transaction_code,'-',1), customer_code) as bank_cust_total
from TABLE
