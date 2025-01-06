CREATE TABLE [rep].[Contact] (
    [BK]               NVARCHAR (MAX) NULL,
    [Code]             NVARCHAR (MAX) NULL,
    [Name]             NVARCHAR (MAX) NULL,
    [Description]      NVARCHAR (MAX) NULL,
    [bk_contactgroup]  NVARCHAR (MAX) NULL,
    [bk_contactrole]   NVARCHAR (MAX) NULL,
    [bk_contactperson] NVARCHAR (MAX) NULL,
    [main_contact]     NVARCHAR (MAX) NULL,
    [alert_contact]    NVARCHAR (MAX) NULL,
    [Active]           NVARCHAR (MAX) NULL,
    [mta_Source]       NVARCHAR (MAX) NULL,
    [mta_LoadDate]     NVARCHAR (MAX) NULL
);

