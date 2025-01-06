









/****** Object:  View [adf].[Connections_Sto_Table]    Script Date: 11/1/2022 1:28:28 PM ******/
CREATE VIEW [adf].[vw_Connections_Sto_Table] AS
WITH LinkedServiceProperties
AS (
	SELECT 
			BK_LinkedService					= ls.BK
			, LinkedServiceName					= ls.[Name]
			, LinkedServicePropertiesName		= lsp.LinkedServicePropertiesName
			, LinkedServicePropertiesValue		= lsp.LinkedServicePropertiesValue
		FROM rep.vw_LinkedService ls
		JOIN rep.vw_LinkedServiceProperties lsp ON ls.BK = lsp.BK_LinkedService
	)
, cte_DataSourceProperties_SDTAP_Values as (
	select 
		src.BK_DataSource
		, src.DataSourceServer
		, src.DataSourceDatabase
		, src.DataSourceURL
		, src.DataSourceUSR
		, src.Environment
	from adf.vw_DataSourceProperties_SDTAP_Values src
)
SELECT
	-- first attribute [SRCConnectionName] is legacy
	  [SRCConnectionName]						= src.GroupShortName
	, LinkedServiceName							= dsl.[Name]
	, [DWHGroupnameShortname]					= src.[GroupShortName]
	, [Prefix_Groupname_Shortname]				= concat(ds.prefix,'_',ds.bk_group,'_',ds.shortname)  --replace(replace(replace(replace(src.DatasetName,src.SchemaName,''),'.',''),'[',''),']','')
	, [DWHGroupname]							= src.GroupName
	-- SRC	
	, [SRC_BK_Dataset]							= src.BK_Dataset
	, [SRC_DatasetType]							= src.DatasetType
	, [SRC_Schema]								= src.SchemaName
	, [SRC_Tablename]							= src.DatasetShortName
	, [SRC_Dataset]								= src.DatasetName
	, [SRC_DataSource]							= src.DataSourceName
	, [SRC_DataSourceServer]					= src.DataSourceServer
	, [SRC_DataSourceDatabase]					= src.DataSourceDatabase
	, [SRC_DataSourceURL]						= src.DataSourceURL
	, [SRC_DataSourceUSR]						= src.DataSourceUSR
	, [SRC_Layer]								= src.LayerName
	, [STG_Container]							= src.[STG_Container]
	, [SRC_DataSourceId]						= src.BK_DataSource
	-- TGT	
	, [TGT_BK_Dataset]							= dt.BK
	, [TGT_LinkedServiceName]					= dslt.[Name]

	, [TGT_DatasetType]							= dt.DatasetType
	, [TGT_Schema]								= dt.SchemaName
	, [TGT_Tablename]							= CONCAT (
	 														src.GroupName
	 														,'_'
	 														,dt.ShortName
	 														)
	, [TGT_Dataset]								= dt.DatasetName
	, [TGT_DataSource]							= dt.DataSource
	, [TGT_DataSourceServer]					= DSPV.DataSourceServer
	, [TGT_DataSourceDatabase]					= DSPV.DataSourceDatabase
	, [TGT_DataSourceURL]						= DSPV.DataSourceURL
	, [TGT_DataSourceUSR]						= DSPV.DataSourceUSR
	, [TGT_Layer]								= dt.LayerName
	, [TGT_Container]							= src.[TGT_Container]
	, [Active] = src.Active

--    DB Info

	, [RepositoryStatusName]					= src.RepositoryStatusName
	, [RepositoryStatusCode]					= src.RepositoryStatusCode
	, DSPV.Environment
FROM [adf].[vw_Connections_BASE] src
JOIN bld.vw_DatasetDependency dd ON src.BK_Dataset = dd.BK_Parent
LEFT JOIN bld.vw_Dataset dt ON dd.BK_Child = dt.BK
LEFT JOIN bld.vw_Dataset ds ON dd.BK_Parent = ds.BK

LEFT JOIN rep.vw_LinkedService dsl ON dt.BK_LinkedService = dsl.BK
LEFT JOIN rep.vw_LinkedService dslt ON dt.BK_LinkedService = dslt.BK
LEFT JOIN LinkedServiceProperties dslp_s ON dslp_s.BK_LinkedService = dsl.BK
	AND dslp_s.LinkedServicePropertiesName = 'FQ_SQLServerName'
LEFT JOIN LinkedServiceProperties dslp_d ON dslp_d.BK_LinkedService = dsl.BK
	AND dslp_d.LinkedServicePropertiesName = 'DatabaseName'
left join cte_DataSourceProperties_SDTAP_Values DSPV on dt.BK_DataSource = DSPV.BK_DataSource and src.Environment = DSPV.Environment
LEFT JOIN [adf].[vw_DataSourceProperties] dspL ON dt.BK_DataSource = dspl.BK_Datasource 
	AND dspL.[DataSourcePropertiesName] = 'linkedservicename'
WHERE 1 = 1
	--AND src.SchemaName = 'sto'

	AND dt.LayerName IN (
		'TGT'
		,'MDSstg'
		)