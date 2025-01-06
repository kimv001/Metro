﻿
CREATE VIEW [rep].[vw_testdefinition] AS /*
    View is generated by  : metro
    Generated at          : 2025-01-06 16:02:26
    Description           : View on stage table
    */
SELECT -- List of columns:
 ltrim(rtrim(cast([bk] AS varchar(255)))) AS [bk],

       ltrim(rtrim(cast([name] AS varchar(255)))) AS [name],

       ltrim(rtrim(cast([code] AS varchar(255)))) AS [code],

       ltrim(rtrim(cast([description] AS varchar(255)))) AS [description],

       ltrim(rtrim(cast([active] AS varchar(255)))) AS [active],

       ltrim(rtrim(cast([test] AS varchar(255)))) AS [test],

       ltrim(rtrim(cast([getattributes] AS varchar(255)))) AS [getattributes],

       ltrim(rtrim(cast([adfpipeline] AS varchar(255)))) AS [adfpipeline],

       ltrim(rtrim(cast([bk_template_createtestscript] AS varchar(MAX)))) AS [bk_template_createtestscript],

       ltrim(rtrim(cast([mta_source] AS varchar(255)))) AS [mta_source],

       ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))) AS [mta_loaddate], -- Meta data columns:
 mta_rownum = row_number() OVER (
                                 ORDER BY [bk] ASC),

       mta_bk = upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-')),

       mta_bkh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-'))), 2),

       mta_rh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([name] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([code] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([description] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([active] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([test] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([getattributes] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([adfpipeline] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_template_createtestscript] AS varchar(8000)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_source] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))), '-'))), 2)

  FROM [rep].[testdefinition]

 WHERE 1 = 1

   AND 1 = 1

   AND isnull(active, '1') = '1'

   AND isnull(ltrim(rtrim([bk])), '') != ''
