﻿
CREATE PROCEDURE [rep].[023_bld_recreate_loadprocs] @tgt_table_name varchar(255) = NULL AS /*
Developed by:			metro
Description:			(Re)Create Stored Procedures to load data into [generated]


	examples:
	exec  [rep].[023_bld_Recreate_LoadProcs]

	exec  [rep].[023_bld_Recreate_LoadProcs] @tgt_table_name = 'Schema'


Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/ DECLARE @logprocname varchar(MAX) = '023_bld_Recreate_LoadProcs' DECLARE @lognote varchar(MAX) = '(Re)Create Stored Procedures to load data into [bld] ' DECLARE @logsql varchar(MAX) DECLARE @srcschema varchar(MAX) = 'bld' DECLARE @tgtschema varchar(MAX) = 'bld' DECLARE @smartload varchar(MAX) = '0' DECLARE @lb varchar(MAX) = char(10) + char(9) -- variables for the loop
DECLARE @counternr integer DECLARE @maxnr integer DECLARE @sql1 varchar(MAX) DECLARE @sql2 varchar(MAX) DECLARE @sql2a varchar(MAX) DECLARE @sql2b varchar(MAX) DECLARE @sql2c varchar(MAX) DECLARE @longsql varchar(MAX) DECLARE @srcdataset varchar(MAX) DECLARE @tablename varchar(MAX) DECLARE @routinenamefull varchar(MAX) DECLARE @routinenameshort varchar(MAX) DECLARE @msg varchar(MAX) IF object_id('tempdb..#BuildProcs') IS NOT NULL
DROP TABLE #buildprocs; WITH base AS

        (SELECT table_catalog = t.[table_catalog] ,

               src_table_schema = t.[table_schema] ,

               src_table_name = t.[table_name] ,

               src_table_type = t.[table_type] ,

               tgt_table_name = rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2) ,

               dataset = replace(t.[table_name], 'tr_', '') ,RowNum = row_number() OVER (
                                                                                    ORDER BY t.[table_name]) ,

               smartload = iif(c.column_name = 'mta_RecType', '1', '0')

          FROM [information_schema].[tables] t

          LEFT JOIN [information_schema].[columns] c
            ON c.table_schema = t.[table_schema]

           AND c.table_name = t.[table_name]

           AND c.column_name = 'mta_RecType'

         WHERE 1 = 1

           AND table_type = 'VIEW'

           AND left(t.[table_name], 3) = 'tr_'

           AND t.table_schema = @srcschema

           AND (rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2) = @tgt_table_name
          OR @tgt_table_name IS NULL)
       )
SELECT * INTO #buildprocs

  FROM base
SELECT @counternr = min(RowNum) ,

       @maxnr = max(RowNum)

  FROM #buildprocs WHILE (@counternr IS NOT NULL
                        AND @counternr <= @maxnr) BEGIN
SELECT @tablename = src.tgt_table_name ,

       @srcdataset = src.src_table_name ,

       @smartload = src.smartload ,

       @routinenameshort = 'load_' + src.dataset ,

       @routinenamefull = '[' + @tgtschema + '].[load_' + src.dataset + ']' ,

       @sql1 = 'if exists(select * from INFORMATION_SCHEMA.[ROUTINES] where [ROUTINE_SCHEMA] = ''' + @tgtschema + ''' and [ROUTINE_NAME] =  ''' + @routinenameshort + ''')' + char(10) + 'drop procedure ' + @routinenamefull + ';' ,

       @sql2a = @lb + 'create proc ' + @routinenamefull + ' as' + @lb + '/*' + @lb + 'Proc is generated by	: metro' + @lb + 'Generated at			: ' + convert(varchar(19), getdate(), 121) + @lb + iif(@smartload = 1, 'makes use of Smartload!', '') + @lb + 'exec ' + @routinenamefull + '' + '*/' + char(10) + @lb + @lb + 'Declare @RoutineName	varchar(8000)	= ''' + @routinenameshort + '''' + @lb + 'Declare @StartDateTime	datetime2		=  getutcdate()' + @lb + 'Declare @EndDateTime	datetime2		' + @lb + 'Declare @Duration		bigint' + char(10) + char(10) + char(10) + @lb + '-- Create a helper temp table' + @lb + 'If OBJECT_ID(''tempdb..#' + src.dataset + ''') IS NOT NULL ' + @lb + 'Drop Table #' + src.dataset + ' ;' + @lb + 'Print ''-- create temp table:''' + @lb + 'Select' + @lb + '  mta_BK' + char(9) + char(9) + '= src.[BK]' + @lb + ', mta_BKH' + char(9) + char(9) + '= Convert(char(64),(Hashbytes(''sha2_512'',upper(src.BK) )),2)' + @lb + ', mta_RH' + char(9) + char(9) + '= Convert(char(64),(Hashbytes(''sha2_512'',upper(' + @lb + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + string_agg('ISNULL(Cast(src.[' + c.[column_name] + '] as varchar(8000)),''-'') ', '+''|''+') within GROUP (
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ORDER BY src.tgt_table_name ,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                c.[ordinal_position] ASC) + @lb + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + '))),2)' + @lb + ', mta_Source' + char(9) + '= ''[' + @tgtschema + '].[' + src.src_table_name + ']''' + @lb + ', mta_RecType' + char(9) + '= ' + iif(@smartload = 1, 'diff.RecType', 'case 
												when tgt.[BK] is null then 1
												when tgt.[mta_RH] !=  Convert(char(64),(Hashbytes(''sha2_512'',upper(' + string_agg('ISNULL(Cast(src.[' + c.[column_name] + '] as varchar(8000)),''-'') ', '+''|''+') within GROUP (
                                                                                                                                                                                                ORDER BY src.tgt_table_name , c.[ordinal_position] ASC) + '))),2)' + @lb + char(9) + char(9) + char(9) + char(9) + char(9) + 'then 0' + @lb + char(9) + char(9) + char(9) + char(9) + char(9) + 'else -99 end' + @lb) + @lb + 'Into #' + src.dataset + @lb + 'From [' + @tgtschema + '].[' + src.src_table_name + '] src' + @lb + 'Left join [' + @tgtschema + '].[vw_' + src.tgt_table_name + '] tgt on src.[BK] = tgt.[BK]' + @lb + iif(@smartload = 1, 'join [bld].[vw_' + src.tgt_table_name + 'SmartLoad] diff on diff.code =  src.code', '') + @lb + iif(@smartload = 1, 'where 1=1  and  cast(diff.RecType as int) > -99', '') + @lb + @lb + 'Create Clustered INDEX [IX_' + src.src_table_name + '] ON #' + src.dataset + '( [mta_BKH] ASC,[mta_RH] ASC)' + @lb + @lb + @lb + '--------------------- start loading data' + @lb + @lb + 'Print ''-- new records:''' + @lb + @lb + 'set @StartDateTime = getdate()' + @lb + @lb + 'Insert Into [' + @tgtschema + '].[' + src.tgt_table_name + ']' + @lb + '( ' + @lb + char(9) + string_agg('[' + c.[column_name] + '] ', ',') within GROUP (
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ORDER BY src.tgt_table_name ,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            c.[ordinal_position] ASC) + @lb + char(9) + ', [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]' + ') ' + @lb + 'select ' + @lb + char(9) + string_agg('src.[' + c.[column_name] + '] ', ',') within GROUP (
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ORDER BY src.tgt_table_name ,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           c.[ordinal_position] ASC) + @lb + char(9) + ', h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]' + @lb + 'From  [' + @srcschema + '].[' + src.src_table_name + '] src' + @lb + 'Join #' + src.dataset + ' h on h.[mta_BK] = src.[BK]' + @lb + 'Left Join [' + @tgtschema + '].[vw_' + src.tgt_table_name + '] tgt on h.[mta_BKH] = tgt.[mta_BKH] ' + @lb + 'Where 1=1 and cast(h.mta_RecType as int) = 1 and tgt.[mta_BKH] is null' + @lb + @lb + @lb + 'set @EndDateTime = getutcdate()' + @lb + 'exec [aud].[proc_Log_Procedure]  
							@LogAction		= ''INSERT - NEW'', 
							@LogNote		= ''New Records'',
							@LogProcedure	= @RoutineName,
							@LogSQL			= ''Insert Into [' + @tgtschema + '].[' + src.tgt_table_name + ']'',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;' + @lb + @lb + 'Print ''-- changed records:''' + @lb + 'set @StartDateTime = getdate()' + @lb + @lb + char(9) + 'Insert Into [' + @tgtschema + '].[' + src.tgt_table_name + ']' + @lb + '( ' + @lb + char(9) + string_agg('[' + c.[column_name] + '] ', ',') within GROUP (
                                                                                                                                                                                                                                                                                                                  ORDER BY src.tgt_table_name ,
                                                                                                                                                                                                                                                                                                                           c.[ordinal_position] ASC) + @lb + char(9) + ', [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]' + ') ' + @lb + 'select ' + @lb + char(9) + string_agg('src.[' + c.[column_name] + '] ', ',') within GROUP (
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ORDER BY src.tgt_table_name ,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          c.[ordinal_position] ASC) + char(10) + char(9) + char(9) + ', h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]' + @lb + 'From  [' + @srcschema + '].[' + src.src_table_name + '] src' + @lb + 'Join #' + src.dataset + ' h on h.[mta_BK] = src.[BK]' + @lb + 'Where 1=1 and cast(h.mta_RecType as int) = 0' + char(10) + @lb + @lb + 'set @EndDateTime = getutcdate()' + @lb + 'exec [aud].[proc_Log_Procedure]  
												@LogAction		= ''INSERT - CHG'', 
												@LogNote		= ''Changed Records'',
												@LogProcedure	= @RoutineName,
												@LogSQL			= ''Insert Into [' + @tgtschema + '].[' + src.tgt_table_name + ']'',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;' + @lb + @lb + 'Print ''-- deleted records:''' + @lb + @lb + 'set @StartDateTime = getdate()' + @lb + @lb + 'Insert Into [' + @tgtschema + '].[' + src.tgt_table_name + ']' + @lb + @lb + '( ' + @lb + @lb + char(9) + string_agg('[' + c.[column_name] + '] ', ',') within GROUP (
                                                                                                                                                                                                                                                                                                                               ORDER BY src.tgt_table_name ,
                                                                                                                                                                                                                                                                                                                                        c.[ordinal_position] ASC) + @lb + char(9) + ', [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]' + ') ' + @lb + 'select ' + @lb + char(9) + string_agg('src.[' + c.[column_name] + '] ', ',') within GROUP (
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ORDER BY src.tgt_table_name ,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       c.[ordinal_position] ASC) + @lb + char(9) + ', src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1' + @lb + 'From  [' + @tgtschema + '].[vw_' + src.tgt_table_name + '] src' + @lb + 'Left Join #' + src.dataset + ' h on h.[mta_BKH] = src.[mta_BKH] and h.[mta_Source] = src.[mta_Source]' + @lb + 'Where 1=1 and h.[mta_BKH] is null and  src.mta_Source = ''[' + @tgtschema + '].[' + src.src_table_name + ']''' + @lb + iif(@smartload = 1, 'and  h.mta_RecType =-1', '') + @lb + @lb + 'set @EndDateTime = getutcdate()' + @lb + 'exec [aud].[proc_Log_Procedure]  
												@LogAction		= ''INSERT - DEL'', 
												@LogNote		= ''Changed Deleted'',
												@LogProcedure	= @RoutineName,
												@LogSQL			= ''Insert Into [' + @tgtschema + '].[' + src.tgt_table_name + ']'',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;' + @lb + @lb ,

       @sql2b = '' ,

       @sql2c = '-- Clean up ...' + @lb + 'If OBJECT_ID(''tempdb..#' + src.dataset + ''') IS NOT NULL ' + char(10) + 'Drop Table #' + src.dataset + ';' + @lb + @lb + 'set @EndDateTime =  getutcdate()' + @lb + 'set @Duration = datediff(ss,@StartDateTime, @EndDateTime)' + @lb + 'print ''Load "' + @routinenameshort + '" took '' +cast(@Duration as varchar(10))+ '' second(s)''' + @lb --select *


  FROM #buildprocs src

  JOIN [information_schema].[columns] c
    ON c.table_schema = src.src_table_schema

   AND c.table_name = src.src_table_name

 WHERE 1 = 1

   AND left(c.column_name, 3) != 'mta'

   AND c.column_name != src.tgt_table_name + 'Id'

   AND src.rownum = @counternr

 GROUP BY src.src_table_name ,

          src.tgt_table_name ,

          src.dataset ,

          src.smartload -- Drop load procedure
 PRINT (@sql1) EXEC (@sql1)

   SET @msg = 'Drop Load proc ' + @logprocname EXEC [aud].[proc_log_procedure] @logaction = 'DROP' ,

       @lognote = @msg ,

       @logprocedure = @logprocname ,

       @logsql = @sql1 ,

       @logrowcount = 1 -- create load procedure


   SET @longsql = @sql2a + @sql2b + @sql2c EXEC rep.helper_longprint @string = @longsql EXEC (@longsql)

   SET @msg = 'Load proc ' + @logprocname EXEC [aud].[proc_log_procedure] @logaction = 'CREATE' ,

       @lognote = @msg ,

       @logprocedure = @logprocname ,

       @logsql = @sql2 ,

       @logrowcount = 1

   SET @counternr = @counternr + 1 END

   SET @logsql = 'exec ' + @tgtschema + '.' + @logprocname EXEC [aud].[proc_log_procedure] @logaction = 'INFO' ,

       @lognote = @lognote ,

       @logprocedure = @logprocname ,

       @logsql = @logsql ,

       @logrowcount = @maxnr -- Cleaning
IF object_id('tempdb..#BuildProcs') IS NOT NULL
DROP TABLE #buildprocs;