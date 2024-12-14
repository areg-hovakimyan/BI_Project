DECLARE @DimTable NVARCHAR(255) = 'DimCategories';
DECLARE @StagingTable NVARCHAR(255) = 'Staging_Categories';
DECLARE @KeyColumn NVARCHAR(255) = 'CategoryID';
DECLARE @Columns NVARCHAR(MAX) = 'CategoryName, Description';

DECLARE @SQL NVARCHAR(MAX);

SET @SQL = '
MERGE dbo.' + @DimTable + ' AS DST 
USING dbo.' + @StagingTable + ' AS SRC
ON (SRC.' + @KeyColumn + ' = DST.' + @KeyColumn + ')
WHEN NOT MATCHED THEN
    INSERT (' + @KeyColumn + ', ' + @Columns + ')
    VALUES (SRC.' + @KeyColumn + ', SRC.CategoryName, SRC.Description)
WHEN MATCHED AND (ISNULL(DST.CategoryName, '''') <> ISNULL(SRC.CategoryName, '''')
                   OR ISNULL(DST.Description, '''') <> ISNULL(SRC.Description, ''''))
    THEN
        UPDATE SET
            DST.CategoryName = SRC.CategoryName,
            DST.Description = SRC.Description;';

EXEC sp_executesql @SQL;
