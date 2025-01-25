






CREATE VIEW [bld].[tr_100_Dataset_030_AddDefaultViews] AS 
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
--20250114	0930		K. Vermeij				droppped, de replaces of _ in the shortname
=======================================================
*/
WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.ObjectSchema,'].[',src.ObjectName,']'))
	, [view_defintion_contains_business_logic]	= src.ObjectDefinition_contains_business_logic
    , [view_defintion]							= CAST(src.ObjectDefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 
)

, DefaultDatasetView AS (
	SELECT 
		  BK								= Concat(
		      s.BK,
		      '|',
		      ISNULL(DDV.prefix + '|', ''),
		      d.BK_Group,
		      '|',
		      iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'|',''),D.dwhTargetShortName),
		      '|',
		      ISNULL( DDV.postfix, '')
		  )
		, Code								= d.code 
		, DatasetName						= QUOTENAME(s.SchemaName)
		+ '.['
		+ ISNULL(DDV.prefix + '_', '')
		+ d.BK_Group
		+ '_'
		+ replace(d.shortname,'_','')
		+ ISNULL('_' + DDV.postfix, '')
		+ ']'
		--, DatasetName						= QUOTENAME(s.SchemaName) + '.[' + ISNULL(DDV.prefix + '_', '') + d.BK_Group + '_' + d.shortname + ISNULL('_' + DDV.postfix, '') + ']'
		, SchemaName						= s.SchemaName
		, LayerName							= s.LayerName
		, DataSource						= s.DataSourceName
		, BK_Schema							= s.BK
		, BK_SchemaBasedOn					= DDV.BK_SchemaBasedOn
		, BK_Group							= d.BK_Group
		, Shortname							= iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName) 
		--, Shortname							= iif(isnull(D.dwhTargetShortName,'')='', d.ShortName,D.dwhTargetShortName) 
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
		, [BK_RefType_ObjectType]			= (SELECT BK FROM rep.vw_Reftype WHERE RefType='ObjectType' AND [Name] = 'View')
		, FullLoad						= d.FullLoad
		, InsertOnly					= d.InsertOnly
		, BigData						= d.BigData
		, BK_Template_Load				= null --case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
		, BK_Template_Create			= ddv.BK_Template_Create 
		, CustomStagingView				= d.CustomStagingView
		, BK_RefType_RepositoryStatus	= d.BK_RefType_RepositoryStatus
		, IsSystem						= d.IsSystem
		, mta_RowNum					= ROW_NUMBER() OVER (ORDER BY d.BK)
	FROM [rep].[vw_DefaultDatasetView] DDV
	JOIN bld.vw_schema				s	ON s.BK				= DDV.BK_Schema
	
	JOIN bld.vw_Dataset				D	ON  D.BK_Schema		= DDV.BK_SchemaBasedOn
										AND DDV.BK_RefType_TableTypeBasedOn = D.[BK_RefType_ObjectType]
										--and DDV.BK_Schema = D.BK_Schema
	
		WHERE 1=1
		
			)
, Almost AS (
	SELECT 
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

	
		, FlowOrder							= CAST(isnull(ss.LayerOrder,0) AS int) + ((fl.SortOrder * 10) + 5)
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

	FROM DefaultDatasetView src
	JOIN bld.vw_Schema			ss	ON  ss.BK			= src.BK_Schema
	JOIN rep.vw_FlowLayer		fl	ON  fl.BK_Flow		= src.BK_Flow 
									AND fl.BK_Layer		= ss.BK_Layer 
									AND (src.BK_Schema	= fl.BK_Schema  
											OR 
											fl.BK_Schema IS null
											OR
										-- csl is a default view on a different schema
											src.BK_SchemaBasedOn = fl.BK_Schema
											) 
	
	WHERE 1=1

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
	, FirstDefaultDWHView						= IIF(ROW_NUMBER() OVER (PARTITION BY src.Code ORDER BY FlowOrder ASC)=1 AND src.LayerName = 'dwh',1,0)
	, ObjectType								= rtOT.[Name]
	, RepositoryStatusName						= rtRS.[Name]
	, RepositoryStatusCode						= rtRS.Code
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, ToDeploy									= 1
FROM almost src
LEFT JOIN rep.vw_Template	T		ON T.BK						= src.BK_Template_Create 
									AND t.BK_RefType_ObjectType = src.[BK_RefType_ObjectType]
JOIN rep.vw_RefType			rtOT	ON rtOT.BK					= src.BK_RefType_ObjectType
JOIN rep.vw_RefType			rtRS	ON rtRS.BK					= src.BK_RefType_RepositoryStatus
LEFT JOIN view_logic		vl		ON vl.dataset_name			= src.DatasetName

WHERE 1=1
--and bk_group = 'wholesale'