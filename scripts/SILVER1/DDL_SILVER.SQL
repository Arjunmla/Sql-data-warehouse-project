/*
===============================================================
 Script: Create Silver Tables

 Script Purpose:
   This script creates tables in the 'silver' schema, dropping
   existing tables if they already exist.
   Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================
*/

---------------------------------------------------------------
-- CRM CUSTOMER INFO
---------------------------------------------------------------
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cid                 INT,
    cst_key             NVARCHAR(50),
    cst_fname           NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO

---------------------------------------------------------------
-- CRM PRODUCT INFO
---------------------------------------------------------------
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nam         NVARCHAR(50),
    prd_cost        INT,
    prd_ctgyline    NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

---------------------------------------------------------------
-- CRM SALES DETAILS 
---------------------------------------------------------------
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_id             INT,
    sls_key            NVARCHAR(50),
    sls_cat_key        NVARCHAR(50),
    sls_amt            INT,
    sls_discount       INT,
    sls_tax            INT,
    sls_country        NVARCHAR(50),
    sls_date           DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

---------------------------------------------------------------
-- ERP CUSTOMER A2LZ
---------------------------------------------------------------
IF OBJECT_ID('silver.erp_cust_a2lz', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_a2lz;
GO

CREATE TABLE silver.erp_cust_a2lz (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

---------------------------------------------------------------
-- ERP PRODUCT CATEGORY GLV2
---------------------------------------------------------------
IF OBJECT_ID('silver.erp_px_cat_glv2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_glv2;
GO

CREATE TABLE silver.erp_px_cat_glv2 (
    id              NVARCHAR(50),
    nam             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

---------------------------------------------------------------
-- CRM SALES DETAILS
---------------------------------------------------------------
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num      NVARCHAR(50),
    sls_ord_key      NVARCHAR(50),
    sls_cust_id      INT,
    sls_order_dt     DATE,
    sls_ship_dt      DATE,
    sls_due_dt       DATE,
    sls_sales        INT,
    sls_quantity     INT,
    sls_price        INT,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

---------------------------------------------------------------
-- ERP LOCATION A101
---------------------------------------------------------------
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid              NVARCHAR(50),
    cnty             NVARCHAR(50),
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO
