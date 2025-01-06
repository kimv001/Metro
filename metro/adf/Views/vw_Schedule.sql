
CREATE VIEW [adf].[vw_schedule] AS
SELECT bk,

       code,

       schedulename,

       scheduledesc,

       startdate = TRY_CAST (iif(isnull([startdate], '') = '', '1900-01-01', [startdate]) AS date) , enddate = TRY_CAST (iif(isnull(enddate, '') = '', '9999-12-31', enddate) AS date) , starttime,

       endtime,

       bk_scheduletype,

       scheduletypecode,

       scheduletypename,

       bk_schedulefrequency,

       schedulefrequencycode,

       schedulefrequencyname,

       bk_scheduledailyinterval,

       scheduledailyintervalcode,

       scheduledailyintervalname,

       bk_scheduleweeklyinterval,

       scheduleweeklyintervalcode,

       scheduleweeklyintervalname,

       bk_schedulemonthlyinterval,

       schedulemonthlyintervalcode,

       schedulemonthlyintervalname,

       bk_schedulequarterlyinterval,

       schedulequarterlyintervalcode,

       schedulequarterlyintervalname,

       bk_scheduleyearlyinterval,

       scheduleyearlyintervalcode,

       scheduleyearlyintervalname,

       bk_schedulespecials,

       schedulespecialscode,

       schedulespecialsname --, CRON
,

       repositorystatusname = sdtap.repositorystatus,

       repositorystatuscode = sdtap.repositorystatuscode,

       environment = sdtap.repositorystatus

  FROM bld.vw_schedule

 CROSS JOIN adf.vw_sdtap sdtap

 WHERE 1 = 1

   AND sdtap.repositorystatuscode > -2
