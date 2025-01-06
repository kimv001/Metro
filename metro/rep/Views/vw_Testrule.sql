﻿
CREATE VIEW [rep].[vw_testrule] AS /*
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

       ltrim(rtrim(cast([bk_datasource] AS varchar(255)))) AS [bk_datasource],

       ltrim(rtrim(cast([bk_schema] AS varchar(255)))) AS [bk_schema],

       ltrim(rtrim(cast([bk_datasetsrc] AS varchar(255)))) AS [bk_datasetsrc],

       ltrim(rtrim(cast([bk_datasettrn] AS varchar(255)))) AS [bk_datasettrn],

       ltrim(rtrim(cast([bk_reftype_objecttype_target] AS varchar(255)))) AS [bk_reftype_objecttype_target],

       ltrim(rtrim(cast([bk_testdefinition] AS varchar(255)))) AS [bk_testdefinition],

       ltrim(rtrim(cast([bk_datasetsrcattribute] AS varchar(255)))) AS [bk_datasetsrcattribute],

       ltrim(rtrim(cast([bk_datasettrnattribute] AS varchar(255)))) AS [bk_datasettrnattribute],

       ltrim(rtrim(cast([expectedvalue] AS varchar(MAX)))) AS [expectedvalue],

       ltrim(rtrim(cast([tresholdvalue] AS varchar(MAX)))) AS [tresholdvalue],

       ltrim(rtrim(cast([bk_schedule] AS varchar(255)))) AS [bk_schedule],

       ltrim(rtrim(cast([bk_reftype_repositorystatus] AS varchar(255)))) AS [bk_reftype_repositorystatus],

       ltrim(rtrim(cast([mta_source] AS varchar(255)))) AS [mta_source],

       ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))) AS [mta_loaddate], -- Meta data columns:
 mta_rownum = row_number() OVER (
                                 ORDER BY [bk] ASC),

       mta_bk = upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-')),

       mta_bkh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-'))), 2),

       mta_rh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([name] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([code] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([description] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([active] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_datasource] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_schema] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_datasetsrc] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_datasettrn] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_reftype_objecttype_target] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_testdefinition] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_datasetsrcattribute] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_datasettrnattribute] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([expectedvalue] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([tresholdvalue] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_schedule] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_reftype_repositorystatus] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_source] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))), '-'))), 2)

  FROM [rep].[testrule]

 WHERE 1 = 1

   AND 1 = 1

   AND isnull(active, '1') = '1'

   AND isnull(ltrim(rtrim([bk])), '') != ''
