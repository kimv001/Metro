

CREATE VIEW [bld].[tr_350_Exports_010_default] AS 

/* 
=== Comments =========================================

Description:
	build up export definitions
	
Changelog:
Date		time		Author					Description
202400821	1400		K. Vermeij				Initial
=======================================================
*/
SELECT
	  e.[bk]
	, e.[code]
	, export_name					= e.[name]
	, bk_contactgroup				= e.bk_contactgroup
	
	, [bk_dataset]					= ds.bk
	, src_datasetname				= ds.datasetname
	, src_schema					= s.schemaname
	, src_dataset					= concat(ds.bk_group,'_', ds.shortname)
	, src_shortname					= ds.shortname
	, src_group						= ds.bk_group
	, src_layer						= 'out'-- ds.LayerName
	, src_datasettype				= rt.[Name]
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
	, ff_name					= ff.[name]
	, ff_fileformat				= ff.fileformat
	, ff_columndelimiter		= ff.columndelimiter
	, ff_rowdelimiter			= ff.rowdelimiter
	, ff_quotecharacter			= isnull(ff.quotecharacter,'')
	, ff_compressionlevel		= ff.compressionlevel
	, ff_compressiontype		= ff.compressiontype
	, ff_enablecdc				= ff.enablecdc
	, ff_escapecharacter		= ff.escapecharacter
	, ff_fileencoding			= ff.fileencoding
	, ff_firstrow				= ff.[FirstRow]
	, ff_firstrowasheader		= ff.firstrowasheader

	--
	, repositorystatusname				= rtrs.[Name]
	, repositorystatuscode				= rtrs.code
		-- select *
 FROM [rep].[vw_export] e
 LEFT JOIN [rep].[vw_DatasetSrcFileFormat] ff ON e.bk_fileformat = ff.bk
 LEFT JOIN bld.vw_dataset ds ON ds.datasetname = e.bk_dataset  AND ds.bk_reftype_objecttype = 'OT|T|Table'
 LEFT JOIN bld.vw_schema s ON ds.bk_schema = s.bk
 LEFT JOIN bld.vw_reftype rt ON ds.bk_reftype_objecttype	= rt.bk
 JOIN rep.vw_reftype			rtrs	ON rtrs.bk				= e.bk_reftype_repositorystatus

 ;