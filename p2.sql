--SQL Retail Sales Analysis - P1
create database sql_project_p2;


--Create Table 
drop table if exists retail_sales;
create table retail_sales (
transactions_id INT primary key,
sale_date DATE,
sale_time TIME, 
customer_id	int,
gender varchar(15),
age	int,
category varchar(15),
quantity	int, 
price_per_unit float,	
cogs float,
total_sale float
);

select * from retail_sales
LIMIT 10

select 
	count (*)
from retail_sales

--
select * from retail_sales
where transactions_id is null

select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null

select * from retail_sales
where 
	transactions_id is null
	OR 
	sale_date is null
	OR 
	sale_time is null 
	OR 
	gender is null
	OR 
	category is null
	OR 
	quantity is null
	OR 
	cogs is null
	OR 
	total_sale is null; 

delete from retail_sales
where 
	 transactions_id is null
	OR 
	sale_date is null
	OR 
	sale_time is null 
	OR 
	gender is null
	OR 
	category is null
	OR 
	quantity is null
	OR 
	cogs is null
	OR 
	total_sale is null; 

--Data exploration 

--How much sales do we have?
select count(*) as total_sale from retail_sales 
select count(distinct customer_id) from retail_sales
select distinct category from retail_sales

--Q1 review all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05'; 

--Q2 all the transactions where the category is 'Clothing' and the quantity is >10 
--in the month of Nov-2022

select *
from retail_sales
where 
	category = 'Clothing'
	and 
	to_char(sale_date,'YYYY-MM') = '2022-11'
	and 
	quantity >= 4; 
	
--Q3 total_sale for each category 
select  
	category,
	sum(total_sale) as net_sale, 
	count(*) as total_orders
from retail_sales 
group by 1

--Q4 avg. age of customer from 'beauty'
select 
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'
	
--Q5 
select *
from retail_sales
where 	total_sale > 1000 

--Q6
select 
	category, 
	gender, 
	count (*) as total_trans
from retail_sales 
group by category, gender
order by 1

--Q7 Write a SQL query to calculate the average sale for each month. Find out 
--best selling month in each year:
select 
	 year, 
	 month, 
	 avg_sale
from 
(
select 
	extract (year from sale_date) as year, 
	extract (month from sale_date) as month, 
	avg(total_sale) as avg_sale,
	RANK() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales  
group by 1, 2
) as t1 
where rank = 1 
-- order by 1,  3 desc

--Q8 **Write a SQL query to find the top 5 customers based on the highest total sales **:
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales 
group by 1
order by 2 desc 
limit 5

--Q9 Write a SQL query to find the number of unique customers who purchased items from each category.:
select 
	category,
	count(distinct customer_id)
from retail_sales  
group by 1

--Q10 Write a SQL query to create each shift and number of orders
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sale
as
(
select *,
	case 
		when extract(hour from sale_time)<12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)

select 
	 shift, 
	 count(*) as total_orders
from hourly_sale
group by shift


