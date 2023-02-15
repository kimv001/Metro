﻿CREATE TABLE [rep].[DatasetSrcFileFormat] (
    [BK]                NVARCHAR (MAX) NULL,
    [Code]              NVARCHAR (MAX) NULL,
    [Name]              NVARCHAR (MAX) NULL,
    [Description]       NVARCHAR (MAX) NULL,
    [Fileformat]        NVARCHAR (MAX) NULL,
    [CompressionType]   NVARCHAR (MAX) NULL,
    [CompressionLevel]  NVARCHAR (MAX) NULL,
    [FileEncoding]      NVARCHAR (MAX) NULL,
    [ColumnDelimiter]   NVARCHAR (MAX) NULL,
    [RowDelimiter]      NVARCHAR (MAX) NULL,
    [QuoteCharacter]    NVARCHAR (MAX) NULL,
    [EscapeCharacter]   NVARCHAR (MAX) NULL,
    [FirstRowAsHeader]  NVARCHAR (MAX) NULL,
    [FirstRow]          NVARCHAR (MAX) NULL,
    [NullValue]         NVARCHAR (MAX) NULL,
    [AllowNoFilesFound] NVARCHAR (MAX) NULL,
    [EnableCDC]         NVARCHAR (MAX) NULL,
    [Active]            NVARCHAR (MAX) NULL,
    [IsSystem]          NVARCHAR (MAX) NULL,
    [mta_Source]        NVARCHAR (MAX) NULL,
    [mta_LoadDate]      NVARCHAR (MAX) NULL
);

