﻿







CREATE VIEW [bld].[tr_650_DatasetTemplates_010_default] AS
/*
View: [bld].[tr_650_DatasetTemplates_010_default]

Description:
    This view builds up the default dataset template definitions. It provides detailed information about which templates need to be filled in for which data warehouse objects.

Columns:
    - BK_TEMPLATE: The business key of the template.
    - BK: The business key of the dataset.
    - CODE: The code of the dataset.
    - TEMPLATETYPE: The type of the template (e.g., Create).
    - TEMPLATESOURCE: The source of the template (e.g., Dataset, FlowLayer).
    - TEMPLATEORDER: The order of the template.
    - BK_REFTYPE_OBJECTTYPE: The business key of the object type reference.
    - TEMPLATESCRIPT: The script of the template.

Example Usage:
    SELECT * FROM [bld].[tr_650_DatasetTemplates_010_default]

Logic:
    1. Selects default templates for datasets.
    2. Selects default templates for flow layers.
    3. Combines the results into a single view.

Source Data:
    - [bld].[vw_Dataset]: Contains dataset definitions.
    - [bld].[vw_Template]: Contains template definitions.
    - [bld].[vw_Schema]: Contains schema definitions.
    - [rep].[vw_FlowLayer]: Contains flow layer definitions.

Changelog:
Date        Time        Author              Description
20220804    00:00       K. Vermeij          Initial version
*/

WITH ALLDEFAULTTEMPLATES AS (
	SELECT 
		  BK_TEMPLATE		= D.[BK_Template_Create]
		  , D.BK
		  , D.CODE
		  , TEMPLATETYPE	= 'Create'
		  , TEMPLATESOURCE	= 'Dataset'
		  , TEMPLATEORDER	= 1
		  , T.BK_REFTYPE_OBJECTTYPE
		  , TEMPLATESCRIPT	= T.SCRIPT
	FROM BLD.VW_DATASET			D
	JOIN BLD.VW_TEMPLATE		T ON T.BK	 = D.BK_TEMPLATE_CREATE
									AND D.BK_REFTYPE_OBJECTTYPE = T.BK_REFTYPE_OBJECTTYPE
	WHERE 1=1
	

	UNION ALL
	
	SELECT 
		  BK_TEMPLATE		= FL.BK_TEMPLATE_CREATE
		  , D.BK
		  , D.CODE
		  , TEMPLATETYPE	= 'Create'
		  , TEMPLATESOURCE	= 'FlowLayer'
		  , TEMPLATEORDER	= 2
		  , T.BK_REFTYPE_OBJECTTYPE
		  , TEMPLATESCRIPT	= T.SCRIPT
	FROM BLD.VW_DATASET			D
	JOIN BLD.VW_SCHEMA			S	ON S.BK				= D.BK_SCHEMA
	JOIN
	    REP.VW_FLOWLAYER		FL
	ON FL.BK_FLOW		= D.BK_FLOW AND ((FL.BK_LAYER = S.BK_LAYER AND FL.BK_SCHEMA = D.BK_SCHEMA) OR (FL.BK_LAYER = S.BK_LAYER AND FL.BK_SCHEMA IS null))
	JOIN BLD.VW_TEMPLATE		T	ON T.BK				= FL.BK_TEMPLATE_CREATE 
									AND D.[BK_RefType_ObjectType]= T.BK_REFTYPE_OBJECTTYPE
	WHERE 1=1

	UNION ALL 

		SELECT 
		  BK_TEMPLATE		=S.BK_TEMPLATE_CREATE
		  , D.BK
		  , D.CODE

		  , TEMPLATETYPE	= 'Create'
		  , TEMPLATESOURCE	= 'Schema'
		  , TEMPLATEORDER	= 3
		  , T.BK_REFTYPE_OBJECTTYPE
		  , TEMPLATESCRIPT	= T.SCRIPT
		 -- ,D.BK_RefType_ObjectType , t.BK_RefType_ObjectType
		 
	FROM BLD.VW_DATASET			D
	JOIN BLD.VW_SCHEMA			S	ON S.BK		= D.BK_SCHEMA
	JOIN BLD.VW_TEMPLATE		T	ON T.BK		= S.BK_TEMPLATE_CREATE
									AND D.BK_REFTYPE_OBJECTTYPE = T.BK_REFTYPE_OBJECTTYPE
								
	WHERE 1=1
	AND D.BK <> D.CODE -- Source Datasets and Transformation Views must not be (re)created
	

	
	UNION ALL
	
		SELECT 
		  BK_TEMPLATE		= D.[BK_Template_Load]
		  , D.BK
		  , D.CODE
		  , TEMPLATETYPE	= 'Load'
		  , TEMPLATESOURCE	= 'Dataset'
		  , TEMPLATEORDER	= 1
		  , T.BK_REFTYPE_OBJECTTYPE
		  , TEMPLATESCRIPT	= T.SCRIPT
	FROM BLD.VW_DATASET			D
	JOIN BLD.VW_TEMPLATE		T ON T.BK	 = D.[BK_Template_Load] 
									AND D.BK_REFTYPE_OBJECTTYPE = T.BK_REFTYPE_OBJECTTYPE_BASEDON
									-- and d.[BK_RefType_ObjectType]= 'OT|T|Table'
	WHERE 1=1


	UNION ALL 

		SELECT 
		  BK_TEMPLATE		= FL.BK_TEMPLATE_LOAD
		  , D.BK
		  , D.CODE
		  , TEMPLATETYPE	= 'Load'
		  , TEMPLATESOURCE	= 'FlowLayer'
		  , TEMPLATEORDER	= 2
		  , T.BK_REFTYPE_OBJECTTYPE
		  , TEMPLATESCRIPT	= T.SCRIPT
	FROM BLD.VW_DATASET			D
	JOIN BLD.VW_SCHEMA			S	ON S.BK				= D.BK_SCHEMA
	JOIN
	    REP.VW_FLOWLAYER		FL
	ON FL.BK_FLOW		= D.BK_FLOW AND ((FL.BK_LAYER = S.BK_LAYER AND FL.BK_SCHEMA = D.BK_SCHEMA) OR (FL.BK_LAYER = S.BK_LAYER AND FL.BK_SCHEMA IS null))
	JOIN BLD.VW_TEMPLATE		T	ON T.BK				= FL.BK_TEMPLATE_LOAD 
									AND D.[BK_RefType_ObjectType]= 'OT|T|Table'
	WHERE 1=1

	UNION ALL 

		SELECT 
		  BK_TEMPLATE		= S.BK_TEMPLATE_LOAD
		  , D.BK
		  , D.CODE
		  , TEMPLATETYPE	= 'Load'
		  , TEMPLATESOURCE	= 'Schema'
		  , TEMPLATEORDER	= 3
		  , T.BK_REFTYPE_OBJECTTYPE
		  , TEMPLATESCRIPT	= T.SCRIPT
	FROM BLD.VW_DATASET			D
	JOIN BLD.VW_SCHEMA			S	ON S.BK		= D.BK_SCHEMA
	JOIN BLD.VW_TEMPLATE		T	ON T.BK	 = S.BK_TEMPLATE_LOAD AND D.[BK_RefType_ObjectType]= 'OT|T|Table'
	WHERE 1=1



	)
, TEMPLATEORDER AS (
SELECT 
	BK						= SRC.BK_TEMPLATE+'|'+SRC.BK
	, CODE					= SRC.CODE
	, BK_TEMPLATE			= SRC.BK_TEMPLATE
	, BK_DATASET			= SRC.BK
	, TEMPLATETYPE			= SRC.TEMPLATETYPE
	, TEMPLATESOURCE		= SRC.TEMPLATESOURCE
	, BK_REFTYPE_OBJECTTYPE	= SRC.BK_REFTYPE_OBJECTTYPE
	, TEMPLATESCRIPT		= SRC.TEMPLATESCRIPT
	, ROWNUM				= ROW_NUMBER() OVER (PARTITION BY SRC.TEMPLATETYPE+'|'+SRC.BK ORDER BY TEMPLATEORDER ASC)
	--, RowNum				= ROW_NUMBER() over (partition by BK_Template+'|'+src.BK order by TemplateOrder asc)
FROM ALLDEFAULTTEMPLATES SRC
)
SELECT
	BK
	, CODE
	, BK_TEMPLATE
	, BK_DATASET
	, TEMPLATETYPE
	, TEMPLATESOURCE
	, BK_REFTYPE_OBJECTTYPE
	, TEMPLATESCRIPT			= CASE 
									WHEN RIGHT(BK_DATASET, 6) = 'custom' THEN '/* User defined view on the database, no deployment desirable. */'
									
									 ELSE TEMPLATESCRIPT
									 END
	, ROWNUM
FROM TEMPLATEORDER
WHERE 1=1
 AND ROWNUM = 1
 --and code = 'SF|SF_API||SF|Netcode__c|'
  --and code = 'DWH|dim|trvs_|Wes|LocationType|'
  --order by 4,1

--and BK_Dataset = 'DWH|stg|vw_|REF|Addresses|Custom'