

CREATE PROCEDURE [rep].[050_bld_load]
AS
/*
Developed by:			metro

Description:
    This stored procedure processes all build procedures and prepares the environment for script creation. It executes SQL statements in sequence and finally calls the procedure to create deployment scripts.

Parameters:
    None

Example Usage:
    exec [rep].[050_bld_load]

Procedure Logic:
    1. Initializes variables for logging and SQL execution.
    2. Iterates through the SQL statements stored in the temporary table #tbl.
    3. Executes each SQL statement in sequence.
    4. Drops the temporary table #tbl.
    5. Calls the stored procedure [rep].[069_bld_CreateDeployScripts] to create deployment scripts.

AST:
Procedure: [rep].[050_bld_load]
  Parameters:
    - None
  Variables:
    - @nbr_statements: INT
    - @i: INT
    - @sql_code: NVARCHAR(4000)
  Logic:
    - Initialize variables
    - While loop to iterate through SQL statements
      - Select SQL code from #tbl
      - Print SQL code
      - Execute SQL code
      - Print new lines for separation
      - Increment counter
    - Drop temporary table #tbl
    - Execute [rep].[069_bld_CreateDeployScripts]

Mermaid Diagram:
graph TD
    A[Start] --> B[Initialize Variables]
    B --> C{While @i <= @nbr_statements}
    C --> D[Select SQL code from #tbl]
    D --> E[Print SQL code]
    E --> F[Execute SQL code]
    F --> G[Print new lines for separation]
    G --> H[Increment counter]
    H --> C
    C --> I[Drop temporary table #tbl]
    I --> J[Execute [rep].[069_bld_CreateDeployScripts]]
    J --> K[End]

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