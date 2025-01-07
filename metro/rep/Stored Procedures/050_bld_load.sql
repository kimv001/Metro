

CREATE PROCEDURE [rep].[050_bld_load]
AS
/*
Developed by:			metro
Description:			Load all bld tables

Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/
IF Object_id('tempdb..#tbl') IS NOT null
	DROP TABLE #tbl;

SELECT table_catalog = t.[TABLE_CATALOG]
	,src_table_schema = t.[TABLE_SCHEMA]
	,src_table_name = t.[TABLE_NAME]
	,src_table_type = t.[TABLE_TYPE]
	,tgt_table_name = [rep].[GetNamePart](replace(t.[TABLE_NAME], 'tr_', ''), 2)
	,sql_code = 'Exec bld.load_' + Replace(t.[TABLE_NAME], 'tr_', '')
	,Sequence = ROW_NUMBER() OVER (
		ORDER BY t.[TABLE_NAME]
		)
INTO #tbl
FROM [INFORMATION_SCHEMA].[TABLES] t
WHERE 1 = 1
	AND TABLE_TYPE = 'VIEW'
	AND LEFT(t.[TABLE_NAME], 3) = 'tr_'

PRINT 'load set defined!'
PRINT 'Start loading ...'

DECLARE @nbr_statements int = (
		SELECT COUNT(*)
		FROM #tbl
		)
	,@i int = 1;

WHILE @i <= @nbr_statements
BEGIN
	DECLARE @sql_code nvarchar(4000) = (
			SELECT sql_code
			FROM #tbl
			WHERE Sequence = @i
			);

	PRINT (@sql_code)

	EXEC sp_executesql @sql_code;

	PRINT char(10) + char(9) + char(10) + char(9) + char(10) + char(9)

	SET @i += 1;
END

DROP TABLE #tbl;


EXEC [rep].[069_bld_CreateDeployScripts]