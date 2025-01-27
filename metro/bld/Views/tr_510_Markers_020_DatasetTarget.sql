



CREATE VIEW [bld].[tr_510_Markers_020_DatasetTarget] AS 
/* 
=== Comments =========================================

Description:
    Creates dataset markers for target datasets. These markers are used to dynamically replace values in templates based on the dataset configurations.

Columns:
    - BK: The business key of the marker.
    - BKBASE: The business key of the base dataset.
    - CODE: The code of the dataset.
    - BKSOURCE: The business key of the source dataset.
    - BKTARGET: The business key of the target dataset.
    - SRC_DATASET: The name of the source dataset.
    - SRC_DATASETSCHEMA: The schema of the source dataset.
    - TGT_BUSINESSDATE: The business date of the target dataset.
    - TGT_RECORDSRCDATE: The record source date of the target dataset.
    - TGT_DATASET: The name of the target dataset.
    - TGT_DATASETGROUPNAME: The group name of the target dataset.
    - TGT_DATASETSCHEMA: The schema of the target dataset.
    - TGT_DATASETSHORTNAME: The short name of the target dataset.
    - TGT_DATASETSHORTNAMESRC: The short name of the source dataset.
    - TGT_FULLLOAD: Indicates if the target dataset is fully loaded.
    - TGT_INSERTONLY: Indicates if the target dataset is insert-only.
    - TGT_INSERTNOCHECK: Indicates if the target dataset has insert no check.
    - TGT_WHERFILTER: The where filter for the target dataset.
    - TGT_TIMESTAMP: The timestamp expression for the target dataset.
    - TGT_PARTITIONSTATEMENT: The partition statement for the target dataset.

Example Usage:
    SELECT * FROM [bld].[tr_510_Markers_020_DatasetTarget]

Logic:
    1. Selects base dataset information.
    2. Joins with relevant views to get additional dataset attributes.
    3. Creates markers for target datasets based on the dataset configurations.

Source Data:
    - [bld].[vw_Dataset]: Contains dataset definitions.
    - [bld].[vw_FileProperties]: Contains file property definitions.
    - [bld].[vw_Attribute]: Contains attribute definitions for datasets.
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Added column [mta_rectype] to Activate SmartLoad
20230409	0839		K. Vermeij				Added the Marker <!<distinct>>
20230616	1554		K. Vermeij				Added marker <!<tgt_insertnocheck>>
20230616	1554		K. Vermeij				Added marker <!<tgt_timestamp>>
20230701	0818		K. Vermeij				Added marker <!<tgt_recordsrcdate>>
20230727	1704		K. Vermeij				added marker <!<tgt_PartitionStatement>>
=======================================================
*/

WITH base AS (

		SELECT DISTINCT
			 bk							= tgt.bk
			, bkbase					= base.bk
			, dd.code 
			, bksource					= src.bk
			, bktarget					= tgt.bk

			, src_dataset				= CAST(src.datasetname					AS varchar(MAX))
			, src_datasetschema			= CAST(src.schemaname					AS varchar(MAX))
			, tgt_businessdate			= CAST(isnull(base.businessdate,'NULL') AS varchar(MAX))
			, tgt_recordsrcdate			= CAST(COALESCE(base.recordsrcdate,fp.dateinfilenameexpression,'mta_loaddate') AS varchar(MAX))
			, tgt_dataset				= CAST(tgt.datasetname					AS varchar(MAX))
			, tgt_datasetgroupname		= CAST(tgt.bk_group						AS varchar(MAX))
			, tgt_datasetschema			= CAST(tgt.schemaname					AS varchar(MAX))
			, tgt_datasetshortname		= CAST(iif(isnull(base.dwhtargetshortname,'')='', base.shortname, base.dwhtargetshortname) AS varchar(MAX))
			, tgt_datasetshortnamesrc	= CAST(base.shortname					AS varchar(MAX))
			, tgt_fullload				= CAST(base.fullload					AS varchar(MAX))
			, tgt_insertonly			= CAST(base.insertonly					AS varchar(MAX))
			, tgt_insertnocheck			= CAST(base.insertnocheck				AS varchar(MAX))
			, tgt_wherefilter			= CAST(base.wherefilter					AS varchar(MAX))
			, tgt_timestampexpression	= CAST(base.[timestamp]					AS varchar(MAX))
			, tgt_partitionstatement	= CAST(base.partitionstatement			AS varchar(MAX))
			, distinctvalues			= CAST(iif(isnull(base.distinctvalues,0) = 0,'', 'Distinct') AS varchar(MAX))
			, scd						= CAST(base.scd							AS varchar(MAX))
			, mta_rectype				= diff.rectype
			, bk_reftype_objecttype		= base.bk_reftype_objecttype
			, objecttypecode			= rto.code

		FROM   bld.vw_dataset base
		JOIN bld.vw_markerssmartload	diff ON diff.code  =  base.code
		JOIN bld.vw_datasetdependency	dd	ON base.code		= dd.code
		JOIN bld.vw_dataset				src ON src.bk		= dd.bk_parent
		JOIN bld.vw_dataset				tgt ON tgt.bk		= dd.bk_child
		JOIN bld.vw_reftype				rto ON rto.bk		= tgt.bk_reftype_objecttype
		LEFT JOIN bld.vw_fileproperties	fp	ON fp.bk		= base.bk
		WHERE 1=1
			AND dd.dependencytype = 'srcTotgt'
			AND dd.mta_source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'
			AND dd.bk_parent != 'src'
			AND base.code=base.bk 
			AND CAST(diff.rectype AS int) > -99

)
, markerbuild AS (
	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_Dataset>>'
		, markervalue			= src.tgt_dataset
		, markerdescription		= 'The name of the target dataset. Example: "[dim].[Common_Asset]"'
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_DatasetGroupName>>'
		, markervalue			= src.tgt_datasetgroupname
		, markerdescription		= 'Groupname of a dataset. Example "Common"'
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_DatasetSchema>>'
		, markervalue			= src.tgt_datasetschema
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<src_datasetschema>>'
		, markervalue			= src.src_datasetschema
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_datasetshortname>>'
		, markervalue			= src.tgt_datasetshortname
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_datasetshortnamesrc>>'
		, markervalue			= src.tgt_datasetshortnamesrc
		, markerdescription		= ''
	FROM base src
	--where src.DatasetShortNamesrc is not null

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<src_dataset>>'
		, markervalue			= src.src_dataset
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_businessdate>>'
		, markervalue			= src.tgt_businessdate
		, markerdescription		= ''
	FROM base src
	--where src.DatasetBusinessDate is not null

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_recordsourcedate>>'
		, markervalue			= src.tgt_recordsrcdate
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<scd>>'
		, markervalue			= src.scd
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<distinct>>'
		, markervalue			= src.distinctvalues
		, markerdescription		= 'In Some cases the dataset delivered isn unique'
	FROM base src
	
	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_wherefilter>>'
		, markervalue			= 'and '+src.tgt_wherefilter
		, markerdescription		= ''
	FROM base src
	--where src.DatasetWhereFilter is not null

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_PartitionStatement>>'
		, markervalue			=  CASE WHEN isnull(ltrim(rtrim(src.tgt_partitionstatement)),'')='' THEN '' ELSE  ',PARTITION('+src.tgt_partitionstatement+')' END
		, markerdescription		= ''
	FROM base src
	--where isnull(ltrim(rtrim(src.tgt_PartitionStatement)),'')!='' and src.ObjectTypeCode = 'T'

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_TimestampExpression>>'
		, markervalue			= isnull(src.tgt_timestampexpression,'null')
		, markerdescription		= ''
	FROM base src
	--where src.DatasetWhereFilter is not null


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_insertonly>>'
		, markervalue			= isnull(src.tgt_insertonly,0)
		, markerdescription		= ''
	FROM base src
	--where src.DatasetInsertOnly is not null

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_insertnocheck>>'
		, markervalue			= isnull(src.tgt_insertnocheck,0)
		, markerdescription		= ''
	FROM base src
	

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<tgt_fullload>>'
		, markervalue			= src.tgt_fullload
		, markerdescription		= ''
	FROM base src
	--where src.DatasetFullLoad is not null

	)
SELECT
	bk					= LEFT(Concat( mb.bk,'|',mb.marker) ,255)
	, bk_dataset		=  mb.bk
	, code				= mb.code
	, markertype		= 'Dynamic'
	, markerdescription
	, mb.marker
	, markervalue		= isnull(mb.markervalue,'/* Marker: '+replace(replace(mb.marker,'<!<','>!>'),'>>','<<')+' not used */')
	, [Pre]				= 0
	, [Post]			= 0
	, mta_rectype		= diff.rectype
FROM markerbuild mb
--join bld.vw_dataset tgt on MB.BK_Dataset_Code = tgt.Code
LEFT JOIN [bld].[vw_MarkersSmartLoad] diff ON diff.code  =  mb.code AND diff.bk = mb.bk
WHERE 1=1
--and marker = '<!<tgt_PartitionStatement>>'