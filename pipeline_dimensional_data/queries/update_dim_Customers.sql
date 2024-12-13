USE ORDER_DDS;
GO

-- Merge data from Staging_Customers into DimCustomers
MERGE INTO DimCustomers AS TARGET
USING (
    SELECT 
        staging_raw_id,
        CustomerID,
        CompanyName,
        ContactName,
        ContactTitle,
        Address,
        City,
        Region,
        PostalCode,
        Country,
        Phone,
        Fax
    FROM Staging_Customers
) AS SOURCE
ON TARGET.CustomerID = SOURCE.CustomerID
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
        TARGET.Fax = SOURCE.Fax
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, SORKey)
    VALUES (SOURCE.CustomerID, SOURCE.CompanyName, SOURCE.ContactName, SOURCE.ContactTitle, SOURCE.Address, SOURCE.City, SOURCE.Region, SOURCE.PostalCode, SOURCE.Country, SOURCE.Phone, SOURCE.Fax, SOURCE.staging_raw_id);

