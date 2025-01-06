﻿
CREATE proc [bld].[load_150_datatypesbyschema_010_allschemas] AS /*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:27

	exec [bld].[load_150_DataTypesBySchema_010_allschemas]*/  DECLARE @routinename varchar(8000) = 'load_150_DataTypesBySchema_010_allschemas' DECLARE @startdatetime datetime2 = getutcdate() DECLARE @enddatetime datetime2 DECLARE @duration bigint -- Create a helper temp table
 IF object_id('tempdb..#150_DataTypesBySchema_010_allschemas') IS NOT NULL
DROP TABLE # 150_datatypesbyschema_010_allschemas ; PRINT '-- create temp table:'
SELECT mta_bk = src.[bk] ,

       mta_bkh = convert(char(64),(hashbytes('sha2_512', upper(src.bk))),2) ,

       mta_rh = convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schema] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datatypemapped] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datatypeinrep] AS varchar(8000)), '-') + '|' + isnull(cast(src.[fixedschemadatatype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[orgmappeddatatype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[defaultvalue] AS varchar(8000)), '-')))),2) ,

       mta_source = '[bld].[tr_150_DataTypesBySchema_010_allschemas]' ,

       mta_rectype = CASE
                         WHEN tgt.[bk] IS NULL                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              THEN 1

            WHEN tgt.[mta_rh] != convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schema] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datatypemapped] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datatypeinrep] AS varchar(8000)), '-') + '|' + isnull(cast(src.[fixedschemadatatype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[orgmappeddatatype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[defaultvalue] AS varchar(8000)), '-')))),2) THEN 0

            ELSE -99

             END INTO # 150_datatypesbyschema_010_allschemas

  FROM [bld].[tr_150_datatypesbyschema_010_allschemas] src

  LEFT JOIN [bld].[vw_datatypesbyschema] tgt
    ON src.[bk] = tgt.[bk]
CREATE clustered INDEX [ix_tr_150_datatypesbyschema_010_allschemas]
    ON # 150_datatypesbyschema_010_allschemas([mta_bkh] ASC, [mta_rh] ASC) --------------------- start loading data
 PRINT '-- new records:'

   SET @startdatetime = getdate()
INSERT INTO [bld].[datatypesbyschema] ([bk], [code], [bk_schema], [datatypemapped], [datatypeinrep], [fixedschemadatatype], [orgmappeddatatype], [defaultvalue] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_schema],

       src.[datatypemapped],

       src.[datatypeinrep],

       src.[fixedschemadatatype],

       src.[orgmappeddatatype],

       src.[defaultvalue] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_150_datatypesbyschema_010_allschemas] src

  JOIN # 150_datatypesbyschema_010_allschemas h
    ON h.[mta_bk] = src.[bk]

  LEFT JOIN [bld].[vw_datatypesbyschema] tgt
    ON h.[mta_bkh] = tgt.[mta_bkh]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 1

   AND tgt.[mta_bkh] IS NULL

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - NEW',

       @lognote = 'New Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[DataTypesBySchema]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- changed records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[datatypesbyschema] ([bk], [code], [bk_schema], [datatypemapped], [datatypeinrep], [fixedschemadatatype], [orgmappeddatatype], [defaultvalue] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_schema],

       src.[datatypemapped],

       src.[datatypeinrep],

       src.[fixedschemadatatype],

       src.[orgmappeddatatype],

       src.[defaultvalue] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_150_datatypesbyschema_010_allschemas] src

  JOIN # 150_datatypesbyschema_010_allschemas h
    ON h.[mta_bk] = src.[bk]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 0

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - CHG',

       @lognote = 'Changed Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[DataTypesBySchema]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- deleted records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[datatypesbyschema] ([bk], [code], [bk_schema], [datatypemapped], [datatypeinrep], [fixedschemadatatype], [orgmappeddatatype], [defaultvalue] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[bk_schema],

       src.[datatypemapped],

       src.[datatypeinrep],

       src.[fixedschemadatatype],

       src.[orgmappeddatatype],

       src.[defaultvalue] ,

       src.[mta_bk],

       src.[mta_bkh],

       src.[mta_rh],

       src.[mta_source],

       [mta_rectype] = -1

  FROM [bld].[vw_datatypesbyschema] src

  LEFT JOIN # 150_datatypesbyschema_010_allschemas h
    ON h.[mta_bkh] = src.[mta_bkh]

   AND h.[mta_source] = src.[mta_source]

 WHERE 1 = 1

   AND h.[mta_bkh] IS NULL

   AND src.mta_source = '[bld].[tr_150_DataTypesBySchema_010_allschemas]'

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - DEL',

       @lognote = 'Changed Deleted',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[DataTypesBySchema]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime ; -- Clean up ...
 IF object_id('tempdb..#150_DataTypesBySchema_010_allschemas') IS NOT NULL
  DROP TABLE # 150_datatypesbyschema_010_allschemas;

   SET @enddatetime = getutcdate()

   SET @duration = datediff(ss, @startdatetime, @enddatetime) PRINT 'Load "load_150_DataTypesBySchema_010_allschemas" took ' + cast(@duration AS varchar(10)) + ' second(s)'
