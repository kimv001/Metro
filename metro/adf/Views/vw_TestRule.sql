
CREATE  VIEW [adf].[vw_TestRule] AS
with cte_DataSourceProperties_SDTAP_Values as (
	Select 
		src.BK_DataSource
		, src.DataSourceServer
		, src.DataSourceDatabase
		, src.DataSourceURL
		, src.DataSourceUSR
		, src.Environment
	From adf.vw_DataSourceProperties_SDTAP_Values src
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
  left join bld.vw_RefType rt on src.BK_RefType_RepositoryStatus = rt.BK
  cross join [adf].[vw_SDTAP]  env --on env.BK_RepositoryStatus = src.[BK_RefType_RepositoryStatus]
 where 1=1
 --and BK_Dataset = 'SA_DWH|src_file||Grafana|LWAP|'
 -- order by BK_Dataset, [TestDefintion]