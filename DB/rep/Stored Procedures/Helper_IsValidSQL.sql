


CREATE procedure rep.[Helper_IsValidSQL] (@sql varchar(8000), @exec bit=0) as

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


begin

declare @ParseSQL as varchar(8000)  = @sql
declare @ErrorMessage as varchar(8000) 

    begin try
        set @ParseSQL = 'set parseonly on;'+@ParseSQL;
        exec(@ParseSQL);
		print '-- SQL Syntax OK'
    end try
    begin catch
	print'-- SQL Syntax NOT OK'
        return(1);
    end catch;

if @exec = 1
	begin try	
 		exec (@sql)
	end try
    begin catch
	
		SELECT @ErrorMessage= ERROR_MESSAGE(); 
		print ''
		print '-- Error in executing SQL:'
		print  @ErrorMessage 
		Print  ''
		print '-- Executed SQL:'
		print (@sql)
		return(1);

    end catch;	
return(0);
end;