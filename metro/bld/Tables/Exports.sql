CREATE TABLE [bld].[Exports] (
    [ExportsId]            INT           IDENTITY (1, 1) NOT NULL,
    [bk]                   VARCHAR (255) NULL,
    [code]                 VARCHAR (255) NULL,
    [export_name]          VARCHAR (255) NULL,
    [BK_ContactGroup]      VARCHAR (255) NULL,
    [bk_dataset]           VARCHAR (255) NULL,
    [src_datasetname]      VARCHAR (255) NULL,
    [src_schema]           VARCHAR (255) NULL,
    [src_dataset]          VARCHAR (255) NULL,
    [src_shortName]        VARCHAR (255) NULL,
    [src_group]            VARCHAR (255) NULL,
    [src_layer]            VARCHAR (255) NULL,
    [src_DatasetType]      VARCHAR (255) NULL,
    [bk_schedule]          VARCHAR (255) NULL,
    [bk_schema]            VARCHAR (255) NULL,
    [container]            VARCHAR (255) NULL,
    [folder]               VARCHAR (255) NULL,
    [filename]             VARCHAR (255) NULL,
    [datetime]             VARCHAR (255) NULL,
    [bk_fileformat]        VARCHAR (255) NULL,
    [where_filter]         VARCHAR (255) NULL,
    [order_by]             VARCHAR (255) NULL,
    [split_by]             VARCHAR (255) NULL,
    [FF_Name]              VARCHAR (255) NULL,
    [FF_Fileformat]        VARCHAR (255) NULL,
    [FF_ColumnDelimiter]   VARCHAR (255) NULL,
    [FF_RowDelimiter]      VARCHAR (255) NULL,
    [FF_QuoteCharacter]    VARCHAR (255) NULL,
    [FF_CompressionLevel]  VARCHAR (255) NULL,
    [FF_CompressionType]   VARCHAR (255) NULL,
    [FF_EnableCDC]         VARCHAR (255) NULL,
    [FF_EscapeCharacter]   VARCHAR (255) NULL,
    [FF_FileEncoding]      VARCHAR (255) NULL,
    [FF_FirstRow]          VARCHAR (255) NULL,
    [FF_FirstRowAsHeader]  VARCHAR (255) NULL,
    [RepositoryStatusName] VARCHAR (255) NULL,
    [RepositoryStatusCode] VARCHAR (255) NULL,
    [mta_Createdate]       DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]          SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]               CHAR (255)    NULL,
    [mta_BKH]              CHAR (128)    NULL,
    [mta_RH]               CHAR (128)    NULL,
    [mta_Source]           VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Exports]
    ON [bld].[Exports]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Exports]
    ON [bld].[Exports]([bk] ASC, [mta_BKH] ASC, [code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

