﻿
        CREATE   VIEW [bld].[vw_Schedule] AS
        /*
        View is generated by  : metro
        Generated at          : 2025-01-06 14:43:22
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                [ScheduleId] AS [ScheduleId],
                [BK] AS [BK],
                [Code] AS [Code],
                [BK_Schedule] AS [BK_Schedule],
                [ScheduleCode] AS [ScheduleCode],
                [ScheduleName] AS [ScheduleName],
                [ScheduleDesc] AS [ScheduleDesc],
                [StartDate] AS [StartDate],
                [EndDate] AS [EndDate],
                [StartTime] AS [StartTime],
                [EndTime] AS [EndTime],
                [BK_ScheduleType] AS [BK_ScheduleType],
                [ScheduleTypeCode] AS [ScheduleTypeCode],
                [ScheduleTypeName] AS [ScheduleTypeName],
                [BK_ScheduleFrequency] AS [BK_ScheduleFrequency],
                [ScheduleFrequencyCode] AS [ScheduleFrequencyCode],
                [ScheduleFrequencyName] AS [ScheduleFrequencyName],
                [BK_ScheduleDailyInterval] AS [BK_ScheduleDailyInterval],
                [ScheduleDailyIntervalCode] AS [ScheduleDailyIntervalCode],
                [ScheduleDailyIntervalName] AS [ScheduleDailyIntervalName],
                [BK_ScheduleWeeklyInterval] AS [BK_ScheduleWeeklyInterval],
                [ScheduleWeeklyIntervalCode] AS [ScheduleWeeklyIntervalCode],
                [ScheduleWeeklyIntervalName] AS [ScheduleWeeklyIntervalName],
                [BK_ScheduleWorkDayInterval] AS [BK_ScheduleWorkDayInterval],
                [ScheduleWorkDayIntervalCode] AS [ScheduleWorkDayIntervalCode],
                [ScheduleWorkDayIntervalName] AS [ScheduleWorkDayIntervalName],
                [BK_ScheduleMonthlyInterval] AS [BK_ScheduleMonthlyInterval],
                [ScheduleMonthlyIntervalCode] AS [ScheduleMonthlyIntervalCode],
                [ScheduleMonthlyIntervalName] AS [ScheduleMonthlyIntervalName],
                [BK_ScheduleQuarterlyInterval] AS [BK_ScheduleQuarterlyInterval],
                [ScheduleQuarterlyIntervalCode] AS [ScheduleQuarterlyIntervalCode],
                [ScheduleQuarterlyIntervalName] AS [ScheduleQuarterlyIntervalName],
                [BK_ScheduleYearlyInterval] AS [BK_ScheduleYearlyInterval],
                [ScheduleYearlyIntervalCode] AS [ScheduleYearlyIntervalCode],
                [ScheduleYearlyIntervalName] AS [ScheduleYearlyIntervalName],
                [BK_ScheduleSpecials] AS [BK_ScheduleSpecials],
                [ScheduleSpecialsCode] AS [ScheduleSpecialsCode],
                [ScheduleSpecialsName] AS [ScheduleSpecialsName],
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [bld].[Schedule]
               
        )
        SELECT 
            [ScheduleId] AS [ScheduleId],
            [BK] AS [BK],
            [Code] AS [Code],
            [BK_Schedule] AS [BK_Schedule],
            [ScheduleCode] AS [ScheduleCode],
            [ScheduleName] AS [ScheduleName],
            [ScheduleDesc] AS [ScheduleDesc],
            [StartDate] AS [StartDate],
            [EndDate] AS [EndDate],
            [StartTime] AS [StartTime],
            [EndTime] AS [EndTime],
            [BK_ScheduleType] AS [BK_ScheduleType],
            [ScheduleTypeCode] AS [ScheduleTypeCode],
            [ScheduleTypeName] AS [ScheduleTypeName],
            [BK_ScheduleFrequency] AS [BK_ScheduleFrequency],
            [ScheduleFrequencyCode] AS [ScheduleFrequencyCode],
            [ScheduleFrequencyName] AS [ScheduleFrequencyName],
            [BK_ScheduleDailyInterval] AS [BK_ScheduleDailyInterval],
            [ScheduleDailyIntervalCode] AS [ScheduleDailyIntervalCode],
            [ScheduleDailyIntervalName] AS [ScheduleDailyIntervalName],
            [BK_ScheduleWeeklyInterval] AS [BK_ScheduleWeeklyInterval],
            [ScheduleWeeklyIntervalCode] AS [ScheduleWeeklyIntervalCode],
            [ScheduleWeeklyIntervalName] AS [ScheduleWeeklyIntervalName],
            [BK_ScheduleWorkDayInterval] AS [BK_ScheduleWorkDayInterval],
            [ScheduleWorkDayIntervalCode] AS [ScheduleWorkDayIntervalCode],
            [ScheduleWorkDayIntervalName] AS [ScheduleWorkDayIntervalName],
            [BK_ScheduleMonthlyInterval] AS [BK_ScheduleMonthlyInterval],
            [ScheduleMonthlyIntervalCode] AS [ScheduleMonthlyIntervalCode],
            [ScheduleMonthlyIntervalName] AS [ScheduleMonthlyIntervalName],
            [BK_ScheduleQuarterlyInterval] AS [BK_ScheduleQuarterlyInterval],
            [ScheduleQuarterlyIntervalCode] AS [ScheduleQuarterlyIntervalCode],
            [ScheduleQuarterlyIntervalName] AS [ScheduleQuarterlyIntervalName],
            [BK_ScheduleYearlyInterval] AS [BK_ScheduleYearlyInterval],
            [ScheduleYearlyIntervalCode] AS [ScheduleYearlyIntervalCode],
            [ScheduleYearlyIntervalName] AS [ScheduleYearlyIntervalName],
            [BK_ScheduleSpecials] AS [BK_ScheduleSpecials],
            [ScheduleSpecialsCode] AS [ScheduleSpecialsCode],
            [ScheduleSpecialsName] AS [ScheduleSpecialsName],
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1