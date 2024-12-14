USE [ORDER_DDS]; 
GO

DECLARE @DatabaseName NVARCHAR(128) = 'ORDER_DDS';
DECLARE @SchemaName NVARCHAR(128) = 'dbo';
DECLARE @TableName NVARCHAR(128) = 'FactOrders'; 
DECLARE @StartDate DATETIME = '2024-01-01';
DECLARE @EndDate DATETIME = '2024-12-31';

-- Dynamic SQL to accommodate flexible database, schema, and table names
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = 'MERGE INTO ' + @DatabaseName + '.' + @SchemaName + '.' + @TableName + ' AS TARGET
USING (
    SELECT 
        s.staging_raw_id,
        d.SORKey,
        s.OrderID,
        s.CustomerID,
        s.OrderDate,
        s.TotalAmount
    FROM ' + @DatabaseName + '.dbo.Staging_Orders AS s
    JOIN ' + @DatabaseName + '.dbo.Dim_SOR AS d ON s.staging_raw_id = d.staging_raw_id
    WHERE s.OrderDate BETWEEN @Start AND @End
) AS SOURCE
ON TARGET.OrderID = SOURCE.OrderID
WHEN MATCHED AND TARGET.OrderDate BETWEEN @Start AND @End THEN
    UPDATE SET
        TARGET.CustomerID = SOURCE.CustomerID,
        TARGET.OrderDate = SOURCE.OrderDate,
        TARGET.TotalAmount = SOURCE.TotalAmount
WHEN NOT MATCHED BY TARGET AND SOURCE.OrderDate BETWEEN @Start AND @End THEN
    INSERT (OrderID, CustomerID, OrderDate, TotalAmount)
    VALUES (SOURCE.OrderID, SOURCE.CustomerID, SOURCE.OrderDate, SOURCE.TotalAmount);'

-- Execute the dynamic SQL
EXEC sp_executesql @SQL, N'@Start DATETIME, @End DATETIME', @Start = @StartDate, @End = @EndDate;
