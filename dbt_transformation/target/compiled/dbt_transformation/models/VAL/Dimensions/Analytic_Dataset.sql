






with ADS as (

SELECT * from TD_OneHotEncodingTransform(

   
ON (
            select 
       T1.cust_id,Min(T1.income) as income,Min(T1.age) as age,Min(T1.years_with_bank) as years_with_bank,Min(T1.nbr_children) as nbr_children, Min(T1.marital_status) as marital_status,Min(T1.gender) as gender,Min(T1.state_code) as state_code,Min(T2.acct_type) as acct_type
       
       
       ,AVG(CASE WHEN T2.acct_type = 'CC' THEN T2.starting_balance+T2.ending_balance ELSE 0 END) AS CC_avg_bal
       ,AVG(CASE WHEN T2.acct_type = 'CC' THEN T3.principal_amt+T3.interest_amt ELSE 0 END) AS CC_avg_tran_amt
       
       ,AVG(CASE WHEN T2.acct_type = 'SV' THEN T2.starting_balance+T2.ending_balance ELSE 0 END) AS SV_avg_bal
       ,AVG(CASE WHEN T2.acct_type = 'SV' THEN T3.principal_amt+T3.interest_amt ELSE 0 END) AS SV_avg_tran_amt
       
       ,AVG(CASE WHEN T2.acct_type = 'CK' THEN T2.starting_balance+T2.ending_balance ELSE 0 END) AS CK_avg_bal
       ,AVG(CASE WHEN T2.acct_type = 'CK' THEN T3.principal_amt+T3.interest_amt ELSE 0 END) AS CK_avg_tran_amt
       
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 1 THEN T3.tran_id ELSE NULL END) AS q1_trans_cnt
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 2 THEN T3.tran_id ELSE NULL END) AS q2_trans_cnt
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 3 THEN T3.tran_id ELSE NULL END) AS q3_trans_cnt
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 4 THEN T3.tran_id ELSE NULL END) AS q4_trans_cnt
       
       ,current_timestamp(0) as event_timestamp
        FROM teddybank.raw_customers AS T1
        LEFT OUTER JOIN teddybank.raw_accounts AS T2
            ON T1.cust_id = T2.cust_id
        LEFT OUTER JOIN teddybank.raw_transactions AS T3
            ON T2.acct_nbr = T3.acct_nbr
        GROUP BY T1.cust_id
) AS InputTable
ON (
        
        SELECT * from TD_OneHotEncodingFit(
            
            ON (
            select 
       T1.cust_id,Min(T1.income) as income,Min(T1.age) as age,Min(T1.years_with_bank) as years_with_bank,Min(T1.nbr_children) as nbr_children, Min(T1.marital_status) as marital_status,Min(T1.gender) as gender,Min(T1.state_code) as state_code,Min(T2.acct_type) as acct_type
       
       
       ,AVG(CASE WHEN T2.acct_type = 'CC' THEN T2.starting_balance+T2.ending_balance ELSE 0 END) AS CC_avg_bal
       ,AVG(CASE WHEN T2.acct_type = 'CC' THEN T3.principal_amt+T3.interest_amt ELSE 0 END) AS CC_avg_tran_amt
       
       ,AVG(CASE WHEN T2.acct_type = 'SV' THEN T2.starting_balance+T2.ending_balance ELSE 0 END) AS SV_avg_bal
       ,AVG(CASE WHEN T2.acct_type = 'SV' THEN T3.principal_amt+T3.interest_amt ELSE 0 END) AS SV_avg_tran_amt
       
       ,AVG(CASE WHEN T2.acct_type = 'CK' THEN T2.starting_balance+T2.ending_balance ELSE 0 END) AS CK_avg_bal
       ,AVG(CASE WHEN T2.acct_type = 'CK' THEN T3.principal_amt+T3.interest_amt ELSE 0 END) AS CK_avg_tran_amt
       
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 1 THEN T3.tran_id ELSE NULL END) AS q1_trans_cnt
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 2 THEN T3.tran_id ELSE NULL END) AS q2_trans_cnt
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 3 THEN T3.tran_id ELSE NULL END) AS q3_trans_cnt
       
       ,COUNT(CASE WHEN ((EXTRACT(MONTH FROM T3.tran_date) + 2) / 3) = 4 THEN T3.tran_id ELSE NULL END) AS q4_trans_cnt
       
       ,current_timestamp(0) as event_timestamp
        FROM teddybank.raw_customers AS T1
        LEFT OUTER JOIN teddybank.raw_accounts AS T2
            ON T1.cust_id = T2.cust_id
        LEFT OUTER JOIN teddybank.raw_transactions AS T3
            ON T2.acct_nbr = T3.acct_nbr
        GROUP BY T1.cust_id
) AS InputTable
            ON teddybank.ohe_dimensionTable AS CategoryTable Dimension
            
            USING
            IsInputDense('true')TargetColumn('gender','state_code','acct_type')
            Approach('List')
        
            TargetColumnNames ('column_name')
            CategoriesColumn ('category')CategoryCounts(2,6,3)
        ) as dt
 ) AS FitTable DIMENSION 
USING
IsInputDense('true')
) as dt


)

select * from ADS