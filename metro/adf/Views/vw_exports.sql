






CREATE view [adf].[vw_exports] as
SELECT 
	 src.[ExportsId]
	,src.[bk]
	,src.[code]
	,src.[export_name]
	,src.[bk_dataset]
	,src.[bk_schema]
	,src.[src_datasetname]
	,src.[src_schema]
	,src.[src_dataset]
	,[bk_schedule] = 'Not applicable over here'
	,src.[container]
	,src.[folder]
	,src.[filename]
	,src.[datetime]
	,src.[bk_fileformat]
	,src.[where_filter]
	,src.[order_by]
	,src.[split_by]
	,src.[FF_Name]
	,src.[FF_Fileformat]
	,src.[FF_ColumnDelimiter]
	,src.[FF_RowDelimiter]
	,src.[FF_QuoteCharacter]
	,src.[FF_CompressionLevel]
	,src.[FF_CompressionType]
	,src.[FF_EnableCDC]
	,src.[FF_EscapeCharacter]
	,src.[FF_FileEncoding]
	,src.[FF_FirstRow]
	,src.[FF_FirstRowAsHeader]
	,src.[mta_RecType]
	,src.[mta_CreateDate]
	,src.[mta_Source]
	,src.[mta_BK]
	,src.[mta_BKH]
	,src.[mta_RH]
	,src.[mta_IsDeleted]
 

  	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.RepositoryStatus

From [bld].[vw_Exports] src
Cross join ADF.vw_SDTAP SDTAP
where 1=1
	and SDTAP.RepositoryStatusCode > -2