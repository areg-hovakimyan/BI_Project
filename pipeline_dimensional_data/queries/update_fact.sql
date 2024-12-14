USE [ORDER_DDS]; 
GO

DECLARE @DatabaseName NVARCHAR(128) = 'ORDER_DDS';
DECLARE @SchemaName NVARCHAR(128) = 'dbo';
DECLARE @TableName NVARCHAR(128) = 'FactOrders'; 
DECLARE @StartDate DATETIME = '2024-01-01';
DECLARE @EndDate DATETIME = '2024-12-31';

-- Example: Combining INSERT and MERGE functionality
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = '
-- Insert new orders
INSERT INTO ' + @DatabaseName + '.' + @SchemaName + '.' + @TableName + ' (
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
    ' + @DatabaseName + '.dbo.Staging_Orders AS so
LEFT JOIN ' + @DatabaseName + '.dbo.Staging_OrderDetails AS od
    ON so.OrderID = od.OrderID
LEFT JOIN ' + @DatabaseName + '.dbo.DimCustomers AS dc
    ON so.CustomerID = dc.CustomerID
LEFT JOIN ' + @DatabaseName + '.dbo.DimEmployees AS de
    ON so.EmployeeID = de.EmployeeID
LEFT JOIN ' + @DatabaseName + '.dbo.DimProducts AS dp
    ON od.ProductID = dp.ProductID
LEFT JOIN ' + @DatabaseName + '.dbo.DimShippers AS ds
    ON so.ShipVia = ds.ShipperID
WHERE
    so.OrderDate BETWEEN @Start AND @End;

-- Merge updates
MERGE INTO ' + @DatabaseName + '.' + @SchemaName + '.' + @TableName + ' AS TARGET
USING (
    SELECT 
        so.OrderID,
        dc.CustomerKey,
        so.OrderDate
    FROM ' + @DatabaseName + '.dbo.Staging_Orders AS so
    JOIN ' + @DatabaseName + '.dbo.DimCustomers AS dc ON so.CustomerID = dc.CustomerID
    WHERE so.OrderDate BETWEEN @Start AND @End
) AS SOURCE
ON TARGET.OrderID = SOURCE.OrderID
WHEN MATCHED THEN
    UPDATE SET
        TARGET.CustomerKey = SOURCE.CustomerKey,
        TARGET.OrderDate = SOURCE.OrderDate;
';

-- Execute the dynamic SQL
EXEC sp_executesql @SQL, N'@Start DATETIME, @End DATETIME', @Start = @StartDate, @End = @EndDate;
