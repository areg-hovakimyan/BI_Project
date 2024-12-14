-- update_fact_error.sql
-- This script captures faulty rows that fail to be inserted into FactOrders due to missing/invalid keys.

-- Parameters
DECLARE @database_name NVARCHAR(50) = 'ORDER_DDS';
DECLARE @schema_name NVARCHAR(50) = 'dbo';
DECLARE @table_name NVARCHAR(50) = 'FactOrders_Error';
DECLARE @start_date DATE = '2024-01-01';
DECLARE @end_date DATE = '2024-12-31';

-- Insert faulty rows into FactOrders_Error
INSERT INTO [@database_name].[@schema_name].[@table_name] (
    OrderID,
    MissingKeyType,
    StagingRawID,
    OrderDate,
    ShipDate,
    Quantity,
    TotalAmount
)
SELECT
    sr.OrderID,
    CASE
        WHEN dc.Customer_SKey IS NULL THEN 'Customer_NKey'
        WHEN de.Employee_SKey IS NULL THEN 'Employee_NKey'
        WHEN dp.Product_SKey IS NULL THEN 'Product_NKey'
        WHEN dr.Region_SKey IS NULL THEN 'Region_NKey'
        WHEN ds.Shipper_SKey IS NULL THEN 'Shipper_NKey'
    END AS MissingKeyType,
    sr.StagingRawID,
    sr.OrderDate,
    sr.ShipDate,
    sr.Quantity,
    sr.TotalAmount
FROM
    [@database_name].[@schema_name].[staging_raw_orders] sr
LEFT JOIN [@database_name].[@schema_name].[DimCustomers] dc
    ON sr.CustomerID = dc.Customer_NKey
LEFT JOIN [@database_name].[@schema_name].[DimEmployees] de
    ON sr.EmployeeID = de.Employee_NKey
LEFT JOIN [@database_name].[@schema_name].[DimProducts] dp
    ON sr.ProductID = dp.Product_NKey
LEFT JOIN [@database_name].[@schema_name].[DimRegion] dr
    ON sr.RegionID = dr.Region_NKey
LEFT JOIN [@database_name].[@schema_name].[DimShippers] ds
    ON sr.ShipVia = ds.Shipper_NKey
WHERE
    sr.OrderDate BETWEEN @start_date AND @end_date
    AND (
        dc.Customer_SKey IS NULL
        OR de.Employee_SKey IS NULL
        OR dp.Product_SKey IS NULL
        OR dr.Region_SKey IS NULL
        OR ds.Shipper_SKey IS NULL
    );
