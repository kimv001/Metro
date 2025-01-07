﻿
    CREATE   VIEW [rep].[vw_DatasetSrcAttribute] AS
    /*
    View is generated by  : metro
    Generated at          : 2025-01-06 16:02:25
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        LTRIM(RTRIM(CAST([BK] AS varchar(255)))) AS [BK],
        LTRIM(RTRIM(CAST([Code] AS varchar(255)))) AS [Code],
        LTRIM(RTRIM(CAST([Name] AS varchar(255)))) AS [Name],
        LTRIM(RTRIM(CAST([DatasetSrc] AS varchar(255)))) AS [DatasetSrc],
        LTRIM(RTRIM(CAST([AttributeName] AS varchar(255)))) AS [AttributeName],
        LTRIM(RTRIM(CAST([BK_DatasetSrc] AS varchar(255)))) AS [BK_DatasetSrc],
        LTRIM(RTRIM(CAST([Description] AS varchar(255)))) AS [Description],
        LTRIM(RTRIM(CAST([Active] AS varchar(255)))) AS [Active],
        LTRIM(RTRIM(CAST([DistributionHashKey] AS varchar(255)))) AS [DistributionHashKey],
        LTRIM(RTRIM(CAST([Expression] AS varchar(MAX)))) AS [Expression],
        LTRIM(RTRIM(CAST([DWHName] AS varchar(255)))) AS [DWHName],
        LTRIM(RTRIM(CAST([NotInRH] AS varchar(255)))) AS [NotInRH],
        LTRIM(RTRIM(CAST([DefaultValue] AS varchar(MAX)))) AS [DefaultValue],
        LTRIM(RTRIM(CAST([BusinessKey] AS varchar(255)))) AS [BusinessKey],
        LTRIM(RTRIM(CAST([SrcName] AS varchar(255)))) AS [SrcName],
        LTRIM(RTRIM(CAST([BK_RefType_DataType] AS varchar(255)))) AS [BK_RefType_DataType],
        LTRIM(RTRIM(CAST([Isnullable] AS varchar(255)))) AS [Isnullable],
        LTRIM(RTRIM(CAST([OrdinalPosition] AS varchar(255)))) AS [OrdinalPosition],
        LTRIM(RTRIM(CAST([MaximumLength] AS varchar(255)))) AS [MaximumLength],
        LTRIM(RTRIM(CAST([Precision] AS varchar(255)))) AS [Precision],
        LTRIM(RTRIM(CAST([Scale] AS varchar(255)))) AS [Scale],
        LTRIM(RTRIM(CAST([Collation] AS varchar(255)))) AS [Collation],
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
                    + ISNULL(LTRIM(RTRIM(CAST([DatasetSrc] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([AttributeName] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_DatasetSrc] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Description] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Active] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([DistributionHashKey] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Expression] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([DWHName] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([NotInRH] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([DefaultValue] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BusinessKey] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([SrcName] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_DataType] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Isnullable] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([OrdinalPosition] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([MaximumLength] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Precision] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Scale] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Collation] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_Source] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_LoadDate] AS VARCHAR(255)))),'-')
                )
            ),
            2
        )
    FROM [rep].[DatasetSrcAttribute]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''