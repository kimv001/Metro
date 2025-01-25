﻿
    CREATE   VIEW [rep].[vw_TestDefinition] AS
    /*
    View is generated by  : metro
    Generated at          : 2025-01-22 20:09:40
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        LTRIM(RTRIM(CAST([BK] AS varchar(255)))) AS [BK],
        LTRIM(RTRIM(CAST([Name] AS varchar(255)))) AS [Name],
        LTRIM(RTRIM(CAST([Code] AS varchar(255)))) AS [Code],
        LTRIM(RTRIM(CAST([Description] AS varchar(255)))) AS [Description],
        LTRIM(RTRIM(CAST([Description_nl] AS varchar(255)))) AS [Description_nl],
        LTRIM(RTRIM(CAST([Active] AS varchar(255)))) AS [Active],
        LTRIM(RTRIM(CAST([Test] AS varchar(255)))) AS [Test],
        LTRIM(RTRIM(CAST([GetAttributes] AS varchar(255)))) AS [GetAttributes],
        LTRIM(RTRIM(CAST([ADFPipeline] AS varchar(255)))) AS [ADFPipeline],
        LTRIM(RTRIM(CAST([BK_Template_CreateTestScript] AS varchar(MAX)))) AS [BK_Template_CreateTestScript],
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
                    + ISNULL(LTRIM(RTRIM(CAST([Name] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Code] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description_nl] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Active] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Test] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([GetAttributes] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([ADFPipeline] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Template_CreateTestScript] AS VARCHAR(8000)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_Source] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_LoadDate] AS VARCHAR(255)))),'-')
                )
            ),
            2
        )
    FROM [rep].[TestDefinition]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''