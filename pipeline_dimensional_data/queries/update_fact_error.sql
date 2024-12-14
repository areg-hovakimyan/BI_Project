-- Parameters
DECLARE @database_name NVARCHAR(50) = 'ORDER_DDS';
DECLARE @schema_name NVARCHAR(50) = 'dbo';
DECLARE @table_name NVARCHAR(50) = 'FactOrders_Error';
DECLARE @start_date DATE = '2024-01-01';
DECLARE @end_date DATE = '2024-12-31';

-- Dynamic SQL query
DECLARE @sql NVARCHAR(MAX);

SET @sql = '
INSERT INTO [' + @database_name + '].[' + @schema_name + '].[' + @table_name + '] (
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
        WHEN dc.CustomerKey IS NULL THEN ''Customer_NKey''
        WHEN de.EmployeeKey IS NULL THEN ''Employee_NKey''
        WHEN dp.ProductKey IS NULL THEN ''Product_NKey''
        WHEN dr.RegionKey IS NULL THEN ''Region_NKey''
        WHEN ds.ShipperKey IS NULL THEN ''Shipper_NKey''
    END AS MissingKeyType,
    sr.staging_raw_id AS StagingRawID,
    sr.OrderDate,
    sr.ShippedDate AS ShipDate,
    od.Quantity,
    od.UnitPrice * od.Quantity * (1 - od.Discount) AS TotalAmount
FROM
    [' + @database_name + '].[' + @schema_name + '].[Staging_Orders] sr
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[Staging_OrderDetails] od
    ON sr.OrderID = od.OrderID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimCustomers] dc
    ON sr.CustomerID = dc.CustomerID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimEmployees] de
    ON sr.EmployeeID = de.EmployeeID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimProducts] dp
    ON od.ProductID = dp.ProductID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimRegion] dr
    ON sr.TerritoryID = dr.RegionID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimShippers] ds
    ON sr.ShipVia = ds.ShipperID
WHERE
    sr.OrderDate BETWEEN @start_date AND @end_date
    AND (
        dc.CustomerKey IS NULL
        OR de.EmployeeKey IS NULL
        OR dp.ProductKey IS NULL
        OR dr.RegionKey IS NULL
        OR ds.ShipperKey IS NULL
    );
';

-- Execute the dynamic SQL
EXEC sp_executesql @sql, N'@start_date DATE, @end_date DATE', @start_date, @end_date;
