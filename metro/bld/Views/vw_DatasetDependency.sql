﻿
CREATE VIEW [bld].[vw_datasetdependency] AS /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:25
        Description           : View on stage table
        */  WITH cur AS

        (SELECT [datasetdependencyid] AS [datasetdependencyid],

               [bk] AS [bk],

               [bk_parent] AS [bk_parent],

               [bk_child] AS [bk_child],

               [code] AS [code],

               [tabletypeparent] AS [tabletypeparent],

               [tabletypechild] AS [tabletypechild],

               [dependencytype] AS [dependencytype],

               [mta_rectype],

               [mta_createdate],

               [mta_source],

               [mta_bk],

               [mta_bkh],

               [mta_rh],

               [mta_currentflag] = row_number() OVER (PARTITION BY [mta_bkh]
                                                 ORDER BY [mta_createdate] DESC)

          FROM [bld].[datasetdependency]
       )
SELECT [datasetdependencyid] AS [datasetdependencyid],

       [bk] AS [bk],

       [bk_parent] AS [bk_parent],

       [bk_child] AS [bk_child],

       [code] AS [code],

       [tabletypeparent] AS [tabletypeparent],

       [tabletypechild] AS [tabletypechild],

       [dependencytype] AS [dependencytype],

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