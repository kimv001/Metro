CREATE TABLE [bld].[RefType] (
    [RefTypeId]               INT           IDENTITY (1, 1) NOT NULL,
    [BK]                      VARCHAR (255) NULL,
    [Code]                    VARCHAR (255) NULL,
    [Name]                    VARCHAR (255) NULL,
    [Description]             VARCHAR (255) NULL,
    [RefType]                 VARCHAR (255) NULL,
    [RefTypeAbbr]             VARCHAR (255) NULL,
    [SortOrder]               VARCHAR (255) NULL,
    [LinkedReftype]           VARCHAR (255) NULL,
    [BK_LinkedRefType]        VARCHAR (255) NULL,
    [LinkedRefTypeCode]       VARCHAR (255) NULL,
    [LinkedRefTypeName]       VARCHAR (255) NULL,
    [LinkedRefTypeDecription] VARCHAR (255) NULL,
    [DefaultValue]            VARCHAR (MAX) NULL,
    [isDefault]               VARCHAR (255) NULL,
    [mta_Createdate]          DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]             SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                  CHAR (255)    NULL,
    [mta_BKH]                 CHAR (128)    NULL,
    [mta_RH]                  CHAR (128)    NULL,
    [mta_Source]              VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_RefType]
    ON [bld].[RefType]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_RefType]
    ON [bld].[RefType]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

