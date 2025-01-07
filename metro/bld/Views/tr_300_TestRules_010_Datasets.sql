



CREATE VIEW [bld].[tr_300_TestRules_010_Datasets] AS 

/* 
=== Comments =========================================

Description:
	builds up a test rules definition set 
	
Changelog:
Date		time		Author					Description
20230907	0012		K. Vermeij				Initial
20231031	1521		K.Siva				    Added new columns to the get_datasets,get_schemas,get_datasources
=======================================================
*/

  WITH all_testrules AS (
  SELECT 
	  bk_testdefinition				= td.bk
	, code							= td.code
	, test							= td.test
	, adfpipeline					= td.adfpipeline
	, getattributes					= td.getattributes
	, bk_reftype_objecttype_target	= tr.bk_reftype_objecttype_target
	, bk_datasource					= tr.bk_datasource
	, bk_schema						= tr.bk_schema
	, bk_dataset					= COALESCE(tr.bk_datasetsrc,tr.bk_datasettrn)
	, bk_datasetsrcattribute		= tr.bk_datasetsrcattribute
	, expectedvalue					= COALESCE(tr.expectedvalue,'')
	, tresholdvalue					= COALESCE(tr.tresholdvalue,'')
	, tr.active
	
	, tr.bk_reftype_repositorystatus
  FROM rep.vw_testdefinition td
  JOIN rep.vw_testrule tr	 ON tr.bk_testdefinition					= td.bk
  )
  , get_datasets AS   (
	  SELECT bk = concat(src.bk_testdefinition,'|dataset|',d.bk,'|'+isnull( a.attributename,''))
		, src.test
		, src.adfpipeline
		, src.bk_reftype_repositorystatus
		, src.getattributes
		, bk_dataset = d.bk
		, objecttype			= src.bk_reftype_objecttype_target
		, specificattribute		= sa.attributename
		, attributename			= isnull( a.attributename,'')
		, src.expectedvalue
		, src.tresholdvalue
	  FROM all_testrules src
	  JOIN bld.vw_dataset	d	ON src.bk_dataset							= d.bk		
										AND src.bk_reftype_objecttype_target	= d.bk_reftype_objecttype
										AND src.bk_schema						= d.bk_schema
	LEFT JOIN bld.vw_attribute a	ON  src.getattributes =1 AND a.bk_dataset = d.bk
	LEFT JOIN bld.vw_attribute sa	ON  src.bk_datasetsrcattribute = sa.bk
									
	)									
, get_schemas AS (
	SELECT bk = concat(src.bk_testdefinition,'|schema|',d.bk,'|'+isnull( a.attributename,''))
		, src.test
		, src.adfpipeline
		, src.bk_reftype_repositorystatus
		, src.getattributes
		, bk_dataset			= d.bk
		, objecttype			= src.bk_reftype_objecttype_target
		, specificattribute		= sa.attributename
		, attributename			= isnull( a.attributename,'')
		, src.expectedvalue
		, src.tresholdvalue
	  FROM all_testrules src
	 JOIN bld.vw_dataset	d ON d.bk_schema						= src.bk_schema
									AND src.bk_dataset IS null
									AND src.bk_reftype_objecttype_target = d.bk_reftype_objecttype
	LEFT JOIN bld.vw_attribute a	ON  src.getattributes =1 AND a.bk_dataset = d.bk
	LEFT JOIN bld.vw_attribute sa	ON  src.bk_datasetsrcattribute = sa.bk
	LEFT JOIN get_datasets gd ON d.bk = gd.bk_dataset AND gd.test = src.test
	WHERE gd.bk IS null

					)
, get_datasources AS (
	SELECT bk = concat(src.bk_testdefinition,'|source|',d.bk,'|'+isnull( a.attributename,''))
		, src.test
		, src.adfpipeline
		, src.bk_reftype_repositorystatus
		, src.getattributes
		, bk_dataset = d.bk
		, objecttype			= src.bk_reftype_objecttype_target
		, specificattribute		= sa.attributename
		, attributename			= isnull( a.attributename,'')
		, src.expectedvalue
		, src.tresholdvalue
	  FROM all_testrules src
	 JOIN bld.vw_dataset	d ON d.bk_datasource						= src.bk_datasource
								AND src.bk_dataset IS null
									AND src.bk_reftype_objecttype_target = d.bk_reftype_objecttype
	 LEFT JOIN bld.vw_attribute a	ON  src.getattributes =1 AND a.bk_dataset = d.bk
	 LEFT JOIN bld.vw_attribute sa	ON  src.bk_datasetsrcattribute = sa.bk
	LEFT JOIN get_datasets gd ON d.bk = gd.bk_dataset AND gd.test = src.test
	LEFT JOIN get_schemas  gs ON d.bk = gs.bk_dataset AND gs.test = src.test
	WHERE gd.bk IS null AND gs.bk IS null
)
, all_datasets AS (				
				SELECT * FROM get_datasets
				UNION ALL
				SELECT * FROM get_schemas
				UNION ALL
				SELECT * FROM get_datasources
				)

, final AS (
SELECT 
	  bk							= src.bk
	, bk_dataset					= src.bk_dataset
	, bk_reftype_repositorystatus	= src.bk_reftype_repositorystatus
	, testdefintion					= src.test
	, adfpipeline					= src.adfpipeline
	, getattributes					= COALESCE(src.getattributes,'')
	, tresholdvalue					= src.tresholdvalue
	, specificattribute				= COALESCE(src.specificattribute,'')
	, attributename					= src.attributename
	, expectedvalue					= concat(fp.filesystem,'\', fp.folder,'\', fp.filemask)
FROM all_datasets src
JOIN bld.vw_fileproperties fp		ON fp.bk=  src.bk_dataset
WHERE src.test  = 'File not found'


UNION ALL									

SELECT 
	  bk							= src.bk
	, bk_dataset					= src.bk_dataset
	, bk_reftype_repositorystatus	= src.bk_reftype_repositorystatus
	, testdefintion					= src.test
	, adfpipeline					= src.adfpipeline
	, getattributes					= COALESCE(src.getattributes,'')
	, tresholdvalue					= src.tresholdvalue
	, specificattribute				= COALESCE(src.specificattribute,'')
	, attributename					= src.attributename
	, expectedvalue					= COALESCE(fp.expectedfilesize, src.expectedvalue, '0')
FROM all_datasets src
JOIN bld.vw_fileproperties fp		ON fp.bk=  src.bk_dataset
WHERE src.test  = 'File size less'


UNION ALL									

SELECT 
	  bk							= src.bk
	, bk_dataset					= src.bk_dataset
	, bk_reftype_repositorystatus	= src.bk_reftype_repositorystatus
	, testdefintion					= src.test
	, adfpipeline					= src.adfpipeline
	, getattributes					= COALESCE(src.getattributes,'')
	, tresholdvalue					= src.tresholdvalue
	, specificattribute				= COALESCE(src.specificattribute,'')
	, attributename					= src.attributename
	, expectedvalue					= COALESCE(src.expectedvalue,src.specificattribute,'')
FROM all_datasets src
WHERE src.test  = 'Date Mismatch in File'

UNION ALL									

SELECT 
	  bk							= src.bk
	, bk_dataset					= src.bk_dataset
	, bk_reftype_repositorystatus	= src.bk_reftype_repositorystatus
	, testdefintion					= src.test
	, adfpipeline					= src.adfpipeline
	, getattributes					= COALESCE(src.getattributes,'')
	, tresholdvalue					= src.tresholdvalue
	, specificattribute				= COALESCE(src.specificattribute,'')
	, attributename					= src.attributename
	, expectedvalue					= COALESCE(src.expectedvalue,'')
FROM all_datasets src
WHERE src.test  = 'column Mismatch 1st'

)
SELECT code=bk, * FROM final
WHERE 1=1
--and bk_dataset = 'SA_DWH|src_file||Billing|CareContracts|'
--and BK_Dataset = 'SA_DWH|src_file||Grafana|LWAP|'