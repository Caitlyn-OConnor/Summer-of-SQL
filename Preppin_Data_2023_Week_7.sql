with accinfo as (
select 
    account_number
    ,account_type
    ,value as account_holder_id
    ,balance_date
    ,balance
from pd2023_wk07_account_information, LATERAL SPLIT_TO_TABLE(account_holder_id,', ')
where account_holder_id is not null
)

select 
    tp.transaction_id
    ,tp.account_to
    ,td.transaction_date
    ,td.value
    ,ai.account_number
    ,ai.account_type
    ,ai.balance_date
    ,ai.balance
    ,ah.name
    ,ah.date_of_birth
    ,concat('0',ah.contact_number) as contact_number
    ,ah.first_line_of_address

from accinfo ai

inner join pd2023_wk07_account_holders ah on ah.account_holder_id = ai.account_holder_id
inner join pd2023_wk07_transaction_path tp on tp.account_from = ai.account_number
inner join pd2023_wk07_transaction_detail td on td.transaction_id = tp.transaction_id

where td.cancelled_ = 'N'
    and td.value>1000
    and ai.account_type != 'Platinum'
