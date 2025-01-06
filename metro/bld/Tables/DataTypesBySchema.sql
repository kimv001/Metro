CREATE TABLE [bld].[DataTypesBySchema] (
    [DataTypesBySchemaId] INT           IDENTITY (1, 1) NOT NULL,
    [BK]                  VARCHAR (255) NULL,
    [Code]                VARCHAR (255) NULL,
    [BK_Schema]           VARCHAR (255) NULL,
    [DataTypeMapped]      VARCHAR (255) NULL,
    [DataTypeInRep]       VARCHAR (255) NULL,
    [FixedSchemaDataType] VARCHAR (255) NULL,
    [OrgMappedDataType]   VARCHAR (255) NULL,
    [DefaultValue]        VARCHAR (MAX) NULL,
    [mta_Createdate]      DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]         SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]              CHAR (255)    NULL,
    [mta_BKH]             CHAR (128)    NULL,
    [mta_RH]              CHAR (128)    NULL,
    [mta_Source]          VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_DataTypesBySchema]
    ON [bld].[DataTypesBySchema]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_DataTypesBySchema]
    ON [bld].[DataTypesBySchema]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

