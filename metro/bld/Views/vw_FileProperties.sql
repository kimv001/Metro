﻿
        CREATE   VIEW [bld].[vw_FileProperties] AS
        /*
        View is generated by  : metro
        Generated at          : 2025-01-21 08:32:49
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                [FilePropertiesId] AS [FilePropertiesId],
                [BK] AS [BK],
                [Code] AS [Code],
                [Description] AS [Description],
                [FileMask] AS [FileMask],
                [Filename] AS [Filename],
                [FileSystem] AS [FileSystem],
                [Folder] AS [Folder],
                [isPGP] AS [isPGP],
                [ExpectedFileCount] AS [ExpectedFileCount],
                [ExpectedFileSize] AS [ExpectedFileSize],
                [bk_schedule_FileExpected] AS [bk_schedule_FileExpected],
                [DateInFileNameFormat] AS [DateInFileNameFormat],
                [DateinFileNameLength] AS [DateinFileNameLength],
                [DateInFileNameStartPos] AS [DateInFileNameStartPos],
                [DateInFileNameExpression] AS [DateInFileNameExpression],
                [TestDateInFileName] AS [TestDateInFileName],
                [FF_Name] AS [FF_Name],
                [FF_Fileformat] AS [FF_Fileformat],
                [FF_ColumnDelimiter] AS [FF_ColumnDelimiter],
                [FF_RowDelimiter] AS [FF_RowDelimiter],
                [FF_QuoteCharacter] AS [FF_QuoteCharacter],
                [FF_CompressionLevel] AS [FF_CompressionLevel],
                [FF_CompressionType] AS [FF_CompressionType],
                [FF_EnableCDC] AS [FF_EnableCDC],
                [FF_EscapeCharacter] AS [FF_EscapeCharacter],
                [FF_FileEncoding] AS [FF_FileEncoding],
                [FF_FirstRow] AS [FF_FirstRow],
                [FF_FirstRowAsHeader] AS [FF_FirstRowAsHeader],
                [FF_Filesize] AS [FF_Filesize],
                [FF_Threshold] AS [FF_Threshold],
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [bld].[FileProperties]
               
        )
        SELECT 
            [FilePropertiesId] AS [FilePropertiesId],
            [BK] AS [BK],
            [Code] AS [Code],
            [Description] AS [Description],
            [FileMask] AS [FileMask],
            [Filename] AS [Filename],
            [FileSystem] AS [FileSystem],
            [Folder] AS [Folder],
            [isPGP] AS [isPGP],
            [ExpectedFileCount] AS [ExpectedFileCount],
            [ExpectedFileSize] AS [ExpectedFileSize],
            [bk_schedule_FileExpected] AS [bk_schedule_FileExpected],
            [DateInFileNameFormat] AS [DateInFileNameFormat],
            [DateinFileNameLength] AS [DateinFileNameLength],
            [DateInFileNameStartPos] AS [DateInFileNameStartPos],
            [DateInFileNameExpression] AS [DateInFileNameExpression],
            [TestDateInFileName] AS [TestDateInFileName],
            [FF_Name] AS [FF_Name],
            [FF_Fileformat] AS [FF_Fileformat],
            [FF_ColumnDelimiter] AS [FF_ColumnDelimiter],
            [FF_RowDelimiter] AS [FF_RowDelimiter],
            [FF_QuoteCharacter] AS [FF_QuoteCharacter],
            [FF_CompressionLevel] AS [FF_CompressionLevel],
            [FF_CompressionType] AS [FF_CompressionType],
            [FF_EnableCDC] AS [FF_EnableCDC],
            [FF_EscapeCharacter] AS [FF_EscapeCharacter],
            [FF_FileEncoding] AS [FF_FileEncoding],
            [FF_FirstRow] AS [FF_FirstRow],
            [FF_FirstRowAsHeader] AS [FF_FirstRowAsHeader],
            [FF_Filesize] AS [FF_Filesize],
            [FF_Threshold] AS [FF_Threshold],
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1