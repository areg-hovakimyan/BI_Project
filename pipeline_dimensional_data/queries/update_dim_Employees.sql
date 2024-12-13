USE ORDER_DDS;
GO

-- Merge data from Staging_Employees into DimEmployees
MERGE INTO DimEmployees AS TARGET
USING (
    SELECT 
        staging_raw_id,
        EmployeeID,
        LastName,
        FirstName,
        Title,
        TitleOfCourtesy,
        BirthDate,
        HireDate,
        Address,
        City,
        Region,
        PostalCode,
        Country,
        HomePhone,
        Extension,
        Photo,
        Notes,
        ReportsTo
    FROM Staging_Employees
) AS SOURCE
ON TARGET.EmployeeID = SOURCE.EmployeeID
WHEN MATCHED THEN
    UPDATE SET
        TARGET.LastName = SOURCE.LastName,
        TARGET.FirstName = SOURCE.FirstName,
        TARGET.Title = SOURCE.Title,
        TARGET.TitleOfCourtesy = SOURCE.TitleOfCourtesy,
        TARGET.BirthDate = SOURCE.BirthDate,
        TARGET.HireDate = SOURCE.HireDate,
        TARGET.Address = SOURCE.Address,
        TARGET.City = SOURCE.City,
        TARGET.Region = SOURCE.Region,
        TARGET.PostalCode = SOURCE.PostalCode,
        TARGET.Country = SOURCE.Country,
        TARGET.HomePhone = SOURCE.HomePhone,
        TARGET.Extension = SOURCE.Extension,
        TARGET.Photo = SOURCE.Photo,
        TARGET.Notes = SOURCE.Notes,
        TARGET.ReportsTo = SOURCE.ReportsTo
WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, SORKey)
    VALUES (SOURCE.EmployeeID, SOURCE.LastName, SOURCE.FirstName, SOURCE.Title, SOURCE.TitleOfCourtesy, SOURCE.BirthDate, SOURCE.HireDate, SOURCE.Address, SOURCE.City, SOURCE.Region, SOURCE.PostalCode, SOURCE.Country, SOURCE.HomePhone, SOURCE.Extension, SOURCE.Photo, SOURCE.Notes, SOURCE.ReportsTo, SOURCE.staging_raw_id);

