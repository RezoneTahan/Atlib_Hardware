-- 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
SELECT distinct market FROM gdb023.dim_customer
where customer = "Atliq Exclusive" and region ="APAC";

-- 2. What is the percentage of unique product increase in 2021 vs. 2020? 
-- The final output contains these fields, unique_products_2020 unique_products_2021 percentage_chg
with cte1 as
(SELECT count(distinct product_code) as uniqe_product_count_2020 FROM fact_sales_monthly 
where fiscal_year = 2020),

cte2 as
(SELECT count(distinct product_code) as uniqe_product_count_2021 FROM fact_sales_monthly 
where fiscal_year = 2021),

cte3 as
(select * from cte1 cross join cte2)

select *, round(((uniqe_product_count_2021 - uniqe_product_count_2020)/uniqe_product_count_2020)*100, 1) as Pct_chng
from cte3;

-- 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 
-- The final output contains 2 fields, segment, product_count

select segment, count(product_code) as product_count
from dim_product
group by segment
order by product_count desc;

-- Get the products that have the highest and lowest manufacturing costs.
-- The final output should contain these fields, product_code, product, manufacturing_cost

select a.product_code, a.product, b.manufacturing_cost
from dim_product a
join fact_manufacturing_cost b on a.product_code = b.product_code
where manufacturing_cost = (select max(manufacturing_cost) from fact_manufacturing_cost)
union
select a.product_code, a.product, b.manufacturing_cost
from dim_product a
join fact_manufacturing_cost b on a.product_code = b.product_code
where manufacturing_cost = (select min(manufacturing_cost) from fact_manufacturing_cost);