CREATE VIEW gold.dim_products AS
SELECT
ROW_NUMBER() OVER(ORDER BY PN.prd_start_dt,PN.prd_key) AS product_key,
PN.prd_id AS product_id,
PN.prd_key as product_number,
PN.prd_nm as product_name,
PN.cat_id as category_id,
PC.CAT as category,
PC.SUBCAT as subcategory,
PC.MAINTENANCE as maintenance,
PN.prd_cost as cost,
PN.prd_line as product_line,
PN.prd_start_dt as start_date
FROM SILVER.crm_prd_info PN
LEFT JOIN SILVER.ERP_PX_CAT_G1V2 PC
ON PN.cat_id=PC.ID
WHERE prd_end_dt IS NULL


SELECT*
FROM GOLD.dim_products





CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num as order_number,
pr.product_key ,
cu.CUSTOMER_KEY as customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_dare,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price price
FROM SILVER.crm_sales_details sd
left join GOLD.dim_products pr
on sd.sls_prd_key=pr.product_number
left join GOLD.dim_customers cu
on sd.sls_cust_id=cu.CUSTOMER_ID

