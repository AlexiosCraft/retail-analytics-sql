-- Data import, schema inspection and column preparation
-- PostgreSQL

-- NOTE: replace the original local CSV path with your own path before running.
copy retail_inventory
from 'C:\Users\Alex Craft\Desktop\Retail Transactions and Stocks Data\retail_inventory_ml_apl.csv'
delimiter ','
csv
header;

select *
from retail_inventory;

select *
from retail_sales;

select
    table_name,
    column_name,
    data_type
from information_schema.columns
where table_schema = 'project_one';

select
    "Transaction Date",
    count(*) as rows_count
from retail_sales
group by "Transaction Date"
order by "Transaction Date"
limit 20;

select
    min("Transaction Date") as first_date,
    max("Transaction Date") as last_date,
    count(distinct "Transaction Date") as days_count,
    count(*) as rows_count
from retail_sales;

alter table retail_sales
rename column "Transaction Date" to transaction_date;

alter table retail_sales
rename column "Sales Type" to sales_type;

alter table retail_sales
rename column "Is Return" to is_return;

alter table retail_sales
rename column "Reason of Return" to reason_of_return;

alter table retail_sales
rename column "Product No" to product_no;

alter table retail_sales
rename column "Product Description" to product_description;

alter table retail_sales
rename column "Product Division" to product_division;

alter table retail_sales
rename column "Product Category" to product_category;

alter table retail_sales
rename column "Product Subcategory" to product_subcategory;

alter table retail_sales
rename column "Product Segment" to product_segment;

alter table retail_sales
rename column "Sales Channel" to sales_channel;

alter table retail_sales
rename column "Qty Sold" to qty_sold;

alter table retail_sales
rename column "Sales Amount" to sales_amount;

alter table retail_sales
rename column "Number of Transactions" to number_of_transactions;

alter table retail_sales
    alter column transaction_date type date using transaction_date::date,
    alter column sales_type type varchar,
    alter column is_return type smallint using is_return::smallint,
    alter column reason_of_return type varchar,
    alter column product_no type varchar,
    alter column product_description type varchar,
    alter column product_division type varchar,
    alter column product_category type varchar,
    alter column product_subcategory type varchar,
    alter column product_segment type varchar,
    alter column sales_channel type varchar,
    alter column qty_sold type numeric using qty_sold::numeric,
    alter column sales_amount type numeric using sales_amount::numeric,
    alter column number_of_transactions type numeric using number_of_transactions::numeric,
    alter column "Cogs" type numeric using "Cogs"::numeric,
    alter column "Supplier" type varchar,
    alter column "Store" type varchar;

alter table retail_sales
    rename column "Cogs" to cogs;

alter table retail_sales
    rename column "Supplier" to supplier;

alter table retail_sales
    rename column "Store" to store;
