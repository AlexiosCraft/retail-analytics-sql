-- Revenue, profitability and monthly sales trends

-- Net revenue by product category
select product_category, sum(sales_amount)
from retail_sales
group by product_category
order by sum(sales_amount) desc
limit 10;

-- Gross profit and gross margin by product division
select product_division, sum(sales_amount), sum(cogs),sum(sales_amount)-sum(cogs) as gross_profit,
(sum(sales_amount)-sum(cogs))*100.00/sum(sales_amount) as gross_margin
from retail_sales
group by product_division
order by gross_profit desc;

-- Monthly net revenue and month-over-month change
with s1 as (select date_trunc('month', transaction_date) as month, sum(sales_amount) as month_amount
from retail_sales
group by date_trunc('month', transaction_date))
select month, month_amount, lag(month_amount) over (order by month),
(month_amount- lag(month_amount) over (order by month))*100.00/lag(month_amount) over (order by month) as revenue_change_pct
from s1
order by month;

-- November–December revenue growth contribution by product division
with s1 as (select product_division, sum(case when transaction_date >= date '2025-11-01' and transaction_date < date '2025-12-01' then sales_amount else 0 end) as november_revenue,
sum(case when transaction_date >= date '2025-12-01' and transaction_date < date '2026-01-01' then sales_amount else 0 end) as december_revenue
from retail_sales
where transaction_date >= date '2025-11-01' and transaction_date < date '2026-01-01'
group by product_division),
s2 as (select *, december_revenue - november_revenue as absolute_growth, round((december_revenue - november_revenue) * 100.0/nullif(november_revenue,0),2) as growth_pct
from s1)
select *, round(absolute_growth * 100.0/nullif(sum(absolute_growth) over (),0),2) as contribution_to_total_growth
from s2
order by absolute_growth desc;
