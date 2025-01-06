﻿
CREATE VIEW [bld].[vw_dwhreftemplates] AS /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:26
        Description           : View on stage table
        */  WITH cur AS

        (SELECT [dwhreftemplatesid] AS [dwhreftemplatesid],

               [bk] AS [bk],

               [code] AS [code],

               [bk_template] AS [bk_template],

               [bk_dataset] AS [bk_dataset],

               [templatetype] AS [templatetype],

               [templatesource] AS [templatesource],

               [bk_reftype_objecttype] AS [bk_reftype_objecttype],

               [templatescript] AS [templatescript],

               [templateversion] AS [templateversion],

               [rownum] AS [rownum],

               [mta_rectype],

               [mta_createdate],

               [mta_source],

               [mta_bk],

               [mta_bkh],

               [mta_rh],

               [mta_currentflag] = row_number() OVER (PARTITION BY [mta_bkh]
                                                 ORDER BY [mta_createdate] DESC)

          FROM [bld].[dwhreftemplates]
       )
SELECT [dwhreftemplatesid] AS [dwhreftemplatesid],

       [bk] AS [bk],

       [code] AS [code],

       [bk_template] AS [bk_template],

       [bk_dataset] AS [bk_dataset],

       [templatetype] AS [templatetype],

       [templatesource] AS [templatesource],

       [bk_reftype_objecttype] AS [bk_reftype_objecttype],

       [templatescript] AS [templatescript],

       [templateversion] AS [templateversion],

       [rownum] AS [rownum],

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