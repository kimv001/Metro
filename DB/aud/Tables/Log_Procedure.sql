CREATE TABLE [aud].[Log_Procedure] (
    [Log_ProcedureID] INT           IDENTITY (1, 1) NOT NULL,
    [Log_Time]        DATETIME2 (7) NOT NULL,
    [Log_Action]      VARCHAR (50)  NOT NULL,
    [Log_Note]        VARCHAR (MAX) NOT NULL,
    [Log_Procedure]   VARCHAR (255) NULL,
    [Log_SQL]         VARCHAR (MAX) NULL,
    [Log_RowCount]    BIGINT        NULL,
    [Log_User]        VARCHAR (255) NULL,
    CONSTRAINT [PK_LogProcedure] PRIMARY KEY CLUSTERED ([Log_ProcedureID] ASC)
);

