
CREATE VIEW [adf].[vw_loaddependencies] AS WITH cte_datasourceproperties_sdtap_values AS

        (SELECT src.bk_datasource ,

               src.datasourceserver ,

               src.datasourcedatabase ,

               src.datasourceurl ,

               src.datasourceusr ,

               src.environment

          FROM adf.vw_datasourceproperties_sdtap_values src
       )
SELECT src.[loaddependencyid] ,

       src.[bk] ,

       src.[code] ,

       src.[bk_target] ,

       src.[tgt_layer] ,

       src.[tgt_schema] ,

       src.[tgt_group] ,

       src.[tgt_shortname] ,

       src.[tgt_code] ,

       src.[tgt_datasetname] ,

       src.[bk_source] ,

       src.[src_layer] ,

       src.[src_schema] ,

       src.[src_group] ,

       src.[src_shortname] ,

       src.[src_code] ,

       src.[src_datasetname] ,

       src.[dependencytype] ,

       src.[generation_number] ,

       src.[mta_rectype] ,

       src.[mta_createdate] ,

       src.[mta_source] ,

       src.[mta_bk] ,

       src.[mta_bkh] ,

       src.[mta_rh] ,

       src.[mta_isdeleted] ,

       repositorystatusname = d_t.repositorystatusname --case when d_t.RepositoryStatusName = d_t.RepositoryStatusName then
,

       repositorystatuscode = d_t.repositorystatuscode ,

       environment = dspv.environment

  FROM [bld].[vw_loaddependency] src

  JOIN bld.vw_dataset d_t
    ON src.[bk_target] = d_t.bk

  JOIN bld.vw_dataset d_s
    ON src.[bk_source] = d_s.bk

  LEFT JOIN cte_datasourceproperties_sdtap_values dspv
    ON d_t.bk_datasource = dspv.bk_datasource-- and d_s.BK_DataSource = DSPV.BK_DataSource


 WHERE 1 = 1 --and bk_source = 'SF|SF_API||SF|Account|'
--and DSPV.Environment = 'prd'