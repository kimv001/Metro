CREATE VIEW [bld].[tr_100_Dataset_021_DatasetTrnFlowDatasets] AS 
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
WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.objectschema,'].[',src.objectname,']'))
	, [view_defintion_contains_business_logic]	= src.objectdefinition_contains_business_logic
    , [view_defintion]							= CAST(src.objectdefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 
)

, dataflowtables AS (
	SELECT 
		  bk							= Concat(ts.bk,'||', d.bk_group,'|', d.shortname, '|',Isnull(d.[PostFix],'') )
		, code							= d.bk
		, [preFix]						= Isnull(d.[PreFix],'')
		, [PostFix]						= Isnull(d.[PostFix],'')
		, datasetname					= Quotename(ts.schemaname)+'.'+Quotename(d.bk_group +'_'+d.shortname)
		, schemaname					= ts.schemaname
		, layername						= ts.layername
		, datasource					= ts.datasourcename
		, ts.bk_linkedservice
		, linkedservicename				= ts.linkedservicename
		, ts.bk_datasource
		, ts.bk_layer
		, bk_schema						= ts.bk
		, bk_group						= d.bk_group
		, [BK_Segment]					= d.bk_segment
		, [BK_Bucket]					= d.bk_bucket
		, shortname						= d.shortname
		, dwhtargetshortname			= d.dwhtargetshortname
		, [description]					= d.[description]
		, [BK_ContactGroup]					= d.[BK_ContactGroup]
		, bk_flow						= d.bk_flow
	-- If correct configured, it should be ("LayerOrder" + ("FlowOrder" * "10")) 
		, floworder						= CAST(isnull(ts.layerorder,0) AS int) + (fl.sortorder * 10)
		, [timestamp]					= d.[timestamp]
		, businessdate					= d.businessdate
		, scd							= d.scd
		, wherefilter					= d.wherefilter
		, partitionstatement			= d.partitionstatement
		, [BK_RefType_ObjectType]			= (SELECT bk FROM rep.vw_reftype WHERE reftype='ObjectType' AND [Name] = 'Table')
		, fullload						= d.fullload
		, insertonly					= d.insertonly
		, bigdata						= d.bigdata
		, bk_template_load				= CASE WHEN l.[Name] != 'pst' THEN d.bk_template_load ELSE null END --d.BK_Template_Load
		, bk_template_create			= ''--d.BK_Template_Create
		, customstagingview				= d.customstagingview
		, bk_reftype_repositorystatus	= d.bk_reftype_repositorystatus
		, issystem						= d.issystem
		, isdwh							= ts.isdwh
		, issrc							= ts.issrc
		, istgt							= ts.istgt
		, isrep							= ts.isrep
		, mta_rownum					= ROW_NUMBER() OVER (ORDER BY d.bk)
		, createdummies					= isnull(ts.createdummies,0)
	
	FROM [bld].[tr_100_Dataset_020_DatasetTrn] d
	JOIN bld.vw_schema				ss		ON ss.bk		= d.bk_schema
	JOIN rep.vw_flowlayer fl				ON fl.bk_flow	= d.bk_flow AND (fl.sortorder > 1 OR d.[DatasetName] LIKE '%trvs%')
-- Get Flow Layer
	JOIN rep.vw_layer	l					ON l.bk			= fl.bk_layer 
-- Get target Schema
	LEFT JOIN bld.vw_schema			ts		ON ts.bk		= fl.bk_schema
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
	, src.bk_segment
	, src.bk_bucket
	, src.[Shortname]
	, src.[dwhTargetShortName]
	, tgt_objecttype							= iif(
	    lag(rtot.[Name],1,0) OVER ( PARTITION BY src.code ORDER BY src.floworder DESC)='0',
	    rtot.[Name],
	    lag(rtot.[Name],1,0) OVER ( PARTITION BY src.code ORDER BY src.floworder DESC)
	)
	, src.[Description]
	, [BK_ContactGroup]							= src.[BK_ContactGroup]
	, src.[BK_Flow]

	, src.floworder
	, src.[TimeStamp]
	, src.[BusinessDate]
	, src.scd
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
	, src.isdwh								
	, src.issrc								
	, src.istgt	
	, src.isrep
	, firstdefaultdwhview						= 0
	, createdummies
	
	, objecttype								= rtot.[Name]
	, repositorystatusname						= rtrs.[Name]
	, repositorystatuscode						= rtrs.code
	, [view_defintion_contains_business_logic]	= vl.[view_defintion_contains_business_logic]
	, [view_defintion]							= vl.[view_defintion]
	, todeploy									= 1
FROM dataflowtables			src
JOIN rep.vw_reftype			rtot	ON rtot.bk				= src.bk_reftype_objecttype
JOIN rep.vw_reftype			rtrs	ON rtrs.bk				= src.bk_reftype_repositorystatus
LEFT JOIN view_logic		vl		ON vl.dataset_name		= src.datasetname
WHERE 1=1