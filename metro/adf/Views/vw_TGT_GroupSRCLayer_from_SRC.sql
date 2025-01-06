﻿ ;
CREATE VIEW [adf].[vw_tgt_groupsrclayer_from_src] AS WITH base AS

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

               [generation_number]

          FROM bld.vw_loaddependency src

         WHERE dependencytype = 'TgtFromSrc'
       ),

       layerme AS

        (SELECT DISTINCT [tgt_groupsrclayer] = [tgt_group] + '-' + [src_layer],

               src_bk_dataset,

               [src_dataset],

               [src_shortname],

               [src_group],

               [src_schema],

               [src_layer],

               [generation_number] = min([generation_number]),

               'GroupSRCLayer' AS dependencytype

          FROM base b

         WHERE 1 = 1

         GROUP BY [tgt_group] + '-' + [src_layer],

                  src_bk_dataset,

                  [src_dataset],

                  [src_shortname],

                  [src_group],

                  [src_schema],

                  [src_layer]
       )
SELECT DISTINCT [tgt_groupsrclayer],

       [tgt] = [tgt_groupsrclayer],

       src_bk_dataset,

       [src_dataset],

       src.[src_shortname],

       src_sourcename = src.src_group + '_' + iif(src.src_schema = 'stg', d.src_shortname, src.src_shortname),

       src_datasettype = d.src_objecttype,

       tgt_datasettype = d.tgt_objecttype,

       [src_group],

       [src_schema],

       [src_layer],

       generation_number = dense_rank() over(PARTITION BY [tgt_groupsrclayer]
                                                      ORDER BY [generation_number]),

       dependencytype = 'GroupSRCLayer',

       [repositorystatusname] = d.repositorystatusname,

       [repositorystatuscode] = d.repositorystatuscode

  FROM layerme src

  JOIN bld.vw_dataset d
    ON src.src_bk_dataset = d.bk

 WHERE 1 = 1
