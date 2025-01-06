
CREATE VIEW [bld].[tr_100_dataset_020_datasettrn] AS /*
=== Comments =========================================

Description:
	All Defined Transformation Datasets are selected.

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20230406	1023		K. Vermeij				Added "ToDeploy	= 0", it will be used to determine if a deployscript has to be generated
=======================================================
*/ WITH view_logic AS

        (SELECT [dataset_name] = lower(concat('[', src.objectschema, '].[', src.objectname, ']')) ,

               [view_defintion_contains_business_logic] = src.objectdefinition_contains_business_logic ,

               [view_defintion] = cast(src.objectdefinition AS varchar(MAX))

          FROM [stg].[dwh_objectdefinitions] src
       ) ,

       base AS

        (SELECT trn.[bk] ,

               [code] = trn.[bk] ,

               datasetname = trn.[name] --, trn.[Layer]
 ,

               schemaname = trn.[schema] ,

               trn.[datasource] ,

               trn.[bk_schema] ,

               trn.[bk_group] ,

               trn.[bk_segment] ,

               trn.[bk_bucket] ,

               trn.[shortname] ,

               [dwhtargetshortname] = '' ,

               [prefix] = isnull(trn.[prefix], '') ,

               [postfix] = isnull(trn.[postfix], '') ,

               trn.[description] ,

               [bk_contactgroup] = trn.[bk_contactgroup] ,

               trn.[bk_flow] ,

               trn.[timestamp] ,

               trn.[businessdate] ,

               trn.[wherefilter] ,

               trn.[partitionstatement] ,

               trn.[bk_reftype_objecttype] ,

               scd = isnull(scd.code, '1') ,

               trn.[fullload] ,

               trn.[insertonly] ,

               trn.[bigdata] ,

               trn.[bk_template_load] ,

               trn.[bk_template_create] ,

               [customstagingview] = NULL ,

               trn.[bk_reftype_repositorystatus] ,

               trn.[issystem] ,

               trn.[mta_rownum] ,

               trn.[mta_bk] ,

               trn.[mta_bkh] ,

               trn.[mta_rh] ,

               trn.[mta_source] ,

               trn.[mta_loaddate]

          FROM [rep].[vw_datasettrn] trn

          LEFT JOIN bld.vw_reftype scd
            ON trn.bk_reftype_scd = scd.bk
       )
SELECT src.bk ,

       src.code ,

       src.datasetname ,

       src.schemaname ,

       layername = ss.layername ,

       src.datasource ,

       ss.bk_linkedservice ,

       linkedservicename = ss.linkedservicename ,

       ss.bk_datasource ,

       ss.bk_layer ,

       src.bk_schema ,

       src.bk_group ,

       src.[bk_segment] ,

       src.[bk_bucket] ,

       src.shortname ,

       src.dwhtargetshortname ,

       src.prefix ,

       src.postfix ,

       src.[description] ,

       src.bk_contactgroup ,

       src.bk_flow ,

       floworder = cast(isnull(ss.layerorder, 0) AS int) + cast(isnull(fl.sortorder, 0) AS int) ,

       src.[timestamp] ,

       src.businessdate ,

       src.scd ,

       src.wherefilter ,

       src.partitionstatement ,

       src.bk_reftype_objecttype ,

       src.fullload ,

       src.insertonly ,

       src.bigdata ,

       src.bk_template_load ,

       src.bk_template_create ,

       src.customstagingview ,

       src.bk_reftype_repositorystatus ,

       src.issystem ,

       firstdefaultdwhview = 0 ,

       datasettype = cast('TRN' AS varchar(5)) ,

       objecttype = rtot.[name] ,

       repositorystatusname = rtrs.[name] ,

       repositorystatuscode = rtrs.code ,

       isdwh = ss.isdwh ,

       issrc = ss.issrc ,

       istgt = ss.istgt ,

       isrep = ss.isrep ,

       [view_defintion_contains_business_logic] = vl.[view_defintion_contains_business_logic] ,

       [view_defintion] = vl.[view_defintion] ,

       todeploy = 0 ,

       createdummies = ss.createdummies

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

 WHERE 1 = 1 --and src.code  = 'DWH|dim|trvs|Wes|Location|'
