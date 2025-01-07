






CREATE VIEW [adf].vw_Connections_Src_Api AS
WITH LinkedServiceProperties AS
	(
		SELECT 
			  BK_LinkedService					=  ls.BK
			, LinkedServiceName					= ls.[Name]
			, lsp.LinkedServicePropertiesName
			, lsp.LinkedServicePropertiesValue 
		FROM rep.vw_LinkedService			ls
		JOIN rep.vw_LinkedServiceProperties lsp ON ls.BK = lsp.BK_LinkedService
	)
, cte_DataSourceProperties_SDTAP_Values AS (
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
	-- first attribute [SRCConnectionName] is legacy
	SRCConnectionName				= src.GroupShortName
	
	, [DWHGroupnameShortname]		= src.[GroupShortName] 
	, [DWHGroupname]				= src.GroupName
	, [DWHShortname]				= dt.ShortName
	, [DWHShortnameSource]			= src.DatasetShortName
	, [SRC_BK_Dataset]				= src.BK_Dataset
	, [TGT_BK_Dataset]				= dt.BK
	, [SRC_DatasetType]				= src.ObjectType
	, [TGT_DatasetType]				= dt.ObjectType
	, [SRC_Schema]					= src.SchemaName
	, [TGT_Schema]					= dt.SchemaName
	, [SRC_Layer]					= src.LayerName
	, [TGT_Layer]					= dt.LayerName
	, [SRC_Dataset]					= src.DatasetName
	, [TGT_Dataset]					= dt.DatasetName
	,[TGT_Tablename] = CONCAT (
		src.GroupName
		,'_'
		,dt.ShortName
		)
	,[SRC_DataSource]				= src.DataSourceName
	,[SRC_DataSourceServer]			= src.DataSourceServer
	,[SRC_DataSourceDatabase]		= src.DataSourceDatabase
	,[SRC_DataSourceURL]			= src.DataSourceURL
	,[SRC_DataSourceUSR]			= src.DataSourceUSR
	,[TGT_DataSource]				= dt.DataSource
	,[TGT_DataSourceServer]			= DSPV.DataSourceServer
	,[TGT_DataSourceDatabase]		= DSPV.DataSourceDatabase
	,[TGT_DataSourceURL]			= DSPV.DataSourceURL
	,[TGT_DataSourceUSR]			= DSPV.DataSourceUSR	  


	, [STG_Container]				= src.[STG_Container]
	, [TGT_Container]				= src.[TGT_Container]
	, [Active]						= src.Active
	, [CoreCount]					= src.[CoreCount]
	,[RepositoryStatusName]			= src.RepositoryStatusName
	,[RepositoryStatusCode]		= src.RepositoryStatusCode
	
	-- Api Info

	, [SRC_DataSourceId]			= src.BK_DataSource
	, LinkedServiceName				= src.LinkedServiceName
	, EnvironmentURL				= dslp_e.LinkedServicePropertiesValue
	, Username						= dslp_u.LinkedServicePropertiesValue	
	, Bigdata						= ISNULL(src.Bigdata,0)
	, DSPV.Environment
	, src.DatasetType
FROM [adf].[vw_Connections_BASE]		src
JOIN bld.vw_DatasetDependency		dd		ON src.BK_Dataset		= dd.BK_Parent
JOIN bld.vw_Dataset					dt		ON dd.BK_child			= dt.BK
LEFT JOIN LinkedServiceProperties	dslp_e	ON dslp_e.BK_LinkedService	= src.BK_LinkedService	AND dslp_e.LinkedServicePropertiesName = 'EnvironmentURL'
LEFT JOIN LinkedServiceProperties	dslp_u	ON dslp_u.BK_LinkedService	= src.BK_LinkedService	AND dslp_u.LinkedServicePropertiesName = 'Username'
LEFT JOIN cte_DataSourceProperties_SDTAP_Values DSPV ON dt.BK_DataSource = DSPV.BK_DataSource AND src.Environment = DSPV.Environment
WHERE 1 = 1
AND src.LayerName	= 'src'	
AND src.DatasetType = 'api'