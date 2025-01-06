﻿
CREATE VIEW [bld].[vw_schema] AS /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:26
        Description           : View on stage table
        */  WITH cur AS

        (SELECT [schemaid] AS [schemaid],

               [bk] AS [bk],

               [code] AS [code],

               [name] AS [name],

               [bk_schema] AS [bk_schema],

               [bk_layer] AS [bk_layer],

               [bk_datasource] AS [bk_datasource],

               [bk_linkedservice] AS [bk_linkedservice],

               [schemacode] AS [schemacode],

               [schemaname] AS [schemaname],

               [datasourcecode] AS [datasourcecode],

               [datasourcename] AS [datasourcename],

               [bk_datasourcetype] AS [bk_datasourcetype],

               [datasourcetypecode] AS [datasourcetypecode],

               [datasourcetypename] AS [datasourcetypename],

               [layercode] AS [layercode],

               [layername] AS [layername],

               [layerorder] AS [layerorder],

               [processorderlayer] AS [processorderlayer],

               [processparallel] AS [processparallel],

               [isdwh] AS [isdwh],

               [issrc] AS [issrc],

               [istgt] AS [istgt],

               [isrep] AS [isrep],

               [createdummies] AS [createdummies],

               [linkedservicecode] AS [linkedservicecode],

               [linkedservicename] AS [linkedservicename],

               [bk_template_create] AS [bk_template_create],

               [bk_template_load] AS [bk_template_load],

               [bk_reftype_tochar] AS [bk_reftype_tochar],

               [mta_rectype],

               [mta_createdate],

               [mta_source],

               [mta_bk],

               [mta_bkh],

               [mta_rh],

               [mta_currentflag] = row_number() OVER (PARTITION BY [mta_bkh]
                                                 ORDER BY [mta_createdate] DESC)

          FROM [bld].[schema]
       )
SELECT [schemaid] AS [schemaid],

       [bk] AS [bk],

       [code] AS [code],

       [name] AS [name],

       [bk_schema] AS [bk_schema],

       [bk_layer] AS [bk_layer],

       [bk_datasource] AS [bk_datasource],

       [bk_linkedservice] AS [bk_linkedservice],

       [schemacode] AS [schemacode],

       [schemaname] AS [schemaname],

       [datasourcecode] AS [datasourcecode],

       [datasourcename] AS [datasourcename],

       [bk_datasourcetype] AS [bk_datasourcetype],

       [datasourcetypecode] AS [datasourcetypecode],

       [datasourcetypename] AS [datasourcetypename],

       [layercode] AS [layercode],

       [layername] AS [layername],

       [layerorder] AS [layerorder],

       [processorderlayer] AS [processorderlayer],

       [processparallel] AS [processparallel],

       [isdwh] AS [isdwh],

       [issrc] AS [issrc],

       [istgt] AS [istgt],

       [isrep] AS [isrep],

       [createdummies] AS [createdummies],

       [linkedservicecode] AS [linkedservicecode],

       [linkedservicename] AS [linkedservicename],

       [bk_template_create] AS [bk_template_create],

       [bk_template_load] AS [bk_template_load],

       [bk_reftype_tochar] AS [bk_reftype_tochar],

       [mta_rectype],

       [mta_createdate],

       [mta_source],

       [mta_bk],

       [mta_bkh],

       [mta_rh],

       [mta_isdeleted] = iif([mta_rectype] = -1, 1, 0)

  FROM cur

 WHERE [mta_currentflag] = 1

   AND [mta_rectype] > -1
