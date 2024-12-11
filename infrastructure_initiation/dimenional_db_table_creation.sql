-- Create a new database named ORDER_DDS
CREATE DATABASE ORDER_DDS;
GO

-- Verify that the database was created
USE ORDER_DDS;
GO

-- Check database properties to ensure it's active
SELECT name, database_id, create_date
FROM sys.databases
WHERE name = 'ORDER_DDS';
GO