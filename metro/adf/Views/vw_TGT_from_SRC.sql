
CREATE VIEW [adf].[vw_tgt_from_src] AS WITH base AS

        (SELECT tgt ,

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

          FROM [adf].[vw_tgt_from_src_base]

     UNION ALL SELECT tgt ,

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

          FROM [adf].[vw_tgt_from_src_schedules]
       ),

       FINAL AS

        (SELECT tgt = cast(src.tgt AS varchar(1000)) ,

               src_bk_dataset = cast(src.src_bk_dataset AS varchar(255)) ,

               src_dataset = cast(src.src_dataset AS varchar(255)) ,

               src_shortname = cast(src.src_shortname AS varchar(255)) ,

               src_group = cast(src.src_group AS varchar(255)) ,

               src_schema = cast(src.src_schema AS varchar(255)) ,

               src_layer = cast(src.src_layer AS varchar(255)) ,

               [source] = cast(src.[source] AS varchar(1000)) ,

               src_datasettype = cast(src.src_datasettype AS varchar(255)) ,

               tgt_datasettype = cast(src.tgt_datasettype AS varchar(255)) ,

               generation_number_old = cast(src.generation_number AS bigint) ,

               generation_number = cast(CASE
                                       WHEN s.processparallel = 1 THEN concat(d.floworder, '00000')
                                       ELSE concat(d.floworder, right('00000' + cast(src.generation_number AS varchar), 5))
                                   END AS bigint) ,

               processparallel = cast(s.processparallel AS varchar(255)) ,

               dependencytype = cast(src.dependencytype AS varchar(255)) ,

               repositorystatusname = cast(src.repositorystatusname AS varchar(255)) ,

               repositorystatuscode = cast(src.repositorystatuscode AS varchar(255)) ,

               environment = cast(src.environment AS varchar(255))

          FROM base src

          LEFT JOIN bld.vw_dataset d
            ON src.src_bk_dataset = d.bk

          LEFT JOIN bld.vw_schema s
            ON d.bk_schema = s.bk
       )
SELECT *

  FROM FINAL

 WHERE 1 = 1 --and Environment = 'prd'
--and TGT = '[fct].[IB_ODF_monthly]'
--and TGT = '[fct].[IB_WEAS]'
--and TGT = '[dim].[Common_CustomerProduct]'
--and TGT = ' Percentiel-WAP-pub]'
--order by cast(d.FlowOrder as int) desc
--order by JobOrder desc
--order by JobOrder desc