
CREATE VIEW [bld].[tr_100_dataset_040_aliasviews] AS /*
=== Comments =========================================

Description:
	generates alias views, can be used for dimension aliases like dim.common_Date with aliases dim.vw_common_StartDatde, dim.vw_common_EndDate

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230406	1023		K. Vermeij				Added "ToDeploy	= 1", it will be used to determine if a deployscript has to be generated
=======================================================
*/ WITH aliasviews AS

        (SELECT bk = a.bk ,

               code = d.code ,

               datasetname = quotename(s.schemaname) + '.' + quotename(isnull(a.prefix + '_', '') + a.src_groupname + '_' + a.tgt_shortname + isnull('_' + a.postfix, '')) ,

               schemaname = s.schemaname ,

               layername = s.layername ,

               layerorder = s.layerorder ,

               datasource = d.datasource ,

               bk_schema = s.bk ,

               bk_group = d.bk_group ,

               shortname = d.shortname ,

               dwhtargetshortname = a.tgt_shortname ,

               PREFIX = a.prefix ,

               POSTFIX = a.postfix ,

               description = d.description ,

               bk_flow = d.bk_flow , TimeStamp = d.timestamp ,

               businessdate = NULL ,

               wherefilter = d.wherefilter ,

               partitionstatement = d.partitionstatement ,

               [bk_reftype_objecttype] =

                (SELECT bk

                  FROM rep.vw_reftype

                 WHERE reftype = 'ObjectType'

                   AND [name] = 'View'
               ) ,

               fullload = NULL ,

               insertonly = NULL ,

               bigdata = NULL ,

               bk_template_load = NULL ,

               bk_template_create = a.bk_template_create ,

               customstagingview = NULL ,

               replaceattributenames = a.replaceattributenames ,

               bk_reftype_repositorystatus = a.bk_reftype_repositorystatus ,

               issystem = d.issystem ,

               s.isdwh ,

               s.issrc ,

               s.istgt ,

               s.isrep ,

               mta_rownum = row_number() OVER (
                                                                                               ORDER BY d.bk)

          FROM rep.vw_aliasviews a

          JOIN [bld].[vw_dataset] d
            ON d.bk = a.bk_datasettrn

          JOIN bld.vw_schema s
            ON s.bk = d.bk_schema

          JOIN rep.vw_reftype rt
            ON rt.bk = d.[bk_reftype_objecttype]

         WHERE 1 = 1
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

       [prefix] = src.prefix ,

       [postfix] = src.postfix ,

       src.[description] ,

       src.[bk_flow] ,

       floworder = cast(isnull(src.layerorder, 0) AS int) + ((fl.sortorder * 10) + 5) -- (src.LayerOrder + ((fl.SortOrder * 100) + 2))
,

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

       src.replaceattributenames ,

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

       todeploy = 1

  FROM aliasviews src

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

 WHERE 1 = 1
