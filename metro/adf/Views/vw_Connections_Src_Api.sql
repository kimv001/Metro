
CREATE VIEW [adf].vw_connections_src_api AS WITH linkedserviceproperties AS

        (SELECT bk_linkedservice = ls.bk,

               linkedservicename = ls.[name],

               lsp.linkedservicepropertiesname,

               lsp.linkedservicepropertiesvalue

          FROM rep.vw_linkedservice ls

          JOIN rep.vw_linkedserviceproperties lsp
            ON ls.bk = lsp.bk_linkedservice
       ),

       cte_datasourceproperties_sdtap_values AS

        (SELECT src.bk_datasource,

               src.datasourceserver,

               src.datasourcedatabase,

               src.datasourceurl,

               src.datasourceusr,

               src.environment

          FROM adf.vw_datasourceproperties_sdtap_values src
       )
SELECT -- first attribute [SRCConnectionName] is legacy
 srcconnectionname = src.groupshortname,

       [dwhgroupnameshortname] = src.[groupshortname],

       [dwhgroupname] = src.groupname,

       [dwhshortname] = dt.shortname,

       [dwhshortnamesource] = src.datasetshortname,

       [src_bk_dataset] = src.bk_dataset,

       [tgt_bk_dataset] = dt.bk,

       [src_datasettype] = src.objecttype,

       [tgt_datasettype] = dt.objecttype,

       [src_schema] = src.schemaname,

       [tgt_schema] = dt.schemaname,

       [src_layer] = src.layername,

       [tgt_layer] = dt.layername,

       [src_dataset] = src.datasetname,

       [tgt_dataset] = dt.datasetname,

       [tgt_tablename] =
CONCAT (src.groupname,
                           '_',
                           dt.shortname) ,[src_datasource] = src.datasourcename,

       [src_datasourceserver] = src.datasourceserver,

       [src_datasourcedatabase] = src.datasourcedatabase,

       [src_datasourceurl] = src.datasourceurl,

       [src_datasourceusr] = src.datasourceusr,

       [tgt_datasource] = dt.datasource,

       [tgt_datasourceserver] = dspv.datasourceserver,

       [tgt_datasourcedatabase] = dspv.datasourcedatabase,

       [tgt_datasourceurl] = dspv.datasourceurl,

       [tgt_datasourceusr] = dspv.datasourceusr,

       [stg_container] = src.[stg_container],

       [tgt_container] = src.[tgt_container],

       [active] = src.active,

       [corecount] = src.[corecount],

       [repositorystatusname] = src.repositorystatusname,

       [repositorystatuscode] = src.repositorystatuscode -- Api Info
,

       [src_datasourceid] = src.bk_datasource,

       linkedservicename = src.linkedservicename,

       environmenturl = dslp_e.linkedservicepropertiesvalue,

       username = dslp_u.linkedservicepropertiesvalue,

       bigdata = isnull(src.bigdata, 0),

       dspv.environment,

       src.datasettype

  FROM [adf].[vw_connections_base] src

  JOIN bld.vw_datasetdependency dd
    ON src.bk_dataset = dd.bk_parent

  JOIN bld.vw_dataset dt
    ON dd.bk_child = dt.bk

  LEFT JOIN linkedserviceproperties dslp_e
    ON dslp_e.bk_linkedservice = src.bk_linkedservice

   AND dslp_e.linkedservicepropertiesname = 'EnvironmentURL'

  LEFT JOIN linkedserviceproperties dslp_u
    ON dslp_u.bk_linkedservice = src.bk_linkedservice

   AND dslp_u.linkedservicepropertiesname = 'Username'

  LEFT JOIN cte_datasourceproperties_sdtap_values dspv
    ON dt.bk_datasource = dspv.bk_datasource

   AND src.environment = dspv.environment

 WHERE 1 = 1

   AND src.layername = 'src'

   AND src.datasettype = 'api'
