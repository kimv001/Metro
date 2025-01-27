


CREATE PROCEDURE [rep].[Helper_RefreshMetroViews] AS

/* 
=== Comments =========================================

Description:
    This stored procedure refreshes all views after recreating them by using dynamic SQL.

Parameters:
    None

Example Usage:
    exec [rep].[Helper_RefreshMetroViews]

Procedure Logic:
    1. Initializes a variable to hold the dynamic SQL command.
    2. Constructs the dynamic SQL command to refresh all views.
    3. Prints the constructed SQL command for debugging purposes.
    4. Executes the constructed SQL command.

AST:
Procedure: [rep].[Helper_RefreshMetroViews]
  Parameters:
    - None
  Variables:
    - @sqlcmd: NVARCHAR(MAX)
  Logic:
    - Initialize variable to hold dynamic SQL command
    - Construct dynamic SQL command to refresh all views
    - Print constructed SQL command
    - Execute constructed SQL command

Mermaid Diagram:
graph TD
    A[Start] --> B[Initialize variable to hold dynamic SQL command]
    B --> C[Construct dynamic SQL command to refresh all views]
    C --> D[Print constructed SQL command]
    D --> E[Execute constructed SQL command]
    E --> F[End]

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/

	DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview '''+schema_name(so.schema_id)+'.' +  name + ''';
' 
FROM sys.objects AS so   
INNER JOIN sys.sql_expression_dependencies AS sed   
    ON so.object_id = sed.referencing_id   
	WHERE so.type = 'V'

PRINT (@sqlcmd)

EXEC(@sqlcmd)