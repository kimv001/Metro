
CREATE PROCEDURE [rep].[021_bld_recreate_buildtables] @table_name varchar(255) = NULL,

       @tgt_table_name varchar(255) = NULL AS BEGIN /*
    Developed by:            metro
    Description:             (Re)Create tables in the [stg_bld] schema based on the [bld] schema

	examples:
	exec [rep].[021_bld_Recreate_BuildTables]

	exec [rep].[021_bld_Recreate_BuildTables] @tgt_table_name = 'Schema'

    Change log:
    Date                    Author              Description
    20220916 20:15          K. Vermeij          Initial version
    */  DECLARE @logprocname varchar(255) = '[bld].[021_bld_Recreate_BuildTables]' DECLARE @logsql varchar(255) DECLARE @srcschema varchar(255) = 'bld' DECLARE @tgtschema varchar(255) = 'bld' DECLARE @counternr INT DECLARE @maxnr INT DECLARE @sqldrop nvarchar(MAX) DECLARE @sqlcreate nvarchar(MAX) DECLARE @tablename varchar(255) DECLARE @msg varchar(255) DECLARE @columnlist nvarchar(MAX) DECLARE @src_table_name varchar(255) BEGIN try -- Drop temporary table if it exists
 IF object_id('tempdb..#BuildTables') IS NOT NULL
DROP TABLE #buildtables; -- Create temporary table with row numbers
 ;WITH base AS

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

           AND (rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2) = @tgt_table_name
          OR @tgt_table_name IS NULL)

           AND t.table_schema = @srcschema

           AND (@table_name IS NULL
          OR rep.[getnamepart](replace(t.[table_name], 'tr_', ''), 2) = @table_name)
       )
SELECT *,

       processsequence = row_number() OVER (
                                            ORDER BY tgt_table_name) INTO #buildtables

  FROM base

 WHERE RowNum = 1 -- Initialize loop variables

  SELECT @counternr = min(processsequence),

       @maxnr = max(processsequence)

  FROM #buildtables -- Define the table creation template
 DECLARE @tabletemplate nvarchar(MAX) = '
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
        ' -- Loop through each row in the temporary table
 WHILE @counternr IS NOT NULL

   AND @counternr <= @maxnr BEGIN -- Get the current table name

  SELECT @src_table_name = src_table_name,

       @tgt_table_name = tgt_table_name

  FROM #buildtables

 WHERE processsequence = @counternr -- Generate the column list with transformations

    SELECT @columnlist = string_agg('[' + c.[column_name] + '] VARCHAR(' + CASE
                                                                               WHEN c.[column_name] LIKE '%desc'
                                                                                    OR c.[column_name] LIKE '%expression'
                                                                                    OR c.[column_name] LIKE '%script'
                                                                                    OR c.[column_name] LIKE '%RecordSrcDate'
                                                                                    OR c.[column_name] LIKE '%BusinessDate'
                                                                                    OR c.[column_name] LIKE '%value'
                                                                                    OR c.[column_name] = 'view_defintion' THEN 'MAX'
                                                                               ELSE '255'
                                                                           END + ') NULL', ', ')

  FROM information_schema.columns c
 WHERE c.table_schema = @srcschema

   AND c.table_name = @src_table_name

   AND left(c.[column_name], 3) != 'mta' -- Replace placeholders in the table template


   SET @sqlcreate = replace(replace(replace(replace(@tabletemplate, '{TgtSchema}', @tgtschema), '{tgt_table_name}', @tgt_table_name), '{ColumnList}', @columnlist), '{GeneratedAt}', convert(VARCHAR, getdate(), 120)) -- Execute the table creation script
 PRINT @sqlcreate EXEC sp_executesql @sqlcreate -- Move to the next row


   SET @counternr = @counternr + 1 END -- Log the procedure execution


   SET @logsql = 'exec ' + @tgtschema + '.' + @logprocname EXEC [aud].[proc_log_procedure] @logaction = 'INFO',

       @lognote = '(Re)Created tables in the [stg_bld] schema based on the [bld] schema',

       @logprocedure = @logprocname,

       @logsql = @logsql,

       @logrowcount = @maxnr END try BEGIN catch -- Handle errors
 DECLARE @errormessage nvarchar(4000) = error_message() DECLARE @errorseverity INT = error_severity() DECLARE @errorstate INT = error_state() raiserror (@errormessage, @errorseverity, @errorstate) END catch END