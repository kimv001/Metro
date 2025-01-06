﻿
CREATE VIEW [bld].[vw_deployscripts] AS /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:25
        Description           : View on stage table
        */  WITH cur AS

        (SELECT [deployscriptsid] AS [deployscriptsid],

               [bk] AS [bk],

               [code] AS [code],

               [bk_template] AS [bk_template],

               [bk_dataset] AS [bk_dataset],

               [tgt_objectname] AS [tgt_objectname],

               [objecttype] AS [objecttype],

               [objecttypedeployorder] AS [objecttypedeployorder],

               [templatetype] AS [templatetype],

               [scriptlanguagecode] AS [scriptlanguagecode],

               [scriptlanguage] AS [scriptlanguage],

               [templatesource] AS [templatesource],

               [templatename] AS [templatename],

               [templatescript] AS [templatescript],

               [templateversion] AS [templateversion],

               [todeploy] AS [todeploy],

               [mta_rectype],

               [mta_createdate],

               [mta_source],

               [mta_bk],

               [mta_bkh],

               [mta_rh],

               [mta_currentflag] = row_number() OVER (PARTITION BY [mta_bkh]
                                                 ORDER BY [mta_createdate] DESC)

          FROM [bld].[deployscripts]
       )
SELECT [deployscriptsid] AS [deployscriptsid],

       [bk] AS [bk],

       [code] AS [code],

       [bk_template] AS [bk_template],

       [bk_dataset] AS [bk_dataset],

       [tgt_objectname] AS [tgt_objectname],

       [objecttype] AS [objecttype],

       [objecttypedeployorder] AS [objecttypedeployorder],

       [templatetype] AS [templatetype],

       [scriptlanguagecode] AS [scriptlanguagecode],

       [scriptlanguage] AS [scriptlanguage],

       [templatesource] AS [templatesource],

       [templatename] AS [templatename],

       [templatescript] AS [templatescript],

       [templateversion] AS [templateversion],

       [todeploy] AS [todeploy],

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