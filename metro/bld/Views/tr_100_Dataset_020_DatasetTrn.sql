




CREATE view [bld].[tr_100_Dataset_020_DatasetTrn] as 
/* 
=== Comments =========================================

Description:
	All Defined Transformation Datasets are selected. 
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20230406	1023		K. Vermeij				Added "ToDeploy	= 0", it will be used to determine if a deployscript has to be generated
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
		  trn.[BK]
		, [Code] = trn.[BK]
		, DatasetName = trn.[Name]
		--, trn.[Layer]
		, SchemaName						= trn.[Schema]
		, trn.[DataSource]
		, trn.[BK_Schema]
		, trn.[BK_Group]
		, trn.[BK_Segment]				
		, trn.[BK_Bucket]					
		, trn.[ShortName]
		, [dwhTargetShortName]				= ''
		, [Prefix]							= isnull(trn.[Prefix],'')
		, [PostFix]							= Isnull(trn.[PostFix],'')
		, trn.[Description]
		, [BK_ContactGroup]					= trn.[BK_ContactGroup]
			
		, trn.[BK_Flow]
		, trn.[TimeStamp]
		, trn.[BusinessDate]
		, trn.[WhereFilter]
		, trn.[PartitionStatement]
		, trn.[BK_RefType_ObjectType]
		, SCD								=  isnull(SCD.Code,'1')
		, trn.[FullLoad]
		, trn.[InsertOnly]
		, trn.[BigData]
		, trn.[BK_Template_Load]
		, trn.[BK_Template_Create]
		, [CustomStagingView] = null 
		, trn.[BK_RefType_RepositoryStatus]
		, trn.[IsSystem]
		, trn.[mta_RowNum]
		, trn.[mta_BK]
		, trn.[mta_BKH]
		, trn.[mta_RH]
		, trn.[mta_Source]
		, trn.[mta_Loaddate]
	From [rep].[vw_DatasetTrn]	trn
	left join bld.vw_RefType			SCD on trn.BK_RefType_SCD = SCD.BK
	)
select 
	  src.BK
	, src.Code
	, src.DatasetName
	, src.SchemaName
	, LayerName							= ss.LayerName
	, src.DataSource
	, ss.BK_LinkedService
	, LinkedServiceName					= ss.LinkedServiceName
	, ss.BK_DataSource
	, ss.BK_Layer
	, src.BK_Schema
	, src.BK_Group
	, src.[BK_Segment]					
	, src.[BK_Bucket]					
	, src.ShortName
	, src.dwhTargetShortName
	, src.Prefix
	, src.PostFix
	, src.[Description]
	, src.BK_ContactGroup
	, src.BK_Flow
	, FlowOrder							= cast(isnull(ss.LayerOrder,0) as int) + cast(isnull(fl.SortOrder,0) as int)
	, src.[TimeStamp]
	, src.BusinessDate
	, src.SCD
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
	, FirstDefaultDWHView				= 0
	, DatasetType						= Cast('TRN' as varchar(5))
	, ObjectType						= rtOT.[Name]
	, RepositoryStatusName				= rtRS.[Name]
	, RepositoryStatusCode				= rtRS.Code
	, isDWH								= ss.isDWH
	, isSRC								= ss.isSRC
	, isTGT								= ss.isTGT
	, IsRep								= ss.IsRep
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, ToDeploy							= 0
	, CreateDummies						= ss.CreateDummies
from base src
join bld.vw_Schema			ss		on ss.BK			= src.BK_Schema
join rep.vw_FlowLayer		fl		on fl.BK_Flow		= src.BK_Flow 
										and fl.BK_Layer = ss.BK_Layer 
										and (src.BK_Schema = fl.BK_Schema  OR fl.BK_Schema is null) 
join rep.vw_RefType			rtOT	on rtOT.BK				= src.BK_RefType_ObjectType
join rep.vw_RefType			rtRS	on rtRS.BK				= src.BK_RefType_RepositoryStatus
left join view_logic		vl		on vl.dataset_name		= src.DatasetName
Where 1=1
--and src.code  = 'DWH|dim|trvs|Wes|Location|'