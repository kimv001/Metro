CREATE VIEW [bld].[tr_100_Dataset_035_CustomStagingViews] AS 

/* 
=== Comments =========================================

Description:
    Custom views are added to the repository build to determine dependencies.

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
    - Description: The description of the dataset.
    - BK_Flow: The business key of the flow.
    - Timestamp: The timestamp of the dataset.
    - BusinessDate: The business date of the dataset.
    - WhereFilter: The where filter for the dataset.

Example Usage:
    SELECT * FROM [bld].[tr_100_Dataset_035_CustomStagingViews]

Logic:
    1. Selects dataset definitions from the [stg].[DWH_ObjectDefinitions] view.
    2. Prepares the base dataset information.
    3. Joins with other relevant views to get additional dataset attributes.
    4. Generates custom staging views based on the defined flows.

Source Data:
    - [stg].[DWH_ObjectDefinitions]: Contains object definitions for datasets.
    - [rep].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [rep].[vw_DataSource]: Contains information about data sources.
    - [rep].[vw_Group]: Grouping sets of datasets, mandatory for defining source and transformation datasets.
    - [rep].[vw_Segment]: Organizational grouping of publication tables.
    - [rep].[vw_Bucket]: Defines buckets for organizing datasets.
    - [rep].[vw_Flow]: Defines the flows used in the data warehouse.
    - [rep].[vw_FlowLayer]: Defines the actual flow steps (load pattern).
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230406	1023		K. Vermeij				Added "ToDeploy	= 0", it will be used to determine if a depplyscript has to be generated
=======================================================
*/

WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.objectschema,'].[',src.objectname,']'))
	, [view_defintion_contains_business_logic]	= src.objectdefinition_contains_business_logic
    , [view_defintion]							= CAST(src.objectdefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 
)

,  customstagingviews AS (
	SELECT 
		  bk							= Concat(
		      s.bk,'|','vw_','|', d.bk_group,'|', iif(isnull(d.dwhtargetshortname,'')='', replace(d.shortname,'_',''),d.dwhtargetshortname),'|','Custom'
		  )
		, code							= d.code 
--		, DatasetName					= Quotename('stg')+'.'+Quotename(d.bk_Group+'_'+iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName))
		, datasetname					= QUOTENAME(s.schemaname) + '.[vw_'  + d.bk_group + '_' + replace(d.shortname,'_','') + '_Custom' + ']'
		, schemaname					= s.schemaname
		, layername						= s.layername
		, layerorder					= s.layerorder
		, datasource					= d.datasource
		, bk_schema						= s.bk
		, bk_group						= d.bk_group
		, shortname						= iif(isnull(d.dwhtargetshortname,'')='', replace(d.shortname,'_',''),d.dwhtargetshortname) 
		, dwhtargetshortname			= d.dwhtargetshortname
		, description					= d.description
		, bk_flow						= d.bk_flow
		, timestamp						= d.timestamp
		, businessdate					= d.businessdate
		, wherefilter					= d.wherefilter
		, partitionstatement			= d.partitionstatement
		, [BK_RefType_ObjectType]		= (SELECT bk FROM rep.vw_reftype WHERE reftype='ObjectType' AND [Name] = 'View')
		, fullload						= d.fullload
		, insertonly					= d.insertonly
		, bigdata						= d.bigdata
		, bk_template_load				= ''--case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
		, bk_template_create			= ''--d.BK_Template_Create
		, customstagingview				= d.customstagingview
		, bk_reftype_repositorystatus	= d.bk_reftype_repositorystatus
		, issystem						= d.issystem
		, s.isdwh								
		, s.issrc								
		, s.istgt
		, s.isrep
		, mta_rownum					= ROW_NUMBER() OVER (ORDER BY d.bk)


	--FROM  [bld].[tr_100_Dataset_010_DatasetSrc] D
	--Join bld.vw_Schema		S	on S.bk			= d.BK_Schema

	
	--join bld.vw_RefType		RT	on RT.BK		= D.[BK_RefType_ObjectType]
	--WHERE 1 = 1
	--			AND isnull(d.[CustomStagingView],0) = 1
	FROM [bld].[vw_Dataset] d

	JOIN bld.vw_schema		s	ON s.bk			= d.bk_schema

	
	JOIN rep.vw_reftype		rt	ON rt.bk		= d.[BK_RefType_ObjectType]
	WHERE 1 = 1
				AND isnull(d.[CustomStagingView],0) = 1
				AND s.[Name] = 'stg'

				AND rt.reftype='ObjectType' AND rt.[Name] = 'Table'
				

			)
SELECT 
	  src.[BK]
	, src.[Code]
	, src.[DatasetName]
	, src.[SchemaName]
	, src.[DataSource]
	, ss.bk_linkedservice
	, linkedservicename							= ss.linkedservicename
	, ss.bk_datasource
	, ss.bk_layer
	, src.layername
	, src.[BK_Schema]
	, src.[BK_Group]
	, src.[Shortname]
	, src.[dwhTargetShortName]
	, [Prefix]									= 'vw'
	, [PostFix]									= 'Custom'
	, src.[Description]
	, src.[BK_Flow]
	, floworder									= (src.layerorder + ((fl.sortorder * 10) + 2))
	, src.[TimeStamp]
	, src.[BusinessDate]
	, src.[WhereFilter]
	, src.[PartitionStatement]
	, src.[BK_RefType_ObjectType]
	, src.[FullLoad]
	, src.[InsertOnly]
	, src.[BigData]
	, src.[BK_Template_Load]
	, src.[BK_Template_Create]
	, src.[CustomStagingView]
	, src.[BK_RefType_RepositoryStatus]
	, src.issystem
	, src.isdwh								
	, src.issrc								
	, src.istgt
	, src.isrep
	, firstdefaultdwhview						= 0
	, objecttype								= rtot.[Name]
	, repositorystatusname						= rtrs.[Name]
	, repositorystatuscode						= rtrs.code
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, todeploy									= 0
FROM customstagingviews			src
LEFT JOIN bld.vw_schema			ss		ON ss.bk					= src.bk_schema
LEFT JOIN rep.vw_flowlayer		fl		ON fl.bk_flow				= src.bk_flow 
											AND fl.bk_layer = ss.bk_layer 
											AND (src.bk_schema = fl.bk_schema  OR fl.bk_schema IS null) 
JOIN rep.vw_reftype				rtot	ON rtot.bk					= src.bk_reftype_objecttype
JOIN rep.vw_reftype				rtrs	ON rtrs.bk					= src.bk_reftype_repositorystatus
LEFT JOIN view_logic			vl		ON vl.dataset_name			= src.datasetname
WHERE 1=1
--and src.code  = 'SA_DWH|src_file|Wes|EUAStatus'		