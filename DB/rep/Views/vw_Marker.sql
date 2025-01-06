﻿
    CREATE   VIEW [rep].[vw_Marker] AS
    /*
    View is generated by  : metro
    Generated at          : 2025-01-06 16:02:26
    Description           : View on stage table
    */
    SELECT 
        -- List of columns:
        LTRIM(RTRIM(CAST([BK] as varchar(255)))) as [BK], LTRIM(RTRIM(CAST([Code] as varchar(255)))) as [Code], LTRIM(RTRIM(CAST([Name] as varchar(255)))) as [Name], LTRIM(RTRIM(CAST([Description] as varchar(255)))) as [Description], LTRIM(RTRIM(CAST([DefaultValue] as varchar(max)))) as [DefaultValue], LTRIM(RTRIM(CAST([MarkerVersion] as varchar(255)))) as [MarkerVersion], LTRIM(RTRIM(CAST([IsSystem] as varchar(255)))) as [IsSystem], LTRIM(RTRIM(CAST([Pre] as varchar(255)))) as [Pre], LTRIM(RTRIM(CAST([Post] as varchar(255)))) as [Post], LTRIM(RTRIM(CAST([Active] as varchar(255)))) as [Active], LTRIM(RTRIM(CAST([mta_Source] as varchar(255)))) as [mta_Source], LTRIM(RTRIM(CAST([mta_LoadDate] as varchar(255)))) as [mta_LoadDate],
        -- Meta data columns:
        mta_RowNum     = ROW_NUMBER() OVER (ORDER BY [BK] ASC),
        mta_BK         = UPPER(ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(500)))),'-')),
        mta_BKH        = CONVERT(CHAR(64), HASHBYTES('SHA2_512', UPPER(ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(500)))),'-'))), 2),
        mta_RH         = CONVERT(CHAR(64), HASHBYTES('SHA2_512', UPPER(ISNULL(LTRIM(RTRIM(CAST([BK] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([Code] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([Name] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([Description] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([DefaultValue] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([MarkerVersion] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([IsSystem] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([Pre] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([Post] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([Active] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([mta_Source] AS VARCHAR(255)))),'-') + '|' + ISNULL(LTRIM(RTRIM(CAST([mta_LoadDate] AS VARCHAR(255)))),'-'))), 2)
    FROM [rep].[Marker]
    WHERE 1=1 and 1=1
      AND ISNULL(Active,'1') = '1'
      AND ISNULL(LTRIM(RTRIM([BK])),'') != ''