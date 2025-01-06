





;
CREATE VIEW [adf].[vw_Schedule_Date] AS 
with 
AllDates as (
select * from adf.vw_DWH_Date d
where 1=1
and d.TheYear between year(getdate())-1 and year(getdate())+1
--and d.TheDate between getdate()-7 and  getdate()+93
)
, UNCDate as (

	-- Get the current UTC "Central European Standard Time" date and time
				Select 
					  CurrentDate		= Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as datetime2) 
					, CurrentTime		= Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as time)  
					, CurrentTimeInt	= (DATEPART(hour, Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as time)  ) * 60) + (DATEPART(minute, Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as time)  ) ) 
					, TimeOutInHours	= 4
)
, GetAllDates as (

-- Get Daily Schedules
	Select 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	From [bld].[vw_Schedule] s
	join AllDates d on cast(d.TheDate as varchar) between s.StartDate and s.EndDate
	Where 1=1 and s.ScheduleTypeName = 'TimeBased' and s.ScheduleFrequencyName = 'Daily'

Union 


-- Get Weekly Schedules
	Select 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	From [bld].[vw_Schedule] s
	join AllDates d on cast(d.TheDate as varchar) between s.StartDate and s.EndDate
	Where 1=1 and s.ScheduleTypeName = 'TimeBased' and s.ScheduleWeeklyIntervalCode = d.TheDayOfWeek

Union 

-- Get workdayOfMonth Schedules
	Select 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	From [bld].[vw_Schedule] s
	join AllDates d on cast(d.TheDate as varchar) between s.StartDate and s.EndDate
	Where 1=1 and s.ScheduleTypeName = 'TimeBased' and s.ScheduleWorkdayIntervalCode = d.WorkDayOfMonth

Union 

-- Get Monthly Schedules
	Select 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	From [bld].[vw_Schedule] s
	join AllDates d on cast(d.TheDate as varchar) between s.StartDate and s.EndDate
	Where 1=1 and s.ScheduleTypeName = 'TimeBased' and s.ScheduleMonthlyIntervalCode = d.TheDay

Union 

-- Get Quarterly Schedules
	-- kind of specials Schedule, just the first or the last day of a quarter
	Select 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	From [bld].[vw_Schedule] s
	join AllDates d on cast(d.TheDate as varchar) between s.StartDate and s.EndDate
							and ( 
									( s.ScheduleQuarterlyIntervalCode = 1 and d.TheDate = d.TheFirstOfQuarter)
									OR 
									( s.ScheduleQuarterlyIntervalCode = 2 and d.TheDate = d.TheLastOfQuarter)
								)
	Where 1=1 and s.ScheduleTypeName = 'TimeBased' 

Union 

-- Get Yearly Schedules
	-- kind of specials Schedule, just the first or the last day of a year
	Select 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	
	From [bld].[vw_Schedule] s
	join AllDates d on cast(d.TheDate as varchar) between s.StartDate and s.EndDate
							and ( 
									( s.ScheduleYearlyIntervalCode = 1 and d.TheDate = d.TheFirstOfYear)
									OR 
									( s.ScheduleYearlyIntervalCode = 2 and d.TheDate = d.TheLastOfYear)
								)
	Where 1=1 and s.ScheduleTypeName = 'TimeBased' 

Union 

-- Get Specials (Last workday of Month, First workday of month etc...)
	Select 
		BK_Schedule							= s.BK
		, d.DateKey
		, d.TheDate
	From [bld].[vw_Schedule] s
	join AllDates d on cast(d.TheDate as varchar) between s.StartDate and s.EndDate
							and ( 
									( s.ScheduleSpecialsCode = 1 and d.TheDate = d.TheLastOfMonth)
									OR 
									( s.ScheduleSpecialsCode = 9 and d.TheDate = d.TheLastWorkDayOfMonth)
									OR 
									( s.ScheduleSpecialsCode = 10 and d.TheDate = d.theFirstWorkdayOfMonth)
								)
	Where 1=1 and s.ScheduleTypeName = 'TimeBased' 
)
select 
	  a.BK_Schedule
	, a.DateKey
	, a.TheDate  
	, s.RepositoryStatusCode
	, s.RepositoryStatusName
	, s.Environment
from GetAllDates a
join adf.vw_Schedule s on a.BK_Schedule = s.BK
--where s.Environment = 'prd'
--order by 2 desc
--where s.bk = 'WDM2_1100'