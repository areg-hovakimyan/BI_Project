USE ORDER_DDS;
GO

-- Merge data from Staging_Suppliers into DimSuppliers
MERGE INTO DimSuppliers AS TARGET
USING (
    SELECT 
        staging_raw_id,
        SupplierID,
        CompanyName,
        ContactName,
        ContactTitle,
        Address,
        City,
        Region,
        PostalCode,
        Country,
        Phone,
        Fax,
        HomePage
    FROM Staging_Suppliers
) AS SOURCE
ON TARGET.SupplierID = SOURCE.SupplierID
WHEN MATCHED THEN
    UPDATE SET
        TARGET.CompanyName = SOURCE.CompanyName,
        TARGET.ContactName = SOURCE.ContactName,
        TARGET.ContactTitle = SOURCE.ContactTitle,
        TARGET.Address = SOURCE.Address,
        TARGET.City = SOURCE.City,
        TARGET.Region = SOURCE.Region,
        TARGET.PostalCode = SOURCE.PostalCode,
        TARGET.Country = SOURCE.Country,
        TARGET.Phone = SOURCE.Phone,
        TARGET.Fax = SOURCE.Fax,
        TARGET.HomePage = SOURCE.HomePage
WHEN NOT MATCHED BY TARGET THEN
    INSERT (SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage, SORKey)
    VALUES (SOURCE.SupplierID, SOURCE.CompanyName, SOURCE.ContactName, SOURCE.ContactTitle, SOURCE.Address, SOURCE.City, SOURCE.Region, SOURCE.PostalCode, SOURCE.Country, SOURCE.Phone, SOURCE.Fax, SOURCE.HomePage, SOURCE.staging_raw_id);

