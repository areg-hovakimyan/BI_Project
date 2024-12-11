-- Create staging tables for each source table with staging_raw_id (IDENTITY)

-- Categories Table
CREATE TABLE dbo.Staging_Categories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX),
    Picture VARBINARY(MAX)
);

-- Customers Table
CREATE TABLE dbo.Staging_Customers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(5),
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

-- Employees Table
CREATE TABLE dbo.Staging_Employees (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
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
    ReportsTo INT
);

-- Order Details Table
CREATE TABLE dbo.Staging_OrderDetails (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10,2),
    Quantity SMALLINT,
    Discount FLOAT
);

-- Orders Table
CREATE TABLE dbo.Staging_Orders (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerID NVARCHAR(5),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight DECIMAL(10,2),
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(255),
    ShipCity NVARCHAR(255),
    ShipRegion NVARCHAR(255),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(255),
    TerritoryID INT
);

-- Products Table
CREATE TABLE dbo.Staging_Products (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(255),
    UnitPrice DECIMAL(10,2),
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);

-- Region Table
CREATE TABLE dbo.Staging_Region (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(255)
);

-- Shippers Table
CREATE TABLE dbo.Staging_Shippers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(255)
);

-- Suppliers Table
CREATE TABLE dbo.Staging_Suppliers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
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
    HomePage NVARCHAR(MAX)
);

-- Territories Table
CREATE TABLE dbo.Staging_Territories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(255),
    RegionID INT
);
