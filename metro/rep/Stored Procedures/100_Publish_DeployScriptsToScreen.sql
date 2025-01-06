
CREATE PROCEDURE [rep].[100_publish_deployscriptstoscreen] @tgt_objectname varchar(8000) = '' ,

       @layername varchar(8000) = '' ,

       @schemaname varchar(8000) = '' ,

       @groupname varchar(8000) = '' ,

       @shortname varchar(8000) = '' ,

       @deploydatasets bit = 0 ,

       @deploymappings bit = 1 ,

       @objecttype varchar(100) = '' ,

       @ignoreerrors int = 0 -- 2 just show the scripts, 1 stop on all builderrors, 0 stop on builderrors on selection
AS /*
Developed by:			metro
Description:			Publish deployscripts to screen

Example:

exec  [rep].[100_Publish_DeployScriptsToScreen]
			  @TGT_ObjectName	= ''
			, @LayerName		= ''
			, @SchemaName		= 'pst'
			, @GroupName		= 'boost'
			, @ShortName		= 'case'
			, @DeployDatasets	= 0
			, @DeployMappings	= 1

Change log:
Date					Author				Description
20220916	2015		K. Vermeij			Initial version
20230406	1045		K. Vermeij			Added filter ToDeploy = 1
20230609	0858		K. Vermeij			Builderrors are shown before the scripts are shown. With the new paramter @IgnoreErrors
											you can choose:
											0	- stop generating scripts if there are errors in your selection for generating
											1	- stop generating scripts if there are errors in the total build
											2	- show the errors... but still generate the scripts
*/

   SET ansi_warnings OFF;

   SET nocount
    ON;DECLARE @logprocname varchar(255) = '100_Publish_DeployScriptsToScreen' DECLARE @logsql varchar(MAX) = '' DECLARE @srcschema varchar(255) = 'rep' DECLARE @srcdataset varchar(255) = '' DECLARE @tgtschema varchar(255) = 'rep' DECLARE @tgtdataset varchar(255) = '' DECLARE @msg varchar(8000) DECLARE @deployversion varchar(MAX) = '<!<DeployVersionNum>>' -- Convert(varchar(20),Format(cast(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as datetime), 'yyyyMMddHHmmss'),121)
 -- variables for the loops
DECLARE @counternr int DECLARE @maxnr int DECLARE @stopcounternr int DECLARE @sql varchar(MAX) DECLARE @bld_msg varchar(MAX) IF object_id('tempdb..#bld_errors') IS NOT NULL
DROP TABLE #bld_errors
SELECT bc.* ,rownum = row_number() OVER (PARTITION BY bc.buildcheckid
                                         ORDER BY bc.buildcheckid ASC) INTO #bld_errors

  FROM [bld].[vw_buildcheck] bc

 INNER JOIN bld.vw_dataset d
    ON d.bk = bc.bk

 WHERE 1 = 1

   AND (@ignoreerrors = 2
       OR @ignoreerrors = 1
       OR (@ignoreerrors = 0
           AND (@tgt_objectname = ''
                OR @tgt_objectname = d.[datasetname])
           AND (@layername = ''
                OR @layername = d.layername)
           AND (@schemaname = ''
                OR @schemaname = d.schemaname)
           AND (@groupname = ''
                OR @groupname = d.bk_group)
           AND (@shortname = ''
                OR @shortname = d.shortname)))
  SELECT @counternr = min(rownum) ,

       @maxnr = max(rownum) --, @StopCounterNr= min(rownum)

  FROM #bld_errors bc IF @counternr > 0 PRINT '/*' + char(10) + 'Build errors found:' + char(10) WHILE (@counternr IS NOT NULL
                                                                                                      AND @counternr <= @maxnr) BEGIN
  SELECT @bld_msg = 'Dataset: ' + src.bk + ' Message:' + src.checkmessage + char(10)

  FROM #bld_errors src
 WHERE 1 = 1

   AND src.rownum = @counternr PRINT (@bld_msg) IF @counternr = @maxnr PRINT char(10) + '*/' + char(10)

   SET @counternr = @counternr + 1 END

IF @ignoreerrors < 2

   AND @counternr IS NOT NULL BEGIN -- NEED TO STOP STORED PROCEDURE EXECUTION
 RETURN END

IF object_id('tempdb..#DeployScripts') IS NOT NULL
  DROP TABLE #deployscripts;WITH base AS

        (SELECT --	  DeployOrder				= dense_rank() over (partition by  d.Code order by d.ShortName,d.BK_Group, cast(isnull(fl.SortOrder,'1000') as int) asc,   cast(src.ObjectTypeDeployOrder as int) asc) -- rank() OVER (partition by d.SchemaName order by  cast(src.ObjectTypeDeployOrder as int) asc )
 deployorder = dense_rank() OVER (PARTITION BY d.code
                                  ORDER BY d.shortname , d.bk_group , cast(src.objecttypedeployorder AS int) + cast(d.floworder AS int) ASC) -- rank() OVER (partition by d.SchemaName order by  cast(src.ObjectTypeDeployOrder as int) asc )
 ,

               deployscript = src.templatescript ,

               tgt_objectname = src.tgt_objectname ,

               objecttype = src.objecttype ,

               templatetype = src.templatetype ,

               templatename = src.templatename ,

               bk_dataset = d.bk ,

               schemaname = d.schemaname ,

               layername = d.layername ,

               groupname = d.bk_group ,

               shortname = d.shortname ,

               code = d.code ,

               src.scriptlanguagecode ,

               src.scriptlanguage

          FROM bld.vw_deployscripts src

         INNER JOIN bld.vw_dataset d
            ON d.bk = src.bk_dataset

         INNER JOIN bld.vw_schema s
            ON s.bk = d.bk_schema

         WHERE 1 = 1

           AND isnull(d.todeploy, 1) = 1

           AND ((@deploydatasets = 1
           AND src.templatetype = 'Dataset')
          OR src.templatetype = 'Mapping')

           AND ((@deploymappings = 1
           AND src.templatetype = 'Mapping')
          OR src.templatetype = 'Dataset')

           AND (@objecttype = src.objecttype
          OR @objecttype = '')
       )
SELECT * ,RowNum = row_number() OVER (
                                      ORDER BY groupname , shortname , deployorder) INTO #deployscripts

  FROM base

 WHERE 1 = 1

   AND (@tgt_objectname = ''
       OR @tgt_objectname = tgt_objectname)

   AND (@layername = ''
       OR @layername = layername)

   AND (@schemaname = ''
       OR @schemaname = schemaname)

   AND (@groupname = ''
       OR @groupname = groupname)

   AND (@shortname = ''
       OR @shortname = shortname)

 ORDER BY groupname ,

          shortname ,

          deployorder
SELECT @counternr = min(RowNum) ,

       @maxnr = max(RowNum)

  FROM #deployscripts WHILE (@counternr IS NOT NULL
                           AND @counternr <= @maxnr) BEGIN
SELECT @tgt_objectname = src.tgt_objectname ,

       @sql = replace(src.deployscript, '<!<DeployVersionNum>>', @deployversion)

  FROM #deployscripts src

 WHERE 1 = 1

   AND src.rownum = @counternr EXEC [rep].[helper_longprint] @string = @sql --Print	(@sql)
 --Exec	(@sql1)

   SET @msg = 'Create Deploy Scripts  ' + @tgt_objectname EXEC [aud].[proc_log_procedure] @logaction = 'Create' ,

       @lognote = @msg ,

       @logprocedure = @logprocname ,

       @logsql = @sql ,

       @logrowcount = 1

   SET @counternr = @counternr + 1 END

   SET @logsql = 'exec ' + @tgtschema + '.' + @logprocname EXEC [aud].[proc_log_procedure] @logaction = 'INFO' ,

       @lognote = 'Publish deploy scripts to screen done' ,

       @logprocedure = @logprocname ,

       @logsql = @logsql ,

       @logrowcount = @maxnr -- cleaning
IF object_id('tempdb..#DeployScripts') IS NOT NULL
DROP TABLE #deployscripts
