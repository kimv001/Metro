





CREATE VIEW [bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets] AS 
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
WITH view_logic AS (
SELECT
	  [dataset_name]							= lower(concat('[',src.objectschema,'].[',src.objectname,']'))
	, [view_defintion_contains_business_logic]	= src.objectdefinition_contains_business_logic
    , [view_defintion]							= CAST(src.objectdefinition AS varchar(MAX))
FROM [stg].[DWH_ObjectDefinitions] src 
)

, dataflowtables AS (
SELECT 
	  bk							= Concat(ts.bk,'||', d.bk_group,'|', iif(isnull(d.dwhtargetshortname,'')='', replace(d.shortname,'_',''),d.dwhtargetshortname) ,'|')
	, code							= d.code 
	, datasetname					= Quotename(ts.schemaname)
	+'.'
	+Quotename(d.bk_group+'_'+iif(isnull(d.dwhtargetshortname,'')='', replace(d.shortname,'_',''),d.dwhtargetshortname))
	, schemaname					= ts.schemaname
	, layername						= ts.layername
	, datasource					= ts.datasourcename
	, ts.bk_linkedservice
	, linkedservicename				= ts.linkedservicename
	, ts.bk_datasource
	, ts.bk_layer
	, bk_schema						= ts.bk
	, bk_group						= d.bk_group
	, shortname						= iif(isnull(d.dwhtargetshortname,'')='', replace(d.shortname,'_',''),d.dwhtargetshortname) 
	, src_shortname					= d.src_shortname
	, src_objecttype				= d.objecttype
	, dwhtargetshortname			= d.dwhtargetshortname
	, description					= d.description
	, [BK_ContactGroup]					= d.[BK_ContactGroup]
	, [bk_ContactGroup_Data_Logistics]	= d.[bk_ContactGroup_Data_Logistics]
	, [Data_Logistics_Info]				= d.[Data_Logistics_Info]
	, [bk_ContactGroup_Data_Supplier]	= d.[bk_ContactGroup_Data_Supplier]
	, [Data_Supplier_Info]				= d.[Data_Supplier_Info]
	, bk_flow						= d.bk_flow
	-- If correct configured, it should be ("LayerOrder" + ("FlowOrder" * "10")) 
	, floworder						= CAST(isnull(ts.layerorder,0) AS int) + (fl.sortorder * 10)
	, timestamp						= d.timestamp
	, businessdate					= d.businessdate
	, recordsrcdate					= d.recordsrcdate
	, distinctvalues				= isnull(d.distinctvalues,0)
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
	, createdummies					= isnull(ts.createdummies,0)
	, mta_rownum					= ROW_NUMBER() OVER (ORDER BY d.bk)
	
		FROM [bld].[tr_100_Dataset_010_DatasetSrc] d
		JOIN bld.vw_schema				ss		ON ss.bk		= d.bk_schema
		JOIN rep.vw_flowlayer			fl		ON fl.bk_flow	= d.bk_flow AND (fl.sortorder > 1 )
		-- Get Flow Layer
		JOIN rep.vw_layer	l					ON l.bk			= fl.bk_layer 

		-- Get target Schema
		LEFT JOIN bld.vw_schema			ts		ON ts.bk		= fl.bk_schema

			)
SELECT 
	  src.bk
	, src.code
	, src.datasetname
	, src.schemaname
	, src.layername
	, src.datasource
	, src.bk_datasource
	, src.bk_linkedservice
	, src.bk_layer
	, src.bk_schema
	, src.bk_group
	, src.shortname
	, src.src_shortname
	, src.src_objecttype
	, src.dwhtargetshortname
	, prefix									= ''
	, postfix									= ''
	, src.[Description]
	, [BK_ContactGroup]							= src.[BK_ContactGroup]
	, [bk_ContactGroup_Data_Logistics]			= src.[bk_ContactGroup_Data_Logistics]
	, [Data_Logistics_Info]						= src.[Data_Logistics_Info]
	, [bk_ContactGroup_Data_Supplier]			= src.[bk_ContactGroup_Data_Supplier]
	, [Data_Supplier_Info]						= src.[Data_Supplier_Info]
	, src.bk_flow

	, src.floworder
	, floworderdesc								= ROW_NUMBER() OVER (PARTITION BY src.code ORDER BY src.floworder DESC)
	, src.[TimeStamp]
	, src.businessdate
	, src.recordsrcdate
	, src.distinctvalues
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
FROM dataflowtables src
JOIN rep.vw_reftype			rtot	ON rtot.bk				= src.bk_reftype_objecttype
JOIN rep.vw_reftype			rtrs	ON rtrs.bk				= src.bk_reftype_repositorystatus
LEFT JOIN view_logic		vl		ON vl.dataset_name		= src.datasetname
WHERE 1=1