

CREATE procedure [dbo].[Helper_RefreshMetroViews] as

	DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview '''+schema_name(so.schema_id)+'.' +  name + ''';
' 
FROM sys.objects AS so   
INNER JOIN sys.sql_expression_dependencies AS sed   
    ON so.object_id = sed.referencing_id   
	WHERE so.type = 'V'

print (@sqlcmd)

EXEC(@sqlcmd)