


CREATE VIEW [bld].[tr_100_Dataset_040_AliasViews] AS 
/* 
=== Comments =========================================

Description:
    This view generates alias views, which can be used for dimension aliases like dim.common_Date with aliases dim.vw_common_StartDate, dim.vw_common_EndDate.

Columns:
    - BK: The business key of the dataset.
    - Code: The code of the dataset.
    - DatasetName: The name of the dataset.
    - SchemaName: The name of the schema.
    - LayerName: The name of the layer.
    - LayerOrder: The order of the layer.
    - DataSource: The data source of the dataset.
    - BK_Schema: The business key of the schema.
    - BK_Group: The business key of the group.
    - ShortName: The short name of the dataset.
    - dwhTargetShortName: The target short name of the dataset in the data warehouse.
    - Prefix: The prefix of the dataset.
    - PostFix: The postfix of the dataset.
    - Description: The description of the dataset.
    - BK_Flow: The business key of the flow.
    - Timestamp: The timestamp of the dataset.
    - BusinessDate: The business date of the dataset.
    - WhereFilter: The where filter for the dataset.
    - PartitionStatement: The partition statement for the dataset.
    - BK_RefType_ObjectType: The business key of the reference type object type.
    - FullLoad: Indicates if the dataset is fully loaded.
    - InsertOnly: Indicates if the dataset is insert-only.
    - BigData: Indicates if the dataset is big data.
    - BK_Template_Load: The business key of the load template.
    - BK_Template_Create: The business key of the create template.
    - CustomStagingView: Indicates if the dataset is a custom staging view.

Example Usage:
    SELECT * FROM [bld].[tr_100_Dataset_040_AliasViews]

Logic:
    1. Selects alias view definitions from the [stg].[DWH_ObjectDefinitions] view.
    2. Prepares the base alias view information.
    3. Joins with other relevant views to get additional alias view attributes.
    4. Generates alias views based on the defined flows.

Source Data:
    - [stg].[DWH_ObjectDefinitions]: Contains object definitions for datasets.
    - [rep].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [rep].[vw_DataSource]: Contains information about data sources.
    - [rep].[vw_Group]: Grouping sets of datasets, mandatory for defining source and transformation datasets.
    - [rep].[vw_Segment]: Organizational grouping of publication tables.
    - [rep].[vw_Bucket]: Defines buckets for organizing datasets.
    - [rep].[vw_Flow]: Defines the flows used in the data warehouse.
    - [rep].[vw_FlowLayer]: Defines the actual flow steps (load pattern).
    - [rep].[vw_RefType]: Contains reference types used in the data warehouse.
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230406	1023		K. Vermeij				Added "ToDeploy	= 1", it will be used to determine if a deployscript has to be generated
=======================================================
*/
WITH  ALIASVIEWS AS (
	SELECT 
		  BK							= A.BK
		, CODE							= D.CODE 
		, DATASETNAME					= Quotename(S.SCHEMANAME)+'.'+Quotename(isnull(A.PREFIX+'_','')+A.SRC_GROUPNAME+'_'+A.TGT_SHORTNAME+isnull('_'+A.POSTFIX,''))

		, SCHEMANAME					= S.SCHEMANAME
		, LAYERNAME						= S.LAYERNAME
		, LAYERORDER					= S.LAYERORDER
		, DATASOURCE					= D.DATASOURCE
		, BK_SCHEMA						= S.BK
		, BK_GROUP						= D.BK_GROUP
		, SHORTNAME						= D.SHORTNAME
		, DWHTARGETSHORTNAME			= A.TGT_SHORTNAME
		, PREFIX						= A.PREFIX
		, POSTFIX						= A.POSTFIX
		, DESCRIPTION					= D.DESCRIPTION
		, BK_FLOW						= D.BK_FLOW
		, TIMESTAMP						= D.TIMESTAMP
		, BUSINESSDATE					= null
		, WHEREFILTER					= D.WHEREFILTER
		, PARTITIONSTATEMENT			= D.PARTITIONSTATEMENT
		, [BK_RefType_ObjectType]		= (SELECT BK FROM REP.VW_REFTYPE WHERE REFTYPE='ObjectType' AND [Name] = 'View')
		, FULLLOAD						= null
		, INSERTONLY					= null
		, BIGDATA						= null
		, BK_TEMPLATE_LOAD				= null
		, BK_TEMPLATE_CREATE			= A.BK_TEMPLATE_CREATE
		, CUSTOMSTAGINGVIEW				= null
		, REPLACEATTRIBUTENAMES			= A.REPLACEATTRIBUTENAMES
		, BK_REFTYPE_REPOSITORYSTATUS	= A.BK_REFTYPE_REPOSITORYSTATUS
		, ISSYSTEM						= D.ISSYSTEM
		, S.ISDWH								
		, S.ISSRC								
		, S.ISTGT
		, S.ISREP
		, MTA_ROWNUM					= ROW_NUMBER() OVER (ORDER BY D.BK)

	FROM REP.VW_ALIASVIEWS A
	JOIN [bld].[vw_Dataset] D ON D.BK			=  A.BK_DATASETTRN

	JOIN BLD.VW_SCHEMA		S	ON S.BK			= D.BK_SCHEMA
	JOIN REP.VW_REFTYPE		RT	ON RT.BK		= D.[BK_RefType_ObjectType]
	WHERE 1 = 1


			)
SELECT 
	  SRC.[BK]
	, SRC.[Code]
	, SRC.[DatasetName]
	, SRC.[SchemaName]
	, SRC.[DataSource]
	, SS.BK_LINKEDSERVICE
	, LINKEDSERVICENAME					= SS.LINKEDSERVICENAME
	, SS.BK_DATASOURCE
	, SS.BK_LAYER
	, SRC.LAYERNAME
	, SRC.[BK_Schema]
	, SRC.[BK_Group]
	, SRC.[Shortname]
	, SRC.[dwhTargetShortName]
	, [Prefix]							= SRC.PREFIX
	, [PostFix]							= SRC.POSTFIX
	, SRC.[Description]
	, SRC.[BK_Flow]
	, FLOWORDER							= CAST(isnull(SRC.LAYERORDER,0) AS int) + ((FL.SORTORDER * 10) + 5) -- (src.LayerOrder + ((fl.SortOrder * 100) + 2))
	, SRC.[TimeStamp]
	, SRC.[BusinessDate]
	, SRC.[WhereFilter]
	, SRC.[PartitionStatement]
	, SRC.[BK_RefType_ObjectType]
	, SRC.[FullLoad]
	, SRC.[InsertOnly]
	, SRC.[BigData]
	, SRC.[BK_Template_Load]
	, SRC.[BK_Template_Create]
	, SRC.[CustomStagingView]
	, SRC.REPLACEATTRIBUTENAMES
	, SRC.[BK_RefType_RepositoryStatus]
	, SRC.ISSYSTEM
	, SRC.ISDWH								
	, SRC.ISSRC								
	, SRC.ISTGT
	, SRC.ISREP
	, FIRSTDEFAULTDWHVIEW				= 0
	, OBJECTTYPE						= RTOT.[Name]
	, REPOSITORYSTATUSNAME				= RTRS.[Name]
	, REPOSITORYSTATUSCODE				= RTRS.CODE
	, TODEPLOY							= 1
FROM ALIASVIEWS SRC
LEFT JOIN BLD.VW_SCHEMA			SS		ON SS.BK			= SRC.BK_SCHEMA

LEFT JOIN REP.VW_FLOWLAYER		FL		ON FL.BK_FLOW		= SRC.BK_FLOW 
											AND FL.BK_LAYER = SS.BK_LAYER 
											AND (SRC.BK_SCHEMA = FL.BK_SCHEMA  OR FL.BK_SCHEMA IS null) 
JOIN REP.VW_REFTYPE				RTOT	ON RTOT.BK			= SRC.BK_REFTYPE_OBJECTTYPE
JOIN REP.VW_REFTYPE				RTRS	ON RTRS.BK			= SRC.BK_REFTYPE_REPOSITORYSTATUS
WHERE 1=1