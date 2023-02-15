﻿CREATE TABLE [rep].[Schedule] (
    [BK]                           NVARCHAR (MAX) NULL,
    [Name]                         NVARCHAR (MAX) NULL,
    [Code]                         NVARCHAR (MAX) NULL,
    [Description]                  NVARCHAR (MAX) NULL,
    [BK_ScheduleType]              NVARCHAR (MAX) NULL,
    [BK_ScheduleFrequency]         NVARCHAR (MAX) NULL,
    [BK_ScheduleDailyInterval]     NVARCHAR (MAX) NULL,
    [BK_ScheduleWeeklyInterval]    NVARCHAR (MAX) NULL,
    [BK_ScheduleMonthlyInterval]   NVARCHAR (MAX) NULL,
    [BK_ScheduleQuarterlyInterval] NVARCHAR (MAX) NULL,
    [BK_ScheduleYearlyInterval]    NVARCHAR (MAX) NULL,
    [BK_ScheduleSpecials]          NVARCHAR (MAX) NULL,
    [StartDate]                    NVARCHAR (MAX) NULL,
    [EndDate]                      NVARCHAR (MAX) NULL,
    [StartTime]                    NVARCHAR (MAX) NULL,
    [EndTime]                      NVARCHAR (MAX) NULL,
    [CRON]                         NVARCHAR (MAX) NULL,
    [Active]                       NVARCHAR (MAX) NULL,
    [mta_Source]                   NVARCHAR (MAX) NULL,
    [mta_LoadDate]                 NVARCHAR (MAX) NULL
);

