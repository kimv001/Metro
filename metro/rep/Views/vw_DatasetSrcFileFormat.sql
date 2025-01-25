﻿
    CREATE   VIEW [rep].[vw_DatasetSrcFileFormat] AS
    /*
    View is generated by  : metro
    Generated at          : 2025-01-22 20:09:39
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        LTRIM(RTRIM(CAST([BK] AS varchar(255)))) AS [BK],
        LTRIM(RTRIM(CAST([Code] AS varchar(255)))) AS [Code],
        LTRIM(RTRIM(CAST([Name] AS varchar(255)))) AS [Name],
        LTRIM(RTRIM(CAST([Description] AS varchar(255)))) AS [Description],
        LTRIM(RTRIM(CAST([Description_nl] AS varchar(255)))) AS [Description_nl],
        LTRIM(RTRIM(CAST([Active] AS varchar(255)))) AS [Active],
        LTRIM(RTRIM(CAST([Fileformat] AS varchar(255)))) AS [Fileformat],
        LTRIM(RTRIM(CAST([CompressionType] AS varchar(255)))) AS [CompressionType],
        LTRIM(RTRIM(CAST([CompressionLevel] AS varchar(255)))) AS [CompressionLevel],
        LTRIM(RTRIM(CAST([FileEncoding] AS varchar(255)))) AS [FileEncoding],
        LTRIM(RTRIM(CAST([ColumnDelimiter] AS varchar(255)))) AS [ColumnDelimiter],
        LTRIM(RTRIM(CAST([RowDelimiter] AS varchar(255)))) AS [RowDelimiter],
        LTRIM(RTRIM(CAST([QuoteCharacter] AS varchar(255)))) AS [QuoteCharacter],
        LTRIM(RTRIM(CAST([EscapeCharacter] AS varchar(255)))) AS [EscapeCharacter],
        LTRIM(RTRIM(CAST([FirstRowAsHeader] AS varchar(255)))) AS [FirstRowAsHeader],
        LTRIM(RTRIM(CAST([FirstRow] AS varchar(255)))) AS [FirstRow],
        LTRIM(RTRIM(CAST([NullValue] AS varchar(MAX)))) AS [NullValue],
        LTRIM(RTRIM(CAST([AllowNoFilesFound] AS varchar(255)))) AS [AllowNoFilesFound],
        LTRIM(RTRIM(CAST([EnableCDC] AS varchar(255)))) AS [EnableCDC],
        LTRIM(RTRIM(CAST([IsSystem] AS varchar(255)))) AS [IsSystem],
        LTRIM(RTRIM(CAST([mta_Source] AS varchar(255)))) AS [mta_Source],
        LTRIM(RTRIM(CAST([mta_LoadDate] AS varchar(255)))) AS [mta_LoadDate],
        -- Meta data columns:
        mta_RowNum     = ROW_NUMBER() OVER (ORDER BY [BK] ASC),
        mta_BK         = UPPER(ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(500)))),'-')),
        mta_BKH        = CONVERT(CHAR(64), HASHBYTES('SHA2_512', UPPER(ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(500)))),'-'))), 2),
        mta_RH         = CONVERT(
            CHAR(64),
            HASHBYTES(
                'SHA2_512',
                UPPER(
                    ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Code] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Name] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description_nl] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Active] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Fileformat] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([CompressionType] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([CompressionLevel] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([FileEncoding] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([ColumnDelimiter] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([RowDelimiter] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([QuoteCharacter] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([EscapeCharacter] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([FirstRowAsHeader] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([FirstRow] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([NullValue] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([AllowNoFilesFound] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([EnableCDC] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([IsSystem] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_Source] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_LoadDate] AS VARCHAR(255)))),'-')
                )
            ),
            2
        )
    FROM [rep].[DatasetSrcFileFormat]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''