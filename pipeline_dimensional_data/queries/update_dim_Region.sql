USE ORDER_DDS;
GO

-- Merge data from Staging_Region into DimRegion
MERGE INTO DimRegion AS TARGET
USING (
    SELECT 
        staging_raw_id,
        RegionID,
        RegionDescription
    FROM Staging_Region
) AS SOURCE
ON TARGET.RegionID = SOURCE.RegionID
WHEN MATCHED THEN
    UPDATE SET
        TARGET.RegionDescription = SOURCE.RegionDescription
WHEN NOT MATCHED BY TARGET THEN
    INSERT (RegionID, RegionDescription, SORKey)
    VALUES (SOURCE.RegionID, SOURCE.RegionDescription, SOURCE.staging_raw_id);

