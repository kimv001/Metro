 ;
CREATE VIEW [adf].[vw_schedule_date] AS WITH alldates AS

        (SELECT *

          FROM adf.vw_dwh_date d

         WHERE 1 = 1

           AND d.theyear BETWEEN year(getdate())-1 AND year(getdate()) + 1 --and d.TheDate between getdate()-7 and  getdate()+93

       ),

       uncdate AS

        (-- Get the current UTC "Central European Standard Time" date and time
 SELECT currentdate = CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS datetime2) , currenttime = CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS TIME) , currenttimeint = (datepart(HOUR, CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS TIME)) * 60) + (datepart(MINUTE, CAST (getutcdate() AT TIME ZONE 'UTC' AT TIME ZONE 'CENTRAL EUROPEAN STANDARD TIME' AS TIME))) ,

               timeoutinhours = 4
       ),

       getalldates AS

        (-- Get Daily Schedules
 SELECT bk_schedule = s.bk ,

               d.datekey ,

               d.thedate

          FROM [bld].[vw_schedule] s

          JOIN alldates d
            ON cast(d.thedate AS varchar) BETWEEN s.startdate AND s.enddate

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased'

           AND s.schedulefrequencyname = 'Daily'

         UNION -- Get Weekly Schedules
 SELECT bk_schedule = s.bk ,

               d.datekey ,

               d.thedate

          FROM [bld].[vw_schedule] s

          JOIN alldates d
            ON cast(d.thedate AS varchar) BETWEEN s.startdate AND s.enddate

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased'

           AND s.scheduleweeklyintervalcode = d.thedayofweek

         UNION -- Get workdayOfMonth Schedules
 SELECT bk_schedule = s.bk ,

               d.datekey ,

               d.thedate

          FROM [bld].[vw_schedule] s

          JOIN alldates d
            ON cast(d.thedate AS varchar) BETWEEN s.startdate AND s.enddate

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased'

           AND s.scheduleworkdayintervalcode = d.workdayofmonth

         UNION -- Get Monthly Schedules
 SELECT bk_schedule = s.bk ,

               d.datekey ,

               d.thedate

          FROM [bld].[vw_schedule] s

          JOIN alldates d
            ON cast(d.thedate AS varchar) BETWEEN s.startdate AND s.enddate

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased'

           AND s.schedulemonthlyintervalcode = d.theday

         UNION -- Get Quarterly Schedules
 -- kind of specials Schedule, just the first or the last day of a quarter
 SELECT bk_schedule = s.bk ,

               d.datekey ,

               d.thedate

          FROM [bld].[vw_schedule] s

          JOIN alldates d
            ON cast(d.thedate AS varchar) BETWEEN s.startdate AND s.enddate

           AND ((s.schedulequarterlyintervalcode = 1
         AND d.thedate = d.thefirstofquarter)
        OR (s.schedulequarterlyintervalcode = 2
            AND d.thedate = d.thelastofquarter))

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased'

         UNION -- Get Yearly Schedules
 -- kind of specials Schedule, just the first or the last day of a year
 SELECT bk_schedule = s.bk ,

               d.datekey ,

               d.thedate

          FROM [bld].[vw_schedule] s

          JOIN alldates d
            ON cast(d.thedate AS varchar) BETWEEN s.startdate AND s.enddate

           AND ((s.scheduleyearlyintervalcode = 1
         AND d.thedate = d.thefirstofyear)
        OR (s.scheduleyearlyintervalcode = 2
            AND d.thedate = d.thelastofyear))

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased'

         UNION -- Get Specials (Last workday of Month, First workday of month etc...)
 SELECT bk_schedule = s.bk ,

               d.datekey ,

               d.thedate

          FROM [bld].[vw_schedule] s

          JOIN alldates d
            ON cast(d.thedate AS varchar) BETWEEN s.startdate AND s.enddate

           AND ((s.schedulespecialscode = 1
         AND d.thedate = d.thelastofmonth)
        OR (s.schedulespecialscode = 9
            AND d.thedate = d.thelastworkdayofmonth)
        OR (s.schedulespecialscode = 10
            AND d.thedate = d.thefirstworkdayofmonth))

         WHERE 1 = 1

           AND s.scheduletypename = 'TimeBased'
       )
SELECT a.bk_schedule ,

       a.datekey ,

       a.thedate ,

       s.repositorystatuscode ,

       s.repositorystatusname ,

       s.environment

  FROM getalldates a

  JOIN adf.vw_schedule s
    ON a.bk_schedule = s.bk --where s.Environment = 'prd'
--order by 2 desc
--where s.bk = 'WDM2_1100'