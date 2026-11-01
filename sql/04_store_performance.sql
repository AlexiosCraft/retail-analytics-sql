-- Store revenue, gross profit and margins

-- Store ranking and profitability
select store, sum(sales_amount), sum(sales_amount-cogs), round(sum(sales_amount-cogs)*100.0/sum(sales_amount),2) as marjin,
sum(case when is_return=0 then qty_sold else qty_sold * 0 end) as qnty, rank() over (order by sum(sales_amount) desc) as rank
from retail_sales
group by store
order by rank;

-- Store margin versus division-wide weighted margin
with s1 as (select store, product_division, sum(sales_amount) as net_revenue,
sum(sales_amount - cogs) as gross_profit, sum(case when is_return = 0 then qty_sold else 0 end) as gross_units_sold,
sum(case when is_return = 1 then -qty_sold else 0 end) as returned_units
from retail_sales
group by store, product_division),
s2 as (select *, round(gross_profit * 100.0/nullif(net_revenue, 0),2) as margin_pct,
round(returned_units * 100.0/nullif(gross_units_sold,0),2) as unit_return_rate,
round(sum(gross_profit) over (partition by product_division*100.0/nullif(sum(net_revenue) over (partition by product_division),0),2) as division_margin_pct
from s1)
select store, product_division, net_revenue, gross_profit, margin_pct, division_margin_pct, round( margin_pct - division_margin_pct, 2) as margin_gap_pp, gross_units_sold, returned_units, unit_return_rate
from s2
order by store, product_division;
