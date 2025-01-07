









CREATE VIEW [adf].[vw_TGT_Schema_from_SRC] AS
WITH base AS (
		SELECT 
		  TGT				= src.TGT_DatasetName
		, TGT_BK_Dataset	= src.BK_Target	
		, TGT_Group
		, TGT_Schema
		, TGT_BK_Schema		= TD.BK_Schema
		, TGT_Layer
		, TGT_DWH			= 'All'
		, SRC_BK_DataSet	= src.BK_Source
		, SRC_DataSet		= src.SRC_DatasetName
		, SRC_ShortName		= src.SRC_ShortName
		, SRC_Group			= src.SRC_Group
		, SRC_Schema		= src.SRC_Schema
		, SRC_Layer			= src.SRC_Layer
		  
		,[generation_number]
		FROM bld.vw_LoadDependency	src
		JOIN bld.vw_Dataset			TD	ON src.BK_Target = TD.BK
		WHERE DependencyType = 'TgtFromSrc'
)
, SchemaMe AS (
	SELECT DISTINCT 
		  TGT_BK_Schema
		, TGT_Layer
		, TGT_DWH			= 'All'
		, SRC_BK_DataSet
		, [SRC_DataSet]
		, [SRC_ShortName]
		, [SRC_Group]
		, [SRC_Schema]
		, [SRC_Layer]
		, [generation_number] =min([generation_number])
	FROM base b
	WHERE 1=1
	GROUP BY
		  TGT_BK_Schema
		  , TGT_Layer
		, SRC_BK_DataSet
		, [SRC_DataSet]
		, [SRC_ShortName]
		, [SRC_Group]
		, [SRC_Schema]
		, [SRC_Layer]
	)
SELECT DISTINCT 
	  [TGT_Schema]				= src.TGT_BK_Schema
	  , TGT_Layer				= src.TGT_Layer
	, [TGT]						= src.TGT_BK_Schema
	, SRC_BK_DataSet
	, [SRC_DataSet]
	, src.[SRC_ShortName]
		, SRC_SourceName			= src.SRC_Group + '_' + iif(src.SRC_Schema = 'stg',d.SRC_ShortName, src.SRC_ShortName)
	, SRC_DatasetType			= D.SRC_ObjectType
	, TGT_DatasetType			= D.TGT_ObjectType
	, [SRC_Group]
	, [SRC_Schema]
	, [SRC_Layer] 
	, generation_number			=  DENSE_RANK() OVER(PARTITION BY src.TGT_BK_Schema ORDER BY [generation_number])
	, DependencyType			= 'Schema'
	, [RepositoryStatusName]    = d.RepositoryStatusName
	, [RepositoryStatusCode]	= d.RepositoryStatusCode
FROM SchemaMe src
JOIN bld.vw_Dataset d ON src.SRC_BK_DataSet = d.BK
WHERE 1=1
--and src.TGT_Schema = 'dim'