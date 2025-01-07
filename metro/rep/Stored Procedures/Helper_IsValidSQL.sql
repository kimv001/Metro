


CREATE PROCEDURE rep.[Helper_IsValidSQL] (@sql varchar(8000), @exec bit=0) AS

/* 
=== Comments =========================================

Description:
	Let you check if generated SQL is valid. With the @exec paramter you can execute it immediate

Test:
OK:
declare @sqlnew varchar(8000) = 'select 1 as kim from bld.vw_dataset'
exec  rep.Helper_IsValidSQL @sql=@sqlnew, @exec=0

NOK:



Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/


BEGIN

DECLARE @ParseSQL AS varchar(8000)  = @sql
DECLARE @ErrorMessage AS varchar(8000) 

    BEGIN TRY
        SET @ParseSQL = 'set parseonly on;'+@ParseSQL;
        EXEC(@ParseSQL);
		PRINT '-- SQL Syntax OK'
    END TRY
    BEGIN CATCH
	PRINT'-- SQL Syntax NOT OK'
        RETURN(1);
    END CATCH;

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