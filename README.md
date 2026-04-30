## SQL Window Functions - Insurance Data Analysis

## Overview
Analysis of insurance dataset using advanced SQL window functions to derive business insights.

# Data Description
This dataset contains insightful information related to insurance claims, giving us an in-depth look into the demographic patterns of those receiving them. The dataset contains information on patient age, gender,
BMI (Body Mass Index), blood pressure levels, diabetic status, number of children, smoking status and region. By analyzing these key factors across geographical areas and across different demographics such as age or
gender we can gain a greater understanding of who is most likely to receive an insurance claim. This understanding gives us valuable insight that can be used to inform our decision making when considering potential
customers for our services. On a broader scale it can inform public policy by allowing for more targeted support for those who are most in need and vulnerable. These kinds of insights are extremely valuable and 
this dataset provides us with the tools we need to uncover them!
## SQL Window Functions - Insurance Data Analysis

## Dataset
- Source: Kaggle Insurance Dataset
- Records: number of rows - 1340
- Columns: list main columns -11

## SQL Techniques Used
- ROW_NUMBER() for ranking policies by premium
- RANK() and DENSE_RANK() for tiered analysis  
- LAG/LEAD for period-over-period comparisons
- Running totals using SUM() OVER()
- Moving averages using AVG() OVER()

# total number of questions solved -16

## Files
- `insurance_data_questions.sql` - All SQL queries
- `insurance_data.csv` - Raw data

## Tools
SQL (PostgreSQL/MySQL)
