﻿
CREATE VIEW [rep].[vw_datatypemapping] AS /*
    View is generated by  : metro
    Generated at          : 2025-01-06 16:02:25
    Description           : View on stage table
    */
SELECT -- List of columns:
 ltrim(rtrim(cast([bk] AS varchar(255)))) AS [bk],

       ltrim(rtrim(cast([code] AS varchar(255)))) AS [code],

       ltrim(rtrim(cast([name] AS varchar(255)))) AS [name],

       ltrim(rtrim(cast([description] AS varchar(255)))) AS [description],

       ltrim(rtrim(cast([bk_reftype_datatype] AS varchar(255)))) AS [bk_reftype_datatype],

       ltrim(rtrim(cast([datatypebydatasource] AS varchar(255)))) AS [datatypebydatasource],

       ltrim(rtrim(cast([bk_reftype_dst] AS varchar(255)))) AS [bk_reftype_dst],

       ltrim(rtrim(cast([active] AS varchar(255)))) AS [active],

       ltrim(rtrim(cast([issystem] AS varchar(255)))) AS [issystem],

       ltrim(rtrim(cast([mta_source] AS varchar(255)))) AS [mta_source],

       ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))) AS [mta_loaddate], -- Meta data columns:
 mta_rownum = row_number() OVER (
                                 ORDER BY [bk] ASC),

       mta_bk = upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-')),

       mta_bkh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-'))), 2),

       mta_rh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([code] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([name] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([description] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_reftype_datatype] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([datatypebydatasource] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_reftype_dst] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([active] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([issystem] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_source] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))), '-'))), 2)

  FROM [rep].[datatypemapping]

 WHERE 1 = 1

   AND 1 = 1

   AND isnull(active, '1') = '1'

   AND isnull(ltrim(rtrim([bk])), '') != ''
