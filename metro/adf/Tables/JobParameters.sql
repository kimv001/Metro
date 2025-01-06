CREATE TABLE [adf].[JobParameters] (
    [JobParameterId]          AS             (CONVERT([nvarchar](900),concat_ws('|',[JobId],[JobParameterName]))) PERSISTED NOT NULL,
    [JobParameterName]        NVARCHAR (280) NOT NULL,
    [JobParameterValue]       NVARCHAR (MAX) NOT NULL,
    [JobParameterDescription] NVARCHAR (MAX) NULL,
    [JobId]                   NVARCHAR (900) NOT NULL,
    CONSTRAINT [PK_JobParameters] PRIMARY KEY CLUSTERED ([JobParameterId] ASC),
    CONSTRAINT [FK_JobParameters_JobId] FOREIGN KEY ([JobId]) REFERENCES [adf].[Jobs] ([JobId]) ON DELETE CASCADE ON UPDATE CASCADE
);

