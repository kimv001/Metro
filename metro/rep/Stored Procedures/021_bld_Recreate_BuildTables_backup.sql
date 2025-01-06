
CREATE procedure [rep].[021_bld_Recreate_BuildTables_backup]
as
/*
Developed by:			metro
Description:			(Re)Create stp_rep tables based on the [rep] tables 

Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/
declare @LogProcName varchar(255) = '[rep].[021_bld_Recreate_BuildTables]'
declare @LogSQL varchar(255)
declare @SrcSchema varchar(255) = 'bld'
declare @SrcDataset varchar(255) = ''
declare @TgtSchema varchar(255) = 'bld'
declare @TgtDataset varchar(255) = ''
-- variables for the loop
declare @CounterNr integer
declare @MaxNr integer
declare @sql1 varchar(8000)
declare @sql2 varchar(8000)
declare @sql3 varchar(8000)
declare @TableName varchar(8000)
declare @Msg varchar(8000)

if OBJECT_ID('tempdb..#BuildTables') is not null
	drop table #BuildTables;

with base
as (
	select table_catalog = t.[TABLE_CATALOG]
		,src_table_schema = t.[TABLE_SCHEMA]
		,src_table_name = t.[TABLE_NAME]
		,src_table_type = t.[TABLE_TYPE]
		,tgt_table_name = rep.[GetNamePart](replace(t.[TABLE_NAME], 'tr_', ''), 2)
		,RowNum = ROW_Number() over (
			partition by rep.[GetNamePart](replace(t.[TABLE_NAME], 'tr_', ''), 2) order by t.[TABLE_NAME]
			)
	from [INFORMATION_SCHEMA].[TABLES] t
	where 1 = 1
		and TABLE_TYPE = 'VIEW'
		and left(t.[TABLE_NAME], 3) = 'tr_'
		and t.TABLE_SCHEMA = @SrcSchema
	)
select *
	,ProcessSequence = Row_Number() over (
		order by tgt_table_name
		)
into #BuildTables
from base
where RowNum = 1

select @CounterNr = min(ProcessSequence)
	,@MaxNr = max(ProcessSequence)
from #BuildTables

while (
		@CounterNr is not null
		and @CounterNr <= @MaxNr
		)
begin
	select @TableName = src.tgt_table_name
		,@sql1 = 'if exists(select * from INFORMATION_SCHEMA.[TABLES]  v where table_schema = ''' + @TgtSchema + ''' and table_name=''' + tgt_table_name + ''' and TABLE_TYPE=''base table'')' + char(10) + 'drop table ' + @TgtSchema + '.[' + tgt_table_name + '];'
		,@sql2 = 'Create table ' + @TgtSchema + '.[' + tgt_table_name + ']' + char(10) + char(9) + '(' + char(10) + char(9) + '[' + tgt_table_name + 'Id] int Identity (1,1) NOT NULL,' + char(10) + char(9) + STRING_AGG('[' + c.[COLUMN_NAME] + ']  varchar(' + case 
				when c.[COLUMN_NAME] like '%desc'
					or c.[COLUMN_NAME] like '%expression'
					or c.[COLUMN_NAME] like '%script'
					or c.[COLUMN_NAME] like '%RecordSrcDate'
					or c.[COLUMN_NAME] like '%BusinessDate'
					or c.[COLUMN_NAME] like '%value'
					or c.[COLUMN_NAME] = 'view_defintion'
					then 'max'
				else '255'
				end + ') NULL ' + char(13) + char(10) + char(9) + '', ',') WITHIN
	group (
			order by tgt_table_name
				,c.[ORDINAL_POSITION] asc
			) + char(10) + char(9) + ',[mta_Createdate] [datetime2](7) default (getdate())' + char(10) + char(9) + ',[mta_RecType] smallint default(1)' + ',[mta_BK] char(255),[mta_BKH] char(128), [mta_RH] char(128), mta_Source varchar(255)' + char(10) + char(9) + ') ON [PRIMARY]'
		,@sql3 = 'Create Unique Index Uix_' + @TgtSchema + '_' + tgt_table_name + char(10) + char(9) + 'ON  ' + @TgtSchema + '.[' + tgt_table_name + ']' + char(10) + char(9) + '([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC)' + char(10) + char(9) + 'Create Clustered Index Cix_' + @TgtSchema + '_' + tgt_table_name + char(10) + char(9) + 'ON  ' + @TgtSchema + '.[' + tgt_table_name + ']' + char(10) + char(9) + '([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);' + char(10) + char(9)

	from #BuildTables src
	join [INFORMATION_SCHEMA].[COLUMNS] c on src.src_table_schema = c.TABLE_SCHEMA
		and src.src_table_name = c.TABLE_NAME
	where 1 = 1
		and left(c.[COLUMN_NAME], 3) != 'mta'
		and src.ProcessSequence = @CounterNr
	group by src.tgt_table_name

	-- drop tables if exists
	print (@sql1)

	exec (@sql1)

	set @Msg = 'Drop Table ' + @TgtSchema + '.' + Isnull(@TableName, '')

	exec [aud].[proc_Log_Procedure] @LogAction = 'DROP'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql1
		,@LogRowCount = 1

	-- create tables
	print (@sql2)

	exec (@sql2)

	set @Msg = 'Create Table ' + @TgtSchema + '.' + Isnull(@TableName, '')

	exec [aud].[proc_Log_Procedure] @LogAction = 'CREATE'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql2
		,@LogRowCount = 1

	-- create tables
	print (@sql3)

	exec (@sql3)

	set @Msg = 'Create Clustered index IX_' + @TgtSchema + '' + Isnull(@TableName, '')

	exec [aud].[proc_Log_Procedure] @LogAction = 'CREATE'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql3
		,@LogRowCount = 1

	set @CounterNr = @CounterNr + 1
end

set @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

exec [aud].[proc_Log_Procedure] @LogAction = 'INFO'
	,@LogNote = '(Re)Create build tables based on the "tr" views'
	,@LogProcedure = @LogProcName
	,@LogSQL = @LogSQL
	,@LogRowCount = @MaxNr

-- cleaning
if OBJECT_ID('tempdb..#BuildTables') is not null
	drop table #BuildTables