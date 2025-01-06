












 CREATE  VIEW [adf].[vw_Connections_Base] AS
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



Select 
	BK_Dataset					= d.BK
	, DatasetName				= d.DatasetName
	, Active					= 1
	, DatasetShortName			= d.ShortName
	, GroupShortName			= d.BK_Group + '_' + d.ShortName
	, GroupName					= d.BK_Group
	, SchemaName				= d.SchemaName
	, DatasetType				= d.ObjectType
	, ObjectType				= d.ObjectType
	, DataSourceName			= d.DataSource
	, BK_DataSource				= d.BK_DataSource
	, BK_LinkedService			= d.BK_LinkedService
	, LinkedServiceName			= d.LinkedServiceName
	, DataSourceServer			= DSPV.DataSourceServer
	, DataSourceDatabase		= DSPV.DataSourceDatabase
	, DataSourceURL				= DSPV.DataSourceURL
	, DataSourceUSR				= DSPV.DataSourceUSR
	, LayerName					= d.LayerName
	, STG_Container				= 'staging'
	, TGT_Container				= IIF(d.SchemaName = 'pre_file', 'import', 'archive')
	, CoreCount					= 8 --> sorry nog geen veld voor
	, mta_source				= d.mta_source
	, RepositoryStatusName		= d.RepositoryStatusName
	, RepositoryStatusCode		= d.RepositoryStatusCode
	, Bigdata					= isnull(Bigdata, 0 )
	, Environment				= DSPV.Environment
From bld.vw_Dataset			d
left join cte_DataSourceProperties_SDTAP_Values DSPV on d.BK_DataSource = DSPV.BK_DataSource