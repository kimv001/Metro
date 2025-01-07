﻿

CREATE PROCEDURE [rep].[010_rep_Recreate_RepViews_backup]
AS
/*
Developed by:			metro
Description:			(Re)Create views on the [stg_rep] tables with meta columns: 
						- mta_BK		(Stores the Businesskey of the table)
						- mta_BKH		(Stores the hash of the Businesskey of the table)
						- mta_RH		(Stores the hash of the full row)
						- mta_RowNum	actually only needed for the view [rep].[vw_XlsTabsToLoad] so i could make an easy loop in this procedure

Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/
DECLARE @LogProcName varchar(MAX) = '[rep].[010_rep_Recreate_RepViews]'
DECLARE @LogSQL varchar(MAX)
DECLARE @SrcSchema varchar(MAX) = 'rep'
DECLARE @TgtSchema varchar(MAX) = 'rep'
-- variables for the loop
DECLARE @CounterNr integer
DECLARE @MaxNr integer
DECLARE @sql1 varchar(MAX)
DECLARE @sql2 varchar(MAX)
DECLARE @TableName varchar(MAX)
DECLARE @Msg varchar(MAX)

IF OBJECT_ID('tempdb..#XlsTabsToLoad') IS NOT null
	DROP TABLE #XlsTabsToLoad

SELECT *
	,mta_RowNum = ROW_NUMBER() OVER (
		ORDER BY [BK] ASC
		)
INTO #XlsTabsToLoad
FROM rep.XlsTabsToLoad
WHERE BK IS NOT null


SELECT @CounterNr = min(mta_RowNum)
	,@MaxNr = max(mta_RowNum)
FROM #XlsTabsToLoad

WHILE (
		@CounterNr IS NOT null
		AND @CounterNr <= @MaxNr
		)
BEGIN
	SELECT @TableName = c.[TABLE_NAME]
		,@sql1
		= 'if exists(select * from INFORMATION_SCHEMA.[TABLES]  v where table_schema = '''
		+ @SrcSchema
		+ ''' and table_name=''vw_'
		+ c.[TABLE_NAME]
		+ ''' and TABLE_TYPE=''VIEW'')'
		+ char(10)
		+ 'drop view '
		+ @SrcSchema
		+ '.[vw_'
		+ c.[TABLE_NAME]
		+ '];'
		,@sql2
		= 'create view '
		+ @TgtSchema
		+ '.vw_'
		+ c.[TABLE_NAME]
		+ ' as'
		+ char(10)
		+ '/*'
		+ char(10)
		+ 'View is generated by  : metro'
		+ char(10)
		+ 'Generated at          : '
		+ CONVERT(varchar(19), getdate(), 121)
		+ char(10)
		+ 'Description           : View on stage table'
		+ char(10)
		+ '*/'
		+ char(10)
		+ char(10)
		+ 'Select '
		+ char(10)
		+ char(9)
		+ '-- List of columns:'
		+ char(10)
		+ char(9)
		+ STRING_AGG('Ltrim(Rtrim(Cast([' + c.[COLUMN_NAME] + '] as varchar(' + CASE 
				WHEN c.[COLUMN_NAME] LIKE '%desc'
					OR c.[COLUMN_NAME] LIKE '%expression'
					OR c.[COLUMN_NAME] LIKE '%script'
					OR c.[COLUMN_NAME] LIKE '%RecordSrcDate'
					OR c.[COLUMN_NAME] LIKE '%BusinessDate'
					OR c.[COLUMN_NAME] LIKE '%value'
					THEN 'max'
				ELSE '255'
				END + ')))) as [' + c.[COLUMN_NAME] + ']', ',') WITHIN
	GROUP (
			ORDER BY t.TABLE_TYPE
				,c.[TABLE_NAME]
				,c.[ORDINAL_POSITION] ASC
			)
			+ char(10)
			+ char(9)
			+ char(10)
			+ char(9)
			+ '-- Meta data columns:'
			+ char(10)
			+ char(9)
			+ ', mta_RowNum     = Row_Number() Over (Order By [BK] asc)'
			+ char(10)
			+ char(9)
			+ ', mta_BK         = Upper(Isnull(Ltrim(Rtrim(Cast([BK] as varchar(500)))),''-''))'
			+ char(10)
			+ char(9)
			+ ', mta_BKH        = Convert(char(64),(hashbytes(''sha2_512'','
			+ char(10)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ 'Upper(Isnull(Ltrim(Rtrim(Cast([BK] as varchar(500)))),''-''))'
			+ char(10)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ ')),2)'
			+ char(10)
			+ char(9)
			+ ', mta_RH         = Convert(char(64),(Hashbytes(''sha2_512'',upper('
			+ char(10)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ STRING_AGG('isnull(ltrim(rtrim(cast([' + c.[COLUMN_NAME] + ']as varchar(' + CASE 
				WHEN c.[COLUMN_NAME] LIKE '%desc'
					OR c.[COLUMN_NAME] LIKE '%script'
					THEN '8000'
				ELSE '255'
				END + '))	)),''-'')', '+''|''+') WITHIN
	GROUP (
			ORDER BY t.TABLE_TYPE
				,c.[TABLE_NAME]
				,c.[ORDINAL_POSITION] ASC
			)
			+ char(10)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ char(9)
			+ '))),2)	'
			+ char(10)
			+ char(9)
			+ ', mta_Source     = mta_Source'
			+ char(10)
			+ char(9)
			+ ', mta_Loaddate   = Cast(mta_LoadDate as datetime2)'
			+ char(10)
			+ 'From '
			+ @SrcSchema
			+ '.['
			+ c.[TABLE_NAME]
			+ ']'
			+ char(10)
			+ 'Where 1=1'
			+ char(10)
			+ char(9)
			+ 'and isnull(Active,''1'') = ''1'' '
			+ char(10)
			+ char(9)
			+ 'and isnull([BK],'''') != ''''	;'
	FROM [INFORMATION_SCHEMA].[COLUMNS] c
	JOIN [INFORMATION_SCHEMA].[TABLES] t ON c.TABLE_SCHEMA = t.TABLE_SCHEMA
		AND c.TABLE_NAME = t.TABLE_NAME
	JOIN #XlsTabsToLoad xt ON c.TABLE_NAME = xt.TableName
	WHERE 1 = 1
		AND t.TABLE_TYPE = 'BASE TABLE'
		AND t.TABLE_SCHEMA = @TgtSchema
		AND c.COLUMN_NAME != 'mta_Source'
		AND c.COLUMN_NAME != 'mta_LoadDate'
		AND xt.TableName != 'XlsTabsToLoad'
		AND xt.mta_RowNum = @CounterNr
	GROUP BY c.[TABLE_NAME]

	-- drop views if exists
	PRINT ('')
	PRINT (@sql1)

	EXEC (@sql1)

	SET @Msg = 'Drop view ' + ISNULL(@TgtSchema, '') + ISNULL('.vw_' + @TableName, '')

	EXEC [aud].[proc_Log_Procedure] @LogAction = 'DROP'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql1
		,@LogRowCount = 1

	-- create views
	PRINT ('')
	PRINT (@sql2)

	EXEC (@sql2)

	SET @Msg = 'Create view ' + ISNULL(@TgtSchema, '') + ISNULL('.vw_' + @TableName, '')

	EXEC [aud].[proc_Log_Procedure] @LogAction = 'CREATE'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql2
		,@LogRowCount = 1

	SET @CounterNr = @CounterNr + 1
END

SET @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

EXEC [aud].[proc_Log_Procedure] @LogAction = 'INFO'
	,@LogNote = '(Re)Created views on the [stg_rep] tables with meta columns'
	,@LogProcedure = @LogProcName
	,@LogSQL = @LogSQL
	,@LogRowCount = @MaxNr