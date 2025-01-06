





CREATE view [bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets] as 
/* 
=== Comments =========================================

Description:
	generates datasets based on Source Datasets and defined Flow.

	For Example you defined a Source table and attached it to the flow SRC-STG-PST
	it creates a staging table and a persistant staging table
	
	
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

, DataFlowTables as (
SELECT 
	  BK							= Concat(ts.BK,'||', d.BK_Group,'|', iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName) ,'|')
	, Code							= d.code 
	, DatasetName					= Quotename(ts.SchemaName)+'.'+Quotename(d.bk_Group+'_'+iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName))
	, SchemaName					= ts.SchemaName
	, LayerName						= ts.LayerName
	, DataSource					= ts.DataSourceName
	, ts.BK_LinkedService
	, LinkedServiceName				= ts.LinkedServiceName
	, ts.BK_DataSource
	, ts.BK_Layer
	, BK_Schema						= ts.BK
	, BK_Group						= d.BK_Group
	, Shortname						= iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName) 
	, SRC_ShortName					= d.SRC_ShortName
	, SRC_ObjectType				= d.ObjectType
	, dwhTargetShortName			= d.dwhTargetShortName
	, Description					= d.Description
	, [BK_ContactGroup]					= d.[BK_ContactGroup]
	, [bk_ContactGroup_Data_Logistics]	= d.[bk_ContactGroup_Data_Logistics]
	, [Data_Logistics_Info]				= d.[Data_Logistics_Info]
	, [bk_ContactGroup_Data_Supplier]	= d.[bk_ContactGroup_Data_Supplier]
	, [Data_Supplier_Info]				= d.[Data_Supplier_Info]
	, BK_Flow						= d.BK_Flow
	-- If correct configured, it should be ("LayerOrder" + ("FlowOrder" * "10")) 
	, FlowOrder						= cast(isnull(ts.LayerOrder,0) as int) + (fl.SortOrder * 10)
	, TimeStamp						= d.TimeStamp
	, BusinessDate					= d.BusinessDate
	, RecordSrcDate					= d.RecordSrcDate
	, DistinctValues				= isnull(d.DistinctValues,0)
	, WhereFilter					= d.WhereFilter
	, PartitionStatement			= d.PartitionStatement
	, [BK_RefType_ObjectType]			= (select BK from rep.vw_Reftype where RefType='ObjectType' and [Name] = 'Table')
	, FullLoad						= d.FullLoad
	, InsertOnly					= d.InsertOnly
	, BigData						= d.BigData
	, BK_Template_Load				= case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
	, BK_Template_Create			= ''--d.BK_Template_Create
	, CustomStagingView				= d.CustomStagingView
	, BK_RefType_RepositoryStatus	= d.BK_RefType_RepositoryStatus
	, isSystem						= d.IsSystem
	, isDWH							= ts.isDWH
	, isSRC							= ts.isSRC
	, isTGT							= ts.isTGT
	, isRep							= ts.IsRep
	, createdummies					= isnull(ts.createdummies,0)
	, mta_RowNum					= Row_Number() over (order by d.BK)
	
		from [bld].[tr_100_Dataset_010_DatasetSrc] d
		join bld.vw_Schema				ss		on ss.BK		= d.BK_Schema
		join rep.vw_FlowLayer			fl		on fl.BK_Flow	= d.BK_Flow and (fl.SortOrder > 1 )
		-- Get Flow Layer
		join rep.vw_Layer	l					on l.BK			= fl.BK_Layer 

		-- Get target Schema
		left join bld.vw_Schema			ts		on ts.BK		= fl.BK_Schema

			)
Select 
	  src.BK
	, src.Code
	, src.DatasetName
	, src.SchemaName
	, src.LayerName
	, src.DataSource
	, src.BK_DataSource
	, src.BK_LinkedService
	, src.BK_Layer
	, src.BK_Schema
	, src.BK_Group
	, src.Shortname
	, src.SRC_ShortName
	, src.SRC_ObjectType
	, src.dwhTargetShortName
	, PreFix									= ''
	, PostFix									= ''
	, src.[Description]
	, [BK_ContactGroup]							= src.[BK_ContactGroup]
	, [bk_ContactGroup_Data_Logistics]			= src.[bk_ContactGroup_Data_Logistics]
	, [Data_Logistics_Info]						= src.[Data_Logistics_Info]
	, [bk_ContactGroup_Data_Supplier]			= src.[bk_ContactGroup_Data_Supplier]
	, [Data_Supplier_Info]						= src.[Data_Supplier_Info]
	, src.BK_Flow

	, src.FlowOrder
	, FlowOrderDesc								= ROW_NUMBER() over (partition by src.Code order by src.FlowOrder desc)
	, src.[TimeStamp]
	, src.BusinessDate
	, src.RecordSrcDate
	, src.DistinctValues
	, src.WhereFilter
	, src.PartitionStatement
	, src.BK_RefType_ObjectType
	, src.FullLoad
	, src.InsertOnly
	, src.BigData
	, src.BK_Template_Load
	, src.BK_Template_Create
	, src.CustomStagingView
	, src.BK_RefType_RepositoryStatus
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
from DataFlowTables src
join rep.vw_RefType			rtOT	on rtOT.BK				= src.BK_RefType_ObjectType
join rep.vw_RefType			rtRS	on rtRS.BK				= src.BK_RefType_RepositoryStatus
left join view_logic		vl		on vl.dataset_name		= src.DatasetName
where 1=1