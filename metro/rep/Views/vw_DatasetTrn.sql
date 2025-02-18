﻿
    CREATE   VIEW [rep].[vw_DatasetTrn] AS
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
        LTRIM(RTRIM(CAST([TargetDataset] AS varchar(255)))) AS [TargetDataset],
        LTRIM(RTRIM(CAST([Active] AS varchar(255)))) AS [Active],
        LTRIM(RTRIM(CAST([DataSource] AS varchar(255)))) AS [DataSource],
        LTRIM(RTRIM(CAST([BK_Schema] AS varchar(255)))) AS [BK_Schema],
        LTRIM(RTRIM(CAST([Schema] AS varchar(255)))) AS [Schema],
        LTRIM(RTRIM(CAST([prefix] AS varchar(255)))) AS [prefix],
        LTRIM(RTRIM(CAST([BK_Group] AS varchar(255)))) AS [BK_Group],
        LTRIM(RTRIM(CAST([BK_Segment] AS varchar(255)))) AS [BK_Segment],
        LTRIM(RTRIM(CAST([BK_Bucket] AS varchar(255)))) AS [BK_Bucket],
        LTRIM(RTRIM(CAST([ShortName] AS varchar(255)))) AS [ShortName],
        LTRIM(RTRIM(CAST([GroupSelector] AS varchar(255)))) AS [GroupSelector],
        LTRIM(RTRIM(CAST([SegmentSelector] AS varchar(255)))) AS [SegmentSelector],
        LTRIM(RTRIM(CAST([BucketSelector] AS varchar(255)))) AS [BucketSelector],
        LTRIM(RTRIM(CAST([ShortNameInput] AS varchar(255)))) AS [ShortNameInput],
        LTRIM(RTRIM(CAST([postfix] AS varchar(255)))) AS [postfix],
        LTRIM(RTRIM(CAST([Description] AS varchar(255)))) AS [Description],
        LTRIM(RTRIM(CAST([Description_nl] AS varchar(255)))) AS [Description_nl],
        LTRIM(RTRIM(CAST([BK_ContactGroup] AS varchar(255)))) AS [BK_ContactGroup],
        LTRIM(RTRIM(CAST([BK_Flow] AS varchar(255)))) AS [BK_Flow],
        LTRIM(RTRIM(CAST([TimeStamp] AS varchar(255)))) AS [TimeStamp],
        LTRIM(RTRIM(CAST([BusinessDate] AS varchar(MAX)))) AS [BusinessDate],
        LTRIM(RTRIM(CAST([BK_RefType_SCD] AS varchar(255)))) AS [BK_RefType_SCD],
        LTRIM(RTRIM(CAST([WhereFilter] AS varchar(255)))) AS [WhereFilter],
        LTRIM(RTRIM(CAST([PartitionStatement] AS varchar(255)))) AS [PartitionStatement],
        LTRIM(RTRIM(CAST([BK_RefType_ObjectType] AS varchar(255)))) AS [BK_RefType_ObjectType],
        LTRIM(RTRIM(CAST([FullLoad] AS varchar(255)))) AS [FullLoad],
        LTRIM(RTRIM(CAST([InsertOnly] AS varchar(255)))) AS [InsertOnly],
        LTRIM(RTRIM(CAST([BigData] AS varchar(255)))) AS [BigData],
        LTRIM(RTRIM(CAST([BK_Template_Load] AS varchar(255)))) AS [BK_Template_Load],
        LTRIM(RTRIM(CAST([BK_Template_Create] AS varchar(255)))) AS [BK_Template_Create],
        LTRIM(RTRIM(CAST([BK_RefType_RepositoryStatus] AS varchar(255)))) AS [BK_RefType_RepositoryStatus],
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
                    + ISNULL(LTRIM(RTRIM(CAST([TargetDataset] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Active] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([DataSource] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Schema] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Schema] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([prefix] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Group] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Segment] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Bucket] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([ShortName] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([GroupSelector] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([SegmentSelector] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BucketSelector] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([ShortNameInput] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([postfix] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description_nl] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_ContactGroup] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Flow] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([TimeStamp] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BusinessDate] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_SCD] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([WhereFilter] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([PartitionStatement] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_ObjectType] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([FullLoad] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([InsertOnly] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BigData] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Template_Load] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Template_Create] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_RepositoryStatus] AS VARCHAR(255)))),'-')
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
    FROM [rep].[DatasetTrn]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''