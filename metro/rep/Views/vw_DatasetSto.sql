﻿
    CREATE   VIEW [rep].[vw_DatasetSto] AS
    /*
    View is generated by  : metro
    Generated at          : 2025-01-22 20:09:39
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        LTRIM(RTRIM(CAST([bk] AS varchar(255)))) AS [bk],
        LTRIM(RTRIM(CAST([code] AS varchar(255)))) AS [code],
        LTRIM(RTRIM(CAST([name] AS varchar(255)))) AS [name],
        LTRIM(RTRIM(CAST([Description] AS varchar(255)))) AS [Description],
        LTRIM(RTRIM(CAST([Description_nl] AS varchar(255)))) AS [Description_nl],
        LTRIM(RTRIM(CAST([active] AS varchar(255)))) AS [active],
        LTRIM(RTRIM(CAST([BK_Schema] AS varchar(255)))) AS [BK_Schema],
        LTRIM(RTRIM(CAST([StoType] AS varchar(255)))) AS [StoType],
        LTRIM(RTRIM(CAST([prefix] AS varchar(255)))) AS [prefix],
        LTRIM(RTRIM(CAST([bk_datasetTrn_based_on] AS varchar(255)))) AS [bk_datasetTrn_based_on],
        LTRIM(RTRIM(CAST([Kolom1] AS varchar(255)))) AS [Kolom1],
        LTRIM(RTRIM(CAST([bk_schedule] AS varchar(255)))) AS [bk_schedule],
        LTRIM(RTRIM(CAST([bk_schema_to] AS varchar(255)))) AS [bk_schema_to],
        LTRIM(RTRIM(CAST([container] AS varchar(255)))) AS [container],
        LTRIM(RTRIM(CAST([folder] AS varchar(255)))) AS [folder],
        LTRIM(RTRIM(CAST([filename] AS varchar(255)))) AS [filename],
        LTRIM(RTRIM(CAST([datetime] AS varchar(255)))) AS [datetime],
        LTRIM(RTRIM(CAST([bk_fileformat] AS varchar(255)))) AS [bk_fileformat],
        LTRIM(RTRIM(CAST([where_filter] AS varchar(255)))) AS [where_filter],
        LTRIM(RTRIM(CAST([order_by] AS varchar(255)))) AS [order_by],
        LTRIM(RTRIM(CAST([BK_ContactGroup] AS varchar(255)))) AS [BK_ContactGroup],
        LTRIM(RTRIM(CAST([split_by] AS varchar(255)))) AS [split_by],
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
                    ISNULL(LTRIM(RTRIM(CAST([bk] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([code] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([name] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description_nl] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([active] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_Schema] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([StoType] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([prefix] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([bk_datasetTrn_based_on] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Kolom1] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([bk_schedule] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([bk_schema_to] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([container] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([folder] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([filename] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([datetime] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([bk_fileformat] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([where_filter] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([order_by] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_ContactGroup] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([split_by] AS VARCHAR(255)))),'-')
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
    FROM [rep].[DatasetSto]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''