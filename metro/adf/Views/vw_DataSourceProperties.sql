CREATE VIEW [adf].[vw_DataSourceProperties] AS
/*
Developed by:            metro
Description:             Generic transformation view to pivot all DataSourceProperties to DTAP environment values

Change log:
Date                     Author                Description
20220915 00:00           K. Vermeij            Initial version
*/

SELECT 
      BK_Datasource,
      DataSourceName,
      BK_LinkedService,
      DataSourcePropertiesName,
      CurrentEnvironment = CASE 
          WHEN RIGHT(CAST(SERVERPROPERTY('ServerName') AS VARCHAR), 3) = 'ROD' THEN 'PRD' 
          ELSE RIGHT(CAST(SERVERPROPERTY('ServerName') AS VARCHAR), 3) 
      END,
      DataSourcePropertiesCurrentValue = CASE 
          WHEN RIGHT(CAST(SERVERPROPERTY('ServerName') AS VARCHAR), 3) = 'dev' THEN ISNULL([D], [X])
          WHEN RIGHT(CAST(SERVERPROPERTY('ServerName') AS VARCHAR), 3) = 'tst' THEN ISNULL([T], [X])
          WHEN RIGHT(CAST(SERVERPROPERTY('ServerName') AS VARCHAR), 3) = 'acc' THEN ISNULL([A], [X])
          WHEN RIGHT(CAST(SERVERPROPERTY('ServerName') AS VARCHAR), 3) = 'rod' THEN ISNULL([P], [X])
          WHEN RIGHT(CAST(SERVERPROPERTY('ServerName') AS VARCHAR), 3) = 'box' THEN ISNULL([S], [X])
          ELSE 'Unknown'
      END,
      D = ISNULL([D], [X]),
      T = ISNULL([T], [X]),
      A = ISNULL([A], [X]),
      P = ISNULL([P], [X]),
      X = [X], -- default value for all DTAP
      S = ISNULL([S], [X]) -- Sandbox environment
FROM (
    SELECT 
          BK_Datasource = ds.bk,
          BK_LinkedService = ds.BK_LinkedService,
          DataSourceName = ds.[Name],
          DataSourcePropertiesName = src.DataSourcePropertiesName,
          DataSourcePropertiesValue = src.DataSourcePropertiesValue,
          DataSourcePropertiesEnvironment = rt.code
    FROM  
          rep.vw_DataSource ds
    JOIN 
          rep.vw_DataSourceProperties src ON src.BK_Datasource = ds.bk
    JOIN 
          rep.vw_refType rt ON rt.bk = src.bk_RefType_Environment
    ) dsp
PIVOT (
    MAX([DataSourcePropertiesValue])
    FOR [DataSourcePropertiesEnvironment] IN ([D], [T], [A], [P], [X], [S])
) AS pivot_table;
