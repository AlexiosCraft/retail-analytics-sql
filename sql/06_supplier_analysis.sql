-- Supplier sales performance

-- Supplier revenue, gross profit, margin and returns
select supplier, count(distinct product_no) as sku_count,
sum(case when is_return = 0 then qty_sold else 0 end) as gross_units_sold,
sum(case when is_return = 1 then -qty_sold else 0 end) as returned_units,
round(sum(case when is_return = 1 then -qty_sold else 0 end)* 100.0/nullif(sum(case when is_return = 0 then qty_sold else 0 end),0), 2) as unit_return_rate,
sum(sales_amount) as net_revenue,
sum(sales_amount - cogs) as gross_profit,
round(sum(sales_amount - cogs) * 100.0 /nullif(sum(sales_amount), 0),2) as margin_pct
from retail_sales
group by supplier
order by net_revenue desc;
