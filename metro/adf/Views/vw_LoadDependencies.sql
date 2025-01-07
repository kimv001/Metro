
CREATE VIEW [adf].[vw_LoadDependencies] AS 
WITH cte_DataSourceProperties_SDTAP_Values AS (
	SELECT 
		src.BK_DataSource
		, src.DataSourceServer
		, src.DataSourceDatabase
		, src.DataSourceURL
		, src.DataSourceUSR
		, src.Environment
	FROM adf.vw_DataSourceProperties_SDTAP_Values src
)

SELECT 
	 src.[LoadDependencyId]
	,src.[BK]
	,src.[Code]
	,src.[BK_Target]
	,src.[TGT_Layer]
	,src.[TGT_Schema]
	,src.[TGT_Group]
	,src.[TGT_ShortName]
	,src.[TGT_Code]
	,src.[TGT_DatasetName]
	,src.[BK_Source]
	,src.[SRC_Layer]
	,src.[SRC_Schema]
	,src.[SRC_Group]
	,src.[SRC_ShortName]
	,src.[SRC_Code]
	,src.[SRC_DatasetName]
	,src.[DependencyType]
	,src.[Generation_Number]
	,src.[mta_RecType]
	,src.[mta_CreateDate]
	,src.[mta_Source]
	,src.[mta_BK]
	,src.[mta_BKH]
	,src.[mta_RH]
	,src.[mta_IsDeleted]
	, RepositoryStatusName		= d_t.RepositoryStatusName --case when d_t.RepositoryStatusName = d_t.RepositoryStatusName then
	, RepositoryStatusCode		= d_t.RepositoryStatusCode
	, Environment				= DSPV.Environment
  FROM [bld].[vw_LoadDependency] src
 JOIN  bld.vw_Dataset			d_t ON src.[BK_Target] = d_t.bk
 JOIN  bld.vw_Dataset			d_s ON src.[BK_Source] = d_s.bk
LEFT JOIN cte_DataSourceProperties_SDTAP_Values DSPV ON d_t.BK_DataSource = DSPV.BK_DataSource-- and d_s.BK_DataSource = DSPV.BK_DataSource
WHERE 1=1
--and bk_source = 'SF|SF_API||SF|Account|'
--and DSPV.Environment = 'prd'