
CREATE VIEW [adf].[vw_tgt_dataset_from_src] AS WITH base AS

        (SELECT tgt = src.tgt_datasetname,

               tgt_bk_dataset = src.bk_target,

               tgt_group,

               tgt_schema,

               tgt_layer,

               tgt_dwh = 'All',

               src_bk_dataset = src.bk_source,

               src_dataset = src.src_datasetname,

               src_shortname,

               src_group,

               src_schema,

               src_layer,

               dependencytype,

               [generation_number]

          FROM bld.vw_loaddependency src

         WHERE dependencytype = 'TgtFromSrc'
       )
SELECT DISTINCT tgt_dataset = b.tgt,

       tgt_bk_dataset = b.tgt_bk_dataset,

       tgt = b.tgt,

       tgt_group,

       tgt_schema,

       tgt_layer,

       src_bk_dataset = b.src_bk_dataset,

       src_dataset = b.src_dataset,

       src_shortname = b.src_shortname,

       src_group = b.src_group,

       src_schema = b.src_schema,

       src_layer = b.src_layer,

       src_sourcename = b.src_group + '_' + iif(b.src_schema = 'stg', d.src_shortname, b.src_shortname),

       src_datasettype = d.src_objecttype,

       tgt_datasettype = d.tgt_objecttype,

       generation_number = b.generation_number,

       dependencytype = 'Dataset',

       repositorystatusname = d.repositorystatusname,

       repositorystatuscode = d.repositorystatuscode

  FROM base b

  JOIN bld.vw_dataset d
    ON b.src_bk_dataset = d.bk
