-- update_fact.sql
-- This script inserts data into the FactOrders table using INSERT-based ingestion.

-- Parameters
DECLARE @database_name NVARCHAR(50) = 'ORDER_DDS';
DECLARE @schema_name NVARCHAR(50) = 'dbo';
DECLARE @table_name NVARCHAR(50) = 'FactOrders';
DECLARE @start_date DATE = '2024-01-01';
DECLARE @end_date DATE = '2024-12-31';

-- Insert new rows into FactOrders
INSERT INTO [@database_name].[@schema_name].[@table_name] (
    OrderID,
    Customer_SKey,
    Employee_SKey,
    Product_SKey,
    OrderDate,
    ShipDate,
    Region_SKey,
    Shipper_SKey,
    Quantity,
    TotalAmount
)
SELECT
    sr.OrderID,
    dc.Customer_SKey,
    de.Employee_SKey,
    dp.Product_SKey,
    sr.OrderDate,
    sr.ShipDate,
    dr.Region_SKey,
    ds.Shipper_SKey,
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
    AND dc.Customer_SKey IS NOT NULL
    AND de.Employee_SKey IS NOT NULL
    AND dp.Product_SKey IS NOT NULL
    AND dr.Region_SKey IS NOT NULL
    AND ds.Shipper_SKey IS NOT NULL;
