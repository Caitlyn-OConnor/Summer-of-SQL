select 
    transaction_id
    , concat('GB',check_digits,swift_code,replace(t.sort_code, '-', ''),account_number) as IBAN
from table1 t
left join table2 s on
    s.bank = t.bank
