
CREATE VIEW [adf].[vw_connections_base] AS WITH cte_datasourceproperties_sdtap_values AS

        (SELECT src.bk_datasource,

               src.datasourceserver,

               src.datasourcedatabase,

               src.datasourceurl,

               src.datasourceusr,

               src.environment

          FROM adf.vw_datasourceproperties_sdtap_values src
       )
SELECT bk_dataset = d.bk,

       datasetname = d.datasetname,

       active = 1,

       datasetshortname = d.shortname,

       groupshortname = d.bk_group + '_' + d.shortname,

       groupname = d.bk_group,

       schemaname = d.schemaname,

       datasettype = d.objecttype,

       objecttype = d.objecttype,

       datasourcename = d.datasource,

       bk_datasource = d.bk_datasource,

       bk_linkedservice = d.bk_linkedservice,

       linkedservicename = d.linkedservicename,

       datasourceserver = dspv.datasourceserver,

       datasourcedatabase = dspv.datasourcedatabase,

       datasourceurl = dspv.datasourceurl,

       datasourceusr = dspv.datasourceusr,

       layername = d.layername,

       stg_container = 'staging',

       tgt_container = iif(d.schemaname = 'pre_file', 'import', 'archive'),

       corecount = 8 --> sorry nog geen veld voor
,

       mta_source = d.mta_source,

       repositorystatusname = d.repositorystatusname,

       repositorystatuscode = d.repositorystatuscode,

       bigdata = isnull(bigdata, 0),

       environment = dspv.environment

  FROM bld.vw_dataset d

  LEFT JOIN cte_datasourceproperties_sdtap_values dspv
    ON d.bk_datasource = dspv.bk_datasource
