





CREATE view [bld].[tr_100_Dataset_030_AddDefaultViews] as 
/* 
=== Comments =========================================

Description:
	generates default flows define in "DefaultDatasetView"

	For Example, when you define a "default" staging view  for all tables in the schema "stg". All thesse views will be created in the repository.
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20230406	1023		K. Vermeij				Added "ToDeploy	= 1", it will be used to determine if a deployscript has to be generated
=======================================================
*/
with view_logic as (
select
	  [dataset_name]							= lower(concat('[',src.ObjectSchema,'].[',src.ObjectName,']'))
	, [view_defintion_contains_business_logic]	= src.ObjectDefinition_contains_business_logic
    , [view_defintion]							= cast(src.ObjectDefinition as varchar(max))
from [stg].[DWH_ObjectDefinitions] src 
)

, DefaultDatasetView as (
	Select 
		  BK								= Concat(s.BK,'|',ISNULL(DDV.prefix + '|', ''), d.BK_Group,'|', iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'|',''),D.dwhTargetShortName),'|',ISNULL( DDV.postfix, '') )
		, Code								= d.code 
		, DatasetName						= QUOTENAME(s.SchemaName) + '.[' + ISNULL(DDV.prefix + '_', '') + d.BK_Group + '_' + replace(d.shortname,'_','') + ISNULL('_' + DDV.postfix, '') + ']'
		, SchemaName						= s.SchemaName
		, LayerName							= s.LayerName
		, DataSource						= s.DataSourceName
		, BK_Schema							= s.BK
		, BK_SchemaBasedOn					= DDV.BK_SchemaBasedOn
		, BK_Group							= d.BK_Group
		, Shortname							= iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName) 
		, dwhTargetShortName				= Isnull(d.dwhTargetShortName,'')
		, [Prefix]							= isnull(ddv.[Prefix],'')
		, [PostFix]							= isnull(ddv.[PostFix],'')
		, [Description]						= d.[Description]
		, [BK_ContactGroup]					= d.[BK_ContactGroup]
		, [bk_ContactGroup_Data_Logistics]	= d.[bk_ContactGroup_Data_Logistics]
		, [Data_Logistics_Info]				= d.[Data_Logistics_Info]
		, [bk_ContactGroup_Data_Supplier]	= d.[bk_ContactGroup_Data_Supplier]
		, [Data_Supplier_Info]				= d.[Data_Supplier_Info]
		, BK_Flow						= d.BK_Flow
		, [TimeStamp]					= d.[TimeStamp]
		, BusinessDate					= d.BusinessDate
		, WhereFilter					= d.WhereFilter
		, PartitionStatement			= d.PartitionStatement
		, [BK_RefType_ObjectType]			= (select BK from rep.vw_Reftype where RefType='ObjectType' and [Name] = 'View')
		, FullLoad						= d.FullLoad
		, InsertOnly					= d.InsertOnly
		, BigData						= d.BigData
		, BK_Template_Load				= null --case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
		, BK_Template_Create			= ddv.BK_Template_Create 
		, CustomStagingView				= d.CustomStagingView
		, BK_RefType_RepositoryStatus	= d.BK_RefType_RepositoryStatus
		, IsSystem						= d.IsSystem
		, mta_RowNum					= Row_Number() over (order by d.BK)
	from [rep].[vw_DefaultDatasetView] DDV
	join bld.vw_schema				s	on s.BK				= DDV.BK_Schema
	
	join bld.vw_Dataset				D	ON  D.BK_Schema		= DDV.BK_SchemaBasedOn
										AND DDV.BK_RefType_TableTypeBasedOn = D.[BK_RefType_ObjectType]
										--and DDV.BK_Schema = D.BK_Schema
	
		where 1=1
		
			)
, Almost as (
	Select 
		  src.[BK]
		, src.[Code]
		, src.[DatasetName]
		, src.[SchemaName]
		, src.[LayerName]
		, src.[DataSource]
		, ss.BK_LinkedService
		, LinkedServiceName					= ss.LinkedServiceName
		, ss.BK_DataSource
		, ss.BK_Layer
		, src.[BK_Schema]
		, src.[BK_Group]
		, src.[Shortname]
		, src.[dwhTargetShortName]
		, src.[Prefix]
		, src.[PostFix]
		, src.[Description]
		, [BK_ContactGroup]					= src.[BK_ContactGroup]
		, [bk_ContactGroup_Data_Logistics]	= src.[bk_ContactGroup_Data_Logistics]
		, [Data_Logistics_Info]				= src.[Data_Logistics_Info]
		, [bk_ContactGroup_Data_Supplier]	= src.[bk_ContactGroup_Data_Supplier]
		, [Data_Supplier_Info]				= src.[Data_Supplier_Info]
		, src.[BK_Flow]

	
		, FlowOrder							= cast(isnull(ss.LayerOrder,0) as int) + ((fl.SortOrder * 10) + 5)
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
		, src.IsSystem
		, ss.isDWH								
		, ss.isSRC								
		, ss.isTGT
		, ss.IsRep

	from DefaultDatasetView src
	join bld.vw_Schema			ss	on  ss.BK			= src.BK_Schema
	join rep.vw_FlowLayer		fl	on  fl.BK_Flow		= src.BK_Flow 
									and fl.BK_Layer		= ss.BK_Layer 
									and (src.BK_Schema	= fl.BK_Schema  
											OR 
											fl.BK_Schema is null
											OR
										-- csl is a default view on a different schema
											src.BK_SchemaBasedOn = fl.BK_Schema
											) 
	
	where 1=1

)
Select 
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
	, src.[Shortname]
	, src.[dwhTargetShortName]
	, src.[Prefix]
	, src.[PostFix]
	, src.[Description]
	, src.[BK_Flow]
	, src.[FlowOrder]
	, src.[TimeStamp]
	, src.[BusinessDate]
	, src.[WhereFilter]
	, src.[PartitionStatement]
	, src.[BK_RefType_ObjectType]
	, src.[FullLoad]
	, src.[InsertOnly]
	, src.[BigData]
	, src.[BK_Template_Load]
	, [BK_Template_Create]						= t.BK
	, src.[CustomStagingView]
	, src.[BK_RefType_RepositoryStatus]
	, src.IsSystem
	, src.isDWH								
	, src.isSRC								
	, src.isTGT
	, FirstDefaultDWHView						= IIF(ROW_NUMBER() over (partition by src.Code Order by FlowOrder asc)=1 and src.LayerName = 'dwh',1,0)
	, ObjectType								= rtOT.[Name]
	, RepositoryStatusName						= rtRS.[Name]
	, RepositoryStatusCode						= rtRS.Code
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, ToDeploy									= 1
From almost src
left join rep.vw_Template	T		on T.BK						= src.BK_Template_Create 
									and t.BK_RefType_ObjectType = src.[BK_RefType_ObjectType]
join rep.vw_RefType			rtOT	on rtOT.BK					= src.BK_RefType_ObjectType
join rep.vw_RefType			rtRS	on rtRS.BK					= src.BK_RefType_RepositoryStatus
left join view_logic		vl		on vl.dataset_name			= src.DatasetName

where 1=1