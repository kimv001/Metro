
CREATE VIEW [adf].[vw_connections_src_table] AS WITH linkedserviceproperties AS

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
SELECT -- first attribute SRCConnectionName is legacy
 srcconnectionname = CASE
                         WHEN dt.layername = 'his' THEN CONCAT (src.groupname ,
                                                                '_' ,
                                                                dt.shortname)

            ELSE src.groupshortname

             END ,

       linkedservicename = dsl.[name] -- SRC
,

       src_bk_dataset = src.bk_dataset ,

       src_datasettype = src.datasettype ,

       src_schema = src.schemaname ,

       src_tablename = src.datasetshortname ,

       src_dataset = src.datasetname ,

       src_datasource = src.datasourcename ,

       src_datasourceserver = src.datasourceserver ,

       src_datasourcedatabase = src.datasourcedatabase ,

       src_datasourceurl = src.datasourceurl ,

       src_datasourceusr = src.datasourceusr ,

       src_layer = src.layername ,

       stg_container = src.stg_container ,

       src_bk_datasource = src.bk_datasource ,

       bigdata = src.bigdata -- TGT
,

       tgt_bk_dataset = dt.bk ,

       tgt_datasettype = dt.datasettype ,

       tgt_schema = dt.schemaname ,

       tgt_tablename =
CONCAT (src.groupname ,
                                             '_' ,
                                             dt.shortname) , tgt_dataset = dt.datasetname ,

       tgt_datasource = dt.datasource ,

       tgt_datasourceserver = dspv.datasourceserver ,

       tgt_datasourcedatabase = dspv.datasourcedatabase ,

       tgt_datasourceurl = dspv.datasourceurl ,

       tgt_datasourceusr = dspv.datasourceusr ,

       tgt_layer = dt.layername ,

       tgt_container = src.tgt_container ,

       active = src.active ,

       repositorystatusname = src.repositorystatusname ,

       repositorystatuscode = src.repositorystatuscode ,

       environment = dspv.environment --, dd.BK_Child
 --, dd.BK_Parent
 --, dt.BK_LinkedService
 --, dsl.*
 --, dslp_s.*
 --, dslp_d.*
 --, DSPV.*

  FROM adf.vw_connections_base src

  JOIN bld.vw_datasetdependency dd
    ON src.bk_dataset = dd.bk_parent

  JOIN bld.vw_dataset dt
    ON dd.bk_child = dt.bk

  LEFT JOIN rep.vw_linkedservice dsl
    ON src.bk_linkedservice = dsl.bk

  LEFT JOIN linkedserviceproperties dslp_s
    ON dslp_s.bk_linkedservice = dsl.bk

   AND dslp_s.linkedservicepropertiesname = 'FQ_SQLServerName'

  LEFT JOIN linkedserviceproperties dslp_d
    ON dslp_d.bk_linkedservice = dsl.bk

   AND dslp_d.linkedservicepropertiesname = 'DatabaseName'

  LEFT JOIN cte_datasourceproperties_sdtap_values dspv
    ON dt.bk_datasource = dspv.bk_datasource

   AND (src.environment = dspv.environment
     OR src.environment = 'X')

 WHERE 1 = 1

   AND src.layername = 'src'

   AND src.datasettype = 'Table' --and  src.GroupShortName =  'ODF_odfBase'
 -- and( src.GroupShortName =  'ODF_Base'
 -- --src.GroupShortName ='EDDBTTI_RAP355_2_NOOD_PROCEDURE_ETN_Archive_ExportAzure'
 ------and src.GroupShortName = 'WLR_DwhNetworkInfo'
 ----or src.groupshortname = 'DWHIB_WbaIb'
 ----or src.GroupShortName = 'Teradata_v_sl_network_operator'
 --or src.groupshortname = 'ODF_odfBase'
 --)
 --and DSPV.Environment = 'prd'
 --and src.BK_DataSource = 'EDDB_CPI'
