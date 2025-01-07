CREATE TABLE [rep].[Testrule] (
    [BK]                           NVARCHAR (MAX) NULL,
    [Name]                         NVARCHAR (MAX) NULL,
    [Code]                         NVARCHAR (MAX) NULL,
    [Description]                  NVARCHAR (MAX) NULL,
    [Active]                       NVARCHAR (MAX) NULL,
    [BK_Datasource]                NVARCHAR (MAX) NULL,
    [BK_Schema]                    NVARCHAR (MAX) NULL,
    [BK_DatasetSrc]                NVARCHAR (MAX) NULL,
    [BK_DatasetTrn]                NVARCHAR (MAX) NULL,
    [BK_RefType_ObjectType_Target] NVARCHAR (MAX) NULL,
    [BK_TestDefinition]            NVARCHAR (MAX) NULL,
    [BK_DatasetSrcAttribute]       NVARCHAR (MAX) NULL,
    [BK_DatasetTrnAttribute]       NVARCHAR (MAX) NULL,
    [ExpectedValue]                NVARCHAR (MAX) NULL,
    [TresholdValue]                NVARCHAR (MAX) NULL,
    [BK_Schedule]                  NVARCHAR (MAX) NULL,
    [BK_RefType_RepositoryStatus]  NVARCHAR (MAX) NULL,
    [mta_Source]                   NVARCHAR (MAX) NULL,
    [mta_LoadDate]                 NVARCHAR (MAX) NULL
);

