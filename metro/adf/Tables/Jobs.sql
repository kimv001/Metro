CREATE TABLE [adf].[Jobs] (
    [JobId]           AS             (CONVERT([nvarchar](900),concat_ws('|',[FlowId],[JobName]))) PERSISTED NOT NULL,
    [JobName]         NVARCHAR (280) NOT NULL,
    [JobDescription]  NVARCHAR (MAX) NOT NULL,
    [FlowId]          NVARCHAR (900) NOT NULL,
    [JobType]         NVARCHAR (MAX) NOT NULL,
    [JobGroup]        NVARCHAR (MAX) NOT NULL,
    [JobOrder]        INT            NOT NULL,
    [LastRunDuration] INT            NULL,
    [LastRunStart]    DATETIME2 (7)  NULL,
    [LastRunStatus]   NVARCHAR (10)  NULL,
    [CheckPoint]      DATETIME2 (7)  NULL,
    CONSTRAINT [PK_JobId] PRIMARY KEY CLUSTERED ([JobId] ASC),
    CONSTRAINT [FK_Jobs_FlowId] FOREIGN KEY ([FlowId]) REFERENCES [adf].[Flows] ([FlowId]) ON DELETE CASCADE ON UPDATE CASCADE
);

