
CREATE VIEW [adf].[vw_tgt_from_src_base] AS WITH tgt AS

        (SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_dwh_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_layer_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_layergroup_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_schema_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_group_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_dataset_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_shortnamegroup_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_shortnamegrouplayer_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_export_from_src]

     UNION ALL SELECT [tgt],

               src_bk_dataset,

               src_dataset,

               [src_shortname],

               src_group,

               src_schema,

               src_layer,

               src_sourcename,

               src_datasettype,

               tgt_datasettype,

               generation_number,

               dependencytype,

               [repositorystatusname],

               [repositorystatuscode]

          FROM [adf].[vw_tgt_groupsrclayer_from_src]
       )
SELECT tgt.[tgt],

       tgt.src_bk_dataset,

       tgt.src_dataset,

       tgt.[src_shortname],

       tgt.src_group,

       tgt.src_schema,

       tgt.src_layer,

       tgt.src_sourcename AS [source],

       tgt.src_datasettype,

       tgt.tgt_datasettype,

       tgt.generation_number,

       tgt.dependencytype,

       tgt.[repositorystatusname],

       tgt.[repositorystatuscode],

       env.environment

  FROM tgt

 CROSS JOIN [adf].[vw_sdtap] env --where TGT.SRC_Layer != 'src' -- sources are no entities from where actions are triggered on in ADF
--and env.Environment = 'PRD' -- 4387
