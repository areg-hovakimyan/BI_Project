USE ORDER_DDS;
GO

-- Merge data from Staging_Shippers into DimShippers
MERGE INTO DimShippers AS TARGET
USING (
    SELECT 
        staging_raw_id,
        ShipperID,
        CompanyName,
        Phone
    FROM Staging_Shippers
) AS SOURCE
ON TARGET.ShipperID = SOURCE.ShipperID
WHEN MATCHED THEN
    UPDATE SET
        TARGET.CompanyName = SOURCE.CompanyName,
        TARGET.Phone = SOURCE.Phone
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ShipperID, CompanyName, Phone, SORKey)
    VALUES (SOURCE.ShipperID, SOURCE.CompanyName, SOURCE.Phone, SOURCE.staging_raw_id);

