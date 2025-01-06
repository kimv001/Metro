



 CREATE view [adf].[vw_DataSourceProperties_SDTAP_Values] as 

 /*
Developed by:			metro
Description:			Generic transformationview to pivot all DataSourceProperties to SDTAP environment values

Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/

with cte_SDTAP as 
	(
	select * from [adf].[vw_DataSourceProperties]
		)
, cte_DataSources as (
	select *, bk as BK_DataSource from rep.vw_DataSource
	)

, cte_DataSourcePropertiesValues as (

-- SaNDbox
	select
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer		= ISNULL(ServerName.s, ServerName.x)
		, DataSourceDatabase	= ISNULL(DatabaseName.s, DatabaseName.x)
		, DataSourceURL			= ISNULL(EnvironmentURL.s, EnvironmentURL.x)
		, DataSourceUSR			= ISNULL(DataSourceUSR.s, DataSourceUSR.x)
		, Environment			= 'SND'
	from cte_DataSources src
	left join cte_sdtap ServerName		on src.BK_DataSource = ServerName.BK_DataSource		and ServerName.[DataSourcePropertiesName]		= 'ServerName'
	left join cte_sdtap DatabaseName	on src.BK_DataSource = DatabaseName.BK_DataSource		and DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	left join cte_sdtap EnvironmentURL	on src.BK_DataSource = EnvironmentURL.BK_DataSource	and EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	left join cte_sdtap DataSourceUSR	on src.BK_DataSource = DataSourceUSR.BK_DataSource	and DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'

union all

--DEVelopment
	select
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer	= ISNULL(ServerName.d, ServerName.x)
		, DatabaseName		= ISNULL(DatabaseName.d, DatabaseName.x)
		, EnvironmentURL	= ISNULL(EnvironmentURL.d, EnvironmentURL.x)
		, DataSourceUSR		= ISNULL(DataSourceUSR.d, DataSourceUSR.x)
		, Environment		= 'DEV'
	from cte_DataSources src
	left join cte_sdtap ServerName		on src.BK_DataSource = ServerName.BK_DataSource		and ServerName.[DataSourcePropertiesName]		= 'ServerName'
	left join cte_sdtap DatabaseName	on src.BK_DataSource = DatabaseName.BK_DataSource		and DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	left join cte_sdtap EnvironmentURL	on src.BK_DataSource = EnvironmentURL.BK_DataSource	and EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	left join cte_sdtap DataSourceUSR	on src.BK_DataSource = DataSourceUSR.BK_DataSource	and DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'

union all

--TeST
	select
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer		= ISNULL(ServerName.t, ServerName.x)
		, DataSourceDatabase	= ISNULL(DatabaseName.t, DatabaseName.x)
		, EnvironmentURL		= ISNULL(EnvironmentURL.t, EnvironmentURL.x)
		, DataSourceUSR			= ISNULL(DataSourceUSR.t, DataSourceUSR.x)
		, Environment			= 'TST'
	from cte_DataSources src
	left join cte_sdtap ServerName		on src.BK_DataSource = ServerName.BK_DataSource		and ServerName.[DataSourcePropertiesName]		= 'ServerName'
	left join cte_sdtap DatabaseName	on src.BK_DataSource = DatabaseName.BK_DataSource		and DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	left join cte_sdtap EnvironmentURL	on src.BK_DataSource = EnvironmentURL.BK_DataSource	and EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	left join cte_sdtap DataSourceUSR	on src.BK_DataSource = DataSourceUSR.BK_DataSource	and DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'


union all

-- ACCeptance
	select
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer	= ISNULL(ServerName.a, ServerName.x)
		, DatabaseName		= ISNULL(DatabaseName.a, DatabaseName.x)
		, EnvironmentURL	= ISNULL(EnvironmentURL.a, EnvironmentURL.x)
		, DataSourceUSR		= ISNULL(DataSourceUSR.a, DataSourceUSR.x)
		, Environment		= 'ACC'
	from cte_DataSources src
	left join cte_sdtap ServerName		on src.BK_DataSource = ServerName.BK_DataSource		and ServerName.[DataSourcePropertiesName]		= 'ServerName'
	left join cte_sdtap DatabaseName	on src.BK_DataSource = DatabaseName.BK_DataSource		and DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	left join cte_sdtap EnvironmentURL	on src.BK_DataSource = EnvironmentURL.BK_DataSource	and EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	left join cte_sdtap DataSourceUSR	on src.BK_DataSource = DataSourceUSR.BK_DataSource	and DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'

union all

-- PRoDuction
	select
		src.BK_DataSource
		, src.IsDWH
		, src.IsRep
		, DataSourceServer	= ISNULL(ServerName.p, ServerName.x)
		, DatabaseName		= ISNULL(DatabaseName.p, DatabaseName.x)
		, EnvironmentURL	= ISNULL(EnvironmentURL.p, EnvironmentURL.x)
		, DataSourceUSR		= ISNULL(DataSourceUSR.p, DataSourceUSR.x)
		, Environment		= 'PRD'
	from cte_DataSources src
	left join cte_sdtap ServerName		on src.BK_DataSource = ServerName.BK_DataSource		and ServerName.[DataSourcePropertiesName]		= 'ServerName'
	left join cte_sdtap DatabaseName	on src.BK_DataSource = DatabaseName.BK_DataSource		and DatabaseName.[DataSourcePropertiesName]		= 'databaseName'
	left join cte_sdtap EnvironmentURL	on src.BK_DataSource = EnvironmentURL.BK_DataSource	and EnvironmentURL.[DataSourcePropertiesName]	= 'EnvironmentURL'
	left join cte_sdtap DataSourceUSR	on src.BK_DataSource = DataSourceUSR.BK_DataSource	and DataSourceUSR.[DataSourcePropertiesName]	= 'DataSourceUSR'
)
select 
	src.BK_DataSource
	, src.IsDWH
		, src.IsRep
	, src.DataSourceServer
	, src.DataSourceDatabase
	, src.DataSourceURL
	, src.DataSourceUSR
	, src.Environment
from cte_DataSourcePropertiesValues src