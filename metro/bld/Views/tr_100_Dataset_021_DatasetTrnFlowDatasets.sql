
CREATE VIEW [bld].[tr_100_dataset_021_datasettrnflowdatasets] AS /*
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
*/ WITH view_logic AS

        (SELECT [dataset_name] = lower(concat('[', src.objectschema, '].[', src.objectname, ']')) ,

               [view_defintion_contains_business_logic] = src.objectdefinition_contains_business_logic ,

               [view_defintion] = cast(src.objectdefinition AS varchar(MAX))

          FROM [stg].[dwh_objectdefinitions] src
       ) ,

       dataflowtables AS

        (SELECT bk = concat(ts.bk, '||', d.bk_group, '|', d.shortname, '|', isnull(d.[postfix], '')) ,

               code = d.bk ,

               [prefix] = isnull(d.[prefix], '') ,

               [postfix] = isnull(d.[postfix], '') ,

               datasetname = quotename(ts.schemaname) + '.' + quotename(d.bk_group + '_' + d.shortname) ,

               schemaname = ts.schemaname ,

               layername = ts.layername ,

               datasource = ts.datasourcename ,

               ts.bk_linkedservice ,

               linkedservicename = ts.linkedservicename ,

               ts.bk_datasource ,

               ts.bk_layer ,

               bk_schema = ts.bk ,

               bk_group = d.bk_group ,

               [bk_segment] = d.bk_segment ,

               [bk_bucket] = d.bk_bucket ,

               shortname = d.shortname ,

               dwhtargetshortname = d.dwhtargetshortname ,

               description = d.description ,

               [bk_contactgroup] = d.[bk_contactgroup] ,

               bk_flow = d.bk_flow -- If correct configured, it should be ("LayerOrder" + ("FlowOrder" * "10"))
,

               floworder = cast(isnull(ts.layerorder, 0) AS int) + (fl.sortorder * 10) , TimeStamp = d.timestamp ,

               businessdate = d.businessdate ,

               scd = d.scd ,

               wherefilter = d.wherefilter ,

               partitionstatement = d.partitionstatement ,

               [bk_reftype_objecttype] =

                (SELECT bk

                  FROM rep.vw_reftype

                 WHERE reftype = 'ObjectType'

                   AND [name] = 'Table'
               ) ,

               fullload = d.fullload ,

               insertonly = d.insertonly ,

               bigdata = d.bigdata ,

               bk_template_load = CASE
                                                                                                                       WHEN l.[name] != 'pst' THEN d.bk_template_load

                    ELSE NULL

                     END --d.BK_Template_Load
,

               bk_template_create = ''--d.BK_Template_Create
,

               customstagingview = d.customstagingview ,

               bk_reftype_repositorystatus = d.bk_reftype_repositorystatus ,

               issystem = d.issystem ,

               isdwh = ts.isdwh ,

               issrc = ts.issrc ,

               istgt = ts.istgt ,

               isrep = ts.isrep ,

               mta_rownum = row_number() OVER (
                                                                                                                                                   ORDER BY d.bk) ,

               createdummies = isnull(ts.createdummies, 0) --from [bld].[vw_Dataset]			d

          FROM [bld].[tr_100_dataset_020_datasettrn] d

          JOIN bld.vw_schema ss
            ON ss.bk = d.bk_schema

          JOIN rep.vw_flowlayer fl
            ON fl.bk_flow = d.bk_flow

           AND (fl.sortorder > 1
        OR d.[datasetname] like '%trvs%')-- Get Flow Layer

          JOIN rep.vw_layer l
            ON l.bk = fl.bk_layer -- Get target Schema

          LEFT JOIN bld.vw_schema ts
            ON ts.bk = fl.bk_schema

         WHERE 1 = 1 --and ts.SchemaName = 'snd'

       )
SELECT src.[bk] ,

       src.[code] ,

       src.[datasetname] ,

       src.[schemaname] ,

       src.[layername] ,

       src.[datasource] ,

       src.bk_linkedservice ,

       src.linkedservicename ,

       src.bk_datasource ,

       src.bk_layer ,

       src.[bk_schema] ,

       src.[bk_group] ,

       src.bk_segment ,

       src.bk_bucket ,

       src.[shortname] ,

       src.[dwhtargetshortname] ,

       tgt_objecttype = iif(lag(rtot.[name], 1, 0) OVER (PARTITION BY src.code
                                                         ORDER BY src.floworder DESC) = '0', rtot.[name], lag(rtot.[name], 1, 0) OVER (PARTITION BY src.code
                                                                                                                                       ORDER BY src.floworder DESC)) ,

       src.[description] ,

       [bk_contactgroup] = src.[bk_contactgroup] ,

       src.[bk_flow] ,

       src.floworder ,

       src.[timestamp] ,

       src.[businessdate] ,

       src.scd ,

       src.[wherefilter] ,

       src.[partitionstatement] ,

       src.[bk_reftype_objecttype] ,

       src.[fullload] ,

       src.[insertonly] ,

       src.[bigdata] ,

       src.[bk_template_load] ,

       src.[bk_template_create] ,

       src.[customstagingview] ,

       src.[bk_reftype_repositorystatus] ,

       src.issystem ,

       src.isdwh ,

       src.issrc ,

       src.istgt ,

       src.isrep ,

       firstdefaultdwhview = 0 ,

       createdummies ,

       objecttype = rtot.[name] ,

       repositorystatusname = rtrs.[name] ,

       repositorystatuscode = rtrs.code ,

       [view_defintion_contains_business_logic] = vl.[view_defintion_contains_business_logic] ,

       [view_defintion] = vl.[view_defintion] ,

       todeploy = 1

  FROM dataflowtables src

  JOIN rep.vw_reftype rtot
    ON rtot.bk = src.bk_reftype_objecttype

  JOIN rep.vw_reftype rtrs
    ON rtrs.bk = src.bk_reftype_repositorystatus

  LEFT JOIN view_logic vl
    ON vl.dataset_name = src.datasetname

 WHERE 1 = 1
