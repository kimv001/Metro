CREATE TABLE [adf].[ProjectParameters] (
    [ProjectParameterId]          AS             (CONVERT([nvarchar](900),concat_ws('|',[ProjectId],[ProjectParameterJobType],[ProjectParameterName]))) PERSISTED NOT NULL,
    [ProjectParameterName]        NVARCHAR (280) NULL,
    [ProjectParameterValue]       NVARCHAR (MAX) NULL,
    [ProjectParameterJobType]     NVARCHAR (280) NULL,
    [ProjectParameterDescription] NVARCHAR (MAX) NULL,
    [ProjectId]                   NVARCHAR (900) NULL,
    CONSTRAINT [PK_ProjectParameters] PRIMARY KEY CLUSTERED ([ProjectParameterId] ASC),
    CONSTRAINT [FK_ProjectParameters_ProjectId] FOREIGN KEY ([ProjectId]) REFERENCES [adf].[Projects] ([ProjectId]) ON DELETE CASCADE ON UPDATE CASCADE
);

