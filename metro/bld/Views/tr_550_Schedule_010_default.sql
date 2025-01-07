






CREATE VIEW [bld].[tr_550_Schedule_010_default] AS 


SELECT  
	  BK									= S.BK
	, CODE									= S.CODE
	, [BK_Schedule]							= S.BK
	, [ScheduleCode]						= S.CODE
	, [ScheduleName]						= S.[Name]
	, [ScheduleDesc]						= S.[Description]

	, S.[StartDate]
	, S.[EndDate]
	, S.[StartTime]
	, S.[EndTime]

	, BK_SCHEDULETYPE						= S.BK_SCHEDULETYPE
	, [ScheduleTypeCode]					= RTST.CODE
	, [ScheduleTypeName]					= RTST.[Name]

	, BK_SCHEDULEFREQUENCY					= S.BK_SCHEDULEFREQUENCY
	, [ScheduleFrequencyCode]				= RTSF.CODE
	, [ScheduleFrequencyName]				= RTSF.[Name]

	, BK_SCHEDULEDAILYINTERVAL				= S.BK_SCHEDULEDAILYINTERVAL
	, [ScheduleDailyIntervalCode]			= RTSD.CODE
	, [ScheduleDailyIntervalName]			= RTSD.[Name]

	, BK_SCHEDULEWEEKLYINTERVAL				= S.BK_SCHEDULEWEEKLYINTERVAL
	, [ScheduleWeeklyIntervalCode]			= RTSW.CODE
	, [ScheduleWeeklyIntervalName]			= RTSW.[Name]

	, BK_SCHEDULEWORKDAYINTERVAL			= S.BK_SCHEDULEWORKDAYINTERVAL
	, [ScheduleWorkDayIntervalCode]			= RTWD.CODE
	, [ScheduleWorkDayIntervalName]			= RTWD.[Name]
	
	, BK_SCHEDULEMONTHLYINTERVAL			= S.BK_SCHEDULEMONTHLYINTERVAL
	, [ScheduleMonthlyIntervalCode]			= RTSM.CODE
	, [ScheduleMonthlyIntervalName]			= RTSM.[Name]

	, BK_SCHEDULEQUARTERLYINTERVAL			= S.BK_SCHEDULEQUARTERLYINTERVAL
	, [ScheduleQuarterlyIntervalCode]		= RTSQ.CODE
	, [ScheduleQuarterlyIntervalName]		= RTSQ.[Name]

	, BK_SCHEDULEYEARLYINTERVAL				= S.BK_SCHEDULEYEARLYINTERVAL
	, [ScheduleYearlyIntervalCode]			= RTSY.CODE
	, [ScheduleYearlyIntervalName]			= RTSY.[Name]

	, BK_SCHEDULESPECIALS					= S.BK_SCHEDULESPECIALS
	, [ScheduleSpecialsCode]				= RTSS.CODE
	, [ScheduleSpecialsName]				= RTSS.[Name]


-- future use
	--, s.[CRON]
    

FROM REP.[vw_Schedule] S
LEFT JOIN BLD.VW_REFTYPE RTST ON  RTST.BK	= S.BK_SCHEDULETYPE
LEFT JOIN BLD.VW_REFTYPE RTSF ON  RTSF.BK	= S.BK_SCHEDULEFREQUENCY
LEFT JOIN BLD.VW_REFTYPE RTSD ON  RTSD.BK	= S.BK_SCHEDULEDAILYINTERVAL
LEFT JOIN BLD.VW_REFTYPE RTSW ON  RTSW.BK	= S.BK_SCHEDULEWEEKLYINTERVAL
LEFT JOIN BLD.VW_REFTYPE RTWD ON  RTWD.BK	= S.BK_SCHEDULEWORKDAYINTERVAL
LEFT JOIN BLD.VW_REFTYPE RTSM ON  RTSM.BK	= S.BK_SCHEDULEMONTHLYINTERVAL
LEFT JOIN BLD.VW_REFTYPE RTSQ ON  RTSQ.BK	= S.BK_SCHEDULEQUARTERLYINTERVAL
LEFT JOIN BLD.VW_REFTYPE RTSY ON  RTSY.BK	= S.BK_SCHEDULEYEARLYINTERVAL
LEFT JOIN BLD.VW_REFTYPE RTSS ON  RTSS.BK	= S.BK_SCHEDULESPECIALS