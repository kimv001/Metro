CREATE procedure [rep].[100_Publish_DeployScriptsToScreen] @TGT_ObjectName varchar(8000) = ''
	,@LayerName varchar(8000) = ''
	,@SchemaName varchar(8000) = ''
	,@GroupName varchar(8000) = ''
	,@ShortName varchar(8000) = ''
	,@DeployDatasets bit = 0
	,@DeployMappings bit = 1
	,@ObjectType varchar(100) = ''
	,@IgnoreErrors int = 0 -- 2 just show the scripts, 1 stop on all builderrors, 0 stop on builderrors on selection
as
/*
Developed by:			metro
Description:			Publish deployscripts to screen

Example:		

exec  [rep].[100_Publish_DeployScriptsToScreen]
			  @TGT_ObjectName	= ''
			, @LayerName		= ''
			, @SchemaName		= 'pst'
			, @GroupName		= 'boost'
			, @ShortName		= 'case'
			, @DeployDatasets	= 0
			, @DeployMappings	= 1

Change log:
Date					Author				Description
20220916	2015		K. Vermeij			Initial version
20230406	1045		K. Vermeij			Added filter ToDeploy = 1
20230609	0858		K. Vermeij			Builderrors are shown before the scripts are shown. With the new paramter @IgnoreErrors
											you can choose:
											0	- stop generating scripts if there are errors in your selection for generating
											1	- stop generating scripts if there are errors in the total build
											2	- show the errors... but still generate the scripts
*/
set ansi_warnings off;
set nocount on;

declare @LogProcName varchar(255) = '100_Publish_DeployScriptsToScreen'
declare @LogSQL varchar(max) = ''
declare @SrcSchema varchar(255) = 'rep'
declare @SrcDataset varchar(255) = ''
declare @TgtSchema varchar(255) = 'rep'
declare @TgtDataset varchar(255) = ''
declare @Msg varchar(8000)
declare @DeployVersion varchar(max) = '<!<DeployVersionNum>>' -- Convert(varchar(20),Format(cast(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as datetime), 'yyyyMMddHHmmss'),121)
	-- variables for the loops
declare @CounterNr int
declare @MaxNr int
declare @StopCounterNr int
declare @sql varchar(max)
declare @bld_msg varchar(max)

if object_id('tempdb..#bld_errors') is not null
	drop table #bld_errors

select bc.*
	,rownum = row_number() over (
		partition by bc.buildcheckid order by bc.buildcheckid asc
		)
into #bld_errors
from [bld].[vw_BuildCheck] bc
inner join bld.vw_Dataset d on d.BK = bc.BK
where 1 = 1
	and (
		@IgnoreErrors = 2
		or @IgnoreErrors = 1
		or (
			@IgnoreErrors = 0
			and (
				@TGT_ObjectName = ''
				or @TGT_ObjectName = d.[DatasetName]
				)
			and (
				@LayerName = ''
				or @LayerName = d.LayerName
				)
			and (
				@SchemaName = ''
				or @SchemaName = d.SchemaName
				)
			and (
				@GroupName = ''
				or @GroupName = d.BK_Group
				)
			and (
				@ShortName = ''
				or @ShortName = d.ShortName
				)
			)
		)

select @counternr = min(rownum)
	,@MaxNr = max(rownum)
--, @StopCounterNr= min(rownum)
from #bld_errors bc

if @CounterNr > 0
	print '/*' + char(10) + 'Build errors found:' + char(10)

while (
		@counternr is not null
		and @counternr <= @MaxNr
		)
begin
	select @bld_msg = 'Dataset: ' + src.BK + ' Message:' + src.CheckMessage + char(10)
	from #bld_errors src
	where 1 = 1
		and src.RowNum = @counternr

	print (@bld_msg)

	if @CounterNr = @MaxNr
		print char(10) + '*/' + char(10)

	set @counternr = @counternr + 1
end

if @IgnoreErrors < 2
	and @counternr is not null
begin
	-- NEED TO STOP STORED PROCEDURE EXECUTION
	return
end

if OBJECT_ID('tempdb..#DeployScripts') is not null
	drop table #DeployScripts;

with base
as (
	select
		--	  DeployOrder				= dense_rank() over (partition by  d.Code order by d.ShortName,d.BK_Group, cast(isnull(fl.SortOrder,'1000') as int) asc,   cast(src.ObjectTypeDeployOrder as int) asc) -- rank() OVER (partition by d.SchemaName order by  cast(src.ObjectTypeDeployOrder as int) asc )
		DeployOrder = dense_rank() over (
			partition by d.Code order by d.ShortName
				,d.BK_Group
				,cast(src.ObjectTypeDeployOrder as int) + cast(d.FlowOrder as int) asc
			) -- rank() OVER (partition by d.SchemaName order by  cast(src.ObjectTypeDeployOrder as int) asc )
		,DeployScript = src.TemplateScript
		,TGT_ObjectName = src.TGT_ObjectName
		,ObjectType = src.ObjectType
		,TemplateType = src.TemplateType
		,TemplateName = src.TemplateName
		,BK_Dataset = d.bk
		,SchemaName = d.SchemaName
		,LayerName = d.LayerName
		,GroupName = d.BK_Group
		,ShortName = d.ShortName
		,Code = d.Code
		,src.ScriptLanguageCode
		,src.ScriptLanguage
	from bld.vw_DeployScripts src
	inner join bld.vw_Dataset d on d.BK = src.BK_Dataset
	inner join bld.vw_Schema s on s.bk = d.BK_Schema
	where 1 = 1
		and isnull(d.ToDeploy, 1) = 1
		and (
			(
				@DeployDatasets = 1
				and src.TemplateType = 'Dataset'
				)
			or src.TemplateType = 'Mapping'
			)
		and (
			(
				@DeployMappings = 1
				and src.TemplateType = 'Mapping'
				)
			or src.TemplateType = 'Dataset'
			)
		and (
			@ObjectType = src.ObjectType
			or @ObjectType = ''
			)
	)
select *
	,RowNum = Row_Number() over (
		order by groupname
			,shortname
			,DeployOrder
		)
into #DeployScripts
from base
where 1 = 1
	and (
		@TGT_ObjectName = ''
		or @TGT_ObjectName = TGT_ObjectName
		)
	and (
		@LayerName = ''
		or @LayerName = LayerName
		)
	and (
		@SchemaName = ''
		or @SchemaName = SchemaName
		)
	and (
		@GroupName = ''
		or @GroupName = GroupName
		)
	and (
		@ShortName = ''
		or @ShortName = ShortName
		)
order by groupname
	,shortname
	,DeployOrder

select @CounterNr = min(RowNum)
	,@MaxNr = max(RowNum)
from #DeployScripts

while (
		@CounterNr is not null
		and @CounterNr <= @MaxNr
		)
begin
	select @TGT_ObjectName = src.TGT_ObjectName
		,@sql = replace(src.DeployScript, '<!<DeployVersionNum>>', @DeployVersion)
	from #DeployScripts src
	where 1 = 1
		and src.RowNum = @CounterNr

	exec [rep].[Helper_LongPrint] @string = @sql

	--Print	(@sql)
	--Exec	(@sql1)
	set @Msg = 'Create Deploy Scripts  ' + @TGT_ObjectName

	exec [aud].[proc_Log_Procedure] @LogAction = 'Create'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql
		,@LogRowCount = 1

	set @CounterNr = @CounterNr + 1
end

set @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

exec [aud].[proc_Log_Procedure] @LogAction = 'INFO'
	,@LogNote = 'Publish deploy scripts to screen done'
	,@LogProcedure = @LogProcName
	,@LogSQL = @LogSQL
	,@LogRowCount = @MaxNr

-- cleaning
if OBJECT_ID('tempdb..#DeployScripts') is not null
	drop table #DeployScripts