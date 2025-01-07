





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
=======================================================
*/
WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.objectschema,'].[',src.objectname,']'))
	, [view_defintion_contains_business_logic]	= src.objectdefinition_contains_business_logic
    , [view_defintion]							= CAST(src.objectdefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 
)

, defaultdatasetview AS (
	SELECT 
		  bk								= Concat(
		      s.bk,
		      '|',
		      ISNULL(ddv.prefix + '|', ''),
		      d.bk_group,
		      '|',
		      iif(isnull(d.dwhtargetshortname,'')='', replace(d.shortname,'|',''),d.dwhtargetshortname),
		      '|',
		      ISNULL( ddv.postfix, '')
		  )
		, code								= d.code 
		, datasetname						= QUOTENAME(s.schemaname)
		+ '.['
		+ ISNULL(ddv.prefix + '_', '')
		+ d.bk_group
		+ '_'
		+ replace(d.shortname,'_','')
		+ ISNULL('_' + ddv.postfix, '')
		+ ']'
		, schemaname						= s.schemaname
		, layername							= s.layername
		, datasource						= s.datasourcename
		, bk_schema							= s.bk
		, bk_schemabasedon					= ddv.bk_schemabasedon
		, bk_group							= d.bk_group
		, shortname							= iif(isnull(d.dwhtargetshortname,'')='', replace(d.shortname,'_',''),d.dwhtargetshortname) 
		, dwhtargetshortname				= Isnull(d.dwhtargetshortname,'')
		, [Prefix]							= isnull(ddv.[Prefix],'')
		, [PostFix]							= isnull(ddv.[PostFix],'')
		, [Description]						= d.[Description]
		, [BK_ContactGroup]					= d.[BK_ContactGroup]
		, [bk_ContactGroup_Data_Logistics]	= d.[bk_ContactGroup_Data_Logistics]
		, [Data_Logistics_Info]				= d.[Data_Logistics_Info]
		, [bk_ContactGroup_Data_Supplier]	= d.[bk_ContactGroup_Data_Supplier]
		, [Data_Supplier_Info]				= d.[Data_Supplier_Info]
		, bk_flow						= d.bk_flow
		, [TimeStamp]					= d.[TimeStamp]
		, businessdate					= d.businessdate
		, wherefilter					= d.wherefilter
		, partitionstatement			= d.partitionstatement
		, [BK_RefType_ObjectType]			= (SELECT bk FROM rep.vw_reftype WHERE reftype='ObjectType' AND [Name] = 'View')
		, fullload						= d.fullload
		, insertonly					= d.insertonly
		, bigdata						= d.bigdata
		, bk_template_load				= null --case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
		, bk_template_create			= ddv.bk_template_create 
		, customstagingview				= d.customstagingview
		, bk_reftype_repositorystatus	= d.bk_reftype_repositorystatus
		, issystem						= d.issystem
		, mta_rownum					= ROW_NUMBER() OVER (ORDER BY d.bk)
	FROM [rep].[vw_DefaultDatasetView] ddv
	JOIN bld.vw_schema				s	ON s.bk				= ddv.bk_schema
	
	JOIN bld.vw_dataset				d	ON  d.bk_schema		= ddv.bk_schemabasedon
										AND ddv.bk_reftype_tabletypebasedon = d.[BK_RefType_ObjectType]
										--and DDV.BK_Schema = D.BK_Schema
	
		WHERE 1=1
		
			)
, almost AS (
	SELECT 
		  src.[BK]
		, src.[Code]
		, src.[DatasetName]
		, src.[SchemaName]
		, src.[LayerName]
		, src.[DataSource]
		, ss.bk_linkedservice
		, linkedservicename					= ss.linkedservicename
		, ss.bk_datasource
		, ss.bk_layer
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

	
		, floworder							= CAST(isnull(ss.layerorder,0) AS int) + ((fl.sortorder * 10) + 5)
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
		, src.issystem
		, ss.isdwh								
		, ss.issrc								
		, ss.istgt
		, ss.isrep

	FROM defaultdatasetview src
	JOIN bld.vw_schema			ss	ON  ss.bk			= src.bk_schema
	JOIN rep.vw_flowlayer		fl	ON  fl.bk_flow		= src.bk_flow 
									AND fl.bk_layer		= ss.bk_layer 
									AND (src.bk_schema	= fl.bk_schema  
											OR 
											fl.bk_schema IS null
											OR
										-- csl is a default view on a different schema
											src.bk_schemabasedon = fl.bk_schema
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
	, src.bk_linkedservice
	, src.linkedservicename
	, src.bk_datasource
	, src.bk_layer
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
	, [BK_Template_Create]						= t.bk
	, src.[CustomStagingView]
	, src.[BK_RefType_RepositoryStatus]
	, src.issystem
	, src.isdwh								
	, src.issrc								
	, src.istgt
	, firstdefaultdwhview						= IIF(ROW_NUMBER() OVER (PARTITION BY src.code ORDER BY floworder ASC)=1 AND src.layername = 'dwh',1,0)
	, objecttype								= rtot.[Name]
	, repositorystatusname						= rtrs.[Name]
	, repositorystatuscode						= rtrs.code
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, todeploy									= 1
FROM almost src
LEFT JOIN rep.vw_template	t		ON t.bk						= src.bk_template_create 
									AND t.bk_reftype_objecttype = src.[BK_RefType_ObjectType]
JOIN rep.vw_reftype			rtot	ON rtot.bk					= src.bk_reftype_objecttype
JOIN rep.vw_reftype			rtrs	ON rtrs.bk					= src.bk_reftype_repositorystatus
LEFT JOIN view_logic		vl		ON vl.dataset_name			= src.datasetname

WHERE 1=1