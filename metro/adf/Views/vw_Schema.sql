
CREATE view [adf].[vw_Schema] as
SELECT 
	  src.BK
	, src.Code
	, src.Name
	, src.BK_Schema
	, src.BK_Layer
	, src.BK_DataSource
	, src.BK_LinkedService
	, src.SchemaCode
	, src.SchemaName
	, src.DataSourceCode
	, src.DataSourceName
	, src.BK_DataSourceType
	, src.DataSourceTypeCode
	, src.DataSourceTypeName
	, src.LayerCode
	, src.LayerName
	, src.LayerOrder
	, src.isDWH
	, src.isSRC
	, src.isTGT
	, src.IsRep
	, src.LinkedServiceCode
	, src.LinkedServiceName
	, src.BK_Template_Create
	, src.BK_Template_Load
	, src.BK_RefType_ToChar
	, RepositoryStatusName			= env.RepositoryStatus
	, RepositoryStatusCode			= env.RepositoryStatusCode
	, Environment					= env.Environment
  FROM bld.vw_Schema src
  Cross join [adf].[vw_SDTAP]  env