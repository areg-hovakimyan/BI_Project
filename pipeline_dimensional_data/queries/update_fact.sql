-- Parameters
DECLARE @database_name NVARCHAR(50) = 'ORDER_DDS';
DECLARE @schema_name NVARCHAR(50) = 'dbo';
DECLARE @table_name NVARCHAR(50) = 'FactOrders';
DECLARE @start_date DATE = '2024-01-01';
DECLARE @end_date DATE = '2024-12-31';

-- Dynamic SQL query
DECLARE @sql NVARCHAR(MAX);

SET @sql = '
INSERT INTO [' + @database_name + '].[' + @schema_name + '].[' + @table_name + '] (
    OrderID,
    CustomerKey,
    EmployeeKey,
    ProductKey,
    OrderDate,
    ShippedDate,
    ShipperKey,
    Quantity,
    UnitPrice,
    Discount
)
SELECT
    so.OrderID,
    dc.CustomerKey,
    de.EmployeeKey,
    dp.ProductKey,
    so.OrderDate,
    so.ShippedDate,
    ds.ShipperKey,
    od.Quantity,
    od.UnitPrice,
    od.Discount
FROM
    [' + @database_name + '].[' + @schema_name + '].[Staging_Orders] so
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[Staging_OrderDetails] od
    ON so.OrderID = od.OrderID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimCustomers] dc
    ON so.CustomerID = dc.CustomerID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimEmployees] de
    ON so.EmployeeID = de.EmployeeID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimProducts] dp
    ON od.ProductID = dp.ProductID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimRegion] dr
    ON so.TerritoryID = dr.RegionID
LEFT JOIN [' + @database_name + '].[' + @schema_name + '].[DimShippers] ds
    ON so.ShipVia = ds.ShipperID
WHERE
    so.OrderDate BETWEEN @start_date AND @end_date
    AND dc.CustomerKey IS NOT NULL
    AND de.EmployeeKey IS NOT NULL
    AND dp.ProductKey IS NOT NULL
    AND dr.RegionKey IS NOT NULL
    AND ds.ShipperKey IS NOT NULL;
';

-- Execute the dynamic SQL
EXEC sp_executesql @sql, N'@start_date DATE, @end_date DATE', @start_date, @end_date;
