
CREATE procedure [rep].[069_bld_CreateDeployScripts]
as
exec [aud].[proc_Log_Procedure] @LogAction = 'INFO'
	,@LogNote = 'Build DeployScripts'
	,@LogProcedure = 'rep.[300_bld_CreateDeployScripts]'
	,@LogSQL = 'Insert Into [bld].[DeployScripts]'
	,@LogRowCount = null;

set ansi_warnings off;
set nocount on;

declare @CheckErrorsCount int

select @CheckErrorsCount = ISNULL(count(''), 0)
from bld.vw_BuildCheck bc

if @CheckErrorsCount > 0
begin
	print '-- ' + cast(@CheckErrorsCount as varchar(5)) + ' errors found in repository definition, see Result set'

	select *
	from bld.vw_BuildCheck bc
end

if @CheckErrorsCount < 1
begin
	print '-- No errors found in repository definition'
	print '--'
end

declare @CurrentDate datetime2 = cast(getutcdate() as datetime2)
declare @CurrentDateVarchar varchar(16) = cast(@CurrentDate as varchar(16))

if OBJECT_ID('tempdb.dbo.#OrderedMarkers', 'U') is not null
	drop table #OrderedMarkers;;

with GeneratorMarkersPost
as (
	select BK_Template = t.bk
		,Marker = '<!<TemplateName>>'
		,MarkerValue = cast(t.TemplateName as varchar(max))
	from bld.vw_Template t
	
	union all
	
	select BK_Template = t.bk
		,Marker = '<!<TemplateDesc>>'
		,MarkerValue = cast(isnull(t.TemplateDecription, 'No description available') as varchar(max))
	from bld.vw_Template t
	
	union all
	
	select BK_Template = t.bk
		,Marker = '<!<TemplateVersionNum>>'
		,MarkerValue = cast(t.templateversion as varchar(max))
	from bld.vw_Template t
	
	union all
	
	select BK_Template = t.bk
		,Marker = '<!<CurrentUser>>'
		,MarkerValue = cast(isnull(ORIGINAL_LOGIN(), 'metro automation') as varchar(max))
	from bld.vw_Template t
	
	union all
	
	select BK_Template = t.bk
		,Marker = '<!<GeneratedAt>>'
		,MarkerValue = cast(@CurrentDateVarchar as varchar(max))
	from bld.vw_Template t
	)
	,GeneratorMarkers
as (
	select distinct src.bk
		,src.Code
		,src.BK_Dataset
		,gm.Marker
		,gm.MarkerValue
		,Script = cast(t.Script as varchar(max))
		,TGT_ObjectName = cast(t.ObjectName as varchar(max))
		,t.ObjectType
		,t.ObjectTypeDeployOrder
		,BK_Template = t.BK
		,t.TemplateType
		,t.ScriptLanguageCode
		,t.ScriptLanguage
		,mta_CreateDate = '1900-01-01'
		,MarkerType = 'System'
		,Pre = 0
		,Post = 1
	from bld.vw_DatasetTemplates src
	join bld.vw_Template t on t.BK = src.BK_Template
	join GeneratorMarkersPost gm on gm.BK_Template = t.bk
	)
	,AllMarkers
as (
	select src.BK
		,m.Code
		,m.BK_Dataset
		,Marker = cast(m.Marker as varchar(max))
		,MarkerValue = cast(isnull(m.MarkerValue, '') as varchar(max)) --, pre=cast(m.pre as int), post=cast(m.post as int)
		,Script = cast(t.Script as varchar(max))
		,TGT_ObjectName = cast(t.ObjectName as varchar(max))
		,t.ObjectType
		,t.ObjectTypeDeployOrder
		,BK_Template = t.BK
		,t.TemplateType
		,t.ScriptLanguageCode
		,t.ScriptLanguage
		,m.mta_CreateDate
		,m.MarkerType
		,m.Pre
		,m.Post
	from bld.vw_DatasetTemplates src
	left join bld.vw_Markers m on M.BK_Dataset = src.BK_Dataset
	left join bld.vw_Template t on t.BK = src.BK_Template
	where 1 = 1
	
	union all
	
	select src.bk
		,src.Code
		,src.BK_Dataset
		,src.Marker
		,src.MarkerValue
		,src.Script
		,src.TGT_ObjectName
		,src.ObjectType
		,src.ObjectTypeDeployOrder
		,src.BK_Template
		,src.TemplateType
		,src.ScriptLanguageCode
		,src.ScriptLanguage
		,src.mta_createdate
		,src.MarkerType
		,src.Pre
		,src.Post
	from GeneratorMarkers src
	)
select HNR = DENSE_RANK() over (
		order by cast(src.ObjectTypeDeployOrder as int) asc
			,src.bk asc
		)
	,NR = ROW_NUMBER() over (
		partition by src.bk order by src.bk asc
		)
	,src.BK
	,src.BK_Dataset
	,src.BK_Template
	,src.Code
	,src.Marker
	,src.MarkerValue
	,src.TemplateType
	,src.ScriptLanguageCode
	,src.ScriptLanguage
	,src.mta_CreateDate
	,src.Script
	,src.TGT_ObjectName
	,src.ObjectType
	,src.ObjectTypeDeployOrder
	,src.MarkerType
	,src.Pre
	,src.Post
	,RecType = cast(sl.RecType as int)
into #OrderedMarkers
from AllMarkers src
join bld.vw_DeployScriptsSmartLoad sl on sl.BK = src.BK_Dataset
	and cast(sl.RecType as int) > - 1
where 1 = 1

create clustered index IDX_C_ID_OrderedMarkers on #OrderedMarkers (
	HNR
	,NR
	,BK
	,Code
	);

print '--   Build DeployScripts: The Metro Magic ... Replace the markers in the templates ' + convert(varchar(20), getdate(), 121)

-- Here comes even more fun... fill in the marker value into the Template markers
declare @Script varchar(max)
	,@PreScript varchar(max)
	,@PostScript varchar(max)
	,@BK_Object varchar(max)
	,@Code varchar(max)
	,@BK_Dataset varchar(max)
	,@ObjectType varchar(max)
	,@ObjectTypeDeployOrder varchar(max)
	,@BK_Template varchar(max)
	,@Marker varchar(max)
	,@MarkerValue varchar(max)
	,@TGT_ObjectName varchar(max)
	,@RecType varchar(max)
	,@TemplateName varchar(max)
	,@TemplateType varchar(max)
	,@ScriptLanguageCode varchar(max)
	,@ScriptLanguage varchar(max)
--	@nl AS VARCHAR(max) = CHAR(13) + CHAR(10),	 -- To do: implement this in de Script replacement. The generated code wil be more readible.
--	@GO AS VARCHAR(max) = CHAR(13) + CHAR(10)+';'+CHAR(13) + CHAR(10)+'GO'+CHAR(13) + CHAR(10)+';'+CHAR(13) + CHAR(10) --- Makes it more Synapse Proof
-- Prepare the Loop (the total Selection list)
declare @MainCounter int
	,@MaxId int

select @MainCounter = min(HNR)
	,@MaxId = max(HNR)
from #OrderedMarkers

-- Start the Main Loop (By Object, By Template)
while (
		@MainCounter is not null
		and @MainCounter <= @MaxId
		)
begin
	-- Prepare the Loop in the Loop ( this one runs per DatasetId, per TemplateId and replaces all the markers )
	declare @PreMarkerCounterObj int
	declare @MarkerCounterObj int
	declare @PostMarkerCounterObj int
	declare @MaxObjId int

	select @MarkerCounterObj = min(NR)
		,@MaxObjId = max(NR)
		,@BK_Dataset = om.BK_Dataset
		,@BK_Object = om.BK
		,@Code = om.Code
		,@TGT_ObjectName = om.TGT_ObjectName
		,@PreScript = om.Script
		,@BK_Template = om.BK_Template
		,@TemplateType = om.TemplateType
		,@ScriptLanguageCode = om.ScriptLanguageCode
		,@ScriptLanguage = om.ScriptLanguage
		,@ObjectType = om.ObjectType
		,@ObjectTypeDeployOrder = om.ObjectTypeDeployOrder
		,@RecType = om.RecType
	from #OrderedMarkers om
	where om.HNR = @MainCounter
	group by om.BK
		,om.BK_Dataset
		,om.Code
		,om.TGT_ObjectName
		,om.Script
		,om.BK_Template
		,om.TemplateType
		,om.ScriptLanguageCode
		,om.ScriptLanguage
		,om.ObjectType
		,om.ObjectTypeDeployOrder
		,om.RecType

	set @PreMarkerCounterObj = @MarkerCounterObj
	set @PostMarkerCounterObj = @MarkerCounterObj

	-- Replace System Markers which are defined als [Pre]=1
	while (
			@PreMarkerCounterObj is not null
			and @PreMarkerCounterObj <= @MaxObjId
			)
	begin
		select @PreScript = replace(cast(@PreScript as varchar(max)), cast(om.marker as varchar(max)), cast(om.MarkerValue as varchar(max)))
		from #OrderedMarkers om
		where 1 = 1
			and om.MarkerType = 'System'
			and cast(om.Pre as int) = 1
			and om.HNR = @MainCounter

		set @PreMarkerCounterObj = @PreMarkerCounterObj + 1
	end

	set @Script = @PreScript

	while (
			@MarkerCounterObj is not null
			and @MarkerCounterObj <= @MaxObjId
			)
	begin
		select @Script = replace(cast(@Script as varchar(max)), cast(om.marker as varchar(max)), cast(om.MarkerValue as varchar(max)))
			,@TGT_ObjectName = replace(cast(@TGT_ObjectName as varchar(max)), cast(om.marker as varchar(max)), cast(om.MarkerValue as varchar(max)))
		from #OrderedMarkers om
		where 1 = 1
			and om.MarkerType != 'System'
			and om.HNR = @MainCounter

		set @MarkerCounterObj = @MarkerCounterObj + 1
	end

	set @PostScript = @Script

	while (
			@PostMarkerCounterObj is not null
			and @PostMarkerCounterObj <= @MaxObjId
			)
	begin
		select @PostScript = replace(cast(@PostScript as varchar(max)), cast(om.marker as varchar(max)), cast(om.MarkerValue as varchar(max)))
		from #OrderedMarkers om
		where 1 = 1
			and cast(om.Post as int) = 1
			and om.HNR = @MainCounter

		set @PostMarkerCounterObj = @PostMarkerCounterObj + 1
	end

	--Set @Script = @PreScript
	print '--' + @TGT_ObjectName

	--exec [rep].[Helper_LongPrint] @String = @PostScript

	--insert into #bld_Done (TGT_ObjectName, Script,mta_CreateDate )
	--select @TGT_ObjectName as TGT_ObjectName, @PostScript as Script , @CurrentDate
	insert into [bld].[DeployScripts] (
		[BK]
		,[Code]
		,[BK_Template]
		,[BK_Dataset]
		,[TGT_ObjectName]
		,[ObjectType]
		,[ObjectTypeDeployOrder]
		,[TemplateType]
		,ScriptLanguageCode
		,ScriptLanguage
		,[TemplateSource]
		,[TemplateName]
		,[TemplateScript]
		,[mta_Createdate]
		,[mta_RecType]
		,[mta_BK]
		,[mta_BKH]
		,[mta_RH]
		,[mta_Source]
		)
	values (
		@BK_Object -- BK
		,@Code -- Code
		,@BK_Template -- BK_Template
		,@BK_Dataset -- BK_Dataset
		,@TGT_ObjectName -- TGT_ObjectName
		,@ObjectType -- ObjectType
		,@ObjectTypeDeployOrder -- ObjectTypeDeployOrder
		,@TemplateType -- TemplateType
		,@ScriptLanguageCode
		,@ScriptLanguage
		,'' -- TemplateSource
		,'' -- TemplateName
		,@PostScript -- Script
		,@CurrentDate -- mta_Createdate
		,@RecType -- mta_RecType
		,@BK_Object + '|' + @BK_Template -- mta_BK
		,Convert(char(64), (Hashbytes('sha2_512', upper(@BK_Object + '|' + @BK_Template))), 2) -- mta_BKH
		,Convert(char(64), (Hashbytes('sha2_512', upper(@TGT_ObjectName + '|' + @ObjectType + '|' + @ObjectTypeDeployOrder + '|' + @PostScript))), 2) -- mta_RH
		,'rep.[300_bld_CreateDeployScripts]' -- mta_Source
		)

	set @MainCounter = @MainCounter + 1
end

--select * from #bld_Done
-- delete DeployScripts if not active anymore:
insert into [bld].[DeployScripts] (
	[BK]
	,[Code]
	,[BK_Template]
	,[BK_Dataset]
	,[TGT_ObjectName]
	,[ObjectType]
	,[ObjectTypeDeployOrder]
	,[TemplateType]
	,[TemplateSource]
	,[TemplateName]
	,[TemplateScript]
	,[mta_Createdate]
	,[mta_RecType]
	,[mta_BK]
	,[mta_BKH]
	,[mta_RH]
	,[mta_Source]
	)
select src.[BK]
	,src.[Code]
	,src.[BK_Template]
	,src.[BK_Dataset]
	,src.[TGT_ObjectName]
	,src.[ObjectType]
	,src.[ObjectTypeDeployOrder]
	,src.[TemplateType]
	,src.[TemplateSource]
	,src.[TemplateName]
	,src.[TemplateScript]
	,@CurrentDate
	,sl.RecType
	,src.[mta_BK]
	,src.[mta_BKH]
	,src.[mta_RH]
	,src.[mta_Source]
from bld.vw_DeployScriptsSmartLoad sl
join bld.vw_DeployScripts src on sl.bk = src.BK_Dataset
where cast(sl.RecType as int) = - 1