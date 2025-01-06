






CREATE view [bld].[tr_550_Schedule_010_default] as 


SELECT  
	  BK									= s.BK
	, Code									= s.Code
	, [BK_Schedule]							= s.BK
	, [ScheduleCode]						= s.Code
	, [ScheduleName]						= s.[Name]
	, [ScheduleDesc]						= s.[Description]

	, s.[StartDate]
	, s.[EndDate]
	, s.[StartTime]
	, s.[EndTime]

	, BK_ScheduleType						= s.BK_ScheduleType
	, [ScheduleTypeCode]					= rtST.Code
	, [ScheduleTypeName]					= rtST.[Name]

	, BK_ScheduleFrequency					= s.BK_ScheduleFrequency
	, [ScheduleFrequencyCode]				= rtSF.Code
	, [ScheduleFrequencyName]				= rtSF.[Name]

	, BK_ScheduleDailyInterval				= s.BK_ScheduleDailyInterval
	, [ScheduleDailyIntervalCode]			= rtSD.Code
	, [ScheduleDailyIntervalName]			= rtSD.[Name]

	, BK_ScheduleWeeklyInterval				= s.BK_ScheduleWeeklyInterval
	, [ScheduleWeeklyIntervalCode]			= rtSW.Code
	, [ScheduleWeeklyIntervalName]			= rtSW.[Name]

	, BK_ScheduleWorkDayInterval			= s.BK_ScheduleWorkdayInterval
	, [ScheduleWorkDayIntervalCode]			= rtWD.Code
	, [ScheduleWorkDayIntervalName]			= rtWD.[Name]
	
	, BK_ScheduleMonthlyInterval			= s.BK_ScheduleMonthlyInterval
	, [ScheduleMonthlyIntervalCode]			= rtSM.Code
	, [ScheduleMonthlyIntervalName]			= rtSM.[Name]

	, BK_ScheduleQuarterlyInterval			= s.BK_ScheduleQuarterlyInterval
	, [ScheduleQuarterlyIntervalCode]		= rtSQ.Code
	, [ScheduleQuarterlyIntervalName]		= rtSQ.[Name]

	, BK_ScheduleYearlyInterval				= s.BK_ScheduleYearlyInterval
	, [ScheduleYearlyIntervalCode]			= rtSY.Code
	, [ScheduleYearlyIntervalName]			= rtSY.[Name]

	, BK_ScheduleSpecials					= s.BK_ScheduleSpecials
	, [ScheduleSpecialsCode]				= rtSS.Code
	, [ScheduleSpecialsName]				= rtSS.[Name]


-- future use
	--, s.[CRON]
    

From rep.[vw_Schedule] s
left join bld.vw_RefType rtST on  rtST.BK	= s.BK_ScheduleType
left join bld.vw_RefType rtSF on  rtSF.BK	= s.BK_ScheduleFrequency
left join bld.vw_RefType rtSD on  rtSD.BK	= s.BK_ScheduleDailyInterval
left join bld.vw_RefType rtSW on  rtSW.BK	= s.BK_ScheduleWeeklyInterval
left join bld.vw_RefType rtWD on  rtWD.BK	= s.BK_ScheduleWorkdayInterval
left join bld.vw_RefType rtSM on  rtSM.BK	= s.BK_ScheduleMonthlyInterval
left join bld.vw_RefType rtSQ on  rtSQ.BK	= s.BK_ScheduleQuarterlyInterval
left join bld.vw_RefType rtSY on  rtSY.BK	= s.BK_ScheduleYearlyInterval
left join bld.vw_RefType rtSS on  rtSS.BK	= s.BK_ScheduleSpecials