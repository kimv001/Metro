

CREATE VIEW [adf].[vw_Schedule_Time] AS 
WITH UNCDate AS (

	-- Get the current UTC "Central European Standard Time" date and time
				SELECT 
					  CurrentDate		= CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS datetime2) 
					, CurrentTime		= CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS time)  
					, CurrentTimeInt	= (DATEPART(HOUR, CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS time)  ) * 60)
					+ (DATEPART(MINUTE, CAST (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' AS time)  ) ) 
					, TimeOutInHours	= 4
)
, Times AS (
	SELECT  
		  Time_HH_MM_SS
		, Time_Int
		, RepositoryStatusName
		, RepositoryStatusCode
		, Environment
	FROM [adf].[vw_DWH_Time]
)
, MinuteSchedules AS (

		SELECT 
			  StartTime_Int	= (DATEPART(HOUR, isnull(s.starttime	,'1900-01-01 00:00')) *  60)	+ (DATEPART(MINUTE, isnull(s.starttime	,'1900-01-01 00:00')	) ) 
			, EndTime_Int	= (DATEPART(HOUR, isnull(s.endtime		,'9999-12-31 13:59')) * 60)		+ (DATEPART(MINUTE, isnull(s.endtime	,'9999-12-31 13:59')	) ) 
			, * 
		FROM [adf].[vw_Schedule] s
		CROSS JOIN UNCDate d
		WHERE s.ScheduleDailyIntervalCode>0
		AND d.CurrentDate >= s.StartDate
		AND d.CurrentDate < s.endDate
		)
, OnceaDaySchedule AS  (

			SELECT 
				  BK_Schedule				= s.BK
				, ScheduleCode				= s.Code
				, ScheduleDailyIntervalCode	= s.ScheduleDailyIntervalCode
				, StartDate					= s.StartDate
				, EndDate					= s.EndDate
				, StartTime					= isnull(s.StartTime,'1900-01-01 00:00')
				, StartTime_Short			= CAST(CAST(isnull(s.StartTime,'1900-01-01 00:00') AS time)  AS varchar(5))
				, StartTime_Int				= (DATEPART(HOUR, isnull(s.starttime	,'1900-01-01 00:00')) *  60)	+ (DATEPART(MINUTE, isnull(s.starttime	,'1900-01-01 00:00')	) ) 
				, EndTime					= s.EndTime
				, RepositoryStatusCode		= s.RepositoryStatusCode
				, RepositoryStatusName		= s.RepositoryStatusName
				, Environment				= s.Environment
				--select *	
			FROM adf.vw_Schedule		s
			CROSS JOIN UNCDate d
			WHERE 1=1
				AND s.ScheduleTypeName			= 'TimeBased'
				--and s.BK_ScheduleFrequency		= 'SF|1|Daily'
				--and s.BK_ScheduleDailyInterval	= 'SDI|0|once'
				AND isnull(s.ScheduleDailyIntervalCode,0) < 1
)
-- Minute Schedules
SELECT
	  BK_Schedule				= s.BK
	, ScheduleCode				= s.Code
	, StartDate					= s.StartDate
	, EndDate					= s.EndDate
	, StartFrom					= CAST(CAST(s.starttime AS time) AS varchar(5))
	, StartTill					= CAST(CAST(s.endtime AS time) AS varchar(5)) 
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
FROM MinuteSchedules s
CROSS JOIN UNCDate d
JOIN   Times  t  ON s.StartTime_Int <= t.Time_Int  AND s.EndTime_Int > t.Time_Int  AND s.Environment = t.Environment--and  d.CurrentTimeInt < s.EndTimeInt
WHERE 1=1
-- the minute trick, calculate minutes diff and finish it with a modulo. The outcome must be 0
AND (t.Time_Int - s.StartTime_Int ) %  s.ScheduleDailyIntervalCode = 0

UNION ALL

-- Once a Day Schedule
SELECT 
	 BK_Schedule				= ODS.BK_Schedule
	, ScheduleCode				= ODS.ScheduleCode
	, StartDate					= ODS.StartDate
	, EndDate					= ODS.EndDate
	, StartFrom					= CAST(CAST(ODS.starttime	AS time) AS varchar(5))
	, StartTill					= CAST(CAST(ODS.endtime		AS time) AS varchar(5)) 
	, ScheduleDailyIntervalCode	= isnull(ODS.ScheduleDailyIntervalCode,0)
	, ScheduleTime				= ODS.starttime
	, RepositoryStatusCode		= ODS.RepositoryStatusCode
	, RepositoryStatusName		= ODS.RepositoryStatusName
	, Environment				= ODS.Environment
FROM OnceaDaySchedule ODS;