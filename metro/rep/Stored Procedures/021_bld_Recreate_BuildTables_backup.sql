
CREATE PROCEDURE [rep].[021_bld_Recreate_BuildTables_backup]
AS
/*
Developed by:			metro
Description:			(Re)Create stp_rep tables based on the [rep] tables 

Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/
DECLARE @LogProcName varchar(255) = '[rep].[021_bld_Recreate_BuildTables]'
DECLARE @LogSQL varchar(255)
DECLARE @SrcSchema varchar(255) = 'bld'
DECLARE @SrcDataset varchar(255) = ''
DECLARE @TgtSchema varchar(255) = 'bld'
DECLARE @TgtDataset varchar(255) = ''
-- variables for the loop
DECLARE @CounterNr integer
DECLARE @MaxNr integer
DECLARE @sql1 varchar(8000)
DECLARE @sql2 varchar(8000)
DECLARE @sql3 varchar(8000)
DECLARE @TableName varchar(8000)
DECLARE @Msg varchar(8000)

IF OBJECT_ID('tempdb..#BuildTables') IS NOT null
	DROP TABLE #BuildTables;

WITH base
AS (
	SELECT table_catalog = t.[TABLE_CATALOG]
		,src_table_schema = t.[TABLE_SCHEMA]
		,src_table_name = t.[TABLE_NAME]
		,src_table_type = t.[TABLE_TYPE]
		,tgt_table_name = rep.[GetNamePart](replace(t.[TABLE_NAME], 'tr_', ''), 2)
		,RowNum = ROW_NUMBER() OVER (
			PARTITION BY rep.[GetNamePart](replace(t.[TABLE_NAME], 'tr_', ''), 2) ORDER BY t.[TABLE_NAME]
			)
	FROM [INFORMATION_SCHEMA].[TABLES] t
	WHERE 1 = 1
		AND TABLE_TYPE = 'VIEW'
		AND LEFT(t.[TABLE_NAME], 3) = 'tr_'
		AND t.TABLE_SCHEMA = @SrcSchema
	)
SELECT *
	,ProcessSequence = ROW_NUMBER() OVER (
		ORDER BY tgt_table_name
		)
INTO #BuildTables
FROM base
WHERE RowNum = 1

SELECT @CounterNr = min(ProcessSequence)
	,@MaxNr = max(ProcessSequence)
FROM #BuildTables

WHILE (
		@CounterNr IS NOT null
		AND @CounterNr <= @MaxNr
		)
BEGIN
	SELECT @TableName = src.tgt_table_name
		,@sql1
		= 'if exists(select * from INFORMATION_SCHEMA.[TABLES]  v where table_schema = '''
		+ @TgtSchema
		+ ''' and table_name='''
		+ tgt_table_name
		+ ''' and TABLE_TYPE=''base table'')'
		+ char(10)
		+ 'drop table '
		+ @TgtSchema
		+ '.['
		+ tgt_table_name
		+ '];'
		,@sql2
		= 'Create table '
		+ @TgtSchema
		+ '.['
		+ tgt_table_name
		+ ']'
		+ char(10)
		+ char(9)
		+ '('
		+ char(10)
		+ char(9)
		+ '['
		+ tgt_table_name
		+ 'Id] int Identity (1,1) NOT NULL,'
		+ char(10)
		+ char(9)
		+ STRING_AGG('[' + c.[COLUMN_NAME] + ']  varchar(' + CASE 
				WHEN c.[COLUMN_NAME] LIKE '%desc'
					OR c.[COLUMN_NAME] LIKE '%expression'
					OR c.[COLUMN_NAME] LIKE '%script'
					OR c.[COLUMN_NAME] LIKE '%RecordSrcDate'
					OR c.[COLUMN_NAME] LIKE '%BusinessDate'
					OR c.[COLUMN_NAME] LIKE '%value'
					OR c.[COLUMN_NAME] = 'view_defintion'
					THEN 'max'
				ELSE '255'
				END + ') NULL ' + char(13) + char(10) + char(9) + '', ',') WITHIN
	GROUP (
			ORDER BY tgt_table_name
				,c.[ORDINAL_POSITION] ASC
			)
			+ char(10)
			+ char(9)
			+ ',[mta_Createdate] [datetime2](7) default (getdate())'
			+ char(10)
			+ char(9)
			+ ',[mta_RecType] smallint default(1)'
			+ ',[mta_BK] char(255),[mta_BKH] char(128), [mta_RH] char(128), mta_Source varchar(255)'
			+ char(10)
			+ char(9)
			+ ') ON [PRIMARY]'
		,@sql3
		= 'Create Unique Index Uix_'
		+ @TgtSchema
		+ '_'
		+ tgt_table_name
		+ char(10)
		+ char(9)
		+ 'ON  '
		+ @TgtSchema
		+ '.['
		+ tgt_table_name
		+ ']'
		+ char(10)
		+ char(9)
		+ '([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC)'
		+ char(10)
		+ char(9)
		+ 'Create Clustered Index Cix_'
		+ @TgtSchema
		+ '_'
		+ tgt_table_name
		+ char(10)
		+ char(9)
		+ 'ON  '
		+ @TgtSchema
		+ '.['
		+ tgt_table_name
		+ ']'
		+ char(10)
		+ char(9)
		+ '([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);'
		+ char(10)
		+ char(9)

	FROM #BuildTables src
	JOIN [INFORMATION_SCHEMA].[COLUMNS] c ON src.src_table_schema = c.TABLE_SCHEMA
		AND src.src_table_name = c.TABLE_NAME
	WHERE 1 = 1
		AND LEFT(c.[COLUMN_NAME], 3) != 'mta'
		AND src.ProcessSequence = @CounterNr
	GROUP BY src.tgt_table_name

	-- drop tables if exists
	PRINT (@sql1)

	EXEC (@sql1)

	SET @Msg = 'Drop Table ' + @TgtSchema + '.' + Isnull(@TableName, '')

	EXEC [aud].[proc_Log_Procedure] @LogAction = 'DROP'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql1
		,@LogRowCount = 1

	-- create tables
	PRINT (@sql2)

	EXEC (@sql2)

	SET @Msg = 'Create Table ' + @TgtSchema + '.' + Isnull(@TableName, '')

	EXEC [aud].[proc_Log_Procedure] @LogAction = 'CREATE'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql2
		,@LogRowCount = 1

	-- create tables
	PRINT (@sql3)

	EXEC (@sql3)

	SET @Msg = 'Create Clustered index IX_' + @TgtSchema + '' + Isnull(@TableName, '')

	EXEC [aud].[proc_Log_Procedure] @LogAction = 'CREATE'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql3
		,@LogRowCount = 1

	SET @CounterNr = @CounterNr + 1
END

SET @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

EXEC [aud].[proc_Log_Procedure] @LogAction = 'INFO'
	,@LogNote = '(Re)Create build tables based on the "tr" views'
	,@LogProcedure = @LogProcName
	,@LogSQL = @LogSQL
	,@LogRowCount = @MaxNr

-- cleaning
IF OBJECT_ID('tempdb..#BuildTables') IS NOT null
	DROP TABLE #BuildTables