with mobile_cte as(
SELECT 
    customer_id,
    CASE mobile_app
        WHEN 'MOBILE_APP___EASE_OF_USE' THEN 'ease_of_use'
        WHEN 'MOBILE_APP___EASE_OF_ACCESS' THEN 'ease_of_access'
        WHEN 'MOBILE_APP___NAVIGATION' THEN 'navigation'
        WHEN 'MOBILE_APP___LIKELIHOOD_TO_RECOMMEND' THEN 'likelihood_to_rec'
    END AS mobile_app,
    mobile_responce
    ,avg(mobile_responce) over (partition by customer_id) as mobile_avg
FROM pd2023_wk06_dsb_customer_survey
UNPIVOT (
    mobile_responce FOR mobile_app IN (
        MOBILE_APP___EASE_OF_USE,
        MOBILE_APP___EASE_OF_ACCESS,
        MOBILE_APP___NAVIGATION,
        MOBILE_APP___LIKELIHOOD_TO_RECOMMEND
    ))
),

online_cte as(
SELECT 
    customer_id,
    case online
    when 'ONLINE_INTERFACE___EASE_OF_USE' THEN 'ease_of_use'
    when 'ONLINE_INTERFACE___EASE_OF_ACCESS' THEN 'ease_of_access'
    when 'ONLINE_INTERFACE___NAVIGATION' THEN 'navigation'
    when 'ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND' THEN 'likelihood_to_rec'
    end as online
    ,online_responce
   , avg(online_responce) over (partition by customer_id) as online_avg
FROM pd2023_wk06_dsb_customer_survey
UNPIVOT (
    online_responce FOR online IN (
        ONLINE_INTERFACE___EASE_OF_USE,
        ONLINE_INTERFACE___EASE_OF_ACCESS,
        ONLINE_INTERFACE___NAVIGATION,
        ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND 
    ))
)

select 
    case 
    when (mobile_avg - online_avg) >= 2 then 'Mobile App Superfan'
    when (mobile_avg - online_avg) >= 1 and (mobile_avg - online_avg)<2 then 'Mobile App Fan'
    when (mobile_avg - online_avg) <= -2 then 'Online Interface Superfan'
    when (mobile_avg - online_avg) <= -1 and (mobile_avg - online_avg)>-2 then 'Online Interface Fan'
    when (mobile_avg - online_avg)< 1 and (mobile_avg - online_avg)>-1 then 'Neutral'
    end as preference
    , round(((count(distinct o.customer_id)) / (select count(distinct customer_id) from pd2023_wk06_dsb_customer_survey))* 100 ,1)as perc_of_total
    
from online_cte o
inner join mobile_cte m on m.customer_id = o.customer_id and o.online = m.mobile_app
group by preference

