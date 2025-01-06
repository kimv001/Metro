
CREATE PROCEDURE [rep].[021_bld_recreate_buildtables_backup] AS /*
Developed by:			metro
Description:			(Re)Create stp_rep tables based on the [rep] tables

Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/ DECLARE @logprocname varchar(255) = '[rep].[021_bld_Recreate_BuildTables]' DECLARE @logsql varchar(255) DECLARE @srcschema varchar(255) = 'bld' DECLARE @srcdataset varchar(255) = '' DECLARE @tgtschema varchar(255) = 'bld' DECLARE @tgtdataset varchar(255) = '' -- variables for the loop
DECLARE @counternr integer DECLARE @maxnr integer DECLARE @sql1 varchar(8000) DECLARE @sql2 varchar(8000) DECLARE @sql3 varchar(8000) DECLARE @tablename varchar(8000) DECLARE @msg varchar(8000) IF object_id('tempdb..#BuildTables') IS NOT NULL
DROP TABLE #buildtables; WITH base AS

        (SELECT table_catalog = t.[table_catalog] ,

               src_table_schema = t.[table_schema] ,

               src_table_name = t.[table_name] ,

               src_table_type = t.[table_type] ,

               tgt_table_name = rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2) ,RowNum = row_number() OVER (PARTITION BY rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2)
                                                                                                                 ORDER BY t.[table_name])

          FROM [information_schema].[tables] t

         WHERE 1 = 1

           AND table_type = 'VIEW'

           AND left(t.[table_name], 3) = 'tr_'

           AND t.table_schema = @srcschema
       )
SELECT * ,

       processsequence = row_number() OVER (
                                            ORDER BY tgt_table_name) INTO #buildtables

  FROM base

 WHERE RowNum = 1
  SELECT @counternr = min(processsequence) ,

       @maxnr = max(processsequence)

  FROM #buildtables WHILE (@counternr IS NOT NULL
                           AND @counternr <= @maxnr) BEGIN
  SELECT @tablename = src.tgt_table_name ,

       @sql1 = 'if exists(select * from INFORMATION_SCHEMA.[TABLES]  v where table_schema = ''' + @tgtschema + ''' and table_name=''' + tgt_table_name + ''' and TABLE_TYPE=''base table'')' + char(10) + 'drop table ' + @tgtschema + '.[' + tgt_table_name + '];' ,

       @sql2 = 'Create table ' + @tgtschema + '.[' + tgt_table_name + ']' + char(10) + char(9) + '(' + char(10) + char(9) + '[' + tgt_table_name + 'Id] int Identity (1,1) NOT NULL,' + char(10) + char(9) + string_agg('[' + c.[column_name] + ']  varchar(' + CASE
                                                                                                                                                                                                                                                                      WHEN c.[column_name] like '%desc'
                                                                                                                                                                                                                                                                           OR c.[column_name] like '%expression'
                                                                                                                                                                                                                                                                           OR c.[column_name] like '%script'
                                                                                                                                                                                                                                                                           OR c.[column_name] like '%RecordSrcDate'
                                                                                                                                                                                                                                                                           OR c.[column_name] like '%BusinessDate'
                                                                                                                                                                                                                                                                           OR c.[column_name] like '%value'
                                                                                                                                                                                                                                                                           OR c.[column_name] = 'view_defintion' THEN 'max'
                                                                                                                                                                                                                                                                      ELSE '255'
                                                                                                                                                                                                                                                                  END + ') NULL ' + char(13) + char(10) + char(9) + '', ',') within GROUP (
                                                                                                                                                                                                                                                                                                                                           ORDER BY tgt_table_name ,
                                                                                                                                                                                                                                                                                                                                                    c.[ordinal_position] ASC) + char(10) + char(9) + ',[mta_Createdate] [datetime2](7) default (getdate())' + char(10) + char(9) + ',[mta_RecType] smallint default(1)' + ',[mta_BK] char(255),[mta_BKH] char(128), [mta_RH] char(128), mta_Source varchar(255)' + char(10) + char(9) + ') ON [PRIMARY]' ,

       @sql3 = 'Create Unique Index Uix_' + @tgtschema + '_' + tgt_table_name + char(10) + char(9) + 'ON  ' + @tgtschema + '.[' + tgt_table_name + ']' + char(10) + char(9) + '([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC)' + char(10) + char(9) + 'Create Clustered Index Cix_' + @tgtschema + '_' + tgt_table_name + char(10) + char(9) + 'ON  ' + @tgtschema + '.[' + tgt_table_name + ']' + char(10) + char(9) + '([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);' + char(10) + char(9)

  FROM #buildtables src

  JOIN [information_schema].[columns] c
    ON src.src_table_schema = c.table_schema

   AND src.src_table_name = c.table_name

 WHERE 1 = 1

   AND left(c.[column_name], 3) != 'mta'

   AND src.processsequence = @counternr

 GROUP BY src.tgt_table_name -- drop tables if exists
 PRINT (@sql1) EXEC (@sql1)

   SET @msg = 'Drop Table ' + @tgtschema + '.' + isnull(@tablename, '') EXEC [aud].[proc_log_procedure] @logaction = 'DROP' ,

       @lognote = @msg ,

       @logprocedure = @logprocname ,

       @logsql = @sql1 ,

       @logrowcount = 1 -- create tables
 PRINT (@sql2) EXEC (@sql2)

   SET @msg = 'Create Table ' + @tgtschema + '.' + isnull(@tablename, '') EXEC [aud].[proc_log_procedure] @logaction = 'CREATE' ,

       @lognote = @msg ,

       @logprocedure = @logprocname ,

       @logsql = @sql2 ,

       @logrowcount = 1 -- create tables
 PRINT (@sql3) EXEC (@sql3)

   SET @msg = 'Create Clustered index IX_' + @tgtschema + '' + isnull(@tablename, '') EXEC [aud].[proc_log_procedure] @logaction = 'CREATE' ,

       @lognote = @msg ,

       @logprocedure = @logprocname ,

       @logsql = @sql3 ,

       @logrowcount = 1

   SET @counternr = @counternr + 1 END

   SET @logsql = 'exec ' + @tgtschema + '.' + @logprocname EXEC [aud].[proc_log_procedure] @logaction = 'INFO' ,

       @lognote = '(Re)Create build tables based on the "tr" views' ,

       @logprocedure = @logprocname ,

       @logsql = @logsql ,

       @logrowcount = @maxnr -- cleaning
IF object_id('tempdb..#BuildTables') IS NOT NULL
  DROP TABLE #buildtables
