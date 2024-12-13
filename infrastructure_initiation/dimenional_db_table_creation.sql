USE ORDER_DDS;
GO

-- Dim_SOR Table
IF OBJECT_ID('dbo.Dim_SOR', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_SOR;
CREATE TABLE dbo.Dim_SOR (
    SORKey INT IDENTITY(1,1) PRIMARY KEY,
    StagingTableName NVARCHAR(255) NOT NULL,
    TablePrimaryKeyColumn NVARCHAR(255) NOT NULL
);

-- DimCategories Table
IF OBJECT_ID('dbo.DimCategories', 'U') IS NOT NULL
    DROP TABLE dbo.DimCategories;
CREATE TABLE dbo.DimCategories (
    CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    CategoryID INT NOT NULL,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

-- DimCustomers Table
IF OBJECT_ID('dbo.DimCustomers', 'U') IS NOT NULL
    DROP TABLE dbo.DimCustomers;
CREATE TABLE dbo.DimCustomers (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    CustomerID NVARCHAR(5) NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    Phone NVARCHAR(255),
    Fax NVARCHAR(255)
);

-- DimEmployees Table
IF OBJECT_ID('dbo.DimEmployees', 'U') IS NOT NULL
    DROP TABLE dbo.DimEmployees;
CREATE TABLE dbo.DimEmployees (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    EmployeeID INT NOT NULL,
    LastName NVARCHAR(255),
    FirstName NVARCHAR(255),
    Title NVARCHAR(255),
    TitleOfCourtesy NVARCHAR(255),
    BirthDate DATETIME,
    HireDate DATETIME,
    Address NVARCHAR(255),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    HomePhone NVARCHAR(255),
    Extension NVARCHAR(10),
    Photo VARBINARY(MAX),
    Notes NVARCHAR(MAX),
    ReportsTo INT FOREIGN KEY REFERENCES dbo.DimEmployees(EmployeeKey),
    IsDeleted BIT
);

-- DimProducts Table
IF OBJECT_ID('dbo.DimProducts', 'U') IS NOT NULL
    DROP TABLE dbo.DimProducts;
CREATE TABLE dbo.DimProducts (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    ProductID INT NOT NULL,
    ProductName NVARCHAR(255),
    SupplierID INT FOREIGN KEY REFERENCES dbo.DimSuppliers(SupplierKey),
    CategoryID INT FOREIGN KEY REFERENCES dbo.DimCategories(CategoryKey),
    QuantityPerUnit NVARCHAR(255),
    UnitPrice DECIMAL(10,2),
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);

-- DimRegion Table
IF OBJECT_ID('dbo.DimRegion', 'U') IS NOT NULL
    DROP TABLE dbo.DimRegion;
CREATE TABLE dbo.DimRegion (
    RegionKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    RegionID INT NOT NULL,
    RegionDescription NVARCHAR(255),
    PreviousRegionDescription NVARCHAR(255)
);

-- HistoricalRegion Table
IF OBJECT_ID('dbo.HistoricalRegion', 'U') IS NOT NULL
    DROP TABLE dbo.HistoricalRegion;
CREATE TABLE dbo.HistoricalRegion (
    HistoricalRegionKey INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT NOT NULL,
    RegionDescription NVARCHAR(255),
    EffectiveDate DATETIME NOT NULL,
    ExpirationDate DATETIME NULL,
    FOREIGN KEY (RegionID) REFERENCES dbo.DimRegion(RegionID)
);

-- DimShippers Table
IF OBJECT_ID('dbo.DimShippers', 'U') IS NOT NULL
    DROP TABLE dbo.DimShippers;
CREATE TABLE dbo.DimShippers (
    ShipperKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    ShipperID INT NOT NULL,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(255),
    IsDeleted BIT
);

-- DimSuppliers Table
IF OBJECT_ID('dbo.DimSuppliers', 'U') IS NOT NULL
    DROP TABLE dbo.DimSuppliers;
CREATE TABLE dbo.DimSuppliers (
    SupplierKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    SupplierID INT NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(255),
    Phone NVARCHAR(255),
    Fax NVARCHAR(255),
    HomePage NVARCHAR(MAX),
    CurrentRegion NVARCHAR(255),
    PreviousRegion NVARCHAR(255)
);

-- DimTerritories Table
IF OBJECT_ID('dbo.DimTerritories', 'U') IS NOT NULL
    DROP TABLE dbo.DimTerritories;
CREATE TABLE dbo.DimTerritories (
    TerritoryKey INT IDENTITY(1,1) PRIMARY KEY,
    SORKey INT FOREIGN KEY REFERENCES dbo.Dim_SOR(SORKey),
    TerritoryID NVARCHAR(20) NOT NULL,
    TerritoryDescription NVARCHAR(255),
    RegionID INT FOREIGN KEY REFERENCES dbo.DimRegion(RegionKey),
    PreviousTerritoryDescription NVARCHAR(255)
);

-- HistoricalTerritories Table
IF OBJECT_ID('dbo.HistoricalTerritories', 'U') IS NOT NULL
    DROP TABLE dbo.HistoricalTerritories;
CREATE TABLE dbo.HistoricalTerritories (
    HistoricalTerritoryKey INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20) NOT NULL,
    TerritoryDescription NVARCHAR(255),
    RegionID INT,
    EffectiveDate DATETIME NOT NULL,
    ExpirationDate DATETIME NULL,
    FOREIGN KEY (RegionID) REFERENCES dbo.DimRegion(RegionID) 
);

-- FactOrders Table
IF OBJECT_ID('dbo.FactOrders', 'U') IS NOT NULL
    DROP TABLE dbo.FactOrders;
CREATE TABLE dbo.FactOrders (
    FactOrderKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    CustomerKey INT FOREIGN KEY REFERENCES dbo.DimCustomers(CustomerKey),
    EmployeeKey INT FOREIGN KEY REFERENCES dbo.DimEmployees(EmployeeKey),
    ProductKey INT FOREIGN KEY REFERENCES dbo.DimProducts(ProductKey),
    ShipperKey INT FOREIGN KEY REFERENCES dbo.DimShippers(ShipperKey),
    TerritoryKey INT FOREIGN KEY REFERENCES dbo.DimTerritories(TerritoryKey),
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    Freight DECIMAL(10,2),
    Quantity SMALLINT,
    UnitPrice DECIMAL(10,2),
    Discount FLOAT,
    TotalAmount AS (Quantity * UnitPrice * (1 - Discount)) PERSISTED
);

-- Insert Into Dim_SOR Table
IF OBJECT_ID('dbo.Dim_SOR', 'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.Dim_SOR (StagingTableName, TablePrimaryKeyColumn)
    VALUES
        ('Staging_Categories', 'CategoryKey'),
        ('Staging_Customers', 'CustomerKey'),
        ('Staging_Employees', 'EmployeeKey'),
        ('Staging_Products', 'ProductKey'),
        ('Staging_Region', 'RegionKey'),
        ('Staging_Shippers', 'ShipperKey'),
        ('Staging_Suppliers', 'SupplierKey'),
        ('Staging_Territories', 'TerritoryKey');
END;
