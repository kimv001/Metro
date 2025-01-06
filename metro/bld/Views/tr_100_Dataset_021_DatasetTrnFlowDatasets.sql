



CREATE view [bld].[tr_100_Dataset_021_DatasetTrnFlowDatasets] as 
/* 
=== Comments =========================================

Description:
	generates datasets based on defined Ttransformation views and defined Flow.

	For Example you defined a transaformation view and attached it to the flow "TR-dim-pub"
	it creates a dimension table based on the transformation view
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20230406	1023		K. Vermeij				Added "ToDeploy	= 1", it will be used to determine if a deployscript has to be generated
20241022	2200		K. Vermeij				Added Postfix to BK
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
	, FlowOrder						= cast(isnull(ts.LayerOrder,0) as int) + (fl.SortOrder * 10)

	, TimeStamp						= d.TimeStamp
	, BusinessDate					= d.BusinessDate
	, SCD							= d.SCD
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
	, mta_RowNum					= Row_Number() over (order by d.BK)
	, createdummies					= isnull(ts.createdummies,0)
		--from [bld].[vw_Dataset]			d
	
		from [bld].[tr_100_Dataset_020_DatasetTrn] d
		join bld.vw_Schema				ss		on ss.BK		= d.BK_Schema

		join rep.vw_FlowLayer fl				on fl.BK_Flow	= d.BK_Flow and (fl.SortOrder > 1 or d.[DatasetName] like '%trvs%')
		-- Get Flow Layer
		join rep.vw_Layer	l					on l.BK			= fl.BK_Layer 

		-- Get target Schema
		left join bld.vw_Schema			ts		on ts.BK		= fl.BK_Schema

		where 1=1
		--and ts.SchemaName = 'snd'

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
	, src.BK_Segment
	, src.BK_Bucket
	, src.[Shortname]
	, src.[dwhTargetShortName]
	, TGT_ObjectType							= iif(lag(rtOT.[Name],1,0) over ( partition by src.code order by src.FlowOrder desc)='0', rtOT.[Name], lag(rtOT.[Name],1,0) over ( partition by src.code order by src.FlowOrder desc) )
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
from DataFlowTables			src
join rep.vw_RefType			rtOT	on rtOT.BK				= src.BK_RefType_ObjectType
join rep.vw_RefType			rtRS	on rtRS.BK				= src.BK_RefType_RepositoryStatus
left join view_logic		vl		on vl.dataset_name		= src.DatasetName
where 1=1