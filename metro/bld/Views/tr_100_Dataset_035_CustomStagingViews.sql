
CREATE VIEW [bld].[tr_100_dataset_035_customstagingviews] AS /*
=== Comments =========================================

Description:
	Custom views are added to the repositry build to determine dependencies

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230406	1023		K. Vermeij				Added "ToDeploy	= 0", it will be used to determine if a depplyscript has to be generated
=======================================================
*/ WITH view_logic AS

        (SELECT [dataset_name] = lower(concat('[', src.objectschema, '].[', src.objectname, ']')) ,

               [view_defintion_contains_business_logic] = src.objectdefinition_contains_business_logic ,

               [view_defintion] = cast(src.objectdefinition AS varchar(MAX))

          FROM [stg].[dwh_objectdefinitions] src
       ) ,

       customstagingviews AS

        (SELECT bk = concat(s.bk, '|', 'vw_', '|', d.bk_group, '|', iif(isnull(d.dwhtargetshortname, '') = '', replace(d.shortname, '_', ''), d.dwhtargetshortname), '|', 'Custom') ,

               code = d.code --		, DatasetName					= Quotename('stg')+'.'+Quotename(d.bk_Group+'_'+iif(isnull(D.dwhTargetShortName,'')='', replace(d.ShortName,'_',''),D.dwhTargetShortName))
 ,

               datasetname = quotename(s.schemaname) + '.[vw_' + d.bk_group + '_' + replace(d.shortname, '_', '') + '_Custom' + ']' ,

               schemaname = s.schemaname ,

               layername = s.layername ,

               layerorder = s.layerorder ,

               datasource = d.datasource ,

               bk_schema = s.bk ,

               bk_group = d.bk_group ,

               shortname = iif(isnull(d.dwhtargetshortname, '') = '', replace(d.shortname, '_', ''), d.dwhtargetshortname) ,

               dwhtargetshortname = d.dwhtargetshortname ,

               description = d.description ,

               bk_flow = d.bk_flow , TimeStamp = d.timestamp ,

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

               bk_template_load = ''--case when l.[Name] != 'pst' then d.BK_Template_Load else null end --d.BK_Template_Load
 ,

               bk_template_create = ''--d.BK_Template_Create
 ,

               customstagingview = d.customstagingview ,

               bk_reftype_repositorystatus = d.bk_reftype_repositorystatus ,

               issystem = d.issystem ,

               s.isdwh ,

               s.issrc ,

               s.istgt ,

               s.isrep ,

               mta_rownum = row_number() OVER (
                                                                            ORDER BY d.bk) --FROM  [bld].[tr_100_Dataset_010_DatasetSrc] D
 --Join bld.vw_Schema		S	on S.bk			= d.BK_Schema
  --join bld.vw_RefType		RT	on RT.BK		= D.[BK_RefType_ObjectType]
 --WHERE 1 = 1
 --			AND isnull(d.[CustomStagingView],0) = 1

          FROM [bld].[vw_dataset] d

          JOIN bld.vw_schema s
            ON s.bk = d.bk_schema

          JOIN rep.vw_reftype rt
            ON rt.bk = d.[bk_reftype_objecttype]

         WHERE 1 = 1

           AND isnull(d.[customstagingview], 0) = 1

           AND s.[name] = 'stg'

           AND rt.reftype = 'ObjectType'

           AND rt.[name] = 'Table'
       )
SELECT src.[bk] ,

       src.[code] ,

       src.[datasetname] ,

       src.[schemaname] ,

       src.[datasource] ,

       ss.bk_linkedservice ,

       linkedservicename = ss.linkedservicename ,

       ss.bk_datasource ,

       ss.bk_layer ,

       src.layername ,

       src.[bk_schema] ,

       src.[bk_group] ,

       src.[shortname] ,

       src.[dwhtargetshortname] ,

       [prefix] = 'vw' ,

       [postfix] = 'Custom' ,

       src.[description] ,

       src.[bk_flow] ,

       floworder = (src.layerorder + ((fl.sortorder * 10) + 2)) ,

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

       src.isdwh ,

       src.issrc ,

       src.istgt ,

       src.isrep ,

       firstdefaultdwhview = 0 ,

       objecttype = rtot.[name] ,

       repositorystatusname = rtrs.[name] ,

       repositorystatuscode = rtrs.code ,

       [view_defintion_contains_business_logic] = vl.[view_defintion_contains_business_logic] ,

       [view_defintion] = vl.[view_defintion] ,

       todeploy = 0

  FROM customstagingviews src

  LEFT JOIN bld.vw_schema ss
    ON ss.bk = src.bk_schema

  LEFT JOIN rep.vw_flowlayer fl
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

 WHERE 1 = 1 --and src.code  = 'SA_DWH|src_file|Wes|EUAStatus'
