



 CREATE VIEW [adf].[vw_DataSourceProperties_SDTAP_Values] AS 

 /*
Developed by:			metro
Description:			Generic transformationview to pivot all DataSourceProperties to SDTAP environment values

Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/

WITH cte_SDTAP AS 
	(
	SELECT * FROM [adf].[vw_DataSourceProperties]
		)
, cte_DataSources AS (
	SELECT *, bk AS BK_DataSource FROM rep.vw_DataSource
	)

, cte_DataSourcePropertiesValues AS (

-- SaNDbox
	SELECT
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer		= ISNULL(ServerName.s, ServerName.x)
		, DataSourceDatabase	= ISNULL(DatabaseName.s, DatabaseName.x)
		, DataSourceURL			= ISNULL(EnvironmentURL.s, EnvironmentURL.x)
		, DataSourceUSR			= ISNULL(DataSourceUSR.s, DataSourceUSR.x)
		, Environment			= 'SND'
	FROM cte_DataSources src
	LEFT JOIN cte_sdtap ServerName		ON src.BK_DataSource = ServerName.BK_DataSource		AND ServerName.[DataSourcePropertiesName]		= 'ServerName'
	LEFT JOIN cte_sdtap DatabaseName	ON src.BK_DataSource = DatabaseName.BK_DataSource		AND DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	LEFT JOIN cte_sdtap EnvironmentURL	ON src.BK_DataSource = EnvironmentURL.BK_DataSource	AND EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	LEFT JOIN cte_sdtap DataSourceUSR	ON src.BK_DataSource = DataSourceUSR.BK_DataSource	AND DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'

UNION ALL

--DEVelopment
	SELECT
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer	= ISNULL(ServerName.d, ServerName.x)
		, DatabaseName		= ISNULL(DatabaseName.d, DatabaseName.x)
		, EnvironmentURL	= ISNULL(EnvironmentURL.d, EnvironmentURL.x)
		, DataSourceUSR		= ISNULL(DataSourceUSR.d, DataSourceUSR.x)
		, Environment		= 'DEV'
	FROM cte_DataSources src
	LEFT JOIN cte_sdtap ServerName		ON src.BK_DataSource = ServerName.BK_DataSource		AND ServerName.[DataSourcePropertiesName]		= 'ServerName'
	LEFT JOIN cte_sdtap DatabaseName	ON src.BK_DataSource = DatabaseName.BK_DataSource		AND DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	LEFT JOIN cte_sdtap EnvironmentURL	ON src.BK_DataSource = EnvironmentURL.BK_DataSource	AND EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	LEFT JOIN cte_sdtap DataSourceUSR	ON src.BK_DataSource = DataSourceUSR.BK_DataSource	AND DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'

UNION ALL

--TeST
	SELECT
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer		= ISNULL(ServerName.t, ServerName.x)
		, DataSourceDatabase	= ISNULL(DatabaseName.t, DatabaseName.x)
		, EnvironmentURL		= ISNULL(EnvironmentURL.t, EnvironmentURL.x)
		, DataSourceUSR			= ISNULL(DataSourceUSR.t, DataSourceUSR.x)
		, Environment			= 'TST'
	FROM cte_DataSources src
	LEFT JOIN cte_sdtap ServerName		ON src.BK_DataSource = ServerName.BK_DataSource		AND ServerName.[DataSourcePropertiesName]		= 'ServerName'
	LEFT JOIN cte_sdtap DatabaseName	ON src.BK_DataSource = DatabaseName.BK_DataSource		AND DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	LEFT JOIN cte_sdtap EnvironmentURL	ON src.BK_DataSource = EnvironmentURL.BK_DataSource	AND EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	LEFT JOIN cte_sdtap DataSourceUSR	ON src.BK_DataSource = DataSourceUSR.BK_DataSource	AND DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'


UNION ALL

-- ACCeptance
	SELECT
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer	= ISNULL(ServerName.a, ServerName.x)
		, DatabaseName		= ISNULL(DatabaseName.a, DatabaseName.x)
		, EnvironmentURL	= ISNULL(EnvironmentURL.a, EnvironmentURL.x)
		, DataSourceUSR		= ISNULL(DataSourceUSR.a, DataSourceUSR.x)
		, Environment		= 'ACC'
	FROM cte_DataSources src
	LEFT JOIN cte_sdtap ServerName		ON src.BK_DataSource = ServerName.BK_DataSource		AND ServerName.[DataSourcePropertiesName]		= 'ServerName'
	LEFT JOIN cte_sdtap DatabaseName	ON src.BK_DataSource = DatabaseName.BK_DataSource		AND DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	LEFT JOIN cte_sdtap EnvironmentURL	ON src.BK_DataSource = EnvironmentURL.BK_DataSource	AND EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	LEFT JOIN cte_sdtap DataSourceUSR	ON src.BK_DataSource = DataSourceUSR.BK_DataSource	AND DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'

UNION ALL

-- PRoDuction
	SELECT
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer	= ISNULL(ServerName.p, ServerName.x)
		, DatabaseName		= ISNULL(DatabaseName.p, DatabaseName.x)
		, EnvironmentURL	= ISNULL(EnvironmentURL.p, EnvironmentURL.x)
		, DataSourceUSR		= ISNULL(DataSourceUSR.p, DataSourceUSR.x)
		, Environment		= 'PRD'
	FROM cte_DataSources src
	LEFT JOIN cte_sdtap ServerName		ON src.BK_DataSource = ServerName.BK_DataSource		AND ServerName.[DataSourcePropertiesName]		= 'ServerName'
	LEFT JOIN cte_sdtap DatabaseName	ON src.BK_DataSource = DatabaseName.BK_DataSource		AND DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	LEFT JOIN cte_sdtap EnvironmentURL	ON src.BK_DataSource = EnvironmentURL.BK_DataSource	AND EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	LEFT JOIN cte_sdtap DataSourceUSR	ON src.BK_DataSource = DataSourceUSR.BK_DataSource	AND DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'
)
SELECT 
	src.BK_DataSource
	, src.IsDWH
		, src.IsRep
	, src.DataSourceServer
	, src.DataSourceDatabase
	, src.DataSourceURL
	, src.DataSourceUSR
	, src.Environment
FROM cte_DataSourcePropertiesValues src