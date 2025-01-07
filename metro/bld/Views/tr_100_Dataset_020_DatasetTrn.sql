




CREATE VIEW [bld].[tr_100_Dataset_020_DatasetTrn] AS 
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
WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.objectschema,'].[',src.objectname,']'))
	, [view_defintion_contains_business_logic]	= src.objectdefinition_contains_business_logic
    , [view_defintion]							= CAST(src.objectdefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 
)

, base AS (
	
		SELECT  
		  trn.[BK]
		, [Code] = trn.[BK]
		, datasetname = trn.[Name]
		--, trn.[Layer]
		, schemaname						= trn.[Schema]
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
		, scd								=  isnull(scd.code,'1')
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
	FROM [rep].[vw_DatasetTrn]	trn
	LEFT JOIN bld.vw_reftype			scd ON trn.bk_reftype_scd = scd.bk
	)
SELECT 
	  src.bk
	, src.code
	, src.datasetname
	, src.schemaname
	, layername							= ss.layername
	, src.datasource
	, ss.bk_linkedservice
	, linkedservicename					= ss.linkedservicename
	, ss.bk_datasource
	, ss.bk_layer
	, src.bk_schema
	, src.bk_group
	, src.[BK_Segment]					
	, src.[BK_Bucket]					
	, src.shortname
	, src.dwhtargetshortname
	, src.prefix
	, src.postfix
	, src.[Description]
	, src.bk_contactgroup
	, src.bk_flow
	, floworder							= CAST(isnull(ss.layerorder,0) AS int) + CAST(isnull(fl.sortorder,0) AS int)
	, src.[TimeStamp]
	, src.businessdate
	, src.scd
	, src.wherefilter
	, src.partitionstatement
	, src.bk_reftype_objecttype
	, src.fullload
	, src.insertonly
	, src.bigdata
	, src.bk_template_load
	, src.bk_template_create
	, src.customstagingview
	, src.bk_reftype_repositorystatus
	, src.issystem
	, firstdefaultdwhview				= 0
	, datasettype						= CAST('TRN' AS varchar(5))
	, objecttype						= rtot.[Name]
	, repositorystatusname				= rtrs.[Name]
	, repositorystatuscode				= rtrs.code
	, isdwh								= ss.isdwh
	, issrc								= ss.issrc
	, istgt								= ss.istgt
	, isrep								= ss.isrep
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, todeploy							= 0
	, createdummies						= ss.createdummies
FROM base src
JOIN bld.vw_schema			ss		ON ss.bk			= src.bk_schema
JOIN rep.vw_flowlayer		fl		ON fl.bk_flow		= src.bk_flow 
										AND fl.bk_layer = ss.bk_layer 
										AND (src.bk_schema = fl.bk_schema  OR fl.bk_schema IS null) 
JOIN rep.vw_reftype			rtot	ON rtot.bk				= src.bk_reftype_objecttype
JOIN rep.vw_reftype			rtrs	ON rtrs.bk				= src.bk_reftype_repositorystatus
LEFT JOIN view_logic		vl		ON vl.dataset_name		= src.datasetname
WHERE 1=1
--and src.code  = 'DWH|dim|trvs|Wes|Location|'