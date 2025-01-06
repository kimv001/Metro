CREATE TABLE [stg].[DWH_ObjectDefinitions] (
    [ObjectCatalog]                            NVARCHAR (128) NULL,
    [ObjectSchema]                             NVARCHAR (128) NULL,
    [ObjectName]                               NVARCHAR (128) NULL,
    [objectType]                               CHAR (2)       NULL,
    [ObjectDefinition]                         NVARCHAR (MAX) NULL,
    [ObjectDefinition_contains_business_logic] INT            NULL,
    [ImportDate]                               DATETIME2 (7)  NULL,
    [mta_Source]                               NVARCHAR (MAX) NULL,
    [mta_LoadDate]                             NVARCHAR (MAX) NULL,
    [BK_DataSource]                            NVARCHAR (MAX) NULL
);

