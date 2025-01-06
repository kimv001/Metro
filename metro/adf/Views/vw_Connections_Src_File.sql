
CREATE VIEW [adf].[vw_connections_src_file] AS WITH cte_datasourceproperties_sdtap_values AS

        (SELECT bk_datasource = src.bk_datasource,

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

       [tgt_bk_dataset] = dt.datasetid,

       [src_datasettype] = src.datasettype,

       [tgt_datasettype] = dt.datasettype,

       [src_schema] = src.schemaname,

       [tgt_schema] = dt.schemaname,

       [src_layer] = src.layername,

       [tgt_layer] = dt.layername,

       [src_dataset] = src.datasetname,

       [tgt_dataset] = dt.datasetname,

       [src_datasource] = src.datasourcename,

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

       [tgt_folder] = src.[groupshortname],

       [active] = src.active,

       [corecount] = src.[corecount],

       [filesize] = fp.[ff_filesize],

       [threshold] = fp.[ff_threshold] -- File MamboJambo:
,

       [bigdata] = src.bigdata,

       [srccontainer] = lower(fp.filesystem),

       [srcfolder] = fp.folder,

       [srcispgp] = fp.ispgp,

       [srcfilemask] = fp.filemask,

       [srcfilename] = fp.filename,

       [srccolumnseperator] = fp.ff_columndelimiter,

       [srccompressiontype] = fp.ff_compressiontype,

       [srccompressionlevel] = fp.ff_compressionlevel,

       [srcencoding] = fp.ff_fileencoding,

       [srcquotecharacter] = fp.ff_quotecharacter,

       [srcfirstrowasheader] = fp.ff_firstrowasheader,

       [srcescapecharacter] = fp.ff_escapecharacter,

       [srcskiplines] = CASE
                      WHEN fp.ff_firstrow IS NULL THEN NULL

            ELSE (fp.ff_firstrow - 1)

             END,

       [dateinfilenamestringstartpos] = isnull(fp.dateinfilenamestartpos, 1),

       [dateinfilenamestringlength] = isnull(fp.dateinfilenamelength, 1),

       [repositorystatusname] = src.repositorystatusname,

       [repositorystatuscode] = src.repositorystatuscode,

       environment = dspv.environment

  FROM [adf].[vw_connections_base] src

  LEFT JOIN bld.vw_fileproperties fp
    ON src.bk_dataset = fp.bk

  JOIN bld.vw_datasetdependency dd
    ON src.bk_dataset = dd.bk_parent

  JOIN bld.vw_dataset dt
    ON dd.bk_child = dt.bk

  LEFT JOIN cte_datasourceproperties_sdtap_values dspv
    ON dt.bk_datasource = dspv.bk_datasource

   AND src.environment = dspv.environment

 WHERE 1 = 1

   AND src.layername = 'src'

   AND src.datasettype = 'File'
