
CREATE VIEW [bld].[tr_100_dataset_030_adddefaultviews] AS /*
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
*/ WITH view_logic AS

        (SELECT [dataset_name] = lower(concat('[', src.objectschema, '].[', src.objectname, ']')) ,

               [view_defintion_contains_business_logic] = src.objectdefinition_contains_business_logic ,

               [view_defintion] = cast(src.objectdefinition AS varchar(MAX))

          FROM [stg].[dwh_objectdefinitions] src
       ) ,

       defaultdatasetview AS

        (SELECT bk = concat(s.bk, '|', isnull(ddv.prefix + '|', ''), d.bk_group, '|', iif(isnull(d.dwhtargetshortname, '') = '', replace(d.shortname, '|', ''), d.dwhtargetshortname), '|', isnull(ddv.postfix, '')) ,

               code = d.code ,

               datasetname = quotename(s.schemaname) + '.[' + isnull(ddv.prefix + '_', '') + d.bk_group + '_' + replace(d.shortname, '_', '') + isnull('_' + ddv.postfix, '') + ']' ,

               schemaname = s.schemaname ,

               layername = s.layername ,

               datasource = s.datasourcename ,

               bk_schema = s.bk ,

               bk_schemabasedon = ddv.bk_schemabasedon ,

               bk_group = d.bk_group ,

               shortname = iif(isnull(d.dwhtargetshortname, '') = '', replace(d.shortname, '_', ''), d.dwhtargetshortname) ,

               dwhtargetshortname = isnull(d.dwhtargetshortname, '') ,

               [prefix] = isnull(ddv.[prefix], '') ,

               [postfix] = isnull(ddv.[postfix], '') ,

               [description] = d.[description] ,

               [bk_contactgroup] = d.[bk_contactgroup] ,

               [bk_contactgroup_data_logistics] = d.[bk_contactgroup_data_logistics] ,

               [data_logistics_info] = d.[data_logistics_info] ,

               [bk_contactgroup_data_supplier] = d.[bk_contactgroup_data_supplier] ,

               [data_supplier_info] = d.[data_supplier_info] ,

               bk_flow = d.bk_flow ,

               [timestamp] = d.[timestamp] ,

               businessdate = d.businessdate ,

               wherefilter = d.wherefilter ,

               partitionstatement = d.partitionstatement ,

               [bk_reftype_objecttype] =

                (SELECT bk

                  FROM rep.vw_reftype

                 WHERE reftype = 'ObjectType'

                   AND [name] = 'View'
               ) ,

               fullload = d.fullload ,

               insertonly = d.insertonly ,

               bigdata = d.bigdata ,

               bk_template_load = NULL --case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
 ,

               bk_template_create = ddv.bk_template_create ,

               customstagingview = d.customstagingview ,

               bk_reftype_repositorystatus = d.bk_reftype_repositorystatus ,

               issystem = d.issystem ,

               mta_rownum = row_number() OVER (
                                          ORDER BY d.bk)

          FROM [rep].[vw_defaultdatasetview] ddv

          JOIN bld.vw_schema s
            ON s.bk = ddv.bk_schema

          JOIN bld.vw_dataset d
            ON d.bk_schema = ddv.bk_schemabasedon

           AND ddv.bk_reftype_tabletypebasedon = d.[bk_reftype_objecttype] --and DDV.BK_Schema = D.BK_Schema

         WHERE 1 = 1
       ),

       almost AS

        (SELECT src.[bk] ,

               src.[code] ,

               src.[datasetname] ,

               src.[schemaname] ,

               src.[layername] ,

               src.[datasource] ,

               ss.bk_linkedservice ,

               linkedservicename = ss.linkedservicename ,

               ss.bk_datasource ,

               ss.bk_layer ,

               src.[bk_schema] ,

               src.[bk_group] ,

               src.[shortname] ,

               src.[dwhtargetshortname] ,

               src.[prefix] ,

               src.[postfix] ,

               src.[description] ,

               [bk_contactgroup] = src.[bk_contactgroup] ,

               [bk_contactgroup_data_logistics] = src.[bk_contactgroup_data_logistics] ,

               [data_logistics_info] = src.[data_logistics_info] ,

               [bk_contactgroup_data_supplier] = src.[bk_contactgroup_data_supplier] ,

               [data_supplier_info] = src.[data_supplier_info] ,

               src.[bk_flow] ,

               floworder = cast(isnull(ss.layerorder, 0) AS int) + ((fl.sortorder * 10) + 5) ,

               src.[timestamp] ,

               src.[businessdate] ,

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

               ss.isdwh ,

               ss.issrc ,

               ss.istgt ,

               ss.isrep

          FROM defaultdatasetview src

          JOIN bld.vw_schema ss
            ON ss.bk = src.bk_schema

          JOIN rep.vw_flowlayer fl
            ON fl.bk_flow = src.bk_flow

           AND fl.bk_layer = ss.bk_layer

           AND (src.bk_schema = fl.bk_schema
        OR fl.bk_schema IS NULL
        OR -- csl is a default view on a different schema
 src.bk_schemabasedon = fl.bk_schema)

         WHERE 1 = 1
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

       src.[shortname] ,

       src.[dwhtargetshortname] ,

       src.[prefix] ,

       src.[postfix] ,

       src.[description] ,

       src.[bk_flow] ,

       src.[floworder] ,

       src.[timestamp] ,

       src.[businessdate] ,

       src.[wherefilter] ,

       src.[partitionstatement] ,

       src.[bk_reftype_objecttype] ,

       src.[fullload] ,

       src.[insertonly] ,

       src.[bigdata] ,

       src.[bk_template_load] ,

       [bk_template_create] = t.bk ,

       src.[customstagingview] ,

       src.[bk_reftype_repositorystatus] ,

       src.issystem ,

       src.isdwh ,

       src.issrc ,

       src.istgt ,

       firstdefaultdwhview = iif(row_number() OVER (PARTITION BY src.code
                                                    ORDER BY floworder ASC) = 1
                                 AND src.layername = 'dwh', 1, 0) ,

       objecttype = rtot.[name] ,

       repositorystatusname = rtrs.[name] ,

       repositorystatuscode = rtrs.code ,

       [view_defintion_contains_business_logic] = vl.[view_defintion_contains_business_logic] ,

       [view_defintion] = vl.[view_defintion] ,

       todeploy = 1

  FROM almost src

  LEFT JOIN rep.vw_template t
    ON t.bk = src.bk_template_create

   AND t.bk_reftype_objecttype = src.[bk_reftype_objecttype]

  JOIN rep.vw_reftype rtot
    ON rtot.bk = src.bk_reftype_objecttype

  JOIN rep.vw_reftype rtrs
    ON rtrs.bk = src.bk_reftype_repositorystatus

  LEFT JOIN view_logic vl
    ON vl.dataset_name = src.datasetname

 WHERE 1 = 1
