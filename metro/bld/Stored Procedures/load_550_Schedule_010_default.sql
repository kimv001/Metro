﻿
CREATE proc [bld].[load_550_schedule_010_default] AS /*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:28

	exec [bld].[load_550_Schedule_010_default]*/  DECLARE @routinename varchar(8000) = 'load_550_Schedule_010_default' DECLARE @startdatetime datetime2 = getutcdate() DECLARE @enddatetime datetime2 DECLARE @duration bigint -- Create a helper temp table
 IF object_id('tempdb..#550_Schedule_010_default') IS NOT NULL
DROP TABLE # 550_schedule_010_default ; PRINT '-- create temp table:'
SELECT mta_bk = src.[bk] ,

       mta_bkh = convert(char(64),(hashbytes('sha2_512', upper(src.bk))),2) ,

       mta_rh = convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedule] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulecode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulename] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduledesc] AS varchar(8000)), '-') + '|' + isnull(cast(src.[startdate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[enddate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[starttime] AS varchar(8000)), '-') + '|' + isnull(cast(src.[endtime] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduletype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduletypecode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduletypename] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulefrequency] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulefrequencycode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulefrequencyname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduledailyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduledailyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduledailyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduleweeklyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleweeklyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleweeklyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduleworkdayinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleworkdayintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleworkdayintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulemonthlyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulemonthlyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulemonthlyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulequarterlyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulequarterlyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulequarterlyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduleyearlyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleyearlyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleyearlyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulespecials] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulespecialscode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulespecialsname] AS varchar(8000)), '-')))),2) ,

       mta_source = '[bld].[tr_550_Schedule_010_default]' ,

       mta_rectype = CASE
                         WHEN tgt.[bk] IS NULL                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  THEN 1

            WHEN tgt.[mta_rh] != convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedule] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulecode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulename] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduledesc] AS varchar(8000)), '-') + '|' + isnull(cast(src.[startdate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[enddate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[starttime] AS varchar(8000)), '-') + '|' + isnull(cast(src.[endtime] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduletype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduletypecode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduletypename] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulefrequency] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulefrequencycode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulefrequencyname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduledailyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduledailyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduledailyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduleweeklyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleweeklyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleweeklyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduleworkdayinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleworkdayintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleworkdayintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulemonthlyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulemonthlyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulemonthlyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulequarterlyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulequarterlyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulequarterlyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_scheduleyearlyinterval] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleyearlyintervalcode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[scheduleyearlyintervalname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schedulespecials] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulespecialscode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schedulespecialsname] AS varchar(8000)), '-')))),2) THEN 0

            ELSE -99

             END INTO # 550_schedule_010_default

  FROM [bld].[tr_550_schedule_010_default] src

  LEFT JOIN [bld].[vw_schedule] tgt
    ON src.[bk] = tgt.[bk]
CREATE clustered INDEX [ix_tr_550_schedule_010_default]
    ON # 550_schedule_010_default([mta_bkh] ASC, [mta_rh] ASC) --------------------- start loading data
 PRINT '-- new records:'

   SET @startdatetime = getdate()
INSERT INTO [bld].[schedule] ([bk], [code], [bk_schedule], [schedulecode], [schedulename], [scheduledesc], [startdate], [enddate], [starttime], [endtime], [bk_scheduletype], [scheduletypecode], [scheduletypename], [bk_schedulefrequency], [schedulefrequencycode], [schedulefrequencyname], [bk_scheduledailyinterval], [scheduledailyintervalcode], [scheduledailyintervalname], [bk_scheduleweeklyinterval], [scheduleweeklyintervalcode], [scheduleweeklyintervalname], [bk_scheduleworkdayinterval], [scheduleworkdayintervalcode], [scheduleworkdayintervalname], [bk_schedulemonthlyinterval], [schedulemonthlyintervalcode], [schedulemonthlyintervalname], [bk_schedulequarterlyinterval], [schedulequarterlyintervalcode], [schedulequarterlyintervalname], [bk_scheduleyearlyinterval], [scheduleyearlyintervalcode], [scheduleyearlyintervalname], [bk_schedulespecials], [schedulespecialscode], [schedulespecialsname] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_schedule],

       src.[schedulecode],

       src.[schedulename],

       src.[scheduledesc],

       src.[startdate],

       src.[enddate],

       src.[starttime],

       src.[endtime],

       src.[bk_scheduletype],

       src.[scheduletypecode],

       src.[scheduletypename],

       src.[bk_schedulefrequency],

       src.[schedulefrequencycode],

       src.[schedulefrequencyname],

       src.[bk_scheduledailyinterval],

       src.[scheduledailyintervalcode],

       src.[scheduledailyintervalname],

       src.[bk_scheduleweeklyinterval],

       src.[scheduleweeklyintervalcode],

       src.[scheduleweeklyintervalname],

       src.[bk_scheduleworkdayinterval],

       src.[scheduleworkdayintervalcode],

       src.[scheduleworkdayintervalname],

       src.[bk_schedulemonthlyinterval],

       src.[schedulemonthlyintervalcode],

       src.[schedulemonthlyintervalname],

       src.[bk_schedulequarterlyinterval],

       src.[schedulequarterlyintervalcode],

       src.[schedulequarterlyintervalname],

       src.[bk_scheduleyearlyinterval],

       src.[scheduleyearlyintervalcode],

       src.[scheduleyearlyintervalname],

       src.[bk_schedulespecials],

       src.[schedulespecialscode],

       src.[schedulespecialsname] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_550_schedule_010_default] src

  JOIN # 550_schedule_010_default h
    ON h.[mta_bk] = src.[bk]

  LEFT JOIN [bld].[vw_schedule] tgt
    ON h.[mta_bkh] = tgt.[mta_bkh]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 1

   AND tgt.[mta_bkh] IS NULL

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - NEW',

       @lognote = 'New Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[Schedule]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- changed records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[schedule] ([bk], [code], [bk_schedule], [schedulecode], [schedulename], [scheduledesc], [startdate], [enddate], [starttime], [endtime], [bk_scheduletype], [scheduletypecode], [scheduletypename], [bk_schedulefrequency], [schedulefrequencycode], [schedulefrequencyname], [bk_scheduledailyinterval], [scheduledailyintervalcode], [scheduledailyintervalname], [bk_scheduleweeklyinterval], [scheduleweeklyintervalcode], [scheduleweeklyintervalname], [bk_scheduleworkdayinterval], [scheduleworkdayintervalcode], [scheduleworkdayintervalname], [bk_schedulemonthlyinterval], [schedulemonthlyintervalcode], [schedulemonthlyintervalname], [bk_schedulequarterlyinterval], [schedulequarterlyintervalcode], [schedulequarterlyintervalname], [bk_scheduleyearlyinterval], [scheduleyearlyintervalcode], [scheduleyearlyintervalname], [bk_schedulespecials], [schedulespecialscode], [schedulespecialsname] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_schedule],

       src.[schedulecode],

       src.[schedulename],

       src.[scheduledesc],

       src.[startdate],

       src.[enddate],

       src.[starttime],

       src.[endtime],

       src.[bk_scheduletype],

       src.[scheduletypecode],

       src.[scheduletypename],

       src.[bk_schedulefrequency],

       src.[schedulefrequencycode],

       src.[schedulefrequencyname],

       src.[bk_scheduledailyinterval],

       src.[scheduledailyintervalcode],

       src.[scheduledailyintervalname],

       src.[bk_scheduleweeklyinterval],

       src.[scheduleweeklyintervalcode],

       src.[scheduleweeklyintervalname],

       src.[bk_scheduleworkdayinterval],

       src.[scheduleworkdayintervalcode],

       src.[scheduleworkdayintervalname],

       src.[bk_schedulemonthlyinterval],

       src.[schedulemonthlyintervalcode],

       src.[schedulemonthlyintervalname],

       src.[bk_schedulequarterlyinterval],

       src.[schedulequarterlyintervalcode],

       src.[schedulequarterlyintervalname],

       src.[bk_scheduleyearlyinterval],

       src.[scheduleyearlyintervalcode],

       src.[scheduleyearlyintervalname],

       src.[bk_schedulespecials],

       src.[schedulespecialscode],

       src.[schedulespecialsname] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_550_schedule_010_default] src

  JOIN # 550_schedule_010_default h
    ON h.[mta_bk] = src.[bk]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 0

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - CHG',

       @lognote = 'Changed Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[Schedule]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- deleted records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[schedule] ([bk], [code], [bk_schedule], [schedulecode], [schedulename], [scheduledesc], [startdate], [enddate], [starttime], [endtime], [bk_scheduletype], [scheduletypecode], [scheduletypename], [bk_schedulefrequency], [schedulefrequencycode], [schedulefrequencyname], [bk_scheduledailyinterval], [scheduledailyintervalcode], [scheduledailyintervalname], [bk_scheduleweeklyinterval], [scheduleweeklyintervalcode], [scheduleweeklyintervalname], [bk_scheduleworkdayinterval], [scheduleworkdayintervalcode], [scheduleworkdayintervalname], [bk_schedulemonthlyinterval], [schedulemonthlyintervalcode], [schedulemonthlyintervalname], [bk_schedulequarterlyinterval], [schedulequarterlyintervalcode], [schedulequarterlyintervalname], [bk_scheduleyearlyinterval], [scheduleyearlyintervalcode], [scheduleyearlyintervalname], [bk_schedulespecials], [schedulespecialscode], [schedulespecialsname] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_schedule],

       src.[schedulecode],

       src.[schedulename],

       src.[scheduledesc],

       src.[startdate],

       src.[enddate],

       src.[starttime],

       src.[endtime],

       src.[bk_scheduletype],

       src.[scheduletypecode],

       src.[scheduletypename],

       src.[bk_schedulefrequency],

       src.[schedulefrequencycode],

       src.[schedulefrequencyname],

       src.[bk_scheduledailyinterval],

       src.[scheduledailyintervalcode],

       src.[scheduledailyintervalname],

       src.[bk_scheduleweeklyinterval],

       src.[scheduleweeklyintervalcode],

       src.[scheduleweeklyintervalname],

       src.[bk_scheduleworkdayinterval],

       src.[scheduleworkdayintervalcode],

       src.[scheduleworkdayintervalname],

       src.[bk_schedulemonthlyinterval],

       src.[schedulemonthlyintervalcode],

       src.[schedulemonthlyintervalname],

       src.[bk_schedulequarterlyinterval],

       src.[schedulequarterlyintervalcode],

       src.[schedulequarterlyintervalname],

       src.[bk_scheduleyearlyinterval],

       src.[scheduleyearlyintervalcode],

       src.[scheduleyearlyintervalname],

       src.[bk_schedulespecials],

       src.[schedulespecialscode],

       src.[schedulespecialsname] ,

       src.[mta_bk],

       src.[mta_bkh],

       src.[mta_rh],

       src.[mta_source],

       [mta_rectype] = -1

  FROM [bld].[vw_schedule] src

  LEFT JOIN # 550_schedule_010_default h
    ON h.[mta_bkh] = src.[mta_bkh]

   AND h.[mta_source] = src.[mta_source]

 WHERE 1 = 1

   AND h.[mta_bkh] IS NULL

   AND src.mta_source = '[bld].[tr_550_Schedule_010_default]'

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - DEL',

       @lognote = 'Changed Deleted',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[Schedule]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime ; -- Clean up ...
 IF object_id('tempdb..#550_Schedule_010_default') IS NOT NULL
  DROP TABLE # 550_schedule_010_default;

   SET @enddatetime = getutcdate()

   SET @duration = datediff(ss, @startdatetime, @enddatetime) PRINT 'Load "load_550_Schedule_010_default" took ' + cast(@duration AS varchar(10)) + ' second(s)'
