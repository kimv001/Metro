CREATE TABLE [bld].[DatasetTemplates] (
    [DatasetTemplatesId]    INT           IDENTITY (1, 1) NOT NULL,
    [BK]                    VARCHAR (255) NULL,
    [Code]                  VARCHAR (255) NULL,
    [BK_Template]           VARCHAR (255) NULL,
    [BK_Dataset]            VARCHAR (255) NULL,
    [TemplateType]          VARCHAR (255) NULL,
    [TemplateSource]        VARCHAR (255) NULL,
    [BK_RefType_ObjectType] VARCHAR (255) NULL,
    [TemplateScript]        VARCHAR (MAX) NULL,
    [RowNum]                VARCHAR (255) NULL,
    [mta_Createdate]        DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]           SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                CHAR (255)    NULL,
    [mta_BKH]               CHAR (128)    NULL,
    [mta_RH]                CHAR (128)    NULL,
    [mta_Source]            VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_DatasetTemplates]
    ON [bld].[DatasetTemplates]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_DatasetTemplates]
    ON [bld].[DatasetTemplates]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

