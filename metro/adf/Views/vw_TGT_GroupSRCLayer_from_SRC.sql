






;
CREATE view [adf].[vw_TGT_GroupSRCLayer_from_SRC] as
With base as (
				Select 
		  TGT				= src.TGT_DatasetName
		, TGT_BK_Dataset	= src.BK_Target	
		, TGT_Group
		, TGT_Schema
		, TGT_Layer
		, TGT_DWH			= 'All'
		, SRC_BK_DataSet	= src.BK_Source
		, SRC_DataSet		= src.SRC_DatasetName
		, SRC_ShortName
		, SRC_Group
		, SRC_Schema
		, SRC_Layer
		  
		,[generation_number]
		FROM bld.vw_LoadDependency src
		where DependencyType = 'TgtFromSrc'
)
, LayerMe as (
	select distinct 
		[TGT_GroupSRCLayer] = [tgt_Group]+'-'+[SRC_Layer]
		,SRC_BK_DataSet
		,[SRC_DataSet]
		,[SRC_ShortName]
		,[SRC_Group]
		,[SRC_Schema]
		,[SRC_Layer]
		,[generation_number] =min([generation_number])
		, 'GroupSRCLayer' as DependencyType
	from base b
	where 1=1
	Group by
		  [tgt_Group]+'-'+[SRC_Layer]
		,SRC_BK_DataSet
		,[SRC_DataSet]
		,[SRC_ShortName]
		,[SRC_Group]
		,[SRC_Schema]
		,[SRC_Layer]
	)
select distinct 
	  [TGT_GroupSRCLayer]
	, [TGT]						= [TGT_GroupSRCLayer]
	, SRC_BK_DataSet
	, [SRC_DataSet]
	, src.[SRC_ShortName]
		, SRC_SourceName			= src.SRC_Group + '_' + iif(src.SRC_Schema = 'stg',d.SRC_ShortName, src.SRC_ShortName)
	, SRC_DatasetType			= D.SRC_ObjectType
	, TGT_DatasetType			= D.TGT_ObjectType
	, [SRC_Group]
	, [SRC_Schema]
	, [SRC_Layer] 
	, generation_number			=  DENSE_RANK() over(partition by [TGT_GroupSRCLayer] order by [generation_number])
	, DependencyType			= 'GroupSRCLayer'
	, [RepositoryStatusName]    = d.RepositoryStatusName
	, [RepositoryStatusCode]	= d.RepositoryStatusCode
from LayerMe src
join bld.vw_Dataset d on src.SRC_BK_DataSet = d.BK
where 1=1