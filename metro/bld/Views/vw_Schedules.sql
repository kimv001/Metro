﻿
CREATE VIEW [bld].[vw_schedules] AS /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:26
        Description           : View on stage table
        */  WITH cur AS

        (SELECT [schedulesid] AS [schedulesid],

               [bk] AS [bk],

               [schedules_group] AS [schedules_group],

               [dependend_on_schedules_group] AS [dependend_on_schedules_group],

               [code] AS [code],

               [bk_schedule] AS [bk_schedule],

               [targettoload] AS [targettoload],

               [scheduletype] AS [scheduletype],

               [excludefromalllevel] AS [excludefromalllevel],

               [excludefromallother] AS [excludefromallother],

               [processsourcedependencies] AS [processsourcedependencies],

               [mta_rectype],

               [mta_createdate],

               [mta_source],

               [mta_bk],

               [mta_bkh],

               [mta_rh],

               [mta_currentflag] = row_number() OVER (PARTITION BY [mta_bkh]
                                                 ORDER BY [mta_createdate] DESC)

          FROM [bld].[schedules]
       )
SELECT [schedulesid] AS [schedulesid],

       [bk] AS [bk],

       [schedules_group] AS [schedules_group],

       [dependend_on_schedules_group] AS [dependend_on_schedules_group],

       [code] AS [code],

       [bk_schedule] AS [bk_schedule],

       [targettoload] AS [targettoload],

       [scheduletype] AS [scheduletype],

       [excludefromalllevel] AS [excludefromalllevel],

       [excludefromallother] AS [excludefromallother],

       [processsourcedependencies] AS [processsourcedependencies],

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