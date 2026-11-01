-- Returns by product, category and store

-- Unit return rate by product category
select product_category,
sum(case when is_return=0 then qty_sold else 0 end) as sold_qty,
sum(case when is_return=1 then -qty_sold else 0 end) as returned_qty,
round(sum(case when is_return=1 then -qty_sold else 0 end)*100.0/sum(case when is_return=0 then qty_sold else 0 end),2) as return_rate
from retail_sales
group by product_category
order by return_rate desc;

-- Unit return rate by store
select store,
sum(case when is_return=0 then qty_sold else 0 end),
sum(case when is_return=1 then -qty_sold else 0 end),
round(sum(case when is_return=1 then -qty_sold else 0 end)*100.0/sum(case when is_return=0 then qty_sold else 0 end),2) as return_rate
from retail_sales
group by store
order by return_rate desc;

-- Unit return rate by store and product division
select store, product_division,
sum(case when is_return=0 then qty_sold else 0 end) as sold_qty,
sum(case when is_return=1 then -qty_sold else 0 end) as returned_qty,
round(sum(case when is_return=1 then -qty_sold else 0 end)*100.0/nullif(sum(case when is_return=0 then qty_sold else 0 end),0),2) as return_rate
from retail_sales
group by store, product_division
having sum(case when is_return=0 then qty_sold else 0 end) > 100
order by return_rate desc;

-- Unit return rate by SKU
select product_no, product_description,
sum(case when is_return=0 then qty_sold else 0 end) as sold_qty,
sum(case when is_return=1 then -qty_sold else 0 end) as returned_qty,
round(sum(case when is_return=1 then -qty_sold else 0 end)*100.0/nullif(sum(case when is_return=0 then qty_sold else 0 end),0),2) as return_rate
from retail_sales
group by product_no, product_description
having sum(case when is_return=0 then qty_sold else 0 end) > 0
order by return_rate desc;

-- Unit and revenue return rates by product division
select product_division, sum(case when is_return = 0 then qty_sold else 0 end) as gross_units_sold,
sum(case when is_return = 1 then -qty_sold else 0 end) as returned_units,
round(sum(case when is_return = 1 then -qty_sold else 0 end) * 100.0/nullif( sum(case when is_return = 0 then qty_sold else 0 end),0),2) as unit_return_rate,
sum(case when is_return = 0 then sales_amount else 0 end) as gross_revenue,
sum(case when is_return = 1 then -sales_amount else 0 end) as returned_revenue,
round(sum(case when is_return = 1 then -sales_amount else 0 end) * 100.0/nullif(sum(case when is_return = 0 then sales_amount else 0 end),0),2) as revenue_return_rate
from retail_sales
group by product_division
order by unit_return_rate desc;
