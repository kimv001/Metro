CREATE VIEW [adf].[vw_Schedule] AS 



SELECT 
	  BK
	, Code
	
	, ScheduleName
	, ScheduleDesc
	, StartDate				= try_cast (iif(isnull([StartDate],'')	='', '1900-01-01', [StartDate]) AS date)
	, EndDate				= try_cast (iif(isnull(EndDate,'')		='', '9999-12-31', EndDate) AS date)
	, StartTime
	, EndTime
	, BK_ScheduleType
	, ScheduleTypeCode
	, ScheduleTypeName
	, BK_ScheduleFrequency
	, ScheduleFrequencyCode
	, ScheduleFrequencyName
	, BK_ScheduleDailyInterval
	, ScheduleDailyIntervalCode
	, ScheduleDailyIntervalName
	, BK_ScheduleWeeklyInterval
	, ScheduleWeeklyIntervalCode
	, ScheduleWeeklyIntervalName
	, BK_ScheduleMonthlyInterval
	, ScheduleMonthlyIntervalCode
	, ScheduleMonthlyIntervalName
	, BK_ScheduleQuarterlyInterval
	, ScheduleQuarterlyIntervalCode
	, ScheduleQuarterlyIntervalName
	, BK_ScheduleYearlyInterval
	, ScheduleYearlyIntervalCode
	, ScheduleYearlyIntervalName
	, BK_ScheduleSpecials
	, ScheduleSpecialsCode
	, ScheduleSpecialsName
	--, CRON
	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.RepositoryStatus

FROM bld.vw_Schedule
CROSS JOIN ADF.vw_SDTAP SDTAP
WHERE 1=1
	AND SDTAP.RepositoryStatusCode > -2