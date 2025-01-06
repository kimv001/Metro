

CREATE VIEW [adf].[vw_Schedule_Time] AS 
with UNCDate as (

	-- Get the current UTC "Central European Standard Time" date and time
				Select 
					  CurrentDate		= Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as datetime2) 
					, CurrentTime		= Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as time)  
					, CurrentTimeInt	= (DATEPART(hour, Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as time)  ) * 60) + (DATEPART(minute, Cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as time)  ) ) 
					, TimeOutInHours	= 4
)
, Times as (
	select  
		  Time_HH_MM_SS
		, Time_Int
		, RepositoryStatusName
		, RepositoryStatusCode
		, Environment
	from [adf].[vw_DWH_Time]
)
, MinuteSchedules as (

		select 
			  StartTime_Int	= (DATEPART(hour, isnull(s.starttime	,'1900-01-01 00:00')) *  60)	+ (DATEPART(minute, isnull(s.starttime	,'1900-01-01 00:00')	) ) 
			, EndTime_Int	= (DATEPART(hour, isnull(s.endtime		,'9999-12-31 13:59')) * 60)		+ (DATEPART(minute, isnull(s.endtime	,'9999-12-31 13:59')	) ) 
			, * 
		from [adf].[vw_Schedule] s
		cross join UNCDate d
		where s.ScheduleDailyIntervalCode>0
		and d.CurrentDate >= s.StartDate
		and d.CurrentDate < s.endDate
		)
, OnceaDaySchedule as  (

			Select 
				  BK_Schedule				= s.BK
				, ScheduleCode				= s.Code
				, ScheduleDailyIntervalCode	= s.ScheduleDailyIntervalCode
				, StartDate					= s.StartDate
				, EndDate					= s.EndDate
				, StartTime					= isnull(s.StartTime,'1900-01-01 00:00')
				, StartTime_Short			= Cast(cast(isnull(s.StartTime,'1900-01-01 00:00') as time)  as varchar(5))
				, StartTime_Int				= (DATEPART(hour, isnull(s.starttime	,'1900-01-01 00:00')) *  60)	+ (DATEPART(minute, isnull(s.starttime	,'1900-01-01 00:00')	) ) 
				, EndTime					= s.EndTime
				, RepositoryStatusCode		= s.RepositoryStatusCode
				, RepositoryStatusName		= s.RepositoryStatusName
				, Environment				= s.Environment
				--select *	
			From adf.vw_Schedule		s
			cross join UNCDate d
			Where 1=1
				and s.ScheduleTypeName			= 'TimeBased'
				--and s.BK_ScheduleFrequency		= 'SF|1|Daily'
				--and s.BK_ScheduleDailyInterval	= 'SDI|0|once'
				and isnull(s.ScheduleDailyIntervalCode,0) < 1
)
-- Minute Schedules
select
	  BK_Schedule				= s.BK
	, ScheduleCode				= s.Code
	, StartDate					= s.StartDate
	, EndDate					= s.EndDate
	, StartFrom					= cast(cast(s.starttime as time) as varchar(5))
	, StartTill					= cast(cast(s.endtime as time) as varchar(5)) 
	, ScheduleDailyIntervalCode	= s.ScheduleDailyIntervalCode
	, ScheduleTime				= t.Time_HH_MM_SS
	, RepositoryStatusCode		= s.RepositoryStatusCode
	, RepositoryStatusName		= s.RepositoryStatusName
	, Environment				= s.Environment
	/*
	, d.CurrentTimeInt
	, s.StartTimeInt
	, t.TimeInt 
	, ( t.TimeInt - s.StartTimeInt) Step1_minute_Diff
	,  (t.TimeInt - s.StartTimeInt ) %  s.ScheduleDailyIntervalCode ModulusZerOrNot
	*/
from MinuteSchedules s
cross join UNCDate d
join   Times  t  on s.StartTime_Int <= t.Time_Int  and s.EndTime_Int > t.Time_Int  and s.Environment = t.Environment--and  d.CurrentTimeInt < s.EndTimeInt
where 1=1
and (t.Time_Int - s.StartTime_Int ) %  s.ScheduleDailyIntervalCode = 0 -- the minute trick, calculate minutes diff and finish it with a modulo. The outcome must be 0

Union All

-- Once a Day Schedule
Select 
	 BK_Schedule				= ODS.BK_Schedule
	, ScheduleCode				= ODS.ScheduleCode
	, StartDate					= ODS.StartDate
	, EndDate					= ODS.EndDate
	, StartFrom					= cast(cast(ODS.starttime	as time) as varchar(5))
	, StartTill					= cast(cast(ODS.endtime		as time) as varchar(5)) 
	, ScheduleDailyIntervalCode	= isnull(ODS.ScheduleDailyIntervalCode,0)
	, ScheduleTime				= ODS.starttime
	, RepositoryStatusCode		= ODS.RepositoryStatusCode
	, RepositoryStatusName		= ODS.RepositoryStatusName
	, Environment				= ODS.Environment
From OnceaDaySchedule ODS;