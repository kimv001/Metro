
CREATE VIEW [adf].[vw_tgt_dwh_from_src] AS -- 493
 WITH excludedfromall AS

        (SELECT bk,

               code,

               targettoload,

               scheduletype

          FROM bld.vw_schedules

         WHERE excludefromalllevel = 1 --and TargetToLoad = 'kanvas'

       ),

       base AS

        (SELECT tgt = src.tgt_datasetname ,

               tgt_bk_dataset = src.bk_target ,

               tgt_group = 'All' ,

               tgt_group_new = src.tgt_group ,

               tgt_schema = 'All' ,

               tgt_layer = 'All' ,

               tgt_dwh = 'All' ,

               src_bk_dataset = src.bk_source ,

               src_dataset = src.src_datasetname ,

               src.src_shortname ,

               src.src_group ,

               src.src_schema ,

               src.src_layer ,

               src.[generation_number] ,

               xa.targettoload

          FROM bld.vw_loaddependency src

          LEFT JOIN excludedfromall xa
            ON xa.targettoload = src.bk_target

            OR xa.targettoload = src.src_datasetname

            OR xa.targettoload = src.src_group

            OR xa.targettoload = src.src_schema

            OR xa.targettoload = src.src_layer

            OR xa.targettoload = src.tgt_group

            OR xa.targettoload = src.tgt_schema

            OR xa.targettoload = src.tgt_layer

         WHERE 1 = 1 --and  src.TGT_layer != 'his' and src.TGT_layer != 'dwh_audit'


           AND xa.targettoload IS NULL

           AND src.dependencytype = 'TgtFromSrc' --and SRC_Group = 'kanvas'
 --and src.BK_Target = 'DWH|rpt||Fixed|AggregatedIB|'

       ),

       dwhme AS

        (SELECT tgt_dwh ,

               tgt_group ,

               tgt_schema ,

               tgt_layer ,

               [src_bk_dataset] ,

               [src_dataset] ,

               [src_shortname] ,

               [src_group] ,

               [src_schema] ,

               [src_layer] ,

               [generation_number] = max([generation_number])

          FROM base b

         WHERE 1 = 1

         GROUP BY [tgt_dwh] ,

                  tgt_group ,

                  tgt_schema ,

                  tgt_layer ,

                  [src_bk_dataset] ,

                  [src_dataset] ,

                  [src_shortname] ,

                  [src_group] ,

                  [src_schema] ,

                  [src_layer]
       ) ,

       FINAL AS

        (SELECT DISTINCT src.[tgt_dwh] ,

               src.[tgt_dwh] AS [tgt] ,

               src.tgt_group ,

               src.tgt_schema ,

               src.tgt_layer ,

               src.[src_bk_dataset] ,

               src.[src_dataset] ,

               src.[src_shortname] ,

               src_sourcename = src.src_group + '_' + iif(src.src_schema = 'stg', d.src_shortname, src.src_shortname) ,

               src_datasettype = d.src_objecttype ,

               tgt_datasettype = d.tgt_objecttype ,

               [src_group] ,

               [src_schema] ,

               [src_layer] --, [generation_number_pre] = [generation_number]
,

               generation_number = cast([generation_number] AS int)-- DENSE_RANK() over(partition by [TGT_DWH] order by [generation_number])
 --, row_num_dataset
,

               dependencytype = 'DWH' ,

               [repositorystatusname] = d.repositorystatusname ,

               [repositorystatuscode] = d.repositorystatuscode

          FROM dwhme src

          JOIN bld.vw_dataset d
            ON src.src_bk_dataset = d.bk

         WHERE 1 = 1
       )
SELECT *

  FROM FINAL

 WHERE 1 = 1 --and src_dataset like '%ODF%'
--and src.[generation_number] = 1
--and D.TGT_ObjectType = 'Table'
--and src.[SRC_ShortName] = 'internet'
--and src.TGT_Schema = 'dim'
--order by cast(generation_number as int)
 ;--select *  from bld.vw_LoadDependency src
--where bk_target like '%ODF%'
--order by generation_number