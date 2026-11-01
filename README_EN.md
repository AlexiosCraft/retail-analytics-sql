# Retail Analytics — SQL Project (PostgreSQL)



## About the Project



The project focuses on analyzing sales, returns, store profitability, inventory, and suppliers in a retail chain.

**Business objective:** identify which product segments and suppliers generate revenue and gross profit, which product categories have higher return rates, how inventory is distributed, and how store performance differs.

The analysis was performed in PostgreSQL. **Analysis outcome:** business insights derived from data aggregation, segmentation, and comparison of metrics.

Project Business Tasks



1. Analyze revenue by segments and product categories, determine gross profit and margins by segment, examine monthly revenue trends and each segment's contribution to changes in revenue.
2. Assess sales concentration across products and suppliers using ABC analysis.
3. Analyze returns by segment, store, and SKU: calculate Unit Return Rate and Revenue Return Rate.
4. Compare stores by net revenue, gross profit, and gross margin, and compare store margins within segments.
5. Assess the structure of current inventory, identify negative and zero stock balances, positive stock balances with no sales at the corresponding stores, and calculate approximate Stock Cover.
6. Evaluate supplier sales metrics: product assortment, revenue, gross profit, margins, and returns.



## Data

Two tables were used:

* `retail_sales` — transactional sales and returns data, including transaction date, product, segment, category, store, supplier, quantity, revenue, and cost of goods sold.
* `retail_inventory` — interval-based inventory history.

Sales period: **June 1, 2025 — April 24, 2026**.



### Data Source and License

Dataset: Retail Transactions and Stocks Data  
Contributor: Jimmy Smith  
Source: [Mendeley Data](https://data.mendeley.com/datasets/27x8mjm8k4/1)  
DOI: `10.17632/27x8mjm8k4.1`  
License: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

The dataset description lists 40 stores, 2,326 SKUs, and three product segments. The files `retail_sales_ml_apl.csv` and `retail_inventory_ml_apl.csv` are available via the **Download All** button on the [dataset page](https://data.mendeley.com/datasets/27x8mjm8k4/1).

Key Calculation Rules

* Returns in the `qty_sold`, `sales_amount`, and `cogs` fields are already recorded as negative values.
* Net revenue — `SUM(sales_amount)`, i.e., total sales including returns.
* Gross profit — `SUM(sales_amount - cogs)`, also accounting for returns.
* Gross margin — gross profit divided by net revenue, expressed as a percentage.
* **Unit Return Rate** — number of returned units (`-qty_sold` where `is_return = 1`) divided by units sold before returns (`qty_sold` where `is_return = 0`).
* **Revenue Return Rate** — returned revenue (`-sales_amount` where `is_return = 1`) divided by revenue before returns (`sales_amount` where `is_return = 0`).
* ABC classification of SKUs and suppliers is based on net revenue. Group A covers a cumulative share of up to 80%, group B covers over 80% up to 95%, and group C covers over 95%.
* The filter `end_date = '9999-12-31'` was applied to analyze current inventory. Historical intervals were excluded from current stock calculations.
* The age of a current inventory record was calculated as the difference between the fixed date `2026-04-24` and `start_date`. This is the age of the record interval, not the verified physical age of each item.
* Stock Cover was estimated using average monthly sales over the entire observation period.



### Key Results and Business Insights



### 1. Revenue, Profitability, and Sales Trends



**Revenue and Gross Profit by Segment**

|Segment|Net Revenue|Revenue Share|Gross Profit|Gross Profit Share|Margin|
|-|-:|-:|-:|-:|-:|
|Scholar Footwear|7 338 189,45|70,0%|3 383 886,39|73,0%|46,11%|
|Femme Footwear|2 712 206,85|25,9%|1 073 341,96|23,2%|39,57%|
|Junior Apparel|431 713,95|4,1%|177 130,80|3,8%|41,03%|
|**Total**|**10 482 110,25**|**100%**|**4 634 359,15**|**100%**|**44,21%**|

Scholar Footwear is the main business segment, accounting for approximately 70% of net revenue and 73% of gross profit. Femme Footwear has the lowest gross margin among the three segments.



**Revenue by Product Category**

|Segment and Category|Net Revenue|
|-|-:|
|Scholar Footwear — Retro Legend|1 920 958,56|
|Scholar Footwear — Trailblazer|1 909 759,99|
|Femme Footwear — Trailblazer|1 238 790,65|
|Scholar Footwear — Modern Legend|1 062 646,92|
|Scholar Footwear — Flight Classic|767 298,33|
|Scholar Footwear — Court Casual|702 385,90|
|Scholar Footwear — Boot Collection|660 152,85|
|Femme Footwear — Court Casual|647 820,37|
|Femme Footwear — Boot Collection|304 630,62|
|Femme Footwear — Flight Classic|303 495,26|

The leaders in net revenue are Scholar Footwear Retro Legend (1.92 million) and Scholar Footwear Trailblazer (1.91 million). Six of the ten highest-ranking entries belong to Scholar Footwear. 



**Monthly Revenue Trends**

|Month|Net Revenue|Change vs. Previous Month|
|-|-:|-:|
|June 2025|706 683,44|—|
|July 2025|855 571,55|+21,07%|
|August 2025|1 535 117,21|+79,43%|
|September 2025|860 457,23|−43,95%|
|October 2025|821 266,08|−4,55%|
|November 2025|871 946,34|+6,17%|
|December 2025|1 785 534,95|+104,78%|
|January 2026|565 272,83|−68,34%|
|February 2026|1 038 967,86|+83,80%|
|March 2026|934 194,48|−10,08%|
|April 2026*|507 098,28|−45,72%*|

Among complete months, revenue peaked in December 2025, followed by August 2025. January 2026 had the lowest revenue among complete months. Based on less than a full year of data, it is possible to hypothesize seasonal demand for the product categories studied (seasonal sales increases in August and December, ahead of the school year and New Year).



**Segment Contributions to December Growth**

|Segment|Revenue Increase vs. November|Growth vs. November|Contribution to Total Growth|
|-|-:|-:|-:|
|Scholar Footwear|646 647,23|104,82%|70,78%|
|Femme Footwear|245 954,82|115,24%|26,92%|
|Junior Apparel|20 986,56|50,41%|2,30%|
|**Total**|**913 588,61**|**104,78%**|**100%**|

In December, revenue increased across all three segments. Scholar Footwear made the largest absolute contribution to total growth, while Femme Footwear recorded the highest relative growth rate.



### 2. ABC Analysis of Products and Suppliers



**ABC Analysis of SKUs by Net Revenue**

|Group|Number of SKUs|SKU Share|Net Revenue Share|
|-|-:|-:|-:|
|A|928|39,90%|79,99%|
|B|601|25,84%|15,00%|
|C|797|34,26%|5,01%|
|**Total**|**2 326**|**100%**|**100%**|

Approximately 40% of SKUs generate 80% of net revenue. Group C represents about one-third of the assortment but contributes only around 5% of revenue. This provides grounds to review the relevance of the product assortment.



**ABC Analysis of Suppliers by Net Revenue**

|Group|Number of Suppliers|Supplier Share|Net Revenue Share|Gross Profit Share|
|-|-:|-:|-:|-:|
|A|3|10,0%|78,20%|76,37%|
|B|4|13,3%|16,33%|18,14%|
|C|23|76,7%|5,47%|5,49%|
|**Total**|**30**|**100%**|**100%**|**100%**|

Three group A suppliers generate approximately 78.2% of net revenue and 76.4% of gross profit. Sales are highly concentrated among suppliers.



### 3. Returns



**Return Rates by Segment**

|Segment|Units Sold Before Returns|Units Returned|Unit Return Rate|Revenue Before Returns|Returned Revenue|Revenue Return Rate|
|-|-:|-:|-:|-:|-:|-:|
|Femme Footwear|28 198|2 322|8,23%|2 961 374,17|249 167,32|8,41%|
|Scholar Footwear|77 365|4 594|5,94%|7 804 335,51|466 146,06|5,97%|
|Junior Apparel|18 979|631|3,32%|449 971,58|18 257,63|4,06%|
|**Total**|**124 542**|**7 547**|**6,06%**|**11 215 681,26**|**733 571,01**|**6,54%**|

Femme Footwear has the highest return rate among segments, both by units and by revenue. Scholar Footwear has the largest absolute number of returns due to the segment's larger size.



**Returns by Subcategory and SKU**



**Five Subcategories with the Highest Unit Return Rate**

|Segment and Category|Units Sold|Units Returned|Unit Return Rate|
|-|-:|-:|-:|
|Femme Footwear — Boot Collection|2 639|318|12,05%|
|Femme Footwear — Retro Legend|929|80|8,61%|
|Scholar Footwear — Hardcourt|768|66|8,59%|
|Femme Footwear — Trailblazer|13 458|1 133|8,42%|
|Scholar Footwear — Trainer|1 002|75|7,49%|

Scholar Footwear Trailblazer leads in the absolute number of returns, with 1,303 units returned out of 21,887 sold (Unit Return Rate: 5.95%). It is followed by Femme Footwear Trailblazer, with 1,133 returns out of 13,458 sold (8.42%), and Scholar Footwear Modern Legend, with 771 returns out of 11,502 sold (6.70%). Thus, Femme Footwear Trailblazer stands out for its high return rate, while Scholar Footwear Trailblazer has the highest absolute number of returns.



**Five SKUs with the Highest Unit Return Rate**

|SKU|Segment |Units Sold|Units Returned|Unit Return Rate|
|-|-:|-:|-:|-:|
|PROD-168536|Femme Footwear — Boot Collection|27|9|33,33%|
|PROD-188435|Junior Apparel — Cozy Pullovers|10|3|30,00%|
|PROD-188445|Junior Apparel — Crew Tees|7|2|28,57%|
|PROD-168531|Femme Footwear — Boot Collection|46|13|28,26%|
|PROD-154480|Femme Footwear — Trailblazer|25|7|28,00%|

Higher return rates occur at the SKU level, but some SKUs have low sales volumes; their metrics should be interpreted in light of the number of units sold.



**Returns by Store**



**Five Stores with the Highest Unit Return Rate**

|Store|Units Sold|Units Returned|Unit Return Rate|
|-|-:|-:|-:|
|STR-1344|1 539|134|8,71%|
|STR-1369|1 621|133|8,20%|
|STR-1348|2 622|207|7,89%|
|STR-1038|2 880|224|7,78%|
|STR-1350|2 689|196|7,29%|

**Five Stores with the Lowest Unit Return Rate**

|Store|Units Sold|Units Returned|Unit Return Rate|
|-|-:|-:|-:|
|STR-1237|2 663|120|4,51%|
|STR-1255|2 568|124|4,83%|
|STR-1082|2 291|115|5,02%|
|STR-1006|5 924|305|5,15%|
|STR-1253|3 609|187|5,18%|

Overall store Unit Return Rates range from 4.51% (STR-1237) to 8.71% (STR-1344). The difference between the extremes is 4.20 percentage points.



**Returns by Store × Segment Combinations**

The comparison included combinations with more than 100 units sold before returns. The five highest values in each segment are shown below.

|Store|Segment|Units Sold|Units Returned|Unit Return Rate|
|-|-:|-:|-:|-:|
|STR-1338|Femme Footwear|436|49|11,24%|
|STR-1344|Femme Footwear|376|41|10,90%|
|STR-1348|Femme Footwear|476|51|10,71%|
|STR-1369|Femme Footwear|367|38|10,35%|
|STR-1094|Femme Footwear|940|94|10,00%|
|STR-1348|Scholar Footwear|1 566|127|8,11%|
|STR-1369|Scholar Footwear|1 254|94|7,50%|
|STR-1038|Scholar Footwear|2 192|163|7,44%|
|STR-1344|Scholar Footwear|1 162|84|7,23%|
|STR-1157|Scholar Footwear|2 018|141|6,99%|
|STR-1348|Junior Apparel|580|29|5,00%|
|STR-1157|Junior Apparel|1 041|51|4,90%|
|STR-1308|Junior Apparel|768|33|4,30%|
|STR-1222|Junior Apparel|260|10|3,85%|
|STR-1145|Junior Apparel|1 218|44|3,61%|

In this sample, elevated return rates for Femme Footwear are observed across multiple stores, not just one location.

Reasons for returns were not analyzed: the `reason_of_return` field contains no populated information that would allow returns to be classified by reason.



### 4. Store Performance and Margins



**Store Results**

|Store|Net Revenue|Gross Profit|Gross Margin|Result|
|-|-:|-:|-:|-:|
|STR-1006|485 561,44|225 775,14|46,50%|First in Revenue and Gross Profit|
|STR-1308|142 256,04|54 791,09|38,52%|Lowest Margin Among Stores|

STR-1006 ranks first in net revenue and gross profit. STR-1308 has the lowest margin among stores. The difference between the highest and lowest margins is 7.98 percentage points.



**Comparison of STR-1308 Margins with Network-Wide Weighted Average Segment Margins**

|Segment|STR-1308 Margin|Network-Wide Segment Margin|Difference|
|-|-:|-:|-:|
|Femme Footwear|32,61%|39,57%|−6,96 pp|
|Junior Apparel|33,90%|41,03%|−7,13 pp|
|Scholar Footwear|41,08%|46,11%|−5,03 pp|

STR-1308 shows substantially lower margins than the network-wide averages across all three segments. This consistent underperformance suggests possible systemic organizational issues at the store level. The store needs to be reviewed to identify the reasons for its weak performance.



### 5. Current Inventory



**Sales ABC Groups Compared with Current Inventory Value**

Each SKU was assigned an ABC group based on net revenue. The classification was then matched with current stock balances and their cost.

|SKU Group|Stock, Units|Cost of Current Inventory|Share of Inventory Value|
|-|-:|-:|-:|
|A|22 416|1 218 447,11|67,54%|
|B|7 855|448 520,56|24,86%|
|C|6 916|137 201,43|7,60%|
|**Total**|**37 187**|**1 804 169,10**|**100%**|

Most of the current inventory value is attributable to group A SKUs (67.54%). Group B accounts for 24.86% of inventory value, and group C for 7.60%. Thus, most inventory value is concentrated in products generating the largest share of net revenue, and the stock structure can be considered "healthy".



**Positive Stock Balances with No Sales at the Corresponding Store**

To identify such items, current stock balances were matched against sales of the same SKU at the same store during the analysis period.

|Metric|Value|
|-|-:|
|SKU–Store Combinations|7 852|
|Unique SKUs|1 333|
|Total Stock, Units|13 880|
|Cost of Stock|725 111,99|
|Records with Interval Age Over 300 Days|84|
|Cost of These Records|12 142,14|

There are positive stock balances for 7,852 SKU–store combinations, but no sales of those SKUs were recorded at the corresponding stores during the analysis period. These balances total 13,880 units with a cost of 725 111,99. This warrants reviewing product allocation across stores and assessing product liquidity at the store level. Of these items, 84 have a current stock age exceeding 300 days; their cost totals 12 142,14.



**Stock Cover**

Stock Cover was calculated at the SKU–store level by dividing current stock by average monthly sales before returns. Average monthly sales were estimated over the entire observation period, from June 1, 2025 to April 24, 2026, using a 30-day month.

|SKU|Store|Current Stock, Units|Average Monthly Sales, Units|Stock Cover, Months|
|-|-:|-:|-:|-:|
|PROD-100449|STR-1219|1|0,91|1,09|
|PROD-184554|STR-1308|1|0,64|1,56|
|PROD-100799|STR-1074|6|0,37|16,40|
|PROD-149700|STR-1305|5|0,09|54,67|
|PROD-100810|STR-1237|6|0,09|65,60|

The examples above show individual SKU–store combinations from the query results.

Some items have extremely high Stock Cover extending several years into the future, resulting from infrequent single-unit sales. Further review of these items is recommended; the operating model could be reconsidered, with delivery against specific customer orders instead of maintaining stock.



### 6. Supplier Sales Performance



The analysis is based on sales of products associated with suppliers in the `retail_sales` table.



**Largest Suppliers by Net Revenue**

|Supplier|SKU|Units Sold Before Returns|Units Returned|Unit Return Rate|Net Revenue|Gross Profit|Margin|
|-|-:|-:|-:|-:|-:|-:|-:|
|Vendor 0166|716|40 935|2 536|6,20%|3 290 375,40|1 385 196,16|42,10%|
|Vendor 0134|391|26 134|1 567|6,00%|3 204 043,60|1 412 364,67|44,08%|
|Vendor 0169|309|19 345|1 360|7,03%|1 703 035,19|741 930,46|43,57%|
|Vendor 0246|24|5 062|313|6,18%|537 752,65|295 653,43|54,98%|
|Vendor 0010|134|7 190|476|6,62%|490 924,49|202 693,65|41,29%|
|Vendor 0064|85|4 040|437|10,82%|423 710,82|215 626,32|50,89%|

Vendor 0166 leads in net revenue, while Vendor 0134 generates the highest gross profit among suppliers. Among the major suppliers shown, Vendor 0064 combines a high margin (50.89%) with an elevated Unit Return Rate (10.82%). This supplier requires further review.



## Overall Business Conclusions



1. **Scholar Footwear generates most of the revenue and gross profit.** The segment accounts for 70.0% of net revenue and 73.0% of gross profit. Among complete months, revenue was highest in December 2025; Scholar Footwear contributed 70.78% of the increase over November.
2. **Sales are concentrated in part of the assortment and among a few suppliers.** Group A contains 39.90% of SKUs and generates 79.99% of net revenue. Three group A suppliers account for 78.20% of net revenue and 76.37% of gross profit.
3. **Femme Footwear has the highest return rate.** The segment's Unit Return Rate is 8.23%, and its Revenue Return Rate is 8.41%. Femme Footwear Boot Collection stands out among product categories with a Unit Return Rate of 12.05%; Scholar Footwear Trailblazer leads in absolute returns with 1,303 units.
4. **STR-1308 requires further margin analysis.** The store has the lowest overall margin (38.52%) and trails network-wide metrics in all three segments. STR-1006 ranks first in net revenue and gross profit.
5. **Significant positive stock balances with no sales at the corresponding stores were identified.** Their cost totals 725 111,99 for 13,880 units. Product allocation across stores needs to be reviewed. Some SKU–store combinations also have very high estimated Stock Cover, warranting a review of assortment relevance.
6. **Supplier performance varies in revenue, profit, and returns.** Vendor 0166 leads in net revenue, while Vendor 0134 leads in gross profit. Among the suppliers shown, Vendor 0064 combines a 50.89% margin with a 10.82% Unit Return Rate, warranting further review.



## Recommendations



* Examine Femme Footwear return rates in detail, particularly Boot Collection and Trailblazer, as well as SKUs with high absolute numbers of returns.
* Investigate the factors behind low margins at STR-1308 and individual stores within Femme Footwear and Junior Apparel.
* Assess opportunities to redistribute products with positive stock balances and no local sales between stores.
* Review Vendor 0064's performance separately and consider revenue concentration risks associated with the three largest suppliers when analyzing commercial results.



## SQL Techniques Used



* Data loading and preparation: `ALTER TABLE`, `RENAME COLUMN`, changing column data types.
* Data selection and filtering: `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `GROUP BY`, `HAVING`.
* Aggregate functions: `SUM`, `COUNT`, `AVG`, `MIN`, `MAX`.
* Conditional calculations: `CASE WHEN`.
* CTEs (`WITH`) for breaking complex queries into stages.
* Joining data: `JOIN`, `LEFT JOIN`, `CROSS JOIN`.
* Window functions: `SUM() OVER()`, `LAG()`, `RANK()`.
* Working with dates and time series: `DATE_TRUNC`.
* Handling division by zero: `NULLIF`.
* Calculating relative metrics: margins, MoM growth, Unit Return Rate, Revenue Return Rate, shares, and cumulative ABC shares.
* XYZ analysis was tested experimentally using monthly SKU sales. The query used thresholds of X — up to 10%, Y — up to 25%, and Z — above 25%; the result was not included in the main business conclusions because a substantial share of SKUs fell into group Z, and some products had insufficient observations.

