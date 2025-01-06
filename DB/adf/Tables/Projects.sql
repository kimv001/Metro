CREATE TABLE [adf].[Projects] (
    [ProjectId]          AS             (CONVERT([nvarchar](900),[ProjectName])) PERSISTED NOT NULL,
    [ProjectName]        NVARCHAR (280) NOT NULL,
    [ProjectDescription] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ProjectId] PRIMARY KEY CLUSTERED ([ProjectId] ASC)
);

