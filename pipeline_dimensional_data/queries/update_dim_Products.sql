USE ORDER_DDS;
GO

-- Merge data from Staging_Products into DimProducts
MERGE INTO DimProducts AS TARGET
USING (
    SELECT 
        staging_raw_id,
        ProductID,
        ProductName,
        SupplierID,
        CategoryID,
        QuantityPerUnit,
        UnitPrice,
        UnitsInStock,
        UnitsOnOrder,
        ReorderLevel,
        Discontinued
    FROM Staging_Products
) AS SOURCE
ON TARGET.ProductID = SOURCE.ProductID
WHEN MATCHED THEN
    UPDATE SET
        TARGET.ProductName = SOURCE.ProductName,
        TARGET.SupplierID = SOURCE.SupplierID,
        TARGET.CategoryID = SOURCE.CategoryID,
        TARGET.QuantityPerUnit = SOURCE.QuantityPerUnit,
        TARGET.UnitPrice = SOURCE.UnitPrice,
        TARGET.UnitsInStock = SOURCE.UnitsInStock,
        TARGET.UnitsOnOrder = SOURCE.UnitsOnOrder,
        TARGET.ReorderLevel = SOURCE.ReorderLevel,
        TARGET.Discontinued = SOURCE.Discontinued
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, SORKey)
    VALUES (SOURCE.ProductID, SOURCE.ProductName, SOURCE.SupplierID, SOURCE.CategoryID, SOURCE.QuantityPerUnit, SOURCE.UnitPrice, SOURCE.UnitsInStock, SOURCE.UnitsOnOrder, SOURCE.ReorderLevel, SOURCE.Discontinued, SOURCE.staging_raw_id);

