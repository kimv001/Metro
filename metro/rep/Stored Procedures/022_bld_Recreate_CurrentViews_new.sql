
CREATE PROCEDURE [rep].[022_bld_Recreate_CurrentViews_new] @table_name VARCHAR(255) = NULL
AS
BEGIN
    /*
    Developed by:            metro
    Description:             (Re)Create views for the current records on the [bld] tables

    Change log:
    Date                    Author              Description
    20220916 20:15          K. Vermeij          Initial version
    */
    DECLARE @LogProcName VARCHAR(255) = '[rep].[022_bld_Recreate_CurrentViews]'
    DECLARE @LogSQL VARCHAR(255)
    DECLARE @SrcSchema VARCHAR(255) = 'bld'
    DECLARE @TgtSchema VARCHAR(255) = 'bld'
    DECLARE @CounterNr INT
    DECLARE @MaxNr INT
    DECLARE @sqlCreate NVARCHAR(MAX)
    DECLARE @TableName VARCHAR(255)
    DECLARE @Msg VARCHAR(255)
    DECLARE @src_table_name VARCHAR(255)
    DECLARE @tgt_table_name VARCHAR(255)

    BEGIN TRY
        -- Drop temporary table if it exists
        IF OBJECT_ID('tempdb..#BuildCurrentViews') IS NOT NULL
            DROP TABLE #BuildCurrentViews;

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
                AND (@table_name IS NULL OR rep.[GetNamePart](REPLACE(t.[TABLE_NAME], 'tr_', ''), 2) = @table_name)
        )
        SELECT * ,
            ProcessSequence = ROW_NUMBER() OVER (ORDER BY tgt_table_name)
        INTO #BuildCurrentViews
        FROM base
        WHERE RowNum = 1

        -- Initialize loop variables
        SELECT @CounterNr = MIN(ProcessSequence),
               @MaxNr = MAX(ProcessSequence)
        FROM #BuildCurrentViews

        -- Define the view creation template
        DECLARE @ViewTemplate NVARCHAR(MAX) = '
        CREATE OR ALTER VIEW [{TgtSchema}].[{tgt_table_name}_Current] AS
        SELECT * 
        FROM [{SrcSchema}].[{tgt_table_name}]
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1
         + char(10) + char(9) + ''-- Add "Deleted" indicator, the current view shows the latest record even if deleted. This gives the opportunity to delete records in the [bld] schema'' + char(10) + char(9) + '',[mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH]'' + char(10) + char(9) + '', mta_IsDeleted = iif([mta_RecType]=-1,1,0)'' + char(10) + ''From Cur'' + char(10) + ''Where [mta_CurrentFlag] = 1 and [mta_RecType]>-1'' + char(10)
        '

        -- Loop through each row in the temporary table
        WHILE @CounterNr IS NOT NULL AND @CounterNr <= @MaxNr
        BEGIN
            -- Get the current table name
            SELECT @src_table_name = src_table_name,
                   @tgt_table_name = tgt_table_name
            FROM #BuildCurrentViews
            WHERE ProcessSequence = @CounterNr

            -- Replace placeholders in the view template
            SET @sqlCreate = REPLACE(REPLACE(REPLACE(
                @ViewTemplate,
                '{TgtSchema}', @TgtSchema),
                '{tgt_table_name}', @tgt_table_name),
                '{SrcSchema}', @SrcSchema
            )

            -- Execute the view creation script
            PRINT @sqlCreate
            EXEC sp_executesql @sqlCreate

            -- Move to the next row
            SET @CounterNr = @CounterNr + 1
        END

        -- Log the procedure execution
        SET @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

        EXEC [aud].[proc_Log_Procedure] 
            @LogAction = 'INFO',
            @LogNote = '(Re)Created views for the current records on the [bld] tables',
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