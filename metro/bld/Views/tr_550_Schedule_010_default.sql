
CREATE VIEW [bld].[tr_550_schedule_010_default] AS
SELECT bk = s.bk ,

       code = s.code ,

       [bk_schedule] = s.bk ,

       [schedulecode] = s.code ,

       [schedulename] = s.[name] ,

       [scheduledesc] = s.[description] ,

       s.[startdate] ,

       s.[enddate] ,

       s.[starttime] ,

       s.[endtime] ,

       bk_scheduletype = s.bk_scheduletype ,

       [scheduletypecode] = rtst.code ,

       [scheduletypename] = rtst.[name] ,

       bk_schedulefrequency = s.bk_schedulefrequency ,

       [schedulefrequencycode] = rtsf.code ,

       [schedulefrequencyname] = rtsf.[name] ,

       bk_scheduledailyinterval = s.bk_scheduledailyinterval ,

       [scheduledailyintervalcode] = rtsd.code ,

       [scheduledailyintervalname] = rtsd.[name] ,

       bk_scheduleweeklyinterval = s.bk_scheduleweeklyinterval ,

       [scheduleweeklyintervalcode] = rtsw.code ,

       [scheduleweeklyintervalname] = rtsw.[name] ,

       bk_scheduleworkdayinterval = s.bk_scheduleworkdayinterval ,

       [scheduleworkdayintervalcode] = rtwd.code ,

       [scheduleworkdayintervalname] = rtwd.[name] ,

       bk_schedulemonthlyinterval = s.bk_schedulemonthlyinterval ,

       [schedulemonthlyintervalcode] = rtsm.code ,

       [schedulemonthlyintervalname] = rtsm.[name] ,

       bk_schedulequarterlyinterval = s.bk_schedulequarterlyinterval ,

       [schedulequarterlyintervalcode] = rtsq.code ,

       [schedulequarterlyintervalname] = rtsq.[name] ,

       bk_scheduleyearlyinterval = s.bk_scheduleyearlyinterval ,

       [scheduleyearlyintervalcode] = rtsy.code ,

       [scheduleyearlyintervalname] = rtsy.[name] ,

       bk_schedulespecials = s.bk_schedulespecials ,

       [schedulespecialscode] = rtss.code ,

       [schedulespecialsname] = rtss.[name] -- future use
 --, s.[CRON]

  FROM rep.[vw_schedule] s

  LEFT JOIN bld.vw_reftype rtst
    ON rtst.bk = s.bk_scheduletype

  LEFT JOIN bld.vw_reftype rtsf
    ON rtsf.bk = s.bk_schedulefrequency

  LEFT JOIN bld.vw_reftype rtsd
    ON rtsd.bk = s.bk_scheduledailyinterval

  LEFT JOIN bld.vw_reftype rtsw
    ON rtsw.bk = s.bk_scheduleweeklyinterval

  LEFT JOIN bld.vw_reftype rtwd
    ON rtwd.bk = s.bk_scheduleworkdayinterval

  LEFT JOIN bld.vw_reftype rtsm
    ON rtsm.bk = s.bk_schedulemonthlyinterval

  LEFT JOIN bld.vw_reftype rtsq
    ON rtsq.bk = s.bk_schedulequarterlyinterval

  LEFT JOIN bld.vw_reftype rtsy
    ON rtsy.bk = s.bk_scheduleyearlyinterval

  LEFT JOIN bld.vw_reftype rtss
    ON rtss.bk = s.bk_schedulespecials
