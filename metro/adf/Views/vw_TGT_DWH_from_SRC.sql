




CREATE  VIEW [adf].[vw_TGT_DWH_from_SRC] AS -- 493

WITH ExcludedFromAll AS 
(
SELECT bk,code,TargetToLoad,ScheduleType FROM bld.vw_Schedules WHERE ExcludeFromAllLevel = 1 --and TargetToLoad = 'kanvas'
)
, base AS (
	SELECT 
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
		FROM bld.vw_LoadDependency src
		LEFT JOIN ExcludedFromAll xa ON xa.TargetToLoad = src.BK_Target
										
										OR xa.TargetToLoad = src.SRC_DatasetName

										OR  xa.TargetToLoad = src.SRC_Group
										 OR xa.TargetToLoad = src.SRC_Schema
										OR  xa.TargetToLoad = src.SRC_Layer
										OR  xa.TargetToLoad = src.TGT_Group
										 OR xa.TargetToLoad = src.TGT_Schema
										OR  xa.TargetToLoad = src.TGT_Layer
		WHERE 1=1	--and  src.TGT_layer != 'his' and src.TGT_layer != 'dwh_audit'
		AND xa.TargetToLoad IS  null
		AND src.DependencyType = 'TgtFromSrc'
		--and SRC_Group = 'kanvas'
		--and src.BK_Target = 'DWH|rpt||Fixed|AggregatedIB|'
	  )
, DWHMe AS (
	SELECT  
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
	FROM base b
	WHERE 1=1

	GROUP BY
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
	, final AS (
SELECT DISTINCT  
	  src.[TGT_DWH]
	, src.[TGT_DWH] AS [TGT]
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
	, generation_number			= CAST([generation_number] AS int)-- DENSE_RANK() over(partition by [TGT_DWH] order by [generation_number])
	--, row_num_dataset
	, DependencyType			= 'DWH'
	, [RepositoryStatusName]    = d.RepositoryStatusName
	, [RepositoryStatusCode]	= d.RepositoryStatusCode
FROM DWHMe src
JOIN bld.vw_Dataset d ON src.SRC_BK_DataSet = d.BK
WHERE 1=1
)
SELECT * FROM final
WHERE 1=1
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