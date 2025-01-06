
CREATE view [adf].[vw_LoadDependencies] as 
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
 join  bld.vw_Dataset			d_t on src.[BK_Target] = d_t.bk
 join  bld.vw_Dataset			d_s on src.[BK_Source] = d_s.bk
left join cte_DataSourceProperties_SDTAP_Values DSPV on d_t.BK_DataSource = DSPV.BK_DataSource-- and d_s.BK_DataSource = DSPV.BK_DataSource
where 1=1
--and bk_source = 'SF|SF_API||SF|Account|'
--and DSPV.Environment = 'prd'