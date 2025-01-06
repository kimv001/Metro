




CREATE  view [adf].[vw_TGT_DWH_from_SRC] as -- 493

with ExcludedFromAll as 
(
select bk,code,TargetToLoad,ScheduleType from bld.vw_Schedules where ExcludeFromAllLevel = 1 --and TargetToLoad = 'kanvas'
)
, base as (
	Select 
		  TGT				= src.TGT_DatasetName
		, TGT_BK_Dataset	= src.BK_Target	
		, TGT_Group			= 'All' 
		, TGT_Group_new = src.TGT_Group
		, TGT_Schema		= 'All' 
		, TGT_Layer			= 'All'
		, TGT_DWH			= 'All'
		, SRC_BK_DataSet	= src.BK_Source
		, SRC_DataSet		= src.SRC_DatasetName
		, src.SRC_ShortName
		, src.SRC_Group
		, src.SRC_Schema
		, src.SRC_Layer
		, src.[generation_number]
		, xa.TargetToLoad
		from bld.vw_LoadDependency src
		left join ExcludedFromAll xa on xa.TargetToLoad = src.BK_Target
										
										or xa.TargetToLoad = src.SRC_DatasetName

										or  xa.TargetToLoad = src.SRC_Group
										 or xa.TargetToLoad = src.SRC_Schema
										or  xa.TargetToLoad = src.SRC_Layer
										or  xa.TargetToLoad = src.TGT_Group
										 or xa.TargetToLoad = src.TGT_Schema
										or  xa.TargetToLoad = src.TGT_Layer
		where 1=1	--and  src.TGT_layer != 'his' and src.TGT_layer != 'dwh_audit'
		and xa.TargetToLoad is  null
		and src.DependencyType = 'TgtFromSrc'
		--and SRC_Group = 'kanvas'
		--and src.BK_Target = 'DWH|rpt||Fixed|AggregatedIB|'
	  )
, DWHMe as (
	select  
		  TGT_DWH
		, TGT_Group 
		, TGT_Schema 
		, TGT_Layer
		, [SRC_BK_DataSet]
		, [SRC_DataSet]
		, [SRC_ShortName]
		, [SRC_Group]
		, [SRC_Schema]
		, [SRC_Layer]
		, [generation_number] =   max([generation_number]) 
	from base b
	where 1=1

	Group by
	 [TGT_DWH]
	  , TGT_Group 
		, TGT_Schema 
		, TGT_Layer
		
		,[SRC_BK_DataSet]
		,[SRC_DataSet]
		,[SRC_ShortName]
		,[SRC_Group]
		,[SRC_Schema]
		,[SRC_Layer]
	)
	, final as (
select distinct  
	  src.[TGT_DWH]
	, src.[TGT_DWH] as [TGT]
	, src.TGT_Group
	, src.TGT_Schema
	, src.TGT_Layer
	, src.[SRC_BK_DataSet]
	, src.[SRC_DataSet]
	, src.[SRC_ShortName]
	, SRC_SourceName			= src.SRC_Group + '_' + iif(src.SRC_Schema = 'stg',d.SRC_ShortName, src.SRC_ShortName)
	, SRC_DatasetType			= D.SRC_ObjectType
	, TGT_DatasetType			= D.TGT_ObjectType
	, [SRC_Group]
	, [SRC_Schema]
	, [SRC_Layer] 
	--, [generation_number_pre] = [generation_number]
	, generation_number			= cast([generation_number] as int)-- DENSE_RANK() over(partition by [TGT_DWH] order by [generation_number])
	--, row_num_dataset
	, DependencyType			= 'DWH'
	, [RepositoryStatusName]    = d.RepositoryStatusName
	, [RepositoryStatusCode]	= d.RepositoryStatusCode
from DWHMe src
join bld.vw_Dataset d on src.SRC_BK_DataSet = d.BK
where 1=1
)
select * from final
where 1=1
--and src_dataset like '%ODF%'
--and src.[generation_number] = 1
--and D.TGT_ObjectType = 'Table'
--and src.[SRC_ShortName] = 'internet'
--and src.TGT_Schema = 'dim'
--order by cast(generation_number as int)


;
--select *  from bld.vw_LoadDependency src
--where bk_target like '%ODF%'
--order by generation_number