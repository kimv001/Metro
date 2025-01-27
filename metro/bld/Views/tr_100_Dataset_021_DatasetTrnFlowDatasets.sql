



CREATE VIEW [bld].[tr_100_Dataset_021_DatasetTrnFlowDatasets] AS 
/* 
=== Comments =========================================

Description:
    This view generates datasets based on defined transformation views and defined flows. 
	For example, if you define a transformation view and attach it to the flow "TR-dim-pub", 
	it creates a dimension table based on the transformation view.

Columns:
    - BK: The business key of the dataset.
    - Code: The code of the dataset.
    - Prefix: The prefix of the dataset.
    - PostFix: The postfix of the dataset.
    - DatasetName: The name of the dataset.
    - SchemaName: The name of the schema.
    - LayerName: The name of the layer.
    - DataSource: The data source of the dataset.
    - BK_LinkedService: The business key of the linked service.
    - LinkedServiceName: The name of the linked service.
    - BK_DataSource: The business key of the data source.
    - BK_Layer: The business key of the layer.
    - BK_Schema: The business key of the schema.
    - ViewDefinitionContainsBusinessLogic: Indicates if the view definition contains business logic.
    - ViewDefinition: The definition of the view.

Example Usage:
    SELECT * FROM [bld].[tr_100_Dataset_021_DatasetTrnFlowDatasets]

Logic:
    1. Selects dataset definitions from the [stg].[DWH_ObjectDefinitions] view.
    2. Prepares the base dataset information.
    3. Joins with other relevant views to get additional dataset attributes.
    4. Generates datasets based on transformation views and defined flows.

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
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20230406	1023		K. Vermeij				Added "ToDeploy	= 1", it will be used to determine if a deployscript has to be generated
20241022	2200		K. Vermeij				Added Postfix to BK
=======================================================
*/
WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.ObjectSchema,'].[',src.ObjectName,']'))
	, [view_defintion_contains_business_logic]	= src.ObjectDefinition_contains_business_logic
    , [view_defintion]							= CAST(src.ObjectDefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 
)

, DataFlowTables AS (
SELECT 
	  BK							= Concat(ts.BK,'||', d.BK_Group,'|', d.ShortName, '|',Isnull(d.[PostFix],'') )
	
	, Code							= d.bk
	, [preFix]						= Isnull(d.[PreFix],'')
	, [PostFix]						= Isnull(d.[PostFix],'')
	, DatasetName					= Quotename(ts.SchemaName)+'.'+Quotename(d.bk_Group +'_'+d.ShortName)
	, SchemaName					= ts.SchemaName
	, LayerName						= ts.LayerName
	, DataSource					= ts.DataSourceName
	, ts.BK_LinkedService
	, LinkedServiceName				= ts.LinkedServiceName
	, ts.BK_DataSource
	, ts.BK_Layer
	, BK_Schema						= ts.BK
	, BK_Group						= d.BK_Group
	, [BK_Segment]					= d.BK_Segment
	, [BK_Bucket]					= d.BK_Bucket
	, Shortname						= d.ShortName
	, dwhTargetShortName			= d.dwhTargetShortName
	, Description					= d.Description
	, [BK_ContactGroup]					= d.[BK_ContactGroup]
	, BK_Flow						= d.BK_Flow

	-- If correct configured, it should be ("LayerOrder" + ("FlowOrder" * "10")) 
	, FlowOrder						= CAST(isnull(ts.LayerOrder,0) AS int) + (fl.SortOrder * 10)

	, TimeStamp						= d.TimeStamp
	, BusinessDate					= d.BusinessDate
	, SCD							= d.SCD
	, WhereFilter					= d.WhereFilter
	, PartitionStatement			= d.PartitionStatement
	, [BK_RefType_ObjectType]			= (SELECT BK FROM rep.vw_Reftype WHERE RefType='ObjectType' AND [Name] = 'Table')
	, FullLoad						= d.FullLoad
	, InsertOnly					= d.InsertOnly
	, BigData						= d.BigData
	, BK_Template_Load				= CASE WHEN l.[Name] != 'pst' THEN d.BK_Template_Load ELSE null END --d.BK_Template_Load
	, BK_Template_Create			= ''--d.BK_Template_Create
	, CustomStagingView				= d.CustomStagingView
	, BK_RefType_RepositoryStatus	= d.BK_RefType_RepositoryStatus
	, isSystem						= d.IsSystem
	, isDWH							= ts.isDWH
	, isSRC							= ts.isSRC
	, isTGT							= ts.isTGT
	, isRep							= ts.IsRep
	, mta_RowNum					= ROW_NUMBER() OVER (ORDER BY d.BK)
	, createdummies					= isnull(ts.createdummies,0)
		--from [bld].[vw_Dataset]			d
	
		FROM [bld].[tr_100_Dataset_020_DatasetTrn] d
		JOIN bld.vw_Schema				ss		ON ss.BK		= d.BK_Schema

		JOIN rep.vw_FlowLayer fl				ON fl.BK_Flow	= d.BK_Flow AND (fl.SortOrder > 1 OR d.[DatasetName] LIKE '%trvs%')
		-- Get Flow Layer
		JOIN rep.vw_Layer	l					ON l.BK			= fl.BK_Layer 

		-- Get target Schema
		LEFT JOIN bld.vw_Schema			ts		ON ts.BK		= fl.BK_Schema

		WHERE 1=1
		--and ts.SchemaName = 'snd'

			)
SELECT 
	  src.[BK]
	, src.[Code]
	, src.[DatasetName]
	, src.[SchemaName]
	, src.[LayerName]
	, src.[DataSource]
	, src.BK_LinkedService
	, src.LinkedServiceName
	, src.BK_DataSource
	, src.BK_Layer
	, src.[BK_Schema]
	, src.[BK_Group]
	, src.BK_Segment
	, src.BK_Bucket
	, src.[Shortname]
	, src.[dwhTargetShortName]
	, TGT_ObjectType							= iif(
	    lag(rtOT.[Name],1,0) OVER ( PARTITION BY src.code ORDER BY src.FlowOrder DESC)='0',
	    rtOT.[Name],
	    lag(rtOT.[Name],1,0) OVER ( PARTITION BY src.code ORDER BY src.FlowOrder DESC)
	)
	, src.[Description]
	, [BK_ContactGroup]							= src.[BK_ContactGroup]
	, src.[BK_Flow]

	, src.FlowOrder
	, src.[TimeStamp]
	, src.[BusinessDate]
	, SRC.SCD
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
	, src.IsSystem
	, src.isDWH								
	, src.isSRC								
	, src.isTGT	
	, src.isRep
	, FirstDefaultDWHView						= 0
	, createdummies
	
	, ObjectType								= rtOT.[Name]
	, RepositoryStatusName						= rtRS.[Name]
	, RepositoryStatusCode						= rtRS.Code
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, ToDeploy									= 1
FROM DataFlowTables			src
JOIN rep.vw_RefType			rtOT	ON rtOT.BK				= src.BK_RefType_ObjectType
JOIN rep.vw_RefType			rtRS	ON rtRS.BK				= src.BK_RefType_RepositoryStatus
LEFT JOIN view_logic		vl		ON vl.dataset_name		= src.DatasetName
WHERE 1=1