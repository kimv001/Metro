 /****** Object:  View [adf].[Connections_Sto_Table]    Script Date: 11/1/2022 1:28:28 PM ******/
CREATE VIEW [adf].[vw_connections_sto_table] AS WITH linkedserviceproperties AS

        (SELECT bk_linkedservice = ls.bk ,

               linkedservicename = ls.[name] ,

               linkedservicepropertiesname = lsp.linkedservicepropertiesname ,

               linkedservicepropertiesvalue = lsp.linkedservicepropertiesvalue

          FROM rep.vw_linkedservice ls

          JOIN rep.vw_linkedserviceproperties lsp
            ON ls.bk = lsp.bk_linkedservice
       ),

       cte_datasourceproperties_sdtap_values AS

        (SELECT src.bk_datasource ,

               src.datasourceserver ,

               src.datasourcedatabase ,

               src.datasourceurl ,

               src.datasourceusr ,

               src.environment

          FROM adf.vw_datasourceproperties_sdtap_values src
       )
SELECT -- first attribute [SRCConnectionName] is legacy
 [srcconnectionname] = src.groupshortname ,

       linkedservicename = dsl.[name] ,

       [dwhgroupnameshortname] = src.[groupshortname] ,

       [prefix_groupname_shortname] = concat(ds.prefix, '_', ds.bk_group, '_', ds.shortname) --replace(replace(replace(replace(src.DatasetName,src.SchemaName,''),'.',''),'[',''),']','')
,

       [dwhgroupname] = src.groupname -- SRC
,

       [src_bk_dataset] = src.bk_dataset ,

       [src_datasettype] = src.datasettype ,

       [src_schema] = src.schemaname ,

       [src_tablename] = src.datasetshortname ,

       [src_dataset] = src.datasetname ,

       [src_datasource] = src.datasourcename ,

       [src_datasourceserver] = src.datasourceserver ,

       [src_datasourcedatabase] = src.datasourcedatabase ,

       [src_datasourceurl] = src.datasourceurl ,

       [src_datasourceusr] = src.datasourceusr ,

       [src_layer] = src.layername ,

       [stg_container] = src.[stg_container] ,

       [src_datasourceid] = src.bk_datasource -- TGT
,

       [tgt_bk_dataset] = dt.bk ,

       [tgt_linkedservicename] = dslt.[name] ,

       [tgt_datasettype] = dt.datasettype ,

       [tgt_schema] = dt.schemaname ,

       [tgt_tablename] =
CONCAT (src.groupname ,
                           '_' ,
                           dt.shortname) , [tgt_dataset] = dt.datasetname ,

       [tgt_datasource] = dt.datasource ,

       [tgt_datasourceserver] = dspv.datasourceserver ,

       [tgt_datasourcedatabase] = dspv.datasourcedatabase ,

       [tgt_datasourceurl] = dspv.datasourceurl ,

       [tgt_datasourceusr] = dspv.datasourceusr ,

       [tgt_layer] = dt.layername ,

       [tgt_container] = src.[tgt_container] ,

       [active] = src.active --    DB Info
 ,

       [repositorystatusname] = src.repositorystatusname ,

       [repositorystatuscode] = src.repositorystatuscode ,

       dspv.environment

  FROM [adf].[vw_connections_base] src

  JOIN bld.vw_datasetdependency dd
    ON src.bk_dataset = dd.bk_parent

  LEFT JOIN bld.vw_dataset dt
    ON dd.bk_child = dt.bk

  LEFT JOIN bld.vw_dataset ds
    ON dd.bk_parent = ds.bk

  LEFT JOIN rep.vw_linkedservice dsl
    ON dt.bk_linkedservice = dsl.bk

  LEFT JOIN rep.vw_linkedservice dslt
    ON dt.bk_linkedservice = dslt.bk

  LEFT JOIN linkedserviceproperties dslp_s
    ON dslp_s.bk_linkedservice = dsl.bk

   AND dslp_s.linkedservicepropertiesname = 'FQ_SQLServerName'

  LEFT JOIN linkedserviceproperties dslp_d
    ON dslp_d.bk_linkedservice = dsl.bk

   AND dslp_d.linkedservicepropertiesname = 'DatabaseName'

  LEFT JOIN cte_datasourceproperties_sdtap_values dspv
    ON dt.bk_datasource = dspv.bk_datasource

   AND src.environment = dspv.environment

  LEFT JOIN [adf].[vw_datasourceproperties] dspl
    ON dt.bk_datasource = dspl.bk_datasource

   AND dspl.[datasourcepropertiesname] = 'linkedservicename'

 WHERE 1 = 1 --AND src.SchemaName = 'sto'


   AND dt.layername IN ('TGT' ,
                       'MDSstg')