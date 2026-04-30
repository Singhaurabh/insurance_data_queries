#What are the top 5 patients who claimed the highest insurance amounts?
select PatientID,max(claim) as max_claim
from insurance_data
group by PatientID
order by max_claim desc
limit 5;
-------------------------------------------------------------------------------------------------------------------------------------------------
# second way of solving this question
select PatientID,claim as max_claim from
(select PatientID,claim from insurance_data
order by claim desc) as top_claims
limit 5;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# third way to solve this problem
select PatientID,claim from 
(select PatientID,claim,
row_number() over(order by claim desc) as row_order
from insurance_data ) as max_claim
where row_order <=5;
-------------------------------------------------------------------------------------------------------------------------------------------------
# q2 ### **Problem 2:** What is the average insurance claimed by patients based on the number of children they have?

(select avg(claim) as avg_claim,children
from insurance_data
group by children);

---------------------------------------------------------------------------------------------------------------------------------------------
# second way to solve this problem
select PatientID,children,claim,avg(claim) over(partition by children)as max_claim
from insurance_data;
-------------------------------------------------------------------------------------------------------------------------------------------------
# follow up question
# Find Patient IDs With Highest Claim in Each Children Group
select PatientID,children,claim from 
(select *,rank()over(partition by children order by claim desc) as ranking
from insurance_data) as t
where ranking =1 ;
---------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 3:** What is the highest and lowest claimed amount by patients in each region?
select distinct(region),max(claim) over(partition by region order by claim desc) as max_claim,
min(claim) over(partition by region order by claim asc) min_claim
from insurance_data
;

# second way to solve this problem
select region,max(claim) as max_claim,min(claim) as min_claim
from insurance_data
group by region
order by max_claim desc,min_claim asc;
-------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 4:** What is the percentage of smokers in each age group?select  from
select age,round(sum(case when smoker ="Yes" then 1 else 0 end)*100/count(*),2) as smoker_per from insurance_data
group by age
order by age asc
;

# second method 
select age,abs(smokers/count(smoker))*0.1 as smokers_per
from 
(select *,count(smoker) over(partition by age order by age) as smokers
from insurance_data
where smoker = 'Yes') as smoker_rec
group by age;
-------------------------------------------------------------------------------------------------------------------------------------------------
#find the first claimed insurance value for male and female patients, within each region order the data by patient age in ascending order,
# and only include patients who are non-diabetic and have a bmi value between 25 and 30.
select PatientID,claim,region,age,gender,bmi
from 
(select *,dense_rank() over(partition by region,gender order by age asc) as ranking
from insurance_data
where diabetic = "No"
having(bmi>=25 and bmi<=30)
) as t
where ranking =1;
## second way of solving this question is
select  PatientID,claim,region,age,gender,bmi
from
(select *, row_number() over(partition by gender,region order by age asc) as row_num
from insurance_data
where diabetic = "No"
and bmi between 25 and 30 ) as t
where row_num =1;
-------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 11:** For each patient, find the rolling average of the last 2 claims.
# use the rows in between the 2 preseding and the current rows
select PatientID,age,claim,running_avg_rolling from
(select *,round(avg(claim) over(partition by PatientID  order by age asc rows between 1 preceding and current row ),2) as running_avg_rolling
from insurance_data) t
order by age asc;
-------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 10:** For each patient, find the maximum BMI value among their next three records (ordered by age).
select PatientID,age,gender,bmi,region,claim,over_next_three from
(select *,max(bmi) over(partition by PatientID order by age asc rows between current row and 2 following) as over_next_three
from insurance_data) t;
-------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 9:** For each patient, calculate the difference in claim amount between the patient and the patient with the highest 
#claim amount among patients with the same bmi and smoker status, within the same region. Return the result in descending order difference.
# important to  note you have to group on 3 factors - 1.bmi,smoker status,region

select PatientID,region,bmi,round((max_claim - claim),2) as diff_in_claim_among_same from 
(select *,ROUND(max(claim) over(partition by bmi,smoker,region),2) as max_claim
from insurance_data) t
order by diff_in_claim_among_same desc;
-------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 8:** Calculate the difference between the claimed amount of each patient and the claimed amount of the
# patient who has the highest BMI in their region.
select PatientID,age,bmi,abs(max_claim - claim) as diff_in_bmi_claim  from 
(select *,rank() over(partition by region order by bmi desc) as max_claim
from insurance_data
group by bmi,region
having (max(bmi))
)t 
where max_claim =1
group by PatientID,age,bmi;
-------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 7:** Show the patient with the highest BMI in each region and their respective rank.
select PatientID,age,gender,region,max_bmi,rank_on_bmi from 
(select *,max(bmi) over(partition by region) as max_bmi,dense_rank()over(partition by region order by bmi desc) as rank_on_bmi
from insurance_data)t
where rank_on_bmi =1;
-------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 6:** For each patient, calculate the difference between their claimed amount and the average claimed amount of 
# patients with the same number of children.
select PatientID,claim,children,avg_claim,abs(avg_claim - claim) as diff_in_claim from 
(select *,round(avg(claim) over(partition by children),2) as avg_claim
 from insurance_data) t;
 -------------------------------------------------------------------------------------------------------------------------------------------------
### **Problem 5:** What is the difference between the claimed amount of each patient and the first claimed amount of that patient?
# wrong question acc to dataset followup questions on dataset 
# Compare with first claim in dataset ordered by age

select * ,first_value(claim) over(order by age) as val_diff
 from 
insurance_data;
-------------------------------------------------------------------------------------------------------------------------------------------------
# few more questions on the same dataset 
# How many patients have claimed more than the average claim amount for patients who are smokers and have at least one child,
# and belong to the southeast region?
select count(PatientID)
from insurance_data
where claim > (select avg(claim) from insurance_data
where region = "southeast" and smoker = "Yes" and children >=1) 
and region = "southeast" and smoker = "Yes" and children >=1;
-------------------------------------------------------------------------------------------------------------------------------------------------
#How many patients have claimed more than the average claim amount for patients who are not smokers and have a BMI greater
# than the average BMI for patients who have at least one child?
select count(PatientID)
from insurance_data
where smoker = "No"  and 
claim > (select avg(claim) from insurance_data where smoker = "No" ) and 
bmi > (select avg(bmi) from insurance_data where children >=1);
-------------------------------------------------------------------------------------------------------------------------------------------------
#How many patients have claimed more than the average claim amount for patients who have a BMI greater than the average BMI for patients
# who are diabetic, have at least one child, and are from the southwest region?
select count(PatientID) from insurance_data
where claim >
(select avg (claim) from insurance_data 
where bmi >
(select avg(bmi) from insurance_data where diabetic = "Yes" and children >=1 and region = "southwest"));
-------------------------------------------------------------------------------------------------------------------------------------------------
#What is the difference in the average claim amount between patients who are smokers and patients who are non-smokers, 
#and have the same BMI and number of children?

with smoker_cte as (select bmi,children,avg(claim) as avg_claim from insurance_data 
where smoker = 'Yes'
group by bmi,children
),
non_smoker_cte as (select bmi,children,avg(claim) as avg_claim from insurance_data
where smoker ="No" group by bmi,children
),
above_avg as (select s.bmi,s.children,round(abs(s.avg_claim - n.avg_claim),2)as diff_in_claim
from smoker_cte s
join non_smoker_cte n
on s.bmi = n.bmi
and s.children =n.children
)
select * from 
above_avg;

# second way to solve this problem
select bmi,children,
avg(case when smoker ="Yes" then claim end) as avg_claim_smoker,
avg(case when smoker ="No" then claim end) as avg_non_smoker,
avg(case when smoker ="Yes" then claim end) - avg(case when smoker ="No" then claim end) as diff_in_claim
from insurance_data
group by bmi,children;



