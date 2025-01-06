

CREATE view [bld].[tr_350_Exports_010_default] as 

/* 
=== Comments =========================================

Description:
	build up export definitions
	
Changelog:
Date		time		Author					Description
202400821	1400		K. Vermeij				Initial
=======================================================
*/
select
	  e.[bk]
	, e.[code]
	, export_name					= e.[name]
	, BK_ContactGroup				= e.BK_ContactGroup
	
	, [bk_dataset]					= ds.bk
	, src_datasetname				= ds.DatasetName
	, src_schema					= s.SchemaName
	, src_dataset					= concat(ds.BK_Group,'_', ds.ShortName)
	, src_shortName					= ds.ShortName
	, src_group						= ds.BK_Group
	, src_layer						= 'out'-- ds.LayerName
	, src_DatasetType				= rt.[Name]
	, [bk_schedule] = ''
	, e.[bk_schema]
	, e.[container]
	, e.[folder]
	, e.[filename]
	, e.[datetime]
	, e.[bk_fileformat]
	, e.[where_filter]
	, e.[order_by]
	, e.[split_by]
	
	-- FileFormat FF
	, FF_Name					= ff.[name]
	, FF_Fileformat				= ff.Fileformat
	, FF_ColumnDelimiter		= ff.ColumnDelimiter
	, FF_RowDelimiter			= ff.RowDelimiter
	, FF_QuoteCharacter			= isnull(ff.QuoteCharacter,'')
	, FF_CompressionLevel		= ff.CompressionLevel
	, FF_CompressionType		= ff.CompressionType
	, FF_EnableCDC				= ff.EnableCDC
	, FF_EscapeCharacter		= ff.EscapeCharacter
	, FF_FileEncoding			= ff.FileEncoding
	, FF_FirstRow				= ff.[FirstRow]
	, FF_FirstRowAsHeader		= ff.FirstRowAsHeader

	--
	, RepositoryStatusName				= rtRS.[Name]
	, RepositoryStatusCode				= rtRS.Code
		-- select *
 from [rep].[vw_export] e
 left join [rep].[vw_DatasetSrcFileFormat] ff on e.bk_fileformat = ff.bk
 left join bld.vw_Dataset ds on ds.datasetname = e.bk_dataset  and ds.BK_RefType_ObjectType = 'OT|T|Table'
 left join bld.vw_Schema s on ds.BK_Schema = s.BK
 left join bld.vw_RefType rt on ds.BK_RefType_ObjectType	= rt.BK
 join rep.vw_RefType			rtRS	on rtRS.BK				= e.BK_RefType_RepositoryStatus

 ;