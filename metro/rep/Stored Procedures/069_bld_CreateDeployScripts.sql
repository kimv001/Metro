
CREATE PROCEDURE [rep].[069_bld_createdeployscripts] AS EXEC [aud].[proc_log_procedure] @logaction = 'INFO' ,

       @lognote = 'Build DeployScripts' ,

       @logprocedure = 'rep.[300_bld_CreateDeployScripts]' ,

       @logsql = 'Insert Into [bld].[DeployScripts]' ,

       @logrowcount = NULL;

   SET ansi_warnings OFF;

   SET nocount
    ON;DECLARE @checkerrorscount int
SELECT @checkerrorscount = isnull(count(''), 0)

  FROM bld.vw_buildcheck bc IF @checkerrorscount > 0 BEGIN PRINT '-- ' + cast(@checkerrorscount AS varchar(5)) + ' errors found in repository definition, see Result set'
SELECT *

  FROM bld.vw_buildcheck bc END

IF @checkerrorscount < 1 BEGIN PRINT '-- No errors found in repository definition' PRINT '--' END DECLARE @currentdate datetime2 = cast(getutcdate() AS datetime2) DECLARE @currentdatevarchar varchar(16) = cast(@currentdate AS varchar(16)) IF object_id('tempdb.dbo.#OrderedMarkers', 'U') IS NOT NULL
DROP TABLE #orderedmarkers;;WITH generatormarkerspost AS

        (SELECT bk_template = t.bk ,

               marker = '<!<TemplateName>>' ,

               markervalue = cast(t.templatename AS varchar(MAX))

          FROM bld.vw_template t

     UNION ALL SELECT bk_template = t.bk ,

               marker = '<!<TemplateDesc>>' ,

               markervalue = cast(isnull(t.templatedecription, 'No description available') AS varchar(MAX))

          FROM bld.vw_template t

     UNION ALL SELECT bk_template = t.bk ,

               marker = '<!<TemplateVersionNum>>' ,

               markervalue = cast(t.templateversion AS varchar(MAX))

          FROM bld.vw_template t

     UNION ALL SELECT bk_template = t.bk ,

               marker = '<!<CurrentUser>>' ,

               markervalue = cast(isnull(original_login(), 'metro automation') AS varchar(MAX))

          FROM bld.vw_template t

     UNION ALL SELECT bk_template = t.bk ,

               marker = '<!<GeneratedAt>>' ,

               markervalue = cast(@currentdatevarchar AS varchar(MAX))

          FROM bld.vw_template t
       ) ,

       generatormarkers AS

        (SELECT DISTINCT src.bk ,

               src.code ,

               src.bk_dataset ,

               gm.marker ,

               gm.markervalue ,

               script = cast(t.script AS varchar(MAX)) ,

               tgt_objectname = cast(t.objectname AS varchar(MAX)) ,

               t.objecttype ,

               t.objecttypedeployorder ,

               bk_template = t.bk ,

               t.templatetype ,

               t.scriptlanguagecode ,

               t.scriptlanguage ,

               mta_createdate = '1900-01-01' ,

               markertype = 'System' ,

               pre = 0 ,

               post = 1

          FROM bld.vw_datasettemplates src

          JOIN bld.vw_template t
            ON t.bk = src.bk_template

          JOIN generatormarkerspost gm
            ON gm.bk_template = t.bk
       ) ,

       allmarkers AS

        (SELECT src.bk ,

               m.code ,

               m.bk_dataset ,

               marker = cast(m.marker AS varchar(MAX)) ,

               markervalue = cast(isnull(m.markervalue, '') AS varchar(MAX)) --, pre=cast(m.pre as int), post=cast(m.post as int)
 ,

               script = cast(t.script AS varchar(MAX)) ,

               tgt_objectname = cast(t.objectname AS varchar(MAX)) ,

               t.objecttype ,

               t.objecttypedeployorder ,

               bk_template = t.bk ,

               t.templatetype ,

               t.scriptlanguagecode ,

               t.scriptlanguage ,

               m.mta_createdate ,

               m.markertype ,

               m.pre ,

               m.post

          FROM bld.vw_datasettemplates src

          LEFT JOIN bld.vw_markers m
            ON m.bk_dataset = src.bk_dataset

          LEFT JOIN bld.vw_template t
            ON t.bk = src.bk_template

         WHERE 1 = 1

     UNION ALL SELECT src.bk ,

               src.code ,

               src.bk_dataset ,

               src.marker ,

               src.markervalue ,

               src.script ,

               src.tgt_objectname ,

               src.objecttype ,

               src.objecttypedeployorder ,

               src.bk_template ,

               src.templatetype ,

               src.scriptlanguagecode ,

               src.scriptlanguage ,

               src.mta_createdate ,

               src.markertype ,

               src.pre ,

               src.post

          FROM generatormarkers src
       )
SELECT hnr = dense_rank() OVER (
                                ORDER BY cast(src.objecttypedeployorder AS int) ASC ,src.bk ASC) ,

       nr = row_number() OVER (PARTITION BY src.bk
                               ORDER BY src.bk ASC) ,

       src.bk ,

       src.bk_dataset ,

       src.bk_template ,

       src.code ,

       src.marker ,

       src.markervalue ,

       src.templatetype ,

       src.scriptlanguagecode ,

       src.scriptlanguage ,

       src.mta_createdate ,

       src.script ,

       src.tgt_objectname ,

       src.objecttype ,

       src.objecttypedeployorder ,

       src.markertype ,

       src.pre ,

       src.post ,

       rectype = cast(sl.rectype AS int) INTO #orderedmarkers

  FROM allmarkers src

  JOIN bld.vw_deployscriptssmartload sl
    ON sl.bk = src.bk_dataset

   AND cast(sl.rectype AS int) > - 1

 WHERE 1 = 1
  CREATE clustered INDEX idx_c_id_orderedmarkers
    ON #orderedmarkers (hnr , nr , bk , code);PRINT '--   Build DeployScripts: The Metro Magic ... Replace the markers in the templates ' + convert(varchar(20), getdate(), 121) -- Here comes even more fun... fill in the marker value into the Template markers
DECLARE @script varchar(MAX) ,

       @prescript varchar(MAX) ,

       @postscript varchar(MAX) ,

       @bk_object varchar(MAX) ,

       @code varchar(MAX) ,

       @bk_dataset varchar(MAX) ,

       @objecttype varchar(MAX) ,

       @objecttypedeployorder varchar(MAX) ,

       @bk_template varchar(MAX) ,

       @marker varchar(MAX) ,

       @markervalue varchar(MAX) ,

       @tgt_objectname varchar(MAX) ,

       @rectype varchar(MAX) ,

       @templatename varchar(MAX) ,

       @templatetype varchar(MAX) ,

       @scriptlanguagecode varchar(MAX) ,

       @scriptlanguage varchar(MAX) --	@nl AS VARCHAR(max) = CHAR(13) + CHAR(10),	 -- To do: implement this in de Script replacement. The generated code wil be more readible.
--	@GO AS VARCHAR(max) = CHAR(13) + CHAR(10)+';'+CHAR(13) + CHAR(10)+'GO'+CHAR(13) + CHAR(10)+';'+CHAR(13) + CHAR(10) --- Makes it more Synapse Proof
-- Prepare the Loop (the total Selection list)
DECLARE @maincounter int ,@maxid int
SELECT @maincounter = min(hnr) ,

       @maxid = max(hnr)

  FROM #orderedmarkers -- Start the Main Loop (By Object, By Template)
WHILE (@maincounter IS NOT NULL
       AND @maincounter <= @maxid) BEGIN -- Prepare the Loop in the Loop ( this one runs per DatasetId, per TemplateId and replaces all the markers )
 DECLARE @premarkercounterobj int DECLARE @markercounterobj int DECLARE @postmarkercounterobj int DECLARE @maxobjid int
SELECT @markercounterobj = min(nr) ,

       @maxobjid = max(nr) ,

       @bk_dataset = om.bk_dataset ,

       @bk_object = om.bk ,

       @code = om.code ,

       @tgt_objectname = om.tgt_objectname ,

       @prescript = om.script ,

       @bk_template = om.bk_template ,

       @templatetype = om.templatetype ,

       @scriptlanguagecode = om.scriptlanguagecode ,

       @scriptlanguage = om.scriptlanguage ,

       @objecttype = om.objecttype ,

       @objecttypedeployorder = om.objecttypedeployorder ,

       @rectype = om.rectype

  FROM #orderedmarkers om

 WHERE om.hnr = @maincounter

 GROUP BY om.bk ,

          om.bk_dataset ,

          om.code ,

          om.tgt_objectname ,

          om.script ,

          om.bk_template ,

          om.templatetype ,

          om.scriptlanguagecode ,

          om.scriptlanguage ,

          om.objecttype ,

          om.objecttypedeployorder ,

          om.rectype

   SET @premarkercounterobj = @markercounterobj

   SET @postmarkercounterobj = @markercounterobj -- Replace System Markers which are defined als [Pre]=1
 WHILE (@premarkercounterobj IS NOT NULL
        AND @premarkercounterobj <= @maxobjid) BEGIN
SELECT @prescript = replace(cast(@prescript AS varchar(MAX)), cast(om.marker AS varchar(MAX)), cast(om.markervalue AS varchar(MAX)))

  FROM #orderedmarkers om

 WHERE 1 = 1

   AND om.markertype = 'System'

   AND cast(om.pre AS int) = 1

   AND om.hnr = @maincounter

   SET @premarkercounterobj = @premarkercounterobj + 1 END

   SET @script = @prescript WHILE (@markercounterobj IS NOT NULL
                                AND @markercounterobj <= @maxobjid) BEGIN
SELECT @script = replace(cast(@script AS varchar(MAX)), cast(om.marker AS varchar(MAX)), cast(om.markervalue AS varchar(MAX))) ,

       @tgt_objectname = replace(cast(@tgt_objectname AS varchar(MAX)), cast(om.marker AS varchar(MAX)), cast(om.markervalue AS varchar(MAX)))

  FROM #orderedmarkers om

 WHERE 1 = 1

   AND om.markertype != 'System'

   AND om.hnr = @maincounter

   SET @markercounterobj = @markercounterobj + 1 END

   SET @postscript = @script WHILE (@postmarkercounterobj IS NOT NULL
                                 AND @postmarkercounterobj <= @maxobjid) BEGIN
SELECT @postscript = replace(cast(@postscript AS varchar(MAX)), cast(om.marker AS varchar(MAX)), cast(om.markervalue AS varchar(MAX)))

  FROM #orderedmarkers om

 WHERE 1 = 1

   AND cast(om.post AS int) = 1

   AND om.hnr = @maincounter

   SET @postmarkercounterobj = @postmarkercounterobj + 1 END --Set @Script = @PreScript
 PRINT '--' + @tgt_objectname --exec [rep].[Helper_LongPrint] @String = @PostScript
  --insert into #bld_Done (TGT_ObjectName, Script,mta_CreateDate )
 --select @TGT_ObjectName as TGT_ObjectName, @PostScript as Script , @CurrentDate

INSERT INTO [bld].[deployscripts] ([bk] , [code] , [bk_template] , [bk_dataset] , [tgt_objectname] , [objecttype] , [objecttypedeployorder] , [templatetype] , scriptlanguagecode , scriptlanguage , [templatesource] , [templatename] , [templatescript] , [mta_createdate] , [mta_rectype] , [mta_bk] , [mta_bkh] , [mta_rh] , [mta_source])

VALUES (@bk_object -- BK
 ,
        @code -- Code
 ,
        @bk_template -- BK_Template
 ,
        @bk_dataset -- BK_Dataset
 ,
        @tgt_objectname -- TGT_ObjectName
 ,
        @objecttype -- ObjectType
 ,
        @objecttypedeployorder -- ObjectTypeDeployOrder
 ,
        @templatetype -- TemplateType
 ,
        @scriptlanguagecode ,
        @scriptlanguage ,
        '' -- TemplateSource
 ,'' -- TemplateName
 ,@postscript -- Script
 ,
  @currentdate -- mta_Createdate
 ,
  @rectype -- mta_RecType
 ,
  @bk_object + '|' + @bk_template -- mta_BK
 ,
  convert(char(64), (hashbytes('sha2_512', upper(@bk_object + '|' + @bk_template))), 2) -- mta_BKH
 ,
  convert(char(64), (hashbytes('sha2_512', upper(@tgt_objectname + '|' + @objecttype + '|' + @objecttypedeployorder + '|' + @postscript))), 2) -- mta_RH
 ,
  'rep.[300_bld_CreateDeployScripts]' -- mta_Source
)

   SET @maincounter = @maincounter + 1 END --select * from #bld_Done
-- delete DeployScripts if not active anymore:

INSERT INTO [bld].[deployscripts] ([bk] , [code] , [bk_template] , [bk_dataset] , [tgt_objectname] , [objecttype] , [objecttypedeployorder] , [templatetype] , [templatesource] , [templatename] , [templatescript] , [mta_createdate] , [mta_rectype] , [mta_bk] , [mta_bkh] , [mta_rh] , [mta_source])
SELECT src.[bk] ,

       src.[code] ,

       src.[bk_template] ,

       src.[bk_dataset] ,

       src.[tgt_objectname] ,

       src.[objecttype] ,

       src.[objecttypedeployorder] ,

       src.[templatetype] ,

       src.[templatesource] ,

       src.[templatename] ,

       src.[templatescript] ,

       @currentdate ,

       sl.rectype ,

       src.[mta_bk] ,

       src.[mta_bkh] ,

       src.[mta_rh] ,

       src.[mta_source]

  FROM bld.vw_deployscriptssmartload sl

  JOIN bld.vw_deployscripts src
    ON sl.bk = src.bk_dataset

 WHERE cast(sl.rectype AS int) = - 1