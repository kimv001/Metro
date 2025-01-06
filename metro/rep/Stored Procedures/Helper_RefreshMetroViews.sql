
CREATE PROCEDURE [rep].[helper_refreshmetroviews] AS /*
=== Comments =========================================

Description:
 Refresh all views after recreating them by dynamic sql

Test:
OK:

NOK:

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/  DECLARE @sqlcmd nvarchar(MAX) = ''
SELECT @sqlcmd = @sqlcmd + 'EXEC sp_refreshview ''' + schema_name(so.schema_id) + '.' + name + ''';
'

  FROM sys.objects AS so

 INNER JOIN sys.sql_expression_dependencies AS sed
    ON so.object_id = sed.referencing_id

 WHERE so.type = 'V' PRINT (@sqlcmd) exec(@sqlcmd)
