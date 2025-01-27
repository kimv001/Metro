





CREATE VIEW [bld].[tr_150_DataTypesBySchema_010_allschemas] AS 
/* 
=== Comments =========================================

Description:
    This view retrieves data types per schema for each data source type. It includes fixed data types for schemas and default data source types if no specific mapping is found.

Columns:
    - BK_SCHEMA: The business key of the schema.
    - DATATYPEMAPPED: The mapped data type for the schema.

Example Usage:
    SELECT * FROM [bld].[tr_150_DataTypesBySchema_010_allschemas]

Logic:
    1. Retrieves fixed data types for schemas.
    2. Selects the default data source type if no specific mapping is found.
    3. Joins with other relevant views to get additional data type mappings.

Source Data:
    - [bld].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [bld].[vw_RefType]: Contains reference types used in the data warehouse.
    - [rep].[vw_DataTypeMapping]: Contains mappings of data types for different data source types.
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20241101	1300		K. Vermeij				Added [DefaultValue]
=======================================================
*/


WITH FIXEDSCHEMADATATYPE AS (

/* get fixed datatypes for scehma's, like "staging" */

	SELECT  
		  BK_SCHEMA				= SS.BK
		, DATATYPEMAPPED		= DTM.DATATYPEBYDATASOURCE
	FROM BLD.VW_SCHEMA				SS
	JOIN BLD.[vw_RefType]			SDT ON SDT.BK				= SS.[BK_RefType_ToChar]
	JOIN BLD.VW_REFTYPE				DST	ON DST.BK				= SS.BK_DATASOURCETYPE
	JOIN REP.VW_DATATYPEMAPPING		DTM ON DTM.BK_REFTYPE_DST	= DST.BK					AND SDT.CODE = DTM.CODE
	JOIN BLD.VW_REFTYPE				DT	ON DT.BK				= DTM.BK_REFTYPE_DATATYPE 
  WHERE SDT.REFTYPE = 'SchemaDataType'

  )
, GENERICDATASOURCETYPE AS (
	-- select the default DataSourceType. This will be used if no datasource Type is mapped in [DataTypeMapping]
	SELECT  
		BK_REFTYPE_DATASOURCETYPE	= R.BK
	FROM BLD.[vw_RefType] R
	WHERE R.REFTYPEABBR = 'DST' AND CAST(R.[isDefault] AS int) = 1
)

, DATATYPEMAPPING AS (

	-- get all datatypes by DataSourceType

	SELECT 
		  BK_SCHEMA					= SS.BK
		, DATATYPEMAPPED			= COALESCE(FD.DATATYPEMAPPED,DTM.DATATYPEBYDATASOURCE, GDTM.DATATYPEBYDATASOURCE)
		, DATATYPEINREP				= COALESCE(DT.CODE,GDTM.DATATYPEBYDATASOURCE)
		, FIXEDSCHEMADATATYPE		= iif(FD.BK_SCHEMA IS null, 0, 1)
		, ORGMAPPEDDATATYPE			= COALESCE(DTM.DATATYPEBYDATASOURCE,GDTM.DATATYPEBYDATASOURCE)
		, DEFAULTVALUE				= COALESCE(DT.DEFAULTVALUE, GDT.DEFAULTVALUE)
	FROM BLD.VW_SCHEMA					SS
	JOIN REP.VW_DATASOURCE				DS		ON DS.BK				= SS.BK_DATASOURCE



	--
	JOIN BLD.VW_REFTYPE					DST		ON DST.BK				= DS.BK_REFTYPE_DATASOURCETYPE
	LEFT JOIN REP.VW_DATATYPEMAPPING	DTM		ON DTM.BK_REFTYPE_DST	= DST.BK
	LEFT JOIN BLD.VW_REFTYPE			DT		ON DT.BK				= DTM.BK_REFTYPE_DATATYPE

	-- DataSourceType zonder specifieke datatypemapping (generic)
	JOIN GENERICDATASOURCETYPE			GDST	ON 1=1
	LEFT JOIN REP.VW_DATATYPEMAPPING	GDTM	ON GDTM.BK_REFTYPE_DST	= GDST.BK_REFTYPE_DATASOURCETYPE AND DTM.BK_REFTYPE_DST IS null
	LEFT JOIN BLD.VW_REFTYPE			GDT		ON GDT.BK				= GDTM.BK_REFTYPE_DATATYPE


	-- Some schema's get a fixed datatype like staging
	LEFT JOIN FIXEDSCHEMADATATYPE		FD		ON SS.BK				= FD.BK_SCHEMA 

)
SELECT DISTINCT
	BK	=  SRC.BK_SCHEMA+'|'+ DATATYPEMAPPED+'|'+DATATYPEINREP
	, CODE = SRC.BK_SCHEMA
	, SRC.BK_SCHEMA
	, SRC.DATATYPEMAPPED
	, SRC.DATATYPEINREP
	, SRC.FIXEDSCHEMADATATYPE
	, SRC.ORGMAPPEDDATATYPE
	, SRC.DEFAULTVALUE

FROM DATATYPEMAPPING SRC