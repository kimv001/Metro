CREATE TABLE [stg].[DWH_ReferencingObjects] (
    [ReferencingObjectType] CHAR (2)       NULL,
    [ReferencingObject]     NVARCHAR (517) NULL,
    [ReferencedObject]      NVARCHAR (517) NULL,
    [ReferencedObjectType]  CHAR (2)       NULL,
    [ImportDate]            DATETIME2 (7)  NULL,
    [mta_Source]            NVARCHAR (MAX) NULL,
    [mta_LoadDate]          NVARCHAR (MAX) NULL,
    [BK_DataSource]         NVARCHAR (MAX) NULL
);

