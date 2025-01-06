


CREATE view [bld].[tr_100_Dataset_040_AliasViews] as 
/* 
=== Comments =========================================

Description:
	generates alias views, can be used for dimension aliases like dim.common_Date with aliases dim.vw_common_StartDatde, dim.vw_common_EndDate

	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230406	1023		K. Vermeij				Added "ToDeploy	= 1", it will be used to determine if a deployscript has to be generated
=======================================================
*/
WITH  AliasViews as (
	SELECT 
		  BK							= a.bk
		, Code							= d.code 
		, DatasetName					= Quotename(s.SchemaName)+'.'+Quotename(isnull(a.Prefix+'_','')+a.SRC_GroupName+'_'+a.TGT_ShortName+isnull('_'+a.postfix,''))

		, SchemaName					= s.SchemaName
		, LayerName						= s.LayerName
		, LayerOrder					= s.LayerOrder
		, DataSource					= d.DataSource
		, BK_Schema						= s.BK
		, BK_Group						= d.BK_Group
		, Shortname						= d.ShortName
		, dwhTargetShortName			= a.TGT_ShortName
		, Prefix						= a.Prefix
		, Postfix						= a.Postfix
		, Description					= d.Description
		, BK_Flow						= d.BK_Flow
		, TimeStamp						= d.TimeStamp
		, BusinessDate					= null
		, WhereFilter					= d.WhereFilter
		, PartitionStatement			= d.PartitionStatement
		, [BK_RefType_ObjectType]		= (select BK from rep.vw_Reftype where RefType='ObjectType' and [Name] = 'View')
		, FullLoad						= null
		, InsertOnly					= null
		, BigData						= null
		, BK_Template_Load				= null
		, BK_Template_Create			= a.BK_Template_Create
		, CustomStagingView				= null
		, ReplaceAttributeNames			= a.ReplaceAttributeNames
		, BK_RefType_RepositoryStatus	= a.BK_RefType_RepositoryStatus
		, IsSystem						= d.IsSystem
		, s.isDWH								
		, s.isSRC								
		, s.isTGT
		, s.IsRep
		, mta_RowNum					= Row_Number() over (order by d.BK)

	FROM rep.vw_AliasViews a
	join [bld].[vw_Dataset] D on d.bk			=  a.BK_DatasetTrn

	Join bld.vw_Schema		S	on S.bk			= d.BK_Schema
	join rep.vw_RefType		RT	on RT.BK		= D.[BK_RefType_ObjectType]
	WHERE 1 = 1


			)
Select 
	  src.[BK]
	, src.[Code]
	, src.[DatasetName]
	, src.[SchemaName]
	, src.[DataSource]
	, ss.BK_LinkedService
	, LinkedServiceName					= ss.LinkedServiceName
	, ss.BK_DataSource
	, ss.BK_Layer
	, src.LayerName
	, src.[BK_Schema]
	, src.[BK_Group]
	, src.[Shortname]
	, src.[dwhTargetShortName]
	, [Prefix]							= src.Prefix
	, [PostFix]							= src.Postfix
	, src.[Description]
	, src.[BK_Flow]
	, FlowOrder							= cast(isnull(src.LayerOrder,0) as int) + ((fl.SortOrder * 10) + 5) -- (src.LayerOrder + ((fl.SortOrder * 100) + 2))
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
	, src.ReplaceAttributeNames
	, src.[BK_RefType_RepositoryStatus]
	, src.IsSystem
	, src.isDWH								
	, src.isSRC								
	, src.isTGT
	, src.IsRep
	, FirstDefaultDWHView				= 0
	, ObjectType						= rtOT.[Name]
	, RepositoryStatusName				= rtRS.[Name]
	, RepositoryStatusCode				= rtRS.Code
	, ToDeploy							= 1
from AliasViews src
left join bld.vw_Schema			ss		on ss.BK			= src.BK_Schema

left join rep.vw_FlowLayer		fl		on fl.BK_Flow		= src.BK_Flow 
											and fl.BK_Layer = ss.BK_Layer 
											and (src.BK_Schema = fl.BK_Schema  OR fl.BK_Schema is null) 
join rep.vw_RefType				rtOT	on rtOT.BK			= src.BK_RefType_ObjectType
join rep.vw_RefType				rtRS	on rtRS.BK			= src.BK_RefType_RepositoryStatus
where 1=1