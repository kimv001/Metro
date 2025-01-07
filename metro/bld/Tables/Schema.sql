CREATE TABLE [bld].[Schema] (
    [SchemaId]           INT           IDENTITY (1, 1) NOT NULL,
    [BK]                 VARCHAR (255) NULL,
    [Code]               VARCHAR (255) NULL,
    [Name]               VARCHAR (255) NULL,
    [BK_Schema]          VARCHAR (255) NULL,
    [BK_Layer]           VARCHAR (255) NULL,
    [BK_DataSource]      VARCHAR (255) NULL,
    [BK_LinkedService]   VARCHAR (255) NULL,
    [SchemaCode]         VARCHAR (255) NULL,
    [SchemaName]         VARCHAR (255) NULL,
    [DataSourceCode]     VARCHAR (255) NULL,
    [DataSourceName]     VARCHAR (255) NULL,
    [BK_DataSourceType]  VARCHAR (255) NULL,
    [DataSourceTypeCode] VARCHAR (255) NULL,
    [DataSourceTypeName] VARCHAR (255) NULL,
    [LayerCode]          VARCHAR (255) NULL,
    [LayerName]          VARCHAR (255) NULL,
    [LayerOrder]         VARCHAR (255) NULL,
    [ProcessOrderLayer]  VARCHAR (255) NULL,
    [ProcessParallel]    VARCHAR (255) NULL,
    [isDWH]              VARCHAR (255) NULL,
    [isSRC]              VARCHAR (255) NULL,
    [isTGT]              VARCHAR (255) NULL,
    [IsRep]              VARCHAR (255) NULL,
    [CreateDummies]      VARCHAR (255) NULL,
    [LinkedServiceCode]  VARCHAR (255) NULL,
    [LinkedServiceName]  VARCHAR (255) NULL,
    [BK_Template_Create] VARCHAR (255) NULL,
    [BK_Template_Load]   VARCHAR (255) NULL,
    [BK_RefType_ToChar]  VARCHAR (255) NULL,
    [mta_Createdate]     DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]        SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]             CHAR (255)    NULL,
    [mta_BKH]            CHAR (128)    NULL,
    [mta_RH]             CHAR (128)    NULL,
    [mta_Source]         VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Schema]
    ON [bld].[Schema]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Schema]
    ON [bld].[Schema]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

