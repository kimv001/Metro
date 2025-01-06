
Create view [adf].[vw_DataSourceProperties] as

/*
Developed by:			metro
Description:			Generic transformationview to pivot all DataSourceProperties to DTAP environment values

Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/

select 
	  BK_Datasource
	, DataSourceName
	, BK_LinkedService
	, DataSourcePropertiesName
	, CurrentEnvironment					= CASE WHEN right(CAST(SERVERPROPERTY( 'ServerName' ) as varchar),3)='ROD' THEN 'PRD' ELSE right(CAST(SERVERPROPERTY( 'ServerName' ) as varchar),3) END
	, DataSourcePropertiesCurrentValue		= CASE 
												WHEN right(CAST(SERVERPROPERTY( 'ServerName' ) as varchar),3)='dev' then ISNULL([D],[X])
												WHEN right(CAST(SERVERPROPERTY( 'ServerName' ) as varchar),3)='tst' then ISNULL([T],[X])
												WHEN right(CAST(SERVERPROPERTY( 'ServerName' ) as varchar),3)='acc' then ISNULL([A],[X])
												WHEN right(CAST(SERVERPROPERTY( 'ServerName' ) as varchar),3)='rod' then ISNULL([P],[X])
												WHEN right(CAST(SERVERPROPERTY( 'ServerName' ) as varchar),3)='box' then ISNULL([S],[X])
												ELSE 'Unknown'
												END
	

	, D = ISNULL([D],[X])
	, T = ISNULL([T],[X])
	, A = ISNULL([A],[X])
	, P = ISNULL([P],[X])
	, X = [X] -- default value for all DTAP
	, S = ISNULL([S],[X]) -- Sandbox environment
	
	from (

			Select 
				BK_Datasource						= ds.bk
				, BK_LinkedService					= ds.BK_LinkedService
				, DataSourceName					= ds.[Name]
				, DataSourcePropertiesName			= src.DataSourcePropertiesName
				, DataSourcePropertiesValue			= src.DataSourcePropertiesValue
				, DataSourcePropertiesEnvironment	= rt.code
			  From  rep.vw_DataSource				ds
			  join rep.vw_DataSourceProperties		src	on src.BK_Datasource	= ds.bk
			  join rep.vw_refType					rt	on rt.bk				= src.bk_RefType_Environment
			  ) dsp
Pivot (
									max([DataSourcePropertiesValue])
							
for [DataSourcePropertiesEnvironment] IN 
			([D],[T],[A],[P],[X], [S])
		)	as pivot_table