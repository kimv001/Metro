
CREATE VIEW [bld].[tr_100_dataset_010_datasetsrc] AS /*
=== Comments =========================================

Description:
	All Defined Source Datasets are selected.

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20230406	1023		K. Vermeij				Added "ToDeploy	= 0", it will be used to determine if a depplyscript has to be generated
20230409	0821		K. Vermeij				Added Attribute [DistinctValues]
20230616	1524		K. Vermeij				Added InsertNoCheck (for later use in template.... load pst)
20241007	1200		K. Vermeij				Added DataLogisticsGroup, SupplierGroup and ContactGroup
20241007	1330		K. Vermeij				Added view definitions
20241212	0800		K. Vermeij				Added Segments and Buckets
=======================================================
*/ WITH view_logic AS

        (SELECT [dataset_name] = lower(concat('[', src.objectschema, '].[', src.objectname, ']')) ,

               [view_defintion_contains_business_logic] = src.objectdefinition_contains_business_logic ,

               [view_defintion] = cast(src.objectdefinition AS varchar(MAX))

          FROM [stg].[dwh_objectdefinitions] src
       ) ,

       base AS

        (SELECT [bk] = src.[bk] ,

               [code] = src.[code] ,

               [datasetname] = src.[name] ,

               [schemaname] = src.[schema] ,

               [datasource] = src.[datasource] ,

               [bk_schema] = src.[bk_schema] ,

               [bk_group] = src.[bk_group] ,

               [bk_segment] = '' ,

               [bk_bucket] = '' ,

               [shortname] = src.[shortname] ,

               [src_shortname] = src.[shortname] ,

               [dwhtargetshortname] = iif(isnull(src.[dwhtargetshortname], '') = '', replace(src.[shortname], '_', ''), src.[dwhtargetshortname]) ,

               [description] = src.[description] ,

               [bk_contactgroup] = src.[bk_contactgroup] ,

               [bk_contactgroup_data_logistics] = src.[bk_contactgroup_data_logistics] ,

               [data_logistics_info] = src.[data_logistics_info] ,

               [bk_contactgroup_data_supplier] = src.[bk_contactgroup_data_supplier] ,

               [data_supplier_info] = src.[data_supplier_info] ,

               [bk_flow] = src.[bk_flow] ,

               [timestamp] = src.[timestamp] ,

               [businessdate] = src.[businessdate] ,

               [recordsrcdate] = src.[recordsrcdate] ,

               [wherefilter] = src.[wherefilter] ,

               [partitionstatement] = src.[partitionstatement] ,

               [bk_reftype_objecttype] = src.[bk_reftype_objecttype] ,

               [fullload] = isnull(src.[fullload], '0') ,

               [insertonly] = isnull(src.[insertonly], '0') ,

               [insertnocheck] = isnull(src.[insertnocheck], '0') ,

               [bigdata] = isnull(src.[bigdata], '0') ,

               [bk_template_load] = src.[bk_template_load] ,

               [bk_template_create] = src.[bk_template_create] ,

               [customstagingview] = src.[customstagingview] ,

               [bk_reftype_repositorystatus] = src.[bk_reftype_repositorystatus] ,

               [issystem] = src.[issystem] ,

               [prefix] = src.[prefix] ,

               [postfix] = '' ,

               [replaceattributenames] = '' ,

               [scd] = '' ,

               [distinctvalues] = isnull(src.[distinctvalues], 0)

          FROM [rep].[vw_datasetsrc] src
       )
SELECT [bk] = src.[bk] ,

       [code] = src.[code] ,

       [datasetname] = src.[datasetname] ,

       [schemaname] = src.[schemaname] ,

       [datasource] = src.[datasource] ,

       [bk_schema] = src.[bk_schema] ,

       [bk_group] = src.[bk_group] ,

       [bk_segment] = src.[bk_segment] ,

       [bk_bucket] = src.[bk_bucket] ,

       [shortname] = src.[shortname] ,

       [src_shortname] = src.[src_shortname] ,

       [dwhtargetshortname] = src.[dwhtargetshortname] ,

       [replaceattributenames] = src.[replaceattributenames] ,

       [prefix] = src.[prefix] ,

       [postfix] = src.[postfix] ,

       [description] = src.[description] ,

       [bk_contactgroup] = src.[bk_contactgroup] ,

       [bk_contactgroup_data_logistics] = src.[bk_contactgroup_data_logistics] ,

       [data_logistics_info] = src.[data_logistics_info] ,

       [bk_contactgroup_data_supplier] = src.[bk_contactgroup_data_supplier] ,

       [data_supplier_info] = src.[data_supplier_info] ,

       [bk_flow] = src.[bk_flow] ,

       [timestamp] = src.[timestamp] ,

       [businessdate] = src.[businessdate] ,

       [recordsrcdate] = src.[recordsrcdate] ,

       [wherefilter] = src.[wherefilter] ,

       [scd] = src.[scd] ,

       [distinctvalues] = src.[distinctvalues] ,

       [partitionstatement] = src.[partitionstatement] ,

       [bk_reftype_objecttype] = src.[bk_reftype_objecttype] ,

       [fullload] = src.[fullload] ,

       [insertonly] = src.[insertonly] ,

       [insertnocheck] = src.[insertnocheck] ,

       [bigdata] = src.[bigdata] ,

       [bk_template_load] = src.[bk_template_load] ,

       [bk_template_create] = src.[bk_template_create] ,

       [customstagingview] = src.[customstagingview] ,

       [bk_reftype_repositorystatus] = src.[bk_reftype_repositorystatus] ,

       [issystem] = src.[issystem] ,

       [layername] = ss.[layername] ,

       [bk_linkedservice] = ss.[bk_linkedservice] ,

       [linkedservicename] = ss.linkedservicename ,

       [bk_datasource] = ss.[bk_datasource] ,

       [bk_layer] = ss.[bk_layer] ,

       [createdummies] = ss.[createdummies] ,

       [floworder] = cast(isnull(ss.[layerorder], 0) AS int) + cast(isnull(fl.[sortorder], 0) AS int) ,

       [floworderdesc] = 9999 ,

       [firstdefaultdwhview] = 0 ,

       [datasettype] = cast('SRC' AS varchar(5)) ,

       [objecttype] = rtot.[name] ,

       [src_objecttype] = rtot.[name] ,

       [tgt_objecttype] = cast('' AS varchar(255)) ,

       [repositorystatusname] = rtrs.[name] ,

       [repositorystatuscode] = rtrs.code ,

       [isdwh] = ss.[isdwh] ,

       [issrc] = ss.[issrc] ,

       [istgt] = ss.[istgt] ,

       [isrep] = ss.[isrep] ,

       [view_defintion_contains_business_logic] = vl.[view_defintion_contains_business_logic] ,

       [view_defintion] = vl.[view_defintion] ,

       [todeploy] = 0

  FROM base src

  JOIN bld.vw_schema ss
    ON ss.bk = src.bk_schema

  JOIN rep.vw_flowlayer fl
    ON fl.bk_flow = src.bk_flow

   AND fl.bk_layer = ss.bk_layer

   AND (src.bk_schema = fl.bk_schema
     OR fl.bk_schema IS NULL)

  JOIN rep.vw_reftype rtot
    ON rtot.bk = src.bk_reftype_objecttype

  JOIN rep.vw_reftype rtrs
    ON rtrs.bk = src.bk_reftype_repositorystatus

  LEFT JOIN view_logic vl
    ON vl.dataset_name = src.datasetname

 WHERE 1 = 1
