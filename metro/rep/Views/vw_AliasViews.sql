﻿
CREATE VIEW [rep].[vw_aliasviews] AS /*
    View is generated by  : metro
    Generated at          : 2025-01-06 16:02:25
    Description           : View on stage table
    */
SELECT -- List of columns:
 ltrim(rtrim(cast([bk] AS varchar(255)))) AS [bk],

       ltrim(rtrim(cast([code] AS varchar(255)))) AS [code],

       ltrim(rtrim(cast([name] AS varchar(255)))) AS [name],

       ltrim(rtrim(cast([bk_datasettrn] AS varchar(255)))) AS [bk_datasettrn],

       ltrim(rtrim(cast([bk_schema] AS varchar(255)))) AS [bk_schema],

       ltrim(rtrim(cast([src_groupname] AS varchar(255)))) AS [src_groupname],

       ltrim(rtrim(cast([src_shortname] AS varchar(255)))) AS [src_shortname],

       ltrim(rtrim(cast([prefix] AS varchar(255)))) AS [prefix],

       ltrim(rtrim(cast([tgt_shortname] AS varchar(255)))) AS [tgt_shortname],

       ltrim(rtrim(cast([postfix] AS varchar(255)))) AS [postfix],

       ltrim(rtrim(cast([replaceattributenames] AS varchar(255)))) AS [replaceattributenames],

       ltrim(rtrim(cast([bk_template_create] AS varchar(255)))) AS [bk_template_create],

       ltrim(rtrim(cast([active] AS varchar(255)))) AS [active],

       ltrim(rtrim(cast([bk_reftype_repositorystatus] AS varchar(255)))) AS [bk_reftype_repositorystatus],

       ltrim(rtrim(cast([mta_source] AS varchar(255)))) AS [mta_source],

       ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))) AS [mta_loaddate], -- Meta data columns:
 mta_rownum = row_number() OVER (
                                 ORDER BY [bk] ASC),

       mta_bk = upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-')),

       mta_bkh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(500)))), '-'))), 2),

       mta_rh = convert(char(64), hashbytes('SHA2_512', upper(isnull(ltrim(rtrim(cast([bk] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([code] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([name] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_datasettrn] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_schema] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([src_groupname] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([src_shortname] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([prefix] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([tgt_shortname] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([postfix] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([replaceattributenames] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_template_create] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([active] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([bk_reftype_repositorystatus] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_source] AS varchar(255)))), '-') + '|' + isnull(ltrim(rtrim(cast([mta_loaddate] AS varchar(255)))), '-'))), 2)

  FROM [rep].[aliasviews]

 WHERE 1 = 1

   AND 1 = 1

   AND isnull(active, '1') = '1'

   AND isnull(ltrim(rtrim([bk])), '') != ''
