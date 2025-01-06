﻿
CREATE proc [bld].[load_655_dwhreftemplates_010_default] AS /*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:28

	exec [bld].[load_655_DWHRefTemplates_010_default]*/  DECLARE @routinename varchar(8000) = 'load_655_DWHRefTemplates_010_default' DECLARE @startdatetime datetime2 = getutcdate() DECLARE @enddatetime datetime2 DECLARE @duration bigint -- Create a helper temp table
 IF object_id('tempdb..#655_DWHRefTemplates_010_default') IS NOT NULL
DROP TABLE # 655_dwhreftemplates_010_default ; PRINT '-- create temp table:'
SELECT mta_bk = src.[bk] ,

       mta_bkh = convert(char(64),(hashbytes('sha2_512', upper(src.bk))),2) ,

       mta_rh = convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_template] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_dataset] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templatetype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templatesource] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_reftype_objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templatescript] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templateversion] AS varchar(8000)), '-') + '|' + isnull(cast(src.[rownum] AS varchar(8000)), '-')))),2) ,

       mta_source = '[bld].[tr_655_DWHRefTemplates_010_default]' ,

       mta_rectype = CASE
                         WHEN tgt.[bk] IS NULL                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       THEN 1

            WHEN tgt.[mta_rh] != convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_template] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_dataset] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templatetype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templatesource] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_reftype_objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templatescript] AS varchar(8000)), '-') + '|' + isnull(cast(src.[templateversion] AS varchar(8000)), '-') + '|' + isnull(cast(src.[rownum] AS varchar(8000)), '-')))),2) THEN 0

            ELSE -99

             END INTO # 655_dwhreftemplates_010_default

  FROM [bld].[tr_655_dwhreftemplates_010_default] src

  LEFT JOIN [bld].[vw_dwhreftemplates] tgt
    ON src.[bk] = tgt.[bk]
CREATE clustered INDEX [ix_tr_655_dwhreftemplates_010_default]
    ON # 655_dwhreftemplates_010_default([mta_bkh] ASC, [mta_rh] ASC) --------------------- start loading data
 PRINT '-- new records:'

   SET @startdatetime = getdate()
INSERT INTO [bld].[dwhreftemplates] ([bk], [code], [bk_template], [bk_dataset], [templatetype], [templatesource], [bk_reftype_objecttype], [templatescript], [templateversion], [rownum] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_template],

       src.[bk_dataset],

       src.[templatetype],

       src.[templatesource],

       src.[bk_reftype_objecttype],

       src.[templatescript],

       src.[templateversion],

       src.[rownum] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_655_dwhreftemplates_010_default] src

  JOIN # 655_dwhreftemplates_010_default h
    ON h.[mta_bk] = src.[bk]

  LEFT JOIN [bld].[vw_dwhreftemplates] tgt
    ON h.[mta_bkh] = tgt.[mta_bkh]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 1

   AND tgt.[mta_bkh] IS NULL

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - NEW',

       @lognote = 'New Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[DWHRefTemplates]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- changed records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[dwhreftemplates] ([bk], [code], [bk_template], [bk_dataset], [templatetype], [templatesource], [bk_reftype_objecttype], [templatescript], [templateversion], [rownum] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_template],

       src.[bk_dataset],

       src.[templatetype],

       src.[templatesource],

       src.[bk_reftype_objecttype],

       src.[templatescript],

       src.[templateversion],

       src.[rownum] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_655_dwhreftemplates_010_default] src

  JOIN # 655_dwhreftemplates_010_default h
    ON h.[mta_bk] = src.[bk]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 0

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - CHG',

       @lognote = 'Changed Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[DWHRefTemplates]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- deleted records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[dwhreftemplates] ([bk], [code], [bk_template], [bk_dataset], [templatetype], [templatesource], [bk_reftype_objecttype], [templatescript], [templateversion], [rownum] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_template],

       src.[bk_dataset],

       src.[templatetype],

       src.[templatesource],

       src.[bk_reftype_objecttype],

       src.[templatescript],

       src.[templateversion],

       src.[rownum] ,

       src.[mta_bk],

       src.[mta_bkh],

       src.[mta_rh],

       src.[mta_source],

       [mta_rectype] = -1

  FROM [bld].[vw_dwhreftemplates] src

  LEFT JOIN # 655_dwhreftemplates_010_default h
    ON h.[mta_bkh] = src.[mta_bkh]

   AND h.[mta_source] = src.[mta_source]

 WHERE 1 = 1

   AND h.[mta_bkh] IS NULL

   AND src.mta_source = '[bld].[tr_655_DWHRefTemplates_010_default]'

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - DEL',

       @lognote = 'Changed Deleted',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[DWHRefTemplates]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime ; -- Clean up ...
 IF object_id('tempdb..#655_DWHRefTemplates_010_default') IS NOT NULL
  DROP TABLE # 655_dwhreftemplates_010_default;

   SET @enddatetime = getutcdate()

   SET @duration = datediff(ss, @startdatetime, @enddatetime) PRINT 'Load "load_655_DWHRefTemplates_010_default" took ' + cast(@duration AS varchar(10)) + ' second(s)'
