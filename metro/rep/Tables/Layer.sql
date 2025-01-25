CREATE TABLE [rep].[Layer] (
    [BK]             NVARCHAR (MAX) NULL,
    [Code]           NVARCHAR (MAX) NULL,
    [Name]           NVARCHAR (MAX) NULL,
    [Description]    NVARCHAR (MAX) NULL,
    [Description_nl] NVARCHAR (MAX) NULL,
    [Active]         NVARCHAR (MAX) NULL,
    [isDWH]          NVARCHAR (MAX) NULL,
    [isSRC]          NVARCHAR (MAX) NULL,
    [isTGT]          NVARCHAR (MAX) NULL,
    [isRep]          NVARCHAR (MAX) NULL,
    [isAudit]        NVARCHAR (MAX) NULL,
    [isDWHhelper]    NVARCHAR (MAX) NULL,
    [IsSystem]       NVARCHAR (MAX) NULL,
    [LayerOrder]     NVARCHAR (MAX) NULL,
    [mta_Source]     NVARCHAR (MAX) NULL,
    [mta_LoadDate]   NVARCHAR (MAX) NULL
);

