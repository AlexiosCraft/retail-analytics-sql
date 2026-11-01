-- Inventory composition, unsold stock and stock cover

-- Stock cover by SKU and store
with s1 as (select product_no, store, sum(qty_sold) as sum_sale
from retail_sales
where is_return = 0
group by product_no, store),
s2 as (select min(transaction_date), max(transaction_date),
    max(transaction_date) - min(transaction_date) + 1 as period_days
from retail_sales)
select retail_inventory.product_no, retail_inventory.store, qty_on_hand, round(sum_sale/period_days*30,2) as avg_sale,
case when sum_sale is null or sum_sale = 0 then null else round(qty_on_hand / (sum_sale / period_days * 30),2)
end as stock_cover_months
from retail_inventory
left join s1 on s1.product_no=retail_inventory.product_no and retail_inventory.store = s1.store
cross join s2
where end_date = '9999-12-31';

-- Inventory cost by SKU ABC group
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
s3 as (select product_no, sum(qty_on_hand) as sum_stock, sum(cost_of_stocks) as sum_cost_stock
from retail_inventory
where end_date = '9999-12-31'
group by product_no),
s4 as (select s3.product_no, sum_stock, sum_cost_stock, ABC, sum(sum_cost_stock) over() as total_sum_stock
from s3
left join s2 on s3.product_no=s2.product_no)
select ABC, sum(sum_stock) as summstock, sum(sum_cost_stock) as summ_cost_stock, max(total_sum_stock) as total_summ_stock,
round(sum(sum_cost_stock)*100.0/max(total_sum_stock),2) as pr_of_sumtotal_stock
from s4
group by ABC
order by pr_of_sumtotal_stock desc;

-- Unsold local stock — summary
with s1 as (select product_no, store, sum(qty_sold) as gross_qty
from retail_sales
where is_return = 0
group by product_no, store),
s2 as (select i.product_no, i.store, i.qty_on_hand, i.cost_of_stocks, i.start_date, date '2026-04-24' - i.start_date as stock_age_days
from retail_inventory i
where i.end_date = '9999-12-31' and i.qty_on_hand > 0),
s3 as (select s2.*, coalesce(s1.gross_qty, 0) as gross_qty
from s2
left join s1 on s2.product_no = s1.product_no and s2.store = s1.store)
select count(*) as inventory_records, count(distinct product_no) as sku_count, count(distinct (product_no, store)) as sku_store_pairs, sum(qty_on_hand) as total_units, sum(cost_of_stocks) as total_stock_cost, min(stock_age_days) as min_stock_age, max(stock_age_days) as max_stock_age,
count(*) filter (where stock_age_days > 300) as records_over_300_days,
sum(cost_of_stocks) filter (where stock_age_days > 300) as cost_over_300_days
from s3
where gross_qty = 0;
