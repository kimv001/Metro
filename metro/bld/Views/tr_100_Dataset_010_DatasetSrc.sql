






CREATE view [bld].[tr_100_Dataset_010_DatasetSrc] as 

/* 
=== Comments =========================================

Description:
	All Defined Source Datasets are selected. 
	
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
with view_logic as (
select
	  [dataset_name]							= lower(concat('[',src.ObjectSchema,'].[',src.ObjectName,']'))
	, [view_defintion_contains_business_logic]	= src.ObjectDefinition_contains_business_logic
    , [view_defintion]							= cast(src.ObjectDefinition as varchar(max))
from [stg].[DWH_ObjectDefinitions] src 

)

, Base as (
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

	From [rep].[vw_DatasetSrc] src

	)
select 
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
	, [LinkedServiceName]						= ss.LinkedServiceName
	, [BK_DataSource]							= ss.[BK_DataSource]
	, [BK_Layer]								= ss.[BK_Layer]
	, [CreateDummies]							= ss.[CreateDummies]
	, [FlowOrder]								= cast(isnull(ss.[LayerOrder],0) as int) + cast(isnull(fl.[SortOrder],0) as int)
	, [FlowOrderDesc]							= 9999

	, [FirstDefaultDWHView]						= 0

	, [DatasetType]								= Cast('SRC' as varchar(5))
	, [ObjectType]								= rtOT.[Name]
	, [SRC_ObjectType]							= rtOT.[Name]
	, [TGT_ObjectType]							= cast('' as varchar(255))

	, [RepositoryStatusName]					= rtRS.[Name]
	, [RepositoryStatusCode]					= rtRS.Code
	, [isDWH]									= ss.[isDWH]
	, [isSRC]									= ss.[isSRC]
	, [isTGT]									= ss.[isTGT]
	, [isRep]									= ss.[IsRep]
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
		
	, [ToDeploy]								= 0
	
From base					src
join bld.vw_Schema			ss		on ss.BK			= src.BK_Schema

join rep.vw_FlowLayer		fl		on fl.BK_Flow		= src.BK_Flow 
										and fl.BK_Layer = ss.BK_Layer 
										and (src.BK_Schema = fl.BK_Schema  OR fl.BK_Schema is null)  
join rep.vw_RefType			rtOT	on rtOT.BK			= src.BK_RefType_ObjectType
join rep.vw_RefType			rtRS	on rtRS.BK			= src.BK_RefType_RepositoryStatus
left join view_logic		vl		on vl.dataset_name		= src.DatasetName
Where 1=1