CREATE TABLE [adf].[Flows] (
    [FlowId]           AS             (CONVERT([nvarchar](900),concat_ws('|',[ProjectId],[FlowName]))) PERSISTED NOT NULL,
    [FlowName]         NVARCHAR (280) NOT NULL,
    [FlowDescription]  NVARCHAR (MAX) NULL,
    [ProjectId]        NVARCHAR (900) NOT NULL,
    [FlowGroup]        NVARCHAR (MAX) NULL,
    [FlowOrder]        INT            NULL,
    [FlowDependencies] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_FlowId] PRIMARY KEY CLUSTERED ([FlowId] ASC),
    CONSTRAINT [FK_Flows_ProjectId] FOREIGN KEY ([ProjectId]) REFERENCES [adf].[Projects] ([ProjectId]) ON DELETE CASCADE ON UPDATE CASCADE
);

