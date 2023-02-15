CREATE TABLE [rep].[Schedules] (
    [BK]                          NVARCHAR (MAX) NULL,
    [BK_Schedule]                 NVARCHAR (MAX) NULL,
    [BK_SRCDataset]               NVARCHAR (MAX) NULL,
    [BK_TrnDataset]               NVARCHAR (MAX) NULL,
    [BK_Group]                    NVARCHAR (MAX) NULL,
    [BK_Schema]                   NVARCHAR (MAX) NULL,
    [BK_Layer]                    NVARCHAR (MAX) NULL,
    [BK_ScheduleLoadType]         NVARCHAR (MAX) NULL,
    [ReloadIfAlreadyLoaded]       NVARCHAR (MAX) NULL,
    [Active]                      NVARCHAR (MAX) NULL,
    [BK_RefType_RepositoryStatus] NVARCHAR (MAX) NULL,
    [mta_Source]                  NVARCHAR (MAX) NULL,
    [mta_LoadDate]                NVARCHAR (MAX) NULL
);

