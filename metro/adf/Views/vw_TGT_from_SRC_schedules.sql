
CREATE VIEW adf.vw_tgt_from_src_schedules AS WITH schedule_all AS

        (SELECT tgt_new = concat('schedule : ', s.bk) ,

               s.excludefromalllevel ,

               s.excludefromallother ,

               ts.*

          FROM bld.vw_schedules s

          JOIN [adf].[vw_tgt_from_src_base] ts
            ON s.targettoload = ts.tgt

         WHERE s.scheduletype = 'DWH' -- All

       ),

       schedule_other AS

        (SELECT tgt_new = concat('schedule : ', s.bk) ,

               s.excludefromalllevel ,

               s.excludefromallother ,

               ts.*

          FROM bld.vw_schedules s

          JOIN [adf].[vw_tgt_from_src_base] ts
            ON s.targettoload = ts.tgt

         WHERE s.scheduletype != 'DWH'
       ),

       final_schedules AS

        (-- all
 SELECT s_a.*

          FROM schedule_all s_a

          LEFT JOIN schedule_other s_o
            ON s_a.src_dataset = s_o.src_dataset

           AND s_a.environment = s_o.environment

           AND s_o.excludefromalllevel = 1

         WHERE s_o.tgt_new IS NULL

     UNION ALL -- other
 SELECT s_a.*

          FROM schedule_other s_a

          LEFT JOIN schedule_other s_o
            ON s_a.tgt != s_o.tgt

           AND s_a.src_dataset = s_o.src_dataset

           AND s_a.environment = s_o.environment

           AND s_o.excludefromallother = 1

         WHERE s_o.tgt_new IS NULL
       )
SELECT tgt = tgt_new --, TGT_old = TGT
,

       src_bk_dataset ,

       src_dataset ,

       src_shortname ,

       src_group ,

       src_schema ,

       src_layer ,

       [source] ,

       src_datasettype ,

       tgt_datasettype ,

       generation_number ,

       dependencytype ,

       repositorystatusname ,

       repositorystatuscode ,

       environment

  FROM final_schedules --where TGT != 'All' and Environment = 'prd'