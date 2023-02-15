

CREATE procedure dbo.[Helper_IsValidSQL] (@sql varchar(8000), @exec bit=0) as
/*
declare @sqlnew varchar(8000) = 'select 1 as kim from rep.layers'
exec rep.IsValidSQL @sql=@sqlnew, @exec=1
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