CREATE VIEW [adf].[vw_TGT_ShortNameGroup_from_SRC] AS
WITH base AS (
				SELECT 
		  TGT				= src.TGT_DatasetName
		, TGT_BK_Dataset	= src.BK_Target	
		, TGT_ShortName
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
		WHERE DependencyType = 'TgtFromSrc'
)
, LayerMe AS (
	SELECT DISTINCT 
		[TGT_ShortNameGroup] = [TGT_ShortName]+'-'+[tgt_Group]
		,SRC_BK_DataSet
		,[SRC_DataSet]
		,[SRC_ShortName]
		,[SRC_Group]
		,[SRC_Schema]
		,[SRC_Layer]
		,[generation_number] =min([generation_number])
		, 'ShortNameGroup' AS DependencyType
	FROM base b
	WHERE 1=1
	GROUP BY
		 [TGT_ShortName]+'-'+[tgt_Group]
		,SRC_BK_DataSet
		,[SRC_DataSet]
		,[SRC_ShortName]
		,[SRC_Group]
		,[SRC_Schema]
		,[SRC_Layer]
	)
SELECT DISTINCT 
	  [TGT_ShortNameGroup]
	, [TGT]						= [TGT_ShortNameGroup]
	, SRC_BK_DataSet
	, [SRC_DataSet]
	, src.[SRC_ShortName]
		, SRC_SourceName			= src.SRC_Group + '_' + iif(src.SRC_Schema = 'stg',d.SRC_ShortName, src.SRC_ShortName)
	, SRC_DatasetType			= D.SRC_ObjectType
	, TGT_DatasetType			= D.TGT_ObjectType
	, [SRC_Group]
	, [SRC_Schema]
	, [SRC_Layer] 
	, generation_number			=  DENSE_RANK() OVER(PARTITION BY [TGT_ShortNameGroup] ORDER BY [generation_number])
	, DependencyType			= 'ShortNameGroup'
	, [RepositoryStatusName]    = d.RepositoryStatusName
	, [RepositoryStatusCode]	= d.RepositoryStatusCode
FROM LayerMe src
JOIN bld.vw_Dataset d ON src.SRC_BK_DataSet = d.BK
WHERE 1=1