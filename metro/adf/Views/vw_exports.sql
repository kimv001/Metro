
CREATE VIEW [adf].[vw_exports] AS
SELECT src.[exportsid] ,

       src.[bk] ,

       src.[code] ,

       src.[export_name] ,

       src.[bk_dataset] ,

       src.[bk_schema] ,

       src.[src_datasetname] ,

       src.[src_schema] ,

       src.[src_dataset] ,

       [bk_schedule] = 'Not applicable over here' ,

       src.[container] ,

       src.[folder] ,

       src.[filename] ,

       src.[datetime] ,

       src.[bk_fileformat] ,

       src.[where_filter] ,

       src.[order_by] ,

       src.[split_by] ,

       src.[ff_name] ,

       src.[ff_fileformat] ,

       src.[ff_columndelimiter] ,

       src.[ff_rowdelimiter] ,

       src.[ff_quotecharacter] ,

       src.[ff_compressionlevel] ,

       src.[ff_compressiontype] ,

       src.[ff_enablecdc] ,

       src.[ff_escapecharacter] ,

       src.[ff_fileencoding] ,

       src.[ff_firstrow] ,

       src.[ff_firstrowasheader] ,

       src.[mta_rectype] ,

       src.[mta_createdate] ,

       src.[mta_source] ,

       src.[mta_bk] ,

       src.[mta_bkh] ,

       src.[mta_rh] ,

       src.[mta_isdeleted] ,

       repositorystatusname = sdtap.repositorystatus ,

       repositorystatuscode = sdtap.repositorystatuscode ,

       environment = sdtap.repositorystatus

  FROM [bld].[vw_exports] src

 CROSS JOIN adf.vw_sdtap sdtap

 WHERE 1 = 1

   AND sdtap.repositorystatuscode > -2