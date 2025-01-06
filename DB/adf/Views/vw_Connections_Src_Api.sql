






create VIEW [adf].vw_Connections_Src_Api AS
with LinkedServiceProperties as
	(
		select 
			  BK_LinkedService					=  ls.BK
			, LinkedServiceName					= ls.[Name]
			, lsp.LinkedServicePropertiesName
			, lsp.LinkedServicePropertiesValue 
		from rep.vw_LinkedService			ls
		join rep.vw_LinkedServiceProperties lsp on ls.BK = lsp.BK_LinkedService
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
select 
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
from [adf].[vw_Connections_BASE]		src
join bld.vw_DatasetDependency		dd		on src.BK_Dataset		= dd.BK_Parent
join bld.vw_Dataset					dt		on dd.BK_child			= dt.BK
left join LinkedServiceProperties	dslp_e	on dslp_e.BK_LinkedService	= src.BK_LinkedService	and dslp_e.LinkedServicePropertiesName = 'EnvironmentURL'
left join LinkedServiceProperties	dslp_u	on dslp_u.BK_LinkedService	= src.BK_LinkedService	and dslp_u.LinkedServicePropertiesName = 'Username'
left join cte_DataSourceProperties_SDTAP_Values DSPV on dt.BK_DataSource = DSPV.BK_DataSource and src.Environment = DSPV.Environment
where 1 = 1
and src.LayerName	= 'src'	
and src.DatasetType = 'api'