


CREATE VIEW [adf].[vw_Connections_Src_Table] AS
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
	-- first attribute SRCConnectionName is legacy
	  SRCConnectionName							= CASE WHEN dt.LayerName = 'his' THEN CONCAT (
	 													src.GroupName
	 													,'_'
	 													,dt.ShortName
	 													)
													ELSE src.GroupShortName END
	, LinkedServiceName							= dsl.[Name]

	-- SRC	
	, SRC_BK_Dataset							= src.BK_Dataset
	, SRC_DatasetType							= src.DatasetType
	, SRC_Schema								= src.SchemaName
	, SRC_Tablename								= src.DatasetShortName
	, SRC_Dataset								= src.DatasetName
	, SRC_DataSource							= src.DataSourceName
	, SRC_DataSourceServer						= src.DataSourceServer
	, SRC_DataSourceDatabase					= src.DataSourceDatabase
	, SRC_DataSourceURL							= src.DataSourceURL
	, SRC_DataSourceUSR							= src.DataSourceUSR
	, SRC_Layer									= src.LayerName
	, STG_Container								= src.STG_Container
	, SRC_BK_DataSource							= src.BK_DataSource
	, Bigdata									= src.Bigdata
	
	-- TGT	
	, TGT_BK_Dataset							= dt.BK
	, TGT_DatasetType							= dt.DatasetType
	, TGT_Schema								= dt.SchemaName
	, TGT_Tablename								= CONCAT (
	 													src.GroupName
	 													,'_'
	 													,dt.ShortName
	 													)
	, TGT_Dataset								= dt.DatasetName
	, TGT_DataSource							= dt.DataSource
	, TGT_DataSourceServer						= DSPV.DataSourceServer
	, TGT_DataSourceDatabase					= DSPV.DataSourceDatabase
	, TGT_DataSourceURL							= DSPV.DataSourceURL
	, TGT_DataSourceUSR							= DSPV.DataSourceUSR	
	, TGT_Layer									= dt.LayerName
	, TGT_Container								= src.TGT_Container
	, Active									= src.Active

	, RepositoryStatusName						= src.RepositoryStatusName
	, RepositoryStatusCode						= src.RepositoryStatusCode
	, Environment								= DSPV.Environment
	--, dd.BK_Child
	--, dd.BK_Parent
	--, dt.BK_LinkedService
	--, dsl.*
	--, dslp_s.*
	--, dslp_d.*
	--, DSPV.*
FROM adf.vw_Connections_BASE src
JOIN bld.vw_DatasetDependency dd ON src.BK_Dataset = dd.BK_Parent
JOIN bld.vw_Dataset dt ON dd.BK_Child = dt.BK

LEFT JOIN rep.vw_LinkedService dsl ON src.BK_LinkedService = dsl.BK
LEFT JOIN LinkedServiceProperties dslp_s ON dslp_s.BK_LinkedService = dsl.BK
	AND dslp_s.LinkedServicePropertiesName = 'FQ_SQLServerName'
LEFT JOIN LinkedServiceProperties dslp_d ON dslp_d.BK_LinkedService = dsl.BK
	AND dslp_d.LinkedServicePropertiesName = 'DatabaseName'
LEFT JOIN cte_DataSourceProperties_SDTAP_Values DSPV ON dt.BK_DataSource = DSPV.BK_DataSource AND (src.Environment = DSPV.Environment OR src.Environment = 'X')
WHERE 1 = 1
	AND src.LayerName = 'src'
	AND src.DatasetType = 'Table'
	--and  src.GroupShortName =  'ODF_odfBase'
	
	-- and( src.GroupShortName =  'ODF_Base'
	-- --src.GroupShortName ='EDDBTTI_RAP355_2_NOOD_PROCEDURE_ETN_Archive_ExportAzure'
	------and src.GroupShortName = 'WLR_DwhNetworkInfo'
	----or src.groupshortname = 'DWHIB_WbaIb'
	----or src.GroupShortName = 'Teradata_v_sl_network_operator'
	--or src.groupshortname = 'ODF_odfBase'
	--)
	--and DSPV.Environment = 'prd'
	--and src.BK_DataSource = 'EDDB_CPI'