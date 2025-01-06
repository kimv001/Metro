

CREATE procedure [rep].[050_bld_load]
as
/*
Developed by:			metro
Description:			Load all bld tables

Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/
if Object_id('tempdb..#tbl') is not null
	drop table #tbl;

select table_catalog = t.[TABLE_CATALOG]
	,src_table_schema = t.[TABLE_SCHEMA]
	,src_table_name = t.[TABLE_NAME]
	,src_table_type = t.[TABLE_TYPE]
	,tgt_table_name = [rep].[GetNamePart](replace(t.[TABLE_NAME], 'tr_', ''), 2)
	,sql_code = 'Exec bld.load_' + Replace(t.[TABLE_NAME], 'tr_', '')
	,Sequence = ROW_Number() over (
		order by t.[TABLE_NAME]
		)
into #tbl
from [INFORMATION_SCHEMA].[TABLES] t
where 1 = 1
	and TABLE_TYPE = 'VIEW'
	and left(t.[TABLE_NAME], 3) = 'tr_'

print 'load set defined!'
print 'Start loading ...'

declare @nbr_statements int = (
		select COUNT(*)
		from #tbl
		)
	,@i int = 1;

while @i <= @nbr_statements
begin
	declare @sql_code nvarchar(4000) = (
			select sql_code
			from #tbl
			where Sequence = @i
			);

	print (@sql_code)

	exec sp_executesql @sql_code;

	print char(10) + char(9) + char(10) + char(9) + char(10) + char(9)

	set @i += 1;
end

drop table #tbl;


exec [rep].[069_bld_CreateDeployScripts]