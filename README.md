# METAVERSE TRANSACTION ANALYSIS 
## Project Overview 

 This data analysis project aims to provide insights, offering an overview of transactions in the Metaverse, covering purchases, sales, scams, and transfers. The analysis highlights key activity periods, average transaction values, and patterns of fraudulent activities, providing insights into transaction flows and potential risks. 
 ## Data Source

This dataset was gotten from github account as csv file which was downloaded to research transaction activity on the metaverse

## Tools


- Microsoft SQL SEVER- This was used to clean and analysis the dataset to extract insight to answer insightful business question
- Power Bi - This was used for visualization of insight and to expansaite
- Power Query - To clean and validate, checking for data quality 


## Data Cleaning
  Initially the data cleaning steps was performed from
  - Data Loading
  -  Removal of Missing Values
  -  Replacement of missing values
 
  ## Exploratory Data Analysis

  EDA involves explaining the human resource datasetbto answerthese questions 
  
  1. Total Amount by IP addres?
  2. How to pontentially detect risky transaction?
  3. which Group of user for pery for the scam attacks?
  4. Transaction Pattern by Time series ?
  5. Total Amount of used in Transaction ?
 
     
## Data Analysis
Include some interesting code/features worked with

```sql
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
	iif(round(amount-AVG(amount)over (partition by sending_address),0) > (2*STDEV(amount)over (partition  by sending_address)),1,0) as fruad_detection
from [dbo].[metaverse_transactions$]
)

select distinct fraud_table.sending_address, amount_difference,fruad_detection, round(fraud_table.standard_deviation,0) as standard_deviation
 from Average_Transaction_Amount  Avg_amount
 full join fraud_detection_table  fraud_table
 on  Avg_amount.sending_address = fraud_table.sending_address
 where fruad_detection =1
`````

### Results/Findings
[metversedata.pdf](https://github.com/user-attachments/files/18000694/metversedata.pdf)

![metavarse pic](https://github.com/user-attachments/assets/1f949371-72a6-48a3-b049-b67d121a34bc)




## Recommendations
Based on the analysis, we recommend the following actions:
The increase in undetected fraud was due to the same IP address being used across five countries, likely through VPNs or shared networks. 
To counter this, implement multi-factor authentication, monitor unusual access patterns, and use advanced detection tools that analyze behavior beyond just IP addresses. 
Different tenure group transacted almost with the same amount of metaverse currency .
To address this, it's crucial to implement user education programs focusing on scam and phishing awareness within the metaverse, 
enforce stricter transaction monitoring for new users, and provide clear guidance on secure transaction practices in this digital environment

## References

Github
