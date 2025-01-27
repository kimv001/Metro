






CREATE VIEW [bld].[tr_550_Schedule_010_default] AS 

/*
Description:
    This view builds up the default schedule definitions. It provides detailed information about schedules, including their types, frequencies, and intervals.

Columns:
    - BK: The business key of the schedule.
    - CODE: The code of the schedule.
    - BK_Schedule: The business key of the schedule.
    - ScheduleCode: The code of the schedule.
    - ScheduleName: The name of the schedule.
    - ScheduleDesc: The description of the schedule.
    - StartDate: The start date of the schedule.
    - EndDate: The end date of the schedule.
    - StartTime: The start time of the schedule.
    - EndTime: The end time of the schedule.
    - BK_SCHEDULETYPE: The business key of the schedule type.
    - ScheduleTypeCode: The code of the schedule type.
    - ScheduleTypeName: The name of the schedule type.
    - BK_SCHEDULEFREQUENCY: The business key of the schedule frequency.
    - ScheduleFrequencyCode: The code of the schedule frequency.
    - ScheduleFrequencyName: The name of the schedule frequency.
    - BK_SCHEDULEDAILYINTERVAL: The business key of the schedule daily interval.
    - ScheduleDailyIntervalCode: The code of the schedule daily interval.
    - ScheduleDailyIntervalName: The name of the schedule daily interval.
    - BK_SCHEDULEWEEKLYINTERVAL: The business key of the schedule weekly interval.
    - ScheduleWeeklyIntervalCode: The code of the schedule weekly interval.
    - ScheduleWeeklyIntervalName: The name of the schedule weekly interval.
    - BK_SCHEDULEWORKDAYINTERVAL: The business key of the schedule workday interval.
    - ScheduleWorkDayIntervalCode: The code of the schedule workday interval.
    - ScheduleWorkDayIntervalName: The name of the schedule workday interval.
    - BK_SCHEDULEMONTHLYINTERVAL: The business key of the schedule monthly interval.
    - ScheduleMonthlyIntervalCode: The code of the schedule monthly interval.
    - ScheduleMonthlyIntervalName: The name of the schedule monthly interval.

Example Usage:
    SELECT * FROM [bld].[tr_550_Schedule_010_default]

Logic:
    1. Selects schedule definitions from the [rep].[vw_Schedule] view.
    2. Joins with the [rep].[vw_RefType] view to get additional schedule attributes.

Source Data:
    - [rep].[vw_Schedule]: Contains schedule definitions.
    - [rep].[vw_RefType]: Contains reference types used in the data warehouse.

Changelog:
Date        Time        Author              Description
20220804    0000 	 	K. Vermeij          Initial version
	*/

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