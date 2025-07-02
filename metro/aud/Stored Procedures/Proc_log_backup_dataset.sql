
create PROC [aud].[Proc_log_backup_dataset]
    @SCHEMA_NAME NVARCHAR(128),
    @TABLE_NAME NVARCHAR(128)
AS
/***************************************************************************************************
Procedure:       [aud].[Proc_log_backup_dataset]

Description:
This stored procedure creates a timestamped backup of any table in the specified schema.
The backup is written to the `[bck]` schema using a `CREATE TABLE AS SELECT` (CTAS)
statement with `HEAP` and `DISTRIBUTION = ROUND_ROBIN`, which ensures broad compatibility
and performance on Synapse SQL pools.

Backup table name format:
    [bck].[yyyyMMdd_HHmmss__schema__table]

Example:
    EXEC [aud].[Proc_log_backup_dataset] @SCHEMA_NAME = 'stg', @TABLE_NAME = 'appel_kim';
    --> Creates: [bck].[20250613_115412__stg__appel_kim]

Parameters:                Type            Description
------------------------------------------------------------------------------------------
@SCHEMA_NAME               NVARCHAR(128)   The schema name of the source table.
@TABLE_NAME                NVARCHAR(128)   The name of the source table.

Steps and Execution Flow:
1. Generate current timestamp in `yyyyMMdd_HHmmss` format.
2. Construct full name for backup target using the timestamp and table details.
3. Build a CTAS (CREATE TABLE AS SELECT) SQL statement using `HEAP` and `ROUND_ROBIN`.
4. Execute the dynamic SQL to perform the backup.
5. Print the SQL and confirmation for traceability.

***************************************************************************************************/
BEGIN
    SET NOCOUNT ON;

    DECLARE @SOURCE_DATASET NVARCHAR(MAX);
    DECLARE @BACKUP_DATASET NVARCHAR(MAX);
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @DATETIME_SUFFIX NVARCHAR(32);

    -- Generate timestamp suffix for uniqueness
    SET @DATETIME_SUFFIX = FORMAT(SYSDATETIME(), 'yyyyMMdd_HHmmss');

    -- Construct source and backup table names
    SET @SOURCE_DATASET = QUOTENAME(@SCHEMA_NAME) + '.' + QUOTENAME(@TABLE_NAME);
    SET @BACKUP_DATASET = '[bck].[' + @DATETIME_SUFFIX + '__' + @SCHEMA_NAME + '__' + @TABLE_NAME + ']';

    -- Build CTAS with HEAP and ROUND_ROBIN
    SET @SQL = '
        CREATE TABLE ' + @BACKUP_DATASET + '
        WITH (
            HEAP,
            DISTRIBUTION = ROUND_ROBIN
        )
        AS
        SELECT * FROM ' + @SOURCE_DATASET + ';
    ';

    -- Print and execute
    PRINT '🔄 SQL for backup:';
    PRINT @SQL;

    EXEC sp_executesql @SQL;

    PRINT '✅ Backup succesvol aangemaakt: ' + @BACKUP_DATASET;
END;