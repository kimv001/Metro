CREATE TABLE [rep].[DataSource] (
    [BK]                        NVARCHAR (MAX) NULL,
    [Code]                      NVARCHAR (MAX) NULL,
    [Name]                      NVARCHAR (MAX) NULL,
    [Description]               NVARCHAR (MAX) NULL,
    [BK_RefType_DataSourceType] NVARCHAR (MAX) NULL,
    [IsDWH]                     NVARCHAR (MAX) NULL,
    [IsRep]                     NVARCHAR (MAX) NULL,
    [ConnectionString]          NVARCHAR (MAX) NULL,
    [BK_LinkedService]          NVARCHAR (MAX) NULL,
    [Active]                    NVARCHAR (MAX) NULL,
    [IsSystem]                  NVARCHAR (MAX) NULL,
    [mta_Source]                NVARCHAR (MAX) NULL,
    [mta_LoadDate]              NVARCHAR (MAX) NULL
);

