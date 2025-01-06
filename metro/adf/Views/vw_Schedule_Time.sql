
CREATE VIEW [adf].[vw_schedule_time] AS WITH uncdate AS

        (-- Get the current UTC "Central European Standard Time" date and time
 SELECT currentdate = CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS datetime2) , currenttime = CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS TIME) , currenttimeint = (datepart(HOUR, CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS TIME)) * 60) + (datepart(MINUTE, CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS TIME))),

               timeoutinhours = 4
       ),

       times AS

        (SELECT time_hh_mm_ss,

               time_int,

               repositorystatusname,

               repositorystatuscode,

               environment

          FROM [adf].[vw_dwh_time]
       ),

       minuteschedules AS

        (SELECT starttime_int = (datepart(HOUR, isnull(s.starttime, '1900-01-01 00:00')) * 60) + (datepart(MINUTE, isnull(s.starttime, '1900-01-01 00:00'))),

               endtime_int = (datepart(HOUR, isnull(s.endtime, '9999-12-31 13:59')) * 60) + (datepart(MINUTE, isnull(s.endtime, '9999-12-31 13:59'))),

               *

          FROM [adf].[vw_schedule] s

         CROSS JOIN uncdate d

         WHERE s.scheduledailyintervalcode > 0

           AND d.currentdate >= s.startdate

           AND d.currentdate < s.enddate
       ),

       onceadayschedule AS

        (SELECT bk_schedule = s.bk,

               schedulecode = s.code,

               scheduledailyintervalcode = s.scheduledailyintervalcode,

               startdate = s.startdate,

               enddate = s.enddate,

               starttime = isnull(s.starttime, '1900-01-01 00:00'),

               starttime_short = cast(cast(isnull(s.starttime, '1900-01-01 00:00') AS TIME) AS varchar(5)),

               starttime_int = (datepart(HOUR, isnull(s.starttime, '1900-01-01 00:00')) * 60) + (datepart(MINUTE, isnull(s.starttime, '1900-01-01 00:00'))),

               endtime = s.endtime,

               repositorystatuscode = s.repositorystatuscode,

               repositorystatusname = s.repositorystatusname,

               environment = s.environment --select *

          FROM adf.vw_schedule s

         CROSS JOIN uncdate d

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased' --and s.BK_ScheduleFrequency		= 'SF|1|Daily'
 --and s.BK_ScheduleDailyInterval	= 'SDI|0|once'

           AND isnull(s.scheduledailyintervalcode, 0) < 1
       ) -- Minute Schedules

SELECT bk_schedule = s.bk,

       schedulecode = s.code,

       startdate = s.startdate,

       enddate = s.enddate,

       startfrom = cast(cast(s.starttime AS TIME) AS varchar(5)),

       starttill = cast(cast(s.endtime AS TIME) AS varchar(5)),

       scheduledailyintervalcode = s.scheduledailyintervalcode,

       scheduletime = t.time_hh_mm_ss,

       repositorystatuscode = s.repositorystatuscode,

       repositorystatusname = s.repositorystatusname,

       environment = s.environment /*
	, d.CurrentTimeInt
	, s.StartTimeInt
	, t.TimeInt
	, ( t.TimeInt - s.StartTimeInt) Step1_minute_Diff
	,  (t.TimeInt - s.StartTimeInt ) %  s.ScheduleDailyIntervalCode ModulusZerOrNot
	*/

  FROM minuteschedules s

 CROSS JOIN uncdate d

  JOIN times t
    ON s.starttime_int <= t.time_int

   AND s.endtime_int > t.time_int

   AND s.environment = t.environment--and  d.CurrentTimeInt < s.EndTimeInt

 WHERE 1 = 1

   AND (t.time_int - s.starttime_int) % s.scheduledailyintervalcode = 0 -- the minute trick, calculate minutes diff and finish it with a modulo. The outcome must be 0

UNION ALL -- Once a Day Schedule

SELECT bk_schedule = ods.bk_schedule,

       schedulecode = ods.schedulecode,

       startdate = ods.startdate,

       enddate = ods.enddate,

       startfrom = cast(cast(ods.starttime AS TIME) AS varchar(5)),

       starttill = cast(cast(ods.endtime AS TIME) AS varchar(5)),

       scheduledailyintervalcode = isnull(ods.scheduledailyintervalcode, 0),

       scheduletime = ods.starttime,

       repositorystatuscode = ods.repositorystatuscode,

       repositorystatusname = ods.repositorystatusname,

       environment = ods.environment

  FROM onceadayschedule ods;
