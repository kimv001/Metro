CREATE TABLE [aud].[JobRuns] (
    [FlowId]         NVARCHAR (900) NOT NULL,
    [FlowRunGUID]    NVARCHAR (36)  NOT NULL,
    [JobId]          NVARCHAR (900) NOT NULL,
    [JobName]        NVARCHAR (280) NOT NULL,
    [JobDescription] NVARCHAR (MAX) NOT NULL,
    [JobType]        NVARCHAR (MAX) NOT NULL,
    [JobRunGUID]     NVARCHAR (36)  NOT NULL,
    [RunStart]       DATETIME2 (7)  NULL,
    [RunEnd]         DATETIME2 (7)  NULL,
    [RunDuration]    INT            NULL,
    [RunStatus]      NVARCHAR (10)  NULL,
    [CheckPoint]     DATETIME2 (7)  NULL,
    [RowsInserted]   INT            NULL,
    [RowsUpdated]    INT            NULL,
    [RowsDeleted]    INT            NULL,
    [LogDateTime]    DATETIME2 (7)  NULL,
    [LogFullMessage] NVARCHAR (MAX) NULL
);

