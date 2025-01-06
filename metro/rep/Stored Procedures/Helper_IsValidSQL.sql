
CREATE PROCEDURE rep.[helper_isvalidsql] (@sql varchar(8000), @exec bit = 0) AS /*
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
*/ BEGIN DECLARE @parsesql AS varchar(8000) = @sql DECLARE @errormessage AS varchar(8000) BEGIN try

   SET @parsesql = 'set parseonly on;' +@ parsesql; exec(@parsesql); PRINT '-- SQL Syntax OK' END try BEGIN catch PRINT'-- SQL Syntax NOT OK' return(1); END catch; IF @exec = 1 BEGIN try EXEC (@sql) END try BEGIN catch
SELECT @errormessage = error_message(); PRINT '' PRINT '-- Error in executing SQL:' PRINT @errormessage PRINT '' PRINT '-- Executed SQL:' PRINT (@sql) return(1); END catch; return(0); END;