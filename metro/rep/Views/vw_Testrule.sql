﻿
    CREATE   VIEW [rep].[vw_Testrule] AS
    /*
    View is generated by  : metro
    Generated at          : 2025-01-06 16:02:26
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        LTRIM(RTRIM(CAST([BK] AS varchar(255)))) AS [BK],
        LTRIM(RTRIM(CAST([Name] AS varchar(255)))) AS [Name],
        LTRIM(RTRIM(CAST([Code] AS varchar(255)))) AS [Code],
        LTRIM(RTRIM(CAST([Description] AS varchar(255)))) AS [Description],
        LTRIM(RTRIM(CAST([Active] AS varchar(255)))) AS [Active],
        LTRIM(RTRIM(CAST([BK_Datasource] AS varchar(255)))) AS [BK_Datasource],
        LTRIM(RTRIM(CAST([BK_Schema] AS varchar(255)))) AS [BK_Schema],
        LTRIM(RTRIM(CAST([BK_DatasetSrc] AS varchar(255)))) AS [BK_DatasetSrc],
        LTRIM(RTRIM(CAST([BK_DatasetTrn] AS varchar(255)))) AS [BK_DatasetTrn],
        LTRIM(RTRIM(CAST([BK_RefType_ObjectType_Target] AS varchar(255)))) AS [BK_RefType_ObjectType_Target],
        LTRIM(RTRIM(CAST([BK_TestDefinition] AS varchar(255)))) AS [BK_TestDefinition],
        LTRIM(RTRIM(CAST([BK_DatasetSrcAttribute] AS varchar(255)))) AS [BK_DatasetSrcAttribute],
        LTRIM(RTRIM(CAST([BK_DatasetTrnAttribute] AS varchar(255)))) AS [BK_DatasetTrnAttribute],
        LTRIM(RTRIM(CAST([ExpectedValue] AS varchar(MAX)))) AS [ExpectedValue],
        LTRIM(RTRIM(CAST([TresholdValue] AS varchar(MAX)))) AS [TresholdValue],
        LTRIM(RTRIM(CAST([BK_Schedule] AS varchar(255)))) AS [BK_Schedule],
        LTRIM(RTRIM(CAST([BK_RefType_RepositoryStatus] AS varchar(255)))) AS [BK_RefType_RepositoryStatus],
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
                    + ISNULL(LTRIM(RTRIM(CAST([Active] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Datasource] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Schema] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_DatasetSrc] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_DatasetTrn] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_ObjectType_Target] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_TestDefinition] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_DatasetSrcAttribute] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_DatasetTrnAttribute] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([ExpectedValue] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([TresholdValue] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Schedule] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_RepositoryStatus] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_Source] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_LoadDate] AS VARCHAR(255)))),'-')
                )
            ),
            2
        )
    FROM [rep].[Testrule]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''