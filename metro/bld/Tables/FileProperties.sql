CREATE TABLE [bld].[FileProperties] (
    [FilePropertiesId]         INT           IDENTITY (1, 1) NOT NULL,
    [BK]                       VARCHAR (255) NULL,
    [Code]                     VARCHAR (255) NULL,
    [Description]              VARCHAR (255) NULL,
    [FileMask]                 VARCHAR (255) NULL,
    [Filename]                 VARCHAR (255) NULL,
    [FileSystem]               VARCHAR (255) NULL,
    [Folder]                   VARCHAR (255) NULL,
    [isPGP]                    VARCHAR (255) NULL,
    [ExpectedFileCount]        VARCHAR (255) NULL,
    [ExpectedFileSize]         VARCHAR (255) NULL,
    [bk_schedule_FileExpected] VARCHAR (255) NULL,
    [DateInFileNameFormat]     VARCHAR (255) NULL,
    [DateinFileNameLength]     VARCHAR (255) NULL,
    [DateInFileNameStartPos]   VARCHAR (255) NULL,
    [DateInFileNameExpression] VARCHAR (MAX) NULL,
    [TestDateInFileName]       VARCHAR (255) NULL,
    [FF_Name]                  VARCHAR (255) NULL,
    [FF_Fileformat]            VARCHAR (255) NULL,
    [FF_ColumnDelimiter]       VARCHAR (255) NULL,
    [FF_RowDelimiter]          VARCHAR (255) NULL,
    [FF_QuoteCharacter]        VARCHAR (255) NULL,
    [FF_CompressionLevel]      VARCHAR (255) NULL,
    [FF_CompressionType]       VARCHAR (255) NULL,
    [FF_EnableCDC]             VARCHAR (255) NULL,
    [FF_EscapeCharacter]       VARCHAR (255) NULL,
    [FF_FileEncoding]          VARCHAR (255) NULL,
    [FF_FirstRow]              VARCHAR (255) NULL,
    [FF_FirstRowAsHeader]      VARCHAR (255) NULL,
    [FF_Filesize]              VARCHAR (255) NULL,
    [FF_Threshold]             VARCHAR (255) NULL,
    [mta_Createdate]           DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]              SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                   CHAR (255)    NULL,
    [mta_BKH]                  CHAR (128)    NULL,
    [mta_RH]                   CHAR (128)    NULL,
    [mta_Source]               VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_FileProperties]
    ON [bld].[FileProperties]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_FileProperties]
    ON [bld].[FileProperties]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

