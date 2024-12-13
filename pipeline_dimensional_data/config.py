# Database configuration
DATABASE_NAME = "ORDER_DDS"
SCHEMA_NAME = "dbo"

# Table names
STAGING_TABLES = {
    "Categories": "dbo.Categories",
    "Customers": "dbo.Customers",
    "Employees": "dbo.Employees",
    "OrderDetails": "dbo.Order Details",
    "Orders": "dbo.Orders",
    "Products": "dbo.Products",
    "Region": "dbo.Region",
    "Shippers": "dbo.Shippers",
    "Suppliers": "dbo.Suppliers",
    "Territories": "dbo.Territories",
}

DIMENSION_TABLES = {
    "Categories": "DimCategories",
    "Customers": "DimCustomers",
    "Employees": "DimEmployees",
    "Products": "DimProducts",
    "Region": "DimRegion",
    "Shippers": "DimShippers",
    "Suppliers": "DimSuppliers",
    "Territories": "DimTerritories",
}

FACT_TABLES = {
    "Orders": "FactOrders"
}

# Logging configuration
LOG_FILE_PATH = "logs/logs_dimensional_data_pipeline.txt"

# Default pipeline parameters
DEFAULT_START_DATE = "2024-01-01"
DEFAULT_END_DATE = "2024-12-31"
