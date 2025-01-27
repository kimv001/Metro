






CREATE VIEW [bld].[tr_100_Dataset_010_DatasetSrc] AS 

/* 
=== Comments =========================================

Description:
    This view selects all defined source datasets and includes various attributes related to the datasets. 
	It is used to prepare the source datasets for further processing and deployment.

Columns:
    - BK: The business key of the dataset.
    - Code: The code of the dataset.
    - DatasetName: The name of the dataset.
    - SchemaName: The name of the schema.
    - DataSource: The data source of the dataset.
    - BK_Schema: The business key of the schema.
    - BK_Group: The business key of the group.
    - BK_Segment: The business key of the segment.
    - BK_Bucket: The business key of the bucket.
    - DatasetName: The name of the dataset.
    - ViewDefinitionContainsBusinessLogic: Indicates if the view definition contains business logic.
    - ViewDefinition: The definition of the view.

Example Usage:
    SELECT * FROM [bld].[tr_100_Dataset_010_DatasetSrc]

Logic:
    1. Selects dataset definitions from the [stg].[DWH_ObjectDefinitions] view.
    2. Prepares the base dataset information.
    3. Joins with other relevant views to get additional dataset attributes.

Source Data:
    - [stg].[DWH_ObjectDefinitions]: Contains object definitions for datasets.
    - [rep].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [rep].[vw_DataSource]: Contains information about data sources.
    - [rep].[vw_Group]: Grouping sets of datasets, mandatory for defining source and transformation datasets.
    - [rep].[vw_Segment]: Organizational grouping of publication tables.
    - [rep].[vw_Bucket]: Defines buckets for organizing datasets.
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20230406	1023		K. Vermeij				Added "ToDeploy	= 0", it will be used to determine if a depplyscript has to be generated
20230409	0821		K. Vermeij				Added Attribute [DistinctValues]
20230616	1524		K. Vermeij				Added InsertNoCheck (for later use in template.... load pst)
20241007	1200		K. Vermeij				Added DataLogisticsGroup, SupplierGroup and ContactGroup
20241007	1330		K. Vermeij				Added view definitions
20241212	0800		K. Vermeij				Added Segments and Buckets
=======================================================
*/
WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.objectschema,'].[',src.objectname,']'))
	, [view_defintion_contains_business_logic]	= src.objectdefinition_contains_business_logic
    , [view_defintion]							= CAST(src.objectdefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 

)

, base AS (
	SELECT  
		  [BK]								= src.[BK]
		, [Code]							= src.[Code]
		, [DatasetName]						= src.[Name]
		, [SchemaName]						= src.[Schema]
		, [DataSource]						= src.[DataSource]
		, [BK_Schema]						= src.[BK_Schema]
		, [BK_Group]						= src.[BK_Group]
		, [BK_Segment]						= ''
		, [BK_Bucket]						= ''
		, [ShortName]						= src.[ShortName]
		, [SRC_ShortName]					= src.[ShortName]
		, [dwhTargetShortName]				= iif(isnull(src.[dwhTargetShortName],'')='', replace(src.[ShortName],'_',''),src.[dwhTargetShortName]) 
		, [Description]						= src.[Description]
		, [BK_ContactGroup]					= src.[BK_ContactGroup]
		, [bk_ContactGroup_Data_Logistics]	= src.[bk_ContactGroup_Data_Logistics]
		, [Data_Logistics_Info]				= src.[Data_Logistics_Info]
		, [bk_ContactGroup_Data_Supplier]	= src.[bk_ContactGroup_Data_Supplier]
		, [Data_Supplier_Info]				= src.[Data_Supplier_Info]
		, [BK_Flow]							= src.[BK_Flow]
		, [TimeStamp]						= src.[TimeStamp]
		, [BusinessDate]					= src.[BusinessDate]
		, [RecordSrcDate]					= src.[RecordSrcDate]
		, [WhereFilter]						= src.[WhereFilter]
		, [PartitionStatement]				= src.[PartitionStatement]
		, [BK_RefType_ObjectType]			= src.[BK_RefType_ObjectType]
		, [FullLoad]						= isnull(src.[FullLoad],'0')
		, [InsertOnly]						= isnull(src.[InsertOnly],'0')
		, [InsertNoCheck]					= isnull(src.[InsertNoCheck],'0')
		, [BigData]							= isnull(src.[BigData],'0')
		, [BK_Template_Load]				= src.[BK_Template_Load]
		, [BK_Template_Create]				= src.[BK_Template_Create]
		, [CustomStagingView]				= src.[CustomStagingView]
		, [BK_RefType_RepositoryStatus]		= src.[BK_RefType_RepositoryStatus]
		, [IsSystem]						= src.[IsSystem]
		, [Prefix]							= src.[Prefix]
		, [PostFix]							= ''
		, [ReplaceAttributeNames]			= ''
		, [SCD]								= ''
		, [DistinctValues]					= isnull(src.[DistinctValues],0)
	FROM [rep].[vw_DatasetSrc] src

	)
SELECT 
	  [BK]										= src.[BK]
	, [Code]									= src.[Code]
	, [DatasetName]								= src.[DatasetName]
	, [SchemaName]								= src.[SchemaName]
	, [DataSource]								= src.[DataSource]
	, [BK_Schema]								= src.[BK_Schema]
	, [BK_Group]								= src.[BK_Group]
	, [BK_Segment]								= src.[BK_Segment]
	, [BK_Bucket]								= src.[BK_Bucket]
	, [ShortName]								= src.[ShortName]
	, [SRC_ShortName]							= src.[SRC_ShortName]
	, [dwhTargetShortName]						= src.[dwhTargetShortName]
	, [ReplaceAttributeNames]					= src.[ReplaceAttributeNames]
	, [Prefix]									= src.[Prefix]
	, [PostFix]									= src.[PostFix]
	, [Description]								= src.[Description]
	, [BK_ContactGroup]							= src.[BK_ContactGroup]
	, [bk_ContactGroup_Data_Logistics]			= src.[bk_ContactGroup_Data_Logistics]
	, [Data_Logistics_Info]						= src.[Data_Logistics_Info]
	, [bk_ContactGroup_Data_Supplier]			= src.[bk_ContactGroup_Data_Supplier]
	, [Data_Supplier_Info]						= src.[Data_Supplier_Info]
	, [BK_Flow]									= src.[BK_Flow]
	, [TimeStamp]								= src.[TimeStamp]
	, [BusinessDate]							= src.[BusinessDate]
	, [RecordSrcDate]							= src.[RecordSrcDate]
	, [WhereFilter]								= src.[WhereFilter]
	, [SCD]										= src.[SCD]
	, [DistinctValues]							= src.[DistinctValues]
	, [PartitionStatement]						= src.[PartitionStatement]
	, [BK_RefType_ObjectType]					= src.[BK_RefType_ObjectType]
	, [FullLoad]								= src.[FullLoad]
	, [InsertOnly]								= src.[InsertOnly]
	, [InsertNoCheck]							= src.[InsertNoCheck]
	, [BigData]									= src.[BigData]
	, [BK_Template_Load]						= src.[BK_Template_Load]
	, [BK_Template_Create]						= src.[BK_Template_Create]
	, [CustomStagingView]						= src.[CustomStagingView]
	, [BK_RefType_RepositoryStatus]				= src.[BK_RefType_RepositoryStatus]
	, [IsSystem]								= src.[IsSystem]
	, [LayerName]								= ss.[LayerName]
	, [BK_LinkedService]						= ss.[BK_LinkedService]
	, [LinkedServiceName]						= ss.linkedservicename
	, [BK_DataSource]							= ss.[BK_DataSource]
	, [BK_Layer]								= ss.[BK_Layer]
	, [CreateDummies]							= ss.[CreateDummies]
	, [FlowOrder]								= CAST(isnull(ss.[LayerOrder],0) AS int) + CAST(isnull(fl.[SortOrder],0) AS int)
	, [FlowOrderDesc]							= 9999
	, [FirstDefaultDWHView]						= 0
	, [DatasetType]								= CAST('SRC' AS varchar(5))
	, [ObjectType]								= rtot.[Name]
	, [SRC_ObjectType]							= rtot.[Name]
	, [TGT_ObjectType]							= CAST('' AS varchar(255))
	, [RepositoryStatusName]					= rtrs.[Name]
	, [RepositoryStatusCode]					= rtrs.code
	, [isDWH]									= ss.[isDWH]
	, [isSRC]									= ss.[isSRC]
	, [isTGT]									= ss.[isTGT]
	, [isRep]									= ss.[IsRep]
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, [ToDeploy]								= 0
FROM base					src
JOIN bld.vw_schema			ss		ON ss.bk			= src.bk_schema
JOIN rep.vw_flowlayer		fl		ON fl.bk_flow		= src.bk_flow 
										AND fl.bk_layer = ss.bk_layer 
										AND (src.bk_schema = fl.bk_schema  OR fl.bk_schema IS null)  
JOIN rep.vw_reftype			rtot	ON rtot.bk			= src.bk_reftype_objecttype
JOIN rep.vw_reftype			rtrs	ON rtrs.bk			= src.bk_reftype_repositorystatus
LEFT JOIN view_logic		vl		ON vl.dataset_name		= src.datasetname
WHERE 1=1