USE ORDER_DDS;
GO

-- Merge data from Staging_Territories into DimTerritories
MERGE INTO DimTerritories AS TARGET
USING (
    SELECT 
        staging_raw_id,
        TerritoryID,
        TerritoryDescription,
        RegionID
    FROM Staging_Territories
) AS SOURCE
ON TARGET.TerritoryID = SOURCE.TerritoryID
WHEN MATCHED THEN
    UPDATE SET
        TARGET.TerritoryDescription = SOURCE.TerritoryDescription,
        TARGET.RegionID = SOURCE.RegionID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (TerritoryID, TerritoryDescription, RegionID, SORKey)
    VALUES (SOURCE.TerritoryID, SOURCE.TerritoryDescription, SOURCE.RegionID, SOURCE.staging_raw_id);

