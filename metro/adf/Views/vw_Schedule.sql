CREATE view [adf].[vw_Schedule] as 



Select 
	  BK
	, Code
	
	, ScheduleName
	, ScheduleDesc
	, StartDate				= try_cast (iif(isnull([StartDate],'')	='', '1900-01-01', [StartDate]) as date)
	, EndDate				= try_cast (iif(isnull(EndDate,'')		='', '9999-12-31', EndDate) as date)
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

From bld.vw_Schedule
Cross join ADF.vw_SDTAP SDTAP
where 1=1
	and SDTAP.RepositoryStatusCode > -2