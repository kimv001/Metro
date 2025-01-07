
CREATE VIEW [adf].[vw_Schedule_Date] AS 
WITH 
AllDates AS (
SELECT * FROM adf.vw_DWH_Date d
WHERE 1=1
AND d.TheYear BETWEEN year(getdate())-1 AND year(getdate())+1
--and d.TheDate between getdate()-7 and  getdate()+93
)
, UNCDate AS (

	-- Get the current UTC "Central European Standard Time" date and time
				SELECT 
					  CurrentDate		= CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS datetime2) 
					, CurrentTime		= CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS time)  
					, CurrentTimeInt	= (DATEPART(HOUR, CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS time)  ) * 60)
					+ (DATEPART(MINUTE, CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS time)  ) ) 
					, TimeOutInHours	= 4
)
, GetAllDates AS (

-- Get Daily Schedules
	SELECT 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	FROM [bld].[vw_Schedule] s
	JOIN AllDates d ON CAST(d.TheDate AS varchar) BETWEEN s.StartDate AND s.EndDate
	WHERE 1=1 AND s.ScheduleTypeName = 'TimeBased' AND s.ScheduleFrequencyName = 'Daily'

UNION 


-- Get Weekly Schedules
	SELECT 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	FROM [bld].[vw_Schedule] s
	JOIN AllDates d ON CAST(d.TheDate AS varchar) BETWEEN s.StartDate AND s.EndDate
	WHERE 1=1 AND s.ScheduleTypeName = 'TimeBased' AND s.ScheduleWeeklyIntervalCode = d.TheDayOfWeek

UNION 

-- Get workdayOfMonth Schedules
	SELECT 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	FROM [bld].[vw_Schedule] s
	JOIN AllDates d ON CAST(d.TheDate AS varchar) BETWEEN s.StartDate AND s.EndDate
	WHERE 1=1 AND s.ScheduleTypeName = 'TimeBased' AND s.ScheduleWorkdayIntervalCode = d.WorkDayOfMonth

UNION 

-- Get Monthly Schedules
	SELECT 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	FROM [bld].[vw_Schedule] s
	JOIN AllDates d ON CAST(d.TheDate AS varchar) BETWEEN s.StartDate AND s.EndDate
	WHERE 1=1 AND s.ScheduleTypeName = 'TimeBased' AND s.ScheduleMonthlyIntervalCode = d.TheDay

UNION 

-- Get Quarterly Schedules
	-- kind of specials Schedule, just the first or the last day of a quarter
	SELECT 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	FROM [bld].[vw_Schedule] s
	JOIN AllDates d ON CAST(d.TheDate AS varchar) BETWEEN s.StartDate AND s.EndDate
							AND ( 
									( s.ScheduleQuarterlyIntervalCode = 1 AND d.TheDate = d.TheFirstOfQuarter)
									OR 
									( s.ScheduleQuarterlyIntervalCode = 2 AND d.TheDate = d.TheLastOfQuarter)
								)
	WHERE 1=1 AND s.ScheduleTypeName = 'TimeBased' 

UNION 

-- Get Yearly Schedules
	-- kind of specials Schedule, just the first or the last day of a year
	SELECT 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	
	FROM [bld].[vw_Schedule] s
	JOIN AllDates d ON CAST(d.TheDate AS varchar) BETWEEN s.StartDate AND s.EndDate
							AND ( 
									( s.ScheduleYearlyIntervalCode = 1 AND d.TheDate = d.TheFirstOfYear)
									OR 
									( s.ScheduleYearlyIntervalCode = 2 AND d.TheDate = d.TheLastOfYear)
								)
	WHERE 1=1 AND s.ScheduleTypeName = 'TimeBased' 

UNION 

-- Get Specials (Last workday of Month, First workday of month etc...)
	SELECT 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	FROM [bld].[vw_Schedule] s
	JOIN AllDates d ON CAST(d.TheDate AS varchar) BETWEEN s.StartDate AND s.EndDate
							AND ( 
									( s.ScheduleSpecialsCode = 1 AND d.TheDate = d.TheLastOfMonth)
									OR 
									( s.ScheduleSpecialsCode = 9 AND d.TheDate = d.TheLastWorkDayOfMonth)
									OR 
									( s.ScheduleSpecialsCode = 10 AND d.TheDate = d.theFirstWorkdayOfMonth)
								)
	WHERE 1=1 AND s.ScheduleTypeName = 'TimeBased' 
)
SELECT 
	  a.BK_Schedule
	, a.DateKey
	, a.TheDate  
	, s.RepositoryStatusCode
	, s.RepositoryStatusName
	, s.Environment
FROM GetAllDates a
JOIN adf.vw_Schedule s ON a.BK_Schedule = s.BK
--where s.Environment = 'prd'
--order by 2 desc
--where s.bk = 'WDM2_1100'