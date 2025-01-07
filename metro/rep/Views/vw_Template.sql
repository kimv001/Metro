﻿
    CREATE   VIEW [rep].[vw_Template] AS
    /*
    View is generated by  : metro
    Generated at          : 2025-01-06 16:02:26
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        LTRIM(RTRIM(CAST([BK] AS varchar(255)))) AS [BK],
        LTRIM(RTRIM(CAST([Code] AS varchar(255)))) AS [Code],
        LTRIM(RTRIM(CAST([Name] AS varchar(255)))) AS [Name],
        LTRIM(RTRIM(CAST([Description] AS varchar(255)))) AS [Description],
        LTRIM(RTRIM(CAST([Script] AS varchar(MAX)))) AS [Script],
        LTRIM(RTRIM(CAST([TemplateVersion] AS varchar(255)))) AS [TemplateVersion],
        LTRIM(RTRIM(CAST([ObjectName] AS varchar(255)))) AS [ObjectName],
        LTRIM(RTRIM(CAST([BK_RefType_ScriptLanguage] AS varchar(255)))) AS [BK_RefType_ScriptLanguage],
        LTRIM(RTRIM(CAST([ScriptLanguage] AS varchar(255)))) AS [ScriptLanguage],
        LTRIM(RTRIM(CAST([BK_RefType_TemplateType] AS varchar(255)))) AS [BK_RefType_TemplateType],
        LTRIM(RTRIM(CAST([BK_RefType_ObjectType] AS varchar(255)))) AS [BK_RefType_ObjectType],
        LTRIM(RTRIM(CAST([BK_RefTYpe_ObjectType_BasedOn] AS varchar(255)))) AS [BK_RefTYpe_ObjectType_BasedOn],
        LTRIM(RTRIM(CAST([Active] AS varchar(255)))) AS [Active],
        LTRIM(RTRIM(CAST([IsSystem] AS varchar(255)))) AS [IsSystem],
        LTRIM(RTRIM(CAST([IsDefault] AS varchar(255)))) AS [IsDefault],
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
                    + ISNULL(LTRIM(RTRIM(CAST([Script] AS VARCHAR(8000)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([TemplateVersion] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([ObjectName] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_ScriptLanguage] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([ScriptLanguage] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_TemplateType] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefType_ObjectType] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([BK_RefTYpe_ObjectType_BasedOn] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([Active] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([IsSystem] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([IsDefault] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_Source] AS VARCHAR(255)))),'-')
                    + '|'
                    + ISNULL(LTRIM(RTRIM(CAST([mta_LoadDate] AS VARCHAR(255)))),'-')
                )
            ),
            2
        )
    FROM [rep].[Template]
    WHERE 1=1 AND 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''