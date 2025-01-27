


CREATE PROCEDURE rep.[Helper_IsValidSQL] (@sql varchar(8000), @exec bit=0) AS

/* 
=== Comments =========================================

Description:
    This stored procedure checks if the provided SQL query is valid. With the @exec parameter, you can choose to execute the SQL query immediately.

Parameters:
    @sql  VARCHAR(8000)  -- The SQL query to be validated.
    @exec BIT = 0        -- Flag to indicate whether to execute the SQL query immediately. Default is 0 (do not execute).

Example Usage:
    -- To check if the SQL query is valid without executing it
    DECLARE @sqlnew VARCHAR(8000) = 'SELECT 1 AS kim FROM bld.vw_dataset'
    EXEC rep.Helper_IsValidSQL @sql = @sqlnew, @exec = 0

    -- To check if the SQL query is valid and execute it
    DECLARE @sqlnew VARCHAR(8000) = 'SELECT 1 AS kim FROM bld.vw_dataset'
    EXEC rep.Helper_IsValidSQL @sql = @sqlnew, @exec = 1

Procedure Logic:
    1. Initializes variables to hold the SQL query and error message.
    2. Tries to parse the SQL query to check for syntax errors.
    3. If the SQL query is valid, prints a success message.
    4. If the SQL query is not valid, prints an error message and returns an error code.
    5. If the @exec parameter is set to 1, executes the SQL query.

AST:
Procedure: [rep].[Helper_IsValidSQL]
  Parameters:
    - @sql: VARCHAR(8000)
    - @exec: BIT = 0
  Variables:
    - @ParseSQL: VARCHAR(8000)
    - @ErrorMessage: VARCHAR(8000)
  Logic:
    - Initialize variables
    - Try Block:
      - Set parseonly on and parse the SQL query
      - Print success message if SQL syntax is OK
    - Catch Block:
      - Print error message if SQL syntax is not OK
      - Return error code
    - If @exec is set to 1, execute the SQL query

Mermaid Diagram:
graph TD
    A[Start] --> B[Initialize variables]
    B --> C{Try to parse SQL query}
    C --> D[Set parseonly on and parse the SQL query]
    D --> E[Print success message if SQL syntax is OK]
    C --> F{Catch Block}
    F --> G[Print error message if SQL syntax is not OK]
    G --> H[Return error code]
    E --> I{If @exec is set to 1}
    I --> J[Execute the SQL query]
    J --> K[End]

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/


BEGIN

DECLARE @ParseSQL AS varchar(8000)  = @sql
DECLARE @ErrorMessage AS varchar(8000) 

    BEGIN TRY
		-- Set parseonly on and parse the SQL query
        SET @ParseSQL = 'set parseonly on;'+@ParseSQL;
        EXEC(@ParseSQL);
		PRINT '-- SQL Syntax OK'
    END TRY
    BEGIN CATCH
	PRINT'-- SQL Syntax NOT OK'
        RETURN(1);
    END CATCH;

	-- If @exec is set to 1, execute the SQL query
	IF @exec = 1
	BEGIN TRY	
 		EXEC (@sql)
	END TRY
    BEGIN CATCH
	
		SELECT @ErrorMessage= ERROR_MESSAGE(); 
		PRINT ''
		PRINT '-- Error in executing SQL:'
		PRINT  @ErrorMessage 
		PRINT  ''
		PRINT '-- Executed SQL:'
		PRINT (@sql)
		RETURN(1);

    END CATCH;	
RETURN(0);
END;