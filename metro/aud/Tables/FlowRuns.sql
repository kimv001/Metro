CREATE TABLE [aud].[FlowRuns] (
    [ProjectId]   NVARCHAR (900) NOT NULL,
    [FlowId]      NVARCHAR (900) NOT NULL,
    [FlowName]    NVARCHAR (280) NOT NULL,
    [FlowRunGUID] NVARCHAR (36)  NOT NULL,
    [RunStart]    DATETIME2 (7)  NULL,
    [RunEnd]      DATETIME2 (7)  NULL,
    [RunDuration] INT            NULL,
    [RunStatus]   NVARCHAR (10)  NULL,
    [LogDateTime] DATETIME2 (7)  NULL
);

