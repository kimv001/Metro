﻿
    CREATE   VIEW [rep].[vw_Layer] AS
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
        LTRIM(RTRIM(CAST([isDWH] AS varchar(255)))) AS [isDWH],
        LTRIM(RTRIM(CAST([isSRC] AS varchar(255)))) AS [isSRC],
        LTRIM(RTRIM(CAST([isTGT] AS varchar(255)))) AS [isTGT],
        LTRIM(RTRIM(CAST([isRep] AS varchar(255)))) AS [isRep],
        LTRIM(RTRIM(CAST([isAudit] AS varchar(255)))) AS [isAudit],
        LTRIM(RTRIM(CAST([isDWHhelper] AS varchar(255)))) AS [isDWHhelper],
        LTRIM(RTRIM(CAST([IsSystem] AS varchar(255)))) AS [IsSystem],
        LTRIM(RTRIM(CAST([LayerOrder] AS varchar(255)))) AS [LayerOrder],
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
                    + ISNULL(LTRIM(RTRIM(CAST([isDWH] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([isSRC] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([isTGT] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([isRep] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([isAudit] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([isDWHhelper] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([IsSystem] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([LayerOrder] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_Source] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_LoadDate] AS VARCHAR(255)))),'-')
                )
            ),
            2
        )
    FROM [rep].[Layer]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''