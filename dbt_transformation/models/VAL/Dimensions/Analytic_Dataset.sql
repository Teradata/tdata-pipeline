{{ config(materialized='table') }}

{% set variables %}
            select 
       T1.cust_id,Min(T1.income) as income,Min(T1.age) as age,Min(T1.years_with_bank) as years_with_bank,Min(T1.nbr_children) as nbr_children, Min(T1.marital_status) as marital_status,Min(T1.gender) as gender,Min(T1.state_code) as state_code,Min(T2.acct_type) as acct_type
       {% set _ = getValues(var('db'),'raw_accounts','acct_type') %}
       {% for value in _%}
       ,AVG(CASE WHEN T2.acct_type = '{{value}}' THEN T2.starting_balance+T2.ending_balance ELSE 0 END) AS {{value}}_avg_bal
       ,AVG(CASE WHEN T2.acct_type = '{{value}}' THEN T3.principal_amt+T3.interest_amt ELSE 0 END) AS {{value}}_avg_tran_amt
       {% endfor %}
       {% for _ in range(1,5) %}
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = {{_}} THEN T3.tran_id ELSE NULL END) AS q{{_}}_trans_cnt
       {% endfor %}
       ,current_timestamp(0) as event_timestamp
        FROM teddybank.raw_customers AS T1
        LEFT OUTER JOIN teddybank.raw_accounts AS T2
            ON T1.cust_id = T2.cust_id
        LEFT OUTER JOIN teddybank.raw_transactions AS T3
            ON T2.acct_nbr = T3.acct_nbr
        GROUP BY T1.cust_id
{% endset %}


{% set fitout %}{{Onehotencoding_Fit(db=var('db'),id = var('OHE_1'), inputtable=variables)}}{% endset %}

with ADS as ({{Onehotencoding_Transform(db=var('db'),id = var('OHE_transform_1'), inputtable=variables, fittable=fitout) }})

select * from ADS