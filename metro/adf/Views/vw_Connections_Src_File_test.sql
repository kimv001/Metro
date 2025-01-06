



CREATE VIEW [adf].[vw_Connections_Src_File_test] AS
with cte_DataSourceProperties_SDTAP_Values as (
	select 
		BK_DataSource	= 	src.BK_DataSource
		, src.DataSourceServer
		, src.DataSourceDatabase
		, src.DataSourceURL
		, src.DataSourceUSR
		, src.Environment
	from adf.vw_DataSourceProperties_SDTAP_Values src
)
SELECT
	-- first attribute [SRCConnectionName] is legacy
	SRCConnectionName				= src.GroupShortName
	,[DWHGroupnameShortname]		= src.[GroupShortName]
	,[DWHGroupname]					= src.GroupName
	,[DWHShortname]					= dt.ShortName
	,[DWHShortnameSource]			= src.DatasetShortName
	,[SRC_BK_Dataset]				= src.BK_Dataset
	,[TGT_BK_Dataset]				= dt.DataSetID
	,[SRC_DatasetType]				= src.DatasetType
	,[TGT_DatasetType]				= dt.DatasetType
	,[SRC_Schema]					= src.SchemaName
	,[TGT_Schema]					= dt.SchemaName
	,[SRC_Layer]					= src.LayerName
	,[TGT_Layer]					= dt.LayerName
	,[SRC_Dataset]					= src.DatasetName
	,[TGT_Dataset]					= dt.DatasetName
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
	,[STG_Container]				= src.[STG_Container]
	,[TGT_Container]				= src.[TGT_Container]
	,[TGT_Folder]					= src.[GroupShortName]
	,[Active]						= src.Active
	,[CoreCount]					= src.[CoreCount]
	-- File MamboJambo
	,[Bigdata]						= src.Bigdata
	,[SRCisPGP]                     = fp.isPGP
	,[SRCContainer]					= lower(fp.FileSystem)
	,[SRCFolder]					= fp.Folder
	,[SRCFileMask]					= fp.FileMask
	,[SRCColumnSeperator]			= fp.FF_ColumnDelimiter
	,[SRCCompressionType]			= fp.FF_CompressionType
	,[SRCCompressionLevel]			= fp.FF_CompressionLevel
	,[SRCEncoding]					= fp.FF_FileEncoding
	,[SRCQuoteCharacter]			= fp.FF_QuoteCharacter
	,[SRCFirstRowAsHeader]			= fp.FF_FirstRowAsHeader
	,[SRCEscapeCharacter]			= fp.FF_EscapeCharacter
	,[SRCSkiplines]					= CASE 
										WHEN fp.FF_FirstRow IS NULL
											THEN NULL
										ELSE (fp.FF_FirstRow - 1)
										END
	,[DateInFileNameStringStartPos] = ISNULL(fp.DateInFileNameStartPos, 1)
	,[DateInFileNameStringLength]	= ISNULL(fp.DateInFileNameLength, 1)
	,[RepositoryStatusName]			= src.RepositoryStatusName
	,[RepositoryStatusCode]			= src.RepositoryStatusCode
	, Environment					=  DSPV.Environment
FROM [adf].[vw_Connections_Base]		src
LEFT JOIN bld.vw_FileProperties		fp	ON src.BK_Dataset		= fp.BK

JOIN bld.vw_DatasetDependency		dd	ON src.BK_Dataset		= dd.BK_Parent
JOIN bld.vw_Dataset					dt	ON dd.BK_Child			= dt.BK

left join cte_DataSourceProperties_SDTAP_Values DSPV on dt.BK_DataSource = DSPV.BK_DataSource and src.Environment = DSPV.Environment
WHERE 1 = 1
	AND src.LayerName = 'src'
	AND src.DatasetType = 'File'