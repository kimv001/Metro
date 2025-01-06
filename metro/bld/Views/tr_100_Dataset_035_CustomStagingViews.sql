










CREATE view [bld].[tr_100_Dataset_035_CustomStagingViews] as 

/* 
=== Comments =========================================

Description:
	Custom views are added to the repositry build to determine dependencies
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230406	1023		K. Vermeij				Added "ToDeploy	= 0", it will be used to determine if a depplyscript has to be generated
=======================================================
*/

with view_logic as (
select
	  [dataset_name]							= lower(concat('[',src.ObjectSchema,'].[',src.ObjectName,']'))
	, [view_defintion_contains_business_logic]	= src.ObjectDefinition_contains_business_logic
    , [view_defintion]							= cast(src.ObjectDefinition as varchar(max))
from [stg].[DWH_ObjectDefinitions] src 
)

,  CustomStagingViews as (
	SELECT 
		  BK							= Concat(s.bk,'|','vw_','|', d.BK_Group,'|', iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName),'|','Custom' )
		, Code							= d.code 
--		, DatasetName					= Quotename('stg')+'.'+Quotename(d.bk_Group+'_'+iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName))
		, DatasetName					= QUOTENAME(s.SchemaName) + '.[vw_'  + d.BK_Group + '_' + replace(d.shortname,'_','') + '_Custom' + ']'
		, SchemaName					= s.SchemaName
		, LayerName						= s.LayerName
		, LayerOrder					= s.LayerOrder
		, DataSource					= d.DataSource
		, BK_Schema						= s.BK
		, BK_Group						= d.BK_Group
		, Shortname						= iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName) 
		, dwhTargetShortName			= d.dwhTargetShortName
		, Description					= d.Description
		, BK_Flow						= d.BK_Flow
		, TimeStamp						= d.TimeStamp
		, BusinessDate					= d.BusinessDate
		, WhereFilter					= d.WhereFilter
		, PartitionStatement			= d.PartitionStatement
		, [BK_RefType_ObjectType]		= (select BK from rep.vw_Reftype where RefType='ObjectType' and [Name] = 'View')
		, FullLoad						= d.FullLoad
		, InsertOnly					= d.InsertOnly
		, BigData						= d.BigData
		, BK_Template_Load				= ''--case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
		, BK_Template_Create			= ''--d.BK_Template_Create
		, CustomStagingView				= d.CustomStagingView
		, BK_RefType_RepositoryStatus	= d.BK_RefType_RepositoryStatus
		, IsSystem						= d.IsSystem
		, s.isDWH								
		, s.isSRC								
		, s.isTGT
		, s.isRep
		, mta_RowNum					= Row_Number() over (order by d.BK)


	--FROM  [bld].[tr_100_Dataset_010_DatasetSrc] D
	--Join bld.vw_Schema		S	on S.bk			= d.BK_Schema

	
	--join bld.vw_RefType		RT	on RT.BK		= D.[BK_RefType_ObjectType]
	--WHERE 1 = 1
	--			AND isnull(d.[CustomStagingView],0) = 1
	FROM [bld].[vw_Dataset] D

	Join bld.vw_Schema		S	on S.bk			= d.BK_Schema

	
	join rep.vw_RefType		RT	on RT.BK		= D.[BK_RefType_ObjectType]
	WHERE 1 = 1
				AND isnull(d.[CustomStagingView],0) = 1
				and s.[Name] = 'stg'

				and RT.RefType='ObjectType' and RT.[Name] = 'Table'
				

			)
Select 
	  src.[BK]
	, src.[Code]
	, src.[DatasetName]
	, src.[SchemaName]
	, src.[DataSource]
	, ss.BK_LinkedService
	, LinkedServiceName							= ss.LinkedServiceName
	, ss.BK_DataSource
	, ss.BK_Layer
	, src.LayerName
	, src.[BK_Schema]
	, src.[BK_Group]
	, src.[Shortname]
	, src.[dwhTargetShortName]
	, [Prefix]									= 'vw'
	, [PostFix]									= 'Custom'
	, src.[Description]
	, src.[BK_Flow]
	, FlowOrder									= (src.LayerOrder + ((fl.SortOrder * 10) + 2))
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
	, src.isDWH								
	, src.isSRC								
	, src.isTGT
	, src.IsRep
	, FirstDefaultDWHView						= 0
	, ObjectType								= rtOT.[Name]
	, RepositoryStatusName						= rtRS.[Name]
	, RepositoryStatusCode						= rtRS.Code
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, ToDeploy									= 0
from CustomStagingViews			src
left join bld.vw_Schema			ss		on ss.BK					= src.BK_Schema
left join rep.vw_FlowLayer		fl		on fl.BK_Flow				= src.BK_Flow 
											and fl.BK_Layer = ss.BK_Layer 
											and (src.BK_Schema = fl.BK_Schema  OR fl.BK_Schema is null) 
join rep.vw_RefType				rtOT	on rtOT.BK					= src.BK_RefType_ObjectType
join rep.vw_RefType				rtRS	on rtRS.BK					= src.BK_RefType_RepositoryStatus
left join view_logic			vl		on vl.dataset_name			= src.DatasetName
where 1=1
--and src.code  = 'SA_DWH|src_file|Wes|EUAStatus'		