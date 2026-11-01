-- ABC analysis of products and suppliers

-- SKU ABC classification — summary
with s1 as (select product_no, product_description, product_division, sum(sales_amount) as summ
from retail_sales
group by product_no, product_description, product_division),
s2 as (select product_no, product_description, product_division, summ,sum(summ) over(), round(summ*100.0/sum(summ) over(),2) as pr_am,
round(sum(summ) over(order by summ desc,product_no)*100/sum(summ) over(),2) as sm_pr_am,
case
	when sum(summ) over(order by summ desc,product_no)*100/sum(summ) over() <=80 then 'A'
	when sum(summ) over(order by summ desc,product_no)*100/sum(summ) over() >95 then 'C'
	else 'B' end as ABC
from s1),
s3 as (select ABC, count(product_no) as cnt, sum(summ) as revenue
from s2
group by ABC)
select ABC, cnt, round(cnt*100.0/sum(cnt) over (),2) as pr_cnt, revenue, round(revenue * 100.0 / sum(revenue) over(), 2) as revenue_share
from S3
order by ABC;

-- Supplier ABC classification — detail
with s1 as (select supplier, count(distinct product_no) as sku_count, sum(case when is_return = 0 then qty_sold else 0 end) as gross_units_sold, sum(case when is_return = 1 then -qty_sold else 0 end) as returned_units, round(sum(case when is_return = 1 then -qty_sold else 0 end) * 100.0 / nullif(sum(case when is_return = 0 then qty_sold else 0 end),0),2) as unit_return_rate, sum(sales_amount) as net_revenue, sum(sales_amount - cogs) as gross_profit, round(sum(sales_amount - cogs) * 100.0 / nullif(sum(sales_amount), 0), 2) as margin_pct
from retail_sales
group by supplier),
s2 as (select supplier, sku_count, gross_units_sold, returned_units, unit_return_rate, net_revenue, gross_profit, margin_pct, sum(net_revenue) over() as total_revenue, round(net_revenue * 100.0 / sum(net_revenue) over(), 2) as pr_am, round(sum(net_revenue) over(order by net_revenue desc, supplier) * 100.0 / sum(net_revenue) over(), 2) as sm_pr_am, case when sum(net_revenue) over(order by net_revenue desc, supplier) * 100.0 / sum(net_revenue) over() <= 80 then 'A' when sum(net_revenue) over(order by net_revenue desc, supplier) * 100.0 / sum(net_revenue) over() > 95 then 'C' else 'B' end as ABC
from s1)
select *
from s2
order by net_revenue desc;
