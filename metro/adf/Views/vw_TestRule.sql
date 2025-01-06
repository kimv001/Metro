
CREATE VIEW [adf].[vw_testrule] AS WITH cte_datasourceproperties_sdtap_values AS

        (SELECT src.bk_datasource,

               src.datasourceserver,

               src.datasourcedatabase,

               src.datasourceurl,

               src.datasourceusr,

               src.environment

          FROM adf.vw_datasourceproperties_sdtap_values src
       )
SELECT src.[testrulesid],

       src.[code],

       bk_testrule = src.[bk],

       src.[bk_dataset],

       src.[bk_reftype_repositorystatus],

       src.[testdefintion],

       src.[adfpipeline],

       src.[getattributes],

       src.[tresholdvalue],

       src.[specificattribute],

       src.[attributename],

       src.[expectedvalue],

       src.[mta_rectype],

       src.[mta_createdate],

       src.[mta_source],

       src.[mta_bk],

       src.[mta_bkh],

       src.[mta_rh],

       src.[mta_isdeleted],

       env.environment,

       [repositorystatuscode] = rt.code

  FROM [bld].[vw_testrules] src

  LEFT JOIN bld.vw_reftype rt
    ON src.bk_reftype_repositorystatus = rt.bk

 CROSS JOIN [adf].[vw_sdtap] env --on env.BK_RepositoryStatus = src.[BK_RefType_RepositoryStatus]

 WHERE 1 = 1 --and BK_Dataset = 'SA_DWH|src_file||Grafana|LWAP|'
 -- order by BK_Dataset, [TestDefintion]
