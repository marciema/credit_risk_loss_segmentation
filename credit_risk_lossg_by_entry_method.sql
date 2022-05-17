
select 
    CASE WHEN method_of_payment in ('register_contactless', 'register_emv_contact', 'register_swiped', 'register_hardware_emv_contact', 'register_hardware_contactless', 'register_hardware_swiped') THEN 'CP'
               WHEN method_of_payment in ('register_manually_keyed', 'register_card_on_file', 'register_hardware_manually_keyed', 'register_hardware_card_on_file') THEN 'CNP'
               WHEN method_of_payment in ('terminal_keyed', 'terminal_card_on_file', 'terminal_swiped') THEN 'VT'
               WHEN method_of_payment in ('invoice_on_file', 'invoice_web_form') THEN 'Invoice'
               WHEN method_of_payment in ('external_api_on_file', 'external_api') THEN 'API'
               ELSE 'Other'
             END  AS "entry_method_high_level",
sum(amount_base_unit_usd)/100
from APP_BI.PENTAGON.FACT_PAYMENT_TRANSACTIONS
where currency_code = 'USD'
and payment_trx_recognized_date between '2020-01-01' and '2020-03-31'
and is_gpv = 1
group by 1
;


SELECT
    date_trunc(quarter, payment_date) as quarter
    ,CASE WHEN LOWER(entry_method) IN ('register_contactless', 'register_emv_contact', 'register_swiped', 'register_hardware_emv_contact', 'register_hardware_contactless', 'register_hardware_swiped') THEN 'CP'
    WHEN LOWER(entry_method) IN ('register_manually_keyed', 'register_card_on_file', 'register_hardware_manually_keyed', 'register_hardware_card_on_file') THEN 'CNP'
    WHEN LOWER(entry_method) IN ('terminal_keyed', 'terminal_card_on_file', 'terminal_swiped') THEN 'VT'
    WHEN LOWER(entry_method) IN ('invoice_on_file', 'invoice_web_form') THEN 'Invoice'
    WHEN LOWER(entry_method) IN ('external_api_on_file', 'external_api') THEN 'API'
    ELSE 'OTHER' END AS entry_method_group
  ,SUM(gpv_cents)/100 AS gpv_dllr
FROM app_risk.app_risk.card_payment_daily_summary
where currency_code = 'USD'
and payment_date >= '2020-01-01'
group by 1,2
order by 1,2
;


SELECT
    date_trunc(quarter, payment_created_at) as quarter
    ,CASE WHEN app_risk_chargebacks.entry_method in ('register_contactless', 'register_emv_contact', 'register_swiped', 'register_hardware_emv_contact', 'register_hardware_contactless', 'register_hardware_swiped') THEN 'CP'
               WHEN app_risk_chargebacks.entry_method in ('register_manually_keyed', 'register_card_on_file', 'register_hardware_manually_keyed', 'register_hardware_card_on_file') THEN 'CNP'
               WHEN app_risk_chargebacks.entry_method in ('terminal_keyed', 'terminal_card_on_file', 'terminal_swiped') THEN 'VT'
               WHEN app_risk_chargebacks.entry_method in ('invoice_on_file', 'invoice_web_form') THEN 'Invoice'
               WHEN app_risk_chargebacks.entry_method in ('external_api_on_file', 'external_api') THEN 'API'
               ELSE 'Other' end as entry_method_group
   ,sum(loss_cents)/100
from app_risk.app_risk.chargebacks as app_risk_chargebacks
where currency_code = 'USD'
and payment_created_at >= '2020-01-01'
and reason_code_type = 'credit'
group by 1,2
order by 1,2
;
