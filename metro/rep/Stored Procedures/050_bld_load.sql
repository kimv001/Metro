
CREATE PROCEDURE [rep].[050_bld_load] AS /*
Developed by:			metro
Description:			Load all bld tables

Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/ IF object_id('tempdb..#tbl') IS NOT NULL
DROP TABLE #tbl;
SELECT table_catalog = t.[table_catalog],

       src_table_schema = t.[table_schema],

       src_table_name = t.[table_name],

       src_table_type = t.[table_type],

       tgt_table_name = [rep].[getnamepart](replace(t.[table_name], 'tr_', ''), 2),

       sql_code = 'Exec bld.load_' + replace(t.[table_name], 'tr_', ''),

       SEQUENCE = row_number() OVER (
                                     ORDER BY t.[table_name]) INTO #tbl

  FROM [information_schema].[tables] t

 WHERE 1 = 1

   AND table_type = 'VIEW'

   AND left(t.[table_name], 3) = 'tr_' PRINT 'load set defined!' PRINT 'Start loading ...' DECLARE @nbr_statements int =

        (SELECT count(*)

          FROM #tbl
       ) , @ i int = 1;WHILE @ i <= @nbr_statements BEGIN DECLARE @sql_code nvarchar(4000) =

        (SELECT sql_code

          FROM #tbl

         WHERE SEQUENCE = @ i
       );PRINT (@sql_code) EXEC sp_executesql @sql_code;PRINT char(10) + char(9) + char(10) + char(9) + char(10) + char(9)

   SET @ i + = 1;END
DROP TABLE #tbl;EXEC [rep].[069_bld_createdeployscripts]
