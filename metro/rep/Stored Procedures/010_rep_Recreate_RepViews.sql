﻿
CREATE PROCEDURE [rep].[010_rep_Recreate_RepViews] AS
BEGIN
    /*
    Developed by:            metro
    Description:             (Re)Create views on the [stg_rep] tables with meta columns: 
                             - mta_BK        (Stores the Businesskey of the table)
                             - mta_BKH       (Stores the hash of the Businesskey of the table)
                             - mta_RH        (Stores the hash of the full row)
                             - mta_RowNum    actually only needed for the view [rep].[vw_XlsTabsToLoad] so i could make an easy loop in this procedure

    Change log:
    Date                    Author              Description
    20220915 00:00          K. Vermeij          Initial version
    */

	DECLARE @LogProcName VARCHAR(MAX) = '[rep].[010_rep_Recreate_RepViews]'
	DECLARE @LogSQL VARCHAR(MAX)
	DECLARE @SrcSchema VARCHAR(MAX) = 'rep'
	DECLARE @TgtSchema VARCHAR(MAX) = 'rep'
	DECLARE @CounterNr INT
	DECLARE @MaxNr INT
	DECLARE @sqlDrop NVARCHAR(MAX)
	DECLARE @sqlCreate NVARCHAR(MAX)
	DECLARE @TableName NVARCHAR(MAX)
	DECLARE @Msg NVARCHAR(MAX)
	DECLARE @ColumnList NVARCHAR(MAX)
	DECLARE @ColumnHashList NVARCHAR(MAX)

    BEGIN TRY
    -- Drop temporary table if it exists
    IF OBJECT_ID('tempdb..#XlsTabsToLoad') IS NOT NULL
        DROP TABLE #XlsTabsToLoad

    -- Create temporary table with row numbers
    SELECT TableName as Table_Name, BK,
           ROW_NUMBER() OVER (ORDER BY [BK] ASC) AS mta_RowNum
    INTO #XlsTabsToLoad
    FROM rep.XlsTabsToLoad
    WHERE BK IS NOT NULL
	

    -- Initialize loop variables
    SELECT @CounterNr = MIN(mta_RowNum),
           @MaxNr = MAX(mta_RowNum)
    FROM #XlsTabsToLoad

    -- Define the view creation template
    DECLARE @ViewTemplate NVARCHAR(MAX) = '
    CREATE OR ALTER VIEW [{TgtSchema}].[vw_{TableName}] AS
    /*
    View is generated by  : metro
    Generated at          : {GeneratedAt}
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        {ColumnList},
        -- Meta data columns:
        mta_RowNum     = ROW_NUMBER() OVER (ORDER BY [BK] ASC),
        mta_BK         = UPPER(ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(500)))),''-'')),
        mta_BKH        = CONVERT(CHAR(64), HASHBYTES(''SHA2_512'', UPPER(ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(500)))),''-''))), 2),
        mta_RH         = CONVERT(CHAR(64), HASHBYTES(''SHA2_512'', UPPER({ColumnHashList})), 2)
    FROM [{SrcSchema}].[{TableName}]
    WHERE 1=1 and 1=1
      AND ISNULL(Active,''1'') = ''1''
      AND ISNULL(LTRIM(RTRIM([BK])),'''') != ''''
    '

    -- Loop through each row in the temporary table
    WHILE @CounterNr <= @MaxNr
    BEGIN
        -- Get the current table name
        SELECT @TableName = Table_Name
        FROM #XlsTabsToLoad
        WHERE mta_RowNum = @CounterNr

        -- Generate the column list with transformations
        SELECT @ColumnList = STRING_AGG('LTRIM(RTRIM(CAST([' + c.[COLUMN_NAME] + '] as varchar(' + case 
				when c.[COLUMN_NAME] like '%desc'
					or c.[COLUMN_NAME] like '%expression'
					or c.[COLUMN_NAME] like '%script'
					or c.[COLUMN_NAME] like '%RecordSrcDate'
					or c.[COLUMN_NAME] like '%BusinessDate'
					or c.[COLUMN_NAME] like '%value'
					then 'max'
				else '255'
				end + ')))) as [' + c.[COLUMN_NAME] + ']', ', ')
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE TABLE_SCHEMA = @SrcSchema
          AND TABLE_NAME = @TableName

        -- Generate the column hash list
        SELECT @ColumnHashList = STRING_AGG('ISNULL(LTRIM(RTRIM(CAST([' + COLUMN_NAME + '] AS VARCHAR(' + CASE 
            WHEN COLUMN_NAME LIKE '%desc' OR COLUMN_NAME LIKE '%script' THEN '8000'
            ELSE '255'
            END + ')))),''-'')', ' + ''|'' + ')
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @SrcSchema
          AND TABLE_NAME = @TableName

        -- Replace placeholders in the view template
        SET @sqlCreate = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( 
											@ViewTemplate
											, '{SrcSchema}' ,@SrcSchema)
											, '{TgtSchema}', @TgtSchema)
											, '{TableName}', @TableName)
											, '{ColumnList}', @ColumnList)
											, '{ColumnHashList}', @ColumnHashList)
											, '{GeneratedAt}', CONVERT(NVARCHAR, GETDATE(), 120)
											)

        
		-- Create the new view
            DECLARE @PrintMsg NVARCHAR(MAX) = @sqlCreate
            WHILE LEN(@PrintMsg) > 0
            BEGIN
                PRINT LEFT(@PrintMsg, 4000)
                SET @PrintMsg = SUBSTRING(@PrintMsg, 4001, LEN(@PrintMsg))
            END
        EXEC sp_executesql @sqlCreate

        -- Move to the next row
        SET @CounterNr = @CounterNr + 1
    END
	 -- Log the procedure execution
        SET @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

        EXEC [aud].[proc_Log_Procedure] 
            @LogAction = 'INFO',
            @LogNote = '(Re)Created views on the [stg_rep] tables with meta columns',
            @LogProcedure = @LogProcName,
            @LogSQL = @LogSQL,
            @LogRowCount = @MaxNr
    END TRY

       
    BEGIN CATCH
        -- Handle errors
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END