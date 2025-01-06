﻿
CREATE PROCEDURE [rep].[022_bld_recreate_currentviews] @tgt_table_name varchar(255) = NULL AS BEGIN /*
    Developed by:            metro
    Description:             (Re)Create views on the [bld] tables with meta columns:
                             - mta_BK        (Stores the Businesskey of the table)
                             - mta_BKH       (Stores the hash of the Businesskey of the table)
                             - mta_RH        (Stores the hash of the full row)
                             - mta_RowNum    actually only needed for the view [bld].[vw_XlsTabsToLoad] so i could make an easy loop in this procedure

	examples:
	exec  [rep].[022_bld_Recreate_CurrentViews]

	exec  [rep].[022_bld_Recreate_CurrentViews] @tgt_table_name = 'Schema'

    Change log:
    Date                    Author              Description
    20220915 00:00          K. Vermeij          Initial version
    */ DECLARE @logprocname varchar(MAX) = '[bld].[022_bld_Recreate_CurrentViews]' DECLARE @logsql varchar(MAX) DECLARE @srcschema varchar(MAX) = 'bld' DECLARE @tgtschema varchar(MAX) = 'bld' DECLARE @counternr INT DECLARE @maxnr INT DECLARE @sqldrop nvarchar(MAX) DECLARE @sqlcreate nvarchar(MAX) DECLARE @tablename varchar(MAX) DECLARE @msg varchar(MAX) DECLARE @columnlist nvarchar(MAX) DECLARE @columnhashlist nvarchar(MAX) BEGIN try IF object_id('tempdb..#BuildCurrentViews') IS NOT NULL
DROP TABLE #buildcurrentviews; WITH base AS

        (SELECT table_catalog = t.[table_catalog],

               src_table_schema = t.[table_schema],

               src_table_name = t.[table_name],

               src_table_type = t.[table_type],

               tgt_table_name = rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2), RowNum = row_number() OVER (PARTITION BY rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2)
                                                                                                                 ORDER BY t.[table_name])

          FROM [information_schema].[tables] t

         WHERE 1 = 1

           AND table_type = 'VIEW'

           AND left(t.[table_name], 3) = 'tr_'

           AND t.table_schema = @srcschema and(rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2) = @tgt_table_name
                                         OR @tgt_table_name IS NULL)
       )
SELECT *,

       processsequence = row_number() OVER (
                                            ORDER BY tgt_table_name) INTO #buildcurrentviews

  FROM base

 WHERE RowNum = 1
  SELECT @counternr = min(processsequence),

       @maxnr = max(processsequence)

  FROM #buildcurrentviews -- Define the view creation template
 DECLARE @viewtemplate nvarchar(MAX) = '
        CREATE OR ALTER VIEW [{TgtSchema}].[vw_{TableName}] AS
        /*
        View is generated by  : metro
        Generated at          : {GeneratedAt}
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                {ColumnList},
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [{SrcSchema}].[{TableName}]
               
        )
        SELECT 
            {ColumnList},
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1
        ' -- Loop through each row in the temporary table
 WHILE @counternr IS NOT NULL

   AND @counternr <= @maxnr BEGIN -- Get the current table name

  SELECT @tablename = src.tgt_table_name

  FROM #buildcurrentviews src

 WHERE processsequence = @counternr -- Generate the column list with transformations

    SELECT @columnlist = string_agg('[' + c.[column_name] + '] AS [' + c.[column_name] + ']', ', ')

  FROM [information_schema].[columns] c
 WHERE c.table_schema = @srcschema

   AND c.table_name = @tablename

   AND left(c.[column_name], 3) != 'mta' -- Replace placeholders in the view template

   SET @sqlcreate = replace(replace(replace(replace(replace(@viewtemplate, '{SrcSchema}', @srcschema), '{TgtSchema}', @tgtschema), '{TableName}', @tablename), '{ColumnList}', @columnlist), '{GeneratedAt}', convert(VARCHAR, getdate(), 120)) -- Create the new view
 PRINT @sqlcreate EXEC sp_executesql @sqlcreate -- Move to the next row

   SET @counternr = @counternr + 1 END -- Log the procedure execution

   SET @logsql = 'EXEC ' + @tgtschema + '.' + @logprocname EXEC [aud].[proc_log_procedure] @logaction = 'INFO',

       @lognote = '(Re)Created views on the [bld] tables with meta columns',

       @logprocedure = @logprocname,

       @logsql = @logsql,

       @logrowcount = @maxnr END try BEGIN catch -- Handle errors
 DECLARE @errormessage nvarchar(4000) = error_message() DECLARE @errorseverity INT = error_severity() DECLARE @errorstate INT = error_state() raiserror (@errormessage, @errorseverity, @errorstate) END catch END
