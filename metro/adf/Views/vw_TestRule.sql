
CREATE  VIEW [adf].[vw_TestRule] AS
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
 src.[TestRulesId]
,src.[Code]
,BK_Testrule					= src.[BK]
,src.[BK_Dataset]
,src.[BK_RefType_RepositoryStatus]
,src.[TestDefintion]
,src.[ADFPipeline]
,src.[GetAttributes]
,src.[TresholdValue]
,src.[SpecificAttribute]
,src.[AttributeName]
,src.[ExpectedValue]
,src.[mta_RecType]
,src.[mta_CreateDate]
,src.[mta_Source]
,src.[mta_BK]
,src.[mta_BKH]
,src.[mta_RH]
,src.[mta_IsDeleted]
	, env.Environment
	
	, [RepositoryStatusCode]	= rt.Code
  FROM [bld].[vw_TestRules] src
  LEFT JOIN bld.vw_RefType rt ON src.BK_RefType_RepositoryStatus = rt.BK
  CROSS JOIN [adf].[vw_SDTAP]  env --on env.BK_RepositoryStatus = src.[BK_RefType_RepositoryStatus]
 WHERE 1=1
 --and BK_Dataset = 'SA_DWH|src_file||Grafana|LWAP|'
 -- order by BK_Dataset, [TestDefintion]