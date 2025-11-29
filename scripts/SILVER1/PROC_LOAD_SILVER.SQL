CREATE OR ALTER PROCEDURE SILVER.load_silver 
AS
BEGIN

    -------------------------------------------------------
    -- 1. CRM CUSTOMER INFO
    -------------------------------------------------------
    PRINT '>> Truncating Table: SILVER.crm_cust_info';
    TRUNCATE TABLE SILVER.crm_cust_info;

    PRINT '>> Inserting Data Into: SILVER.crm_cust_info';
    INSERT INTO SILVER.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_material_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE
            WHEN UPPER(TRIM(CST_MATERIAL_STATUS)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(CST_MATERIAL_STATUS)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END,
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM BRONZE.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE flag_last = 1;



    -------------------------------------------------------
    -- 2. CRM PRODUCT INFO
    -------------------------------------------------------
    PRINT '>> Truncating Table: SILVER.crm_prd_info';
    TRUNCATE TABLE SILVER.crm_prd_info;

    PRINT '>> Inserting Data Into: SILVER.crm_prd_info';
    INSERT INTO SILVER.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
        SUBSTRING(prd_key, 7, LEN(prd_key)),
        prd_nm,
        ISNULL(prd_cost, 0),
        CASE UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'n/a'
        END,
        CAST(prd_start_dt AS DATE),
        CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE)
    FROM BRONZE.crm_prd_info;



    -------------------------------------------------------
    -- 3. CRM SALES DETAILS
    -------------------------------------------------------
    PRINT '>> Truncating Table: SILVER.crm_sales_details';
    TRUNCATE TABLE SILVER.crm_sales_details;

    PRINT '>> Inserting Data Into: SILVER.crm_sales_details';
    INSERT INTO SILVER.crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
             ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END,
        CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
             ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END,
        CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
             ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END,
        CASE
            WHEN sls_sales IS NULL
              OR sls_sales <= 0
              OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END,
        sls_quantity,
        CASE
            WHEN sls_price IS NULL OR sls_price = 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END
    FROM BRONZE.crm_sales_details;



    -------------------------------------------------------
    -- 4. ERP_LOC_CUST_AZ12
    -------------------------------------------------------
    PRINT '>> Truncating Table: SILVER.ERP_LOC_CUST_AZ12';
    TRUNCATE TABLE SILVER.ERP_LOC_CUST_AZ12;

    PRINT '>> Inserting Data Into: SILVER.ERP_LOC_CUST_AZ12';
    INSERT INTO SILVER.ERP_LOC_CUST_AZ12 (cid, bdate, gen)
    SELECT
        CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
             ELSE CID
        END,
        CASE WHEN BDATE > GETDATE() THEN NULL
             ELSE BDATE
        END,
        CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
             WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
             ELSE 'n/a'
        END
    FROM BRONZE.ERP_LOC_CUST_AZ12;



    -------------------------------------------------------
    -- 5. ERP_LOC_A101
    -------------------------------------------------------
    PRINT '>> Truncating Table: SILVER.ERP_LOC_A101';
    TRUNCATE TABLE SILVER.ERP_LOC_A101;

    PRINT '>> Inserting Data Into: SILVER.ERP_LOC_A101';
    INSERT INTO SILVER.ERP_LOC_A101 (CID, CNTRY)
    SELECT
        REPLACE(cid, '-', ''),
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END
    FROM BRONZE.ERP_LOC_A101;



    -------------------------------------------------------
    -- 6. ERP_PX_CAT_G1V2
    -------------------------------------------------------
    PRINT '>> Truncating Table: SILVER.ERP_PX_CAT_G1V2';
    TRUNCATE TABLE SILVER.ERP_PX_CAT_G1V2;

    PRINT '>> Inserting Data Into: SILVER.ERP_PX_CAT_G1V2';
    INSERT INTO SILVER.ERP_PX_CAT_G1V2 (ID, CAT, SUBCAT, MAINTENANCE)
    SELECT
        ID,
        CAT,
        SUBCAT,
        MAINTENANCE
    FROM BRONZE.ERP_PX_CAT_G1V2;

END;
GO
