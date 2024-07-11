select *
from [dbo].[metaverse_transactions$]


---DATA CLEANING 
select distinct sending_address
from [dbo].[metaverse_transactions$]
---checking for null values 
select 'timestamp' as columnname, count(*) as count 
from [dbo].[metaverse_transactions$]
where timestamp is null
group by timestamp
union 
select 'hour_of_day' , count(*)
from [dbo].[metaverse_transactions$]
where hour_of_day is null
group by hour_of_day
union 
select 'sending_address' , count(*)
from [dbo].[metaverse_transactions$]
where sending_address is null
group by sending_address
union 
select 'receiving_address' , count(*)
from [dbo].[metaverse_transactions$]
where receiving_address is null
group by receiving_address
union 
select 'amount' , count(*)
from [dbo].[metaverse_transactions$]
where amount is null
group by amount
union 
select 'transaction_type' , count(*)
from [dbo].[metaverse_transactions$]
where transaction_type is null
group by transaction_type
union 
select 'location_region' , count(*)
from [dbo].[metaverse_transactions$]
where location_region is null
group by location_region
union 
select 'ip_prefix' , count(*)
from [dbo].[metaverse_transactions$]
where ip_prefix is null
group by ip_prefix
union 
select 'login_frequency' , count(*)
from [dbo].[metaverse_transactions$]
where login_frequency is null
group by login_frequency
union 
select 'session_duration' , count(*)
from [dbo].[metaverse_transactions$]
where session_duration is null
group by session_duration
union 
select 'purchase_pattern' , count(*)
from [dbo].[metaverse_transactions$]
where purchase_pattern is null
group by purchase_pattern
union 
select 'age_group' , count(*)
from [dbo].[metaverse_transactions$]
where age_group is null
group by age_group
union 
select 'risk_score' , count(*)
from [dbo].[metaverse_transactions$]
where risk_score is null
group by risk_score
union 
select 'anomaly' , count(*)
from [dbo].[metaverse_transactions$]
where anomaly is null
group by anomaly
--- no null values
select distinct transaction_type
from [dbo].[metaverse_transactions$]
union 
select distinct location_region
from  [dbo].[metaverse_transactions$] 
select *
from [dbo].[metaverse_transactions$]

select distinct ip_prefix,location_region
from [dbo].[metaverse_transactions$]
order by ip_prefix

select distinct age_group
from  [dbo].[metaverse_transactions$]
--- rename age_group to tenure_group because the value are not corresponding to the column name
sp_rename '[dbo].[metaverse_transactions$].age_group','tenure_group', 'column'
select distinct anomaly 
from [dbo].[metaverse_transactions$]
--replace value in column anomaly;low_risk to low risk and high_risk to high risk etc 
update [dbo].[metaverse_transactions$]
set anomaly = REPLACE(anomaly,'moderate_risk','moderate risk')

update [dbo].[metaverse_transactions$]
set anomaly = REPLACE(anomaly,'high_risk','high risk')

update [dbo].[metaverse_transactions$]
set anomaly = REPLACE(anomaly,'low_risk','low risk')

update [dbo].[metaverse_transactions$]
set purchase_pattern = REPLACE(purchase_pattern,'high_vlue','high value')






/*****Write a SQL query to identify potentially fraudulent transactions by comparing the average
transaction amount of each sending address to its individual transactions. 
Highlight those transactions where the amount exceeds the average by more than two standard deviations*/

select *
from [dbo].[metaverse_transactions$]

with Average_Transaction_Amount as(
select timestamp,transaction_type,ip_prefix,login_frequency,sending_address,
	AVG(amount)over (partition by sending_address) as average_amount, amount
from [dbo].[metaverse_transactions$]
),
fraud_detection_table as(
	select sending_address, round(amount-AVG(amount)over (partition by sending_address),0) as amount_difference,
	STDEV(amount)over (partition  by sending_address) as standard_deviation,
	iif(round(amount-AVG(amount)over (partition by sending_address),0) > 2*STDEV(amount)over (partition  by sending_address),1,0) as fruad_detection
from [dbo].[metaverse_transactions$]
)

select distinct fraud_table.sending_address, amount_difference,fruad_detection, round(fraud_table.standard_deviation,0) as standard_deviation
 from Average_Transaction_Amount  Avg_amount
 full join fraud_detection_table  fraud_table
 on  Avg_amount.sending_address = fraud_table.sending_address
 where fruad_detection =1
 

/*Describe how you would create a Power BI dashboard to monitor transaction patterns and predict high-risk transactions using historical data.
What key visualizations and data transformations would you include, and how would you implement a predictive model in Power BI?*/


select *
from [dbo].[metaverse_transactions$]
where anomaly ='low risk'


update [dbo].[metaverse_transactions$]
set risk_score = ROUND(risk_score,0)