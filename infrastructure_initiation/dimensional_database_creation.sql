USE master;

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ORDER_DDS')
BEGIN
    DROP DATABASE ORDER_DDS;
    PRINT 'Database ORDER_DDS dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Database ORDER_DDS does not exist.';
END
GO



