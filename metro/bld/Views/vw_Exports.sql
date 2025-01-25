﻿
        CREATE   VIEW [bld].[vw_Exports] AS
        /*
        View is generated by  : metro
        Generated at          : 2025-01-21 08:32:49
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                [ExportsId] AS [ExportsId],
                [bk] AS [bk],
                [code] AS [code],
                [export_name] AS [export_name],
                [BK_ContactGroup] AS [BK_ContactGroup],
                [bk_dataset] AS [bk_dataset],
                [src_datasetname] AS [src_datasetname],
                [src_schema] AS [src_schema],
                [src_dataset] AS [src_dataset],
                [src_shortName] AS [src_shortName],
                [src_group] AS [src_group],
                [src_layer] AS [src_layer],
                [src_DatasetType] AS [src_DatasetType],
                [bk_schedule] AS [bk_schedule],
                [bk_schema] AS [bk_schema],
                [container] AS [container],
                [folder] AS [folder],
                [filename] AS [filename],
                [datetime] AS [datetime],
                [bk_fileformat] AS [bk_fileformat],
                [where_filter] AS [where_filter],
                [order_by] AS [order_by],
                [split_by] AS [split_by],
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
                [RepositoryStatusName] AS [RepositoryStatusName],
                [RepositoryStatusCode] AS [RepositoryStatusCode],
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [bld].[Exports]
               
        )
        SELECT 
            [ExportsId] AS [ExportsId],
            [bk] AS [bk],
            [code] AS [code],
            [export_name] AS [export_name],
            [BK_ContactGroup] AS [BK_ContactGroup],
            [bk_dataset] AS [bk_dataset],
            [src_datasetname] AS [src_datasetname],
            [src_schema] AS [src_schema],
            [src_dataset] AS [src_dataset],
            [src_shortName] AS [src_shortName],
            [src_group] AS [src_group],
            [src_layer] AS [src_layer],
            [src_DatasetType] AS [src_DatasetType],
            [bk_schedule] AS [bk_schedule],
            [bk_schema] AS [bk_schema],
            [container] AS [container],
            [folder] AS [folder],
            [filename] AS [filename],
            [datetime] AS [datetime],
            [bk_fileformat] AS [bk_fileformat],
            [where_filter] AS [where_filter],
            [order_by] AS [order_by],
            [split_by] AS [split_by],
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
            [RepositoryStatusName] AS [RepositoryStatusName],
            [RepositoryStatusCode] AS [RepositoryStatusCode],
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1