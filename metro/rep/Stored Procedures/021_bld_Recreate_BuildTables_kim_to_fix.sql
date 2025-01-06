
CREATE PROCEDURE [rep].[021_bld_Recreate_BuildTables_kim_to_fix] @table_name VARCHAR(255) = NULL
AS
BEGIN
    /*
    Developed by:            metro
    Description:             (Re)Create tables in the [stg_bld] schema based on the [bld] schema

    Change log:
    Date                    Author              Description
    20220916 20:15          K. Vermeij          Initial version
    */
    DECLARE @LogProcName VARCHAR(255) = '[bld].[021_bld_Recreate_BuildTables]'
    DECLARE @LogSQL VARCHAR(255)
    DECLARE @SrcSchema VARCHAR(255) = 'bld'
    DECLARE @TgtSchema VARCHAR(255) = 'bld'
    DECLARE @CounterNr INT
    DECLARE @MaxNr INT
    DECLARE @sqlDrop NVARCHAR(MAX)
    DECLARE @sqlCreate NVARCHAR(MAX)
    DECLARE @TableName VARCHAR(255)
    DECLARE @Msg VARCHAR(255)
    DECLARE @ColumnList NVARCHAR(MAX)
    DECLARE @src_table_name VARCHAR(255)
    DECLARE @tgt_table_name VARCHAR(255)

    BEGIN TRY
        -- Drop temporary table if it exists
        IF OBJECT_ID('tempdb..#BuildTables') IS NOT NULL
            DROP TABLE #BuildTables;

        -- Create temporary table with row numbers
        ;WITH base AS (
            SELECT 
                table_catalog = t.[TABLE_CATALOG],
                src_table_schema = t.[TABLE_SCHEMA],
                src_table_name = t.[TABLE_NAME],
                src_table_type = t.[TABLE_TYPE],
                tgt_table_name = rep.[GetNamePart](REPLACE(t.[TABLE_NAME], 'tr_', ''), 2),
                RowNum = ROW_NUMBER() OVER (
                    PARTITION BY rep.[GetNamePart](REPLACE(t.[TABLE_NAME], 'tr_', ''), 2) 
                    ORDER BY t.[TABLE_NAME]
                )
            FROM [INFORMATION_SCHEMA].[TABLES] t
            WHERE 1 = 1
                AND TABLE_TYPE = 'VIEW'
                AND LEFT(t.[TABLE_NAME], 3) = 'tr_'
                AND t.TABLE_SCHEMA = @SrcSchema
				AND (@table_name is null OR rep.[GetNamePart](REPLACE(t.[TABLE_NAME], 'tr_', ''), 2) = @table_name)
        )
        SELECT *,
            ProcessSequence = ROW_NUMBER() OVER (ORDER BY tgt_table_name)
        INTO #BuildTables
        FROM base
        WHERE RowNum = 1

        -- Initialize loop variables
        SELECT @CounterNr = MIN(ProcessSequence),
               @MaxNr = MAX(ProcessSequence)
        FROM #BuildTables

        -- Define the table creation template
        DECLARE @TableTemplate NVARCHAR(MAX) = '
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.[TABLES] WHERE table_schema = ''{TgtSchema}'' AND table_name = ''{tgt_table_name}'' AND TABLE_TYPE = ''BASE TABLE'')
        BEGIN
            DROP TABLE [{TgtSchema}].[{tgt_table_name}];
        END

        CREATE TABLE [{TgtSchema}].[{tgt_table_name}] (
            [{tgt_table_name}Id] INT IDENTITY (1,1) NOT NULL,
            {ColumnList},
            [mta_Createdate] [datetime2](7) DEFAULT (GETDATE()),
            [mta_RecType] SMALLINT DEFAULT(1),
            [mta_BK] CHAR(255),
            [mta_BKH] CHAR(128),
            [mta_RH] CHAR(128),
            [mta_Source] VARCHAR(255)
        ) ON [PRIMARY];

        CREATE UNIQUE INDEX Uix_{TgtSchema}_{tgt_table_name}
        ON [{TgtSchema}].[{tgt_table_name}] ([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);

        CREATE CLUSTERED INDEX Cix_{TgtSchema}_{tgt_table_name}
        ON [{TgtSchema}].[{tgt_table_name}] ([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);
        '

        -- Loop through each row in the temporary table
        WHILE @CounterNr IS NOT NULL AND @CounterNr <= @MaxNr
        BEGIN
            -- Get the current table name
            SELECT @src_table_name = src_table_name,
                   @tgt_table_name = tgt_table_name
            FROM #BuildTables
            WHERE ProcessSequence = @CounterNr

            -- Generate the column list with transformations
            SELECT @ColumnList = STRING_AGG('[' + c.[COLUMN_NAME] + '] VARCHAR(' + CASE 
                WHEN c.[COLUMN_NAME] LIKE '%desc' OR c.[COLUMN_NAME] LIKE '%expression' OR c.[COLUMN_NAME] LIKE '%script' OR c.[COLUMN_NAME] LIKE '%RecordSrcDate' OR c.[COLUMN_NAME] LIKE '%BusinessDate' OR c.[COLUMN_NAME] LIKE '%value' or c.[COLUMN_NAME] = 'view_defintion' THEN 'MAX'
                ELSE '255'
                END + ') NULL', ', ')
            FROM INFORMATION_SCHEMA.COLUMNS c
            WHERE c.TABLE_SCHEMA = @SrcSchema
              AND c.TABLE_NAME = @src_table_name
              AND LEFT(c.[COLUMN_NAME], 3) != 'mta'

            -- Replace placeholders in the table template
            SET @sqlCreate = REPLACE(REPLACE(REPLACE(REPLACE(
                @TableTemplate,
                '{TgtSchema}', @TgtSchema),
                '{tgt_table_name}', @tgt_table_name),
                '{ColumnList}', @ColumnList),
                '{GeneratedAt}', CONVERT(VARCHAR, GETDATE(), 120)
            )

            -- Execute the table creation script
            PRINT @sqlCreate
            EXEC sp_executesql @sqlCreate

            -- Move to the next row
            SET @CounterNr = @CounterNr + 1
        END

        -- Log the procedure execution
        SET @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

        EXEC [aud].[proc_Log_Procedure] 
            @LogAction = 'INFO',
            @LogNote = '(Re)Created tables in the [stg_bld] schema based on the [bld] schema',
            @LogProcedure = @LogProcName,
            @LogSQL = @LogSQL,
            @LogRowCount = @MaxNr
    END TRY

    BEGIN CATCH
        -- Handle errors
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END