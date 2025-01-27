

CREATE VIEW [bld].[tr_350_Exports_010_default] AS 

/* 
=== Comments =========================================

Description:
    Build up export definitions.

Columns:
    - bk: The business key of the export.
    - code: The code of the export.
    - export_name: The name of the export.
    - bk_contactgroup: The business key of the contact group.
    - bk_dataset: The business key of the dataset.
    - src_datasetname: The name of the source dataset.
    - src_schema: The schema of the source dataset.
    - src_dataset: The source dataset.
    - src_shortname: The short name of the source dataset.
    - src_group: The group of the source dataset.
    - src_layer: The layer of the source dataset.
    - src_datasettype: The type of the source dataset.
    - bk_schedule: The business key of the schedule.
    - bk_schema: The business key of the schema.
    - container: The container for the export.
    - folder: The folder for the export.
    - filename: The filename for the export.
    - datetime: The datetime for the export.
    - bk_fileformat: The business key of the file format.
    - where_filter: The where filter for the export.
    - order_by: The order by clause for the export.
    - split_by: The split by clause for the export.
    - ff_name: The name of the file format.
    - ff_fileformat: The file format.
    - ff_columndelimiter: The column delimiter for the file format.
    - ff_rowdelimiter: The row delimiter for the file format.
    - ff_quotecharacter: The quote character for the file format.
    - ff_compressionlevel: The compression level for the file format.

Example Usage:
    SELECT * FROM [bld].[tr_350_Exports_010_default]

Logic:
    1. Selects export definitions from the [rep].[vw_Export] view.
    2. Joins with the [rep].[vw_Dataset] view to get dataset information.
    3. Joins with the [rep].[vw_Schema] view to get schema information.
    4. Joins with the [rep].[vw_FileFormat] view to get file format information.

Source Data:
    - [rep].[vw_Export]: Contains definitions for exports.
    - [rep].[vw_Dataset]: Contains dataset definitions.
    - [rep].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [rep].[vw_FileFormat]: Contains definitions for file formats.
	
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