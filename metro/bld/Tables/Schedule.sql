CREATE TABLE [bld].[Schedule] (
    [ScheduleId]                    INT           IDENTITY (1, 1) NOT NULL,
    [BK]                            VARCHAR (255) NULL,
    [Code]                          VARCHAR (255) NULL,
    [BK_Schedule]                   VARCHAR (255) NULL,
    [ScheduleCode]                  VARCHAR (255) NULL,
    [ScheduleName]                  VARCHAR (255) NULL,
    [ScheduleDesc]                  VARCHAR (MAX) NULL,
    [StartDate]                     VARCHAR (255) NULL,
    [EndDate]                       VARCHAR (255) NULL,
    [StartTime]                     VARCHAR (255) NULL,
    [EndTime]                       VARCHAR (255) NULL,
    [BK_ScheduleType]               VARCHAR (255) NULL,
    [ScheduleTypeCode]              VARCHAR (255) NULL,
    [ScheduleTypeName]              VARCHAR (255) NULL,
    [BK_ScheduleFrequency]          VARCHAR (255) NULL,
    [ScheduleFrequencyCode]         VARCHAR (255) NULL,
    [ScheduleFrequencyName]         VARCHAR (255) NULL,
    [BK_ScheduleDailyInterval]      VARCHAR (255) NULL,
    [ScheduleDailyIntervalCode]     VARCHAR (255) NULL,
    [ScheduleDailyIntervalName]     VARCHAR (255) NULL,
    [BK_ScheduleWeeklyInterval]     VARCHAR (255) NULL,
    [ScheduleWeeklyIntervalCode]    VARCHAR (255) NULL,
    [ScheduleWeeklyIntervalName]    VARCHAR (255) NULL,
    [BK_ScheduleWorkDayInterval]    VARCHAR (255) NULL,
    [ScheduleWorkDayIntervalCode]   VARCHAR (255) NULL,
    [ScheduleWorkDayIntervalName]   VARCHAR (255) NULL,
    [BK_ScheduleMonthlyInterval]    VARCHAR (255) NULL,
    [ScheduleMonthlyIntervalCode]   VARCHAR (255) NULL,
    [ScheduleMonthlyIntervalName]   VARCHAR (255) NULL,
    [BK_ScheduleQuarterlyInterval]  VARCHAR (255) NULL,
    [ScheduleQuarterlyIntervalCode] VARCHAR (255) NULL,
    [ScheduleQuarterlyIntervalName] VARCHAR (255) NULL,
    [BK_ScheduleYearlyInterval]     VARCHAR (255) NULL,
    [ScheduleYearlyIntervalCode]    VARCHAR (255) NULL,
    [ScheduleYearlyIntervalName]    VARCHAR (255) NULL,
    [BK_ScheduleSpecials]           VARCHAR (255) NULL,
    [ScheduleSpecialsCode]          VARCHAR (255) NULL,
    [ScheduleSpecialsName]          VARCHAR (255) NULL,
    [mta_Createdate]                DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]                   SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                        CHAR (255)    NULL,
    [mta_BKH]                       CHAR (128)    NULL,
    [mta_RH]                        CHAR (128)    NULL,
    [mta_Source]                    VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Schedule]
    ON [bld].[Schedule]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Schedule]
    ON [bld].[Schedule]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

