
CREATE PROCEDURE [rep].[069_bld_CreateDeployScripts_kv_20240301_1215]
AS
EXEC [aud].[proc_Log_Procedure] @LogAction = 'INFO'
	,@LogNote = 'Build DeployScripts'
	,@LogProcedure = 'rep.[300_bld_CreateDeployScripts]'
	,@LogSQL = 'Insert Into [bld].[DeployScripts]'
	,@LogRowCount = null;

SET ANSI_WARNINGS OFF;
SET NOCOUNT ON;

DECLARE @CheckErrorsCount int

SELECT @CheckErrorsCount = ISNULL(count(''), 0)
FROM bld.vw_BuildCheck bc

IF @CheckErrorsCount > 0
BEGIN
	PRINT '-- ' + CAST(@CheckErrorsCount AS varchar(5)) + ' errors found in repository definition, see Result set'

	SELECT *
	FROM bld.vw_BuildCheck bc
END

IF @CheckErrorsCount < 1
BEGIN
	PRINT '-- No errors found in repository definition'
	PRINT '--'
END

DECLARE @CurrentDate datetime2 = CAST(getutcdate() AS datetime2)
DECLARE @CurrentDateVarchar varchar(16) = CAST(@CurrentDate AS varchar(16))

IF OBJECT_ID('tempdb.dbo.#OrderedMarkers', 'U') IS NOT null
	DROP TABLE #OrderedMarkers;;

WITH GeneratorMarkersPost
AS (
	SELECT BK_Template = t.bk
		,Marker = '<!<TemplateName>>'
		,MarkerValue = CAST(t.TemplateName AS varchar(MAX))
	FROM bld.vw_Template t
	
	UNION ALL
	
	SELECT BK_Template = t.bk
		,Marker = '<!<TemplateDesc>>'
		,MarkerValue = CAST(isnull(t.TemplateDecription, 'No description available') AS varchar(MAX))
	FROM bld.vw_Template t
	
	UNION ALL
	
	SELECT BK_Template = t.bk
		,Marker = '<!<TemplateVersionNum>>'
		,MarkerValue = CAST(t.templateversion AS varchar(MAX))
	FROM bld.vw_Template t
	
	UNION ALL
	
	SELECT BK_Template = t.bk
		,Marker = '<!<CurrentUser>>'
		,MarkerValue = CAST(isnull(ORIGINAL_LOGIN(), 'metro automation') AS varchar(MAX))
	FROM bld.vw_Template t
	
	UNION ALL
	
	SELECT BK_Template = t.bk
		,Marker = '<!<GeneratedAt>>'
		,MarkerValue = CAST(@CurrentDateVarchar AS varchar(MAX))
	FROM bld.vw_Template t
	)
	,GeneratorMarkers
AS (
	SELECT DISTINCT src.bk
		,src.Code
		,src.BK_Dataset
		,gm.Marker
		,gm.MarkerValue
		,Script = CAST(t.Script AS varchar(MAX))
		,TGT_ObjectName = CAST(t.ObjectName AS varchar(MAX))
		,t.ObjectType
		,t.ObjectTypeDeployOrder
		,BK_Template = t.BK
		,t.TemplateType
		,t.ScriptLanguageCode
		,t.ScriptLanguage
		,mta_CreateDate = '1900-01-01'
		,MarkerType = 'System'
		,Pre = 0
		,Post = 1
	FROM bld.vw_DatasetTemplates src
	JOIN bld.vw_Template t ON t.BK = src.BK_Template
	JOIN GeneratorMarkersPost gm ON gm.BK_Template = t.bk
	)
	,AllMarkers
AS (
	SELECT src.BK
		,m.Code
		,m.BK_Dataset
		,Marker = CAST(m.Marker AS varchar(MAX))
		,MarkerValue = CAST(isnull(m.MarkerValue, '') AS varchar(MAX)) --, pre=cast(m.pre as int), post=cast(m.post as int)
		,Script = CAST(t.Script AS varchar(MAX))
		,TGT_ObjectName = CAST(t.ObjectName AS varchar(MAX))
		,t.ObjectType
		,t.ObjectTypeDeployOrder
		,BK_Template = t.BK
		,t.TemplateType
		,t.ScriptLanguageCode
		,t.ScriptLanguage
		,m.mta_CreateDate
		,m.MarkerType
		,m.Pre
		,m.Post
	FROM bld.vw_DatasetTemplates src
	LEFT JOIN bld.vw_Markers m ON M.BK_Dataset = src.BK_Dataset
	LEFT JOIN bld.vw_Template t ON t.BK = src.BK_Template
	WHERE 1 = 1
	
	UNION ALL
	
	SELECT src.bk
		,src.Code
		,src.BK_Dataset
		,src.Marker
		,src.MarkerValue
		,src.Script
		,src.TGT_ObjectName
		,src.ObjectType
		,src.ObjectTypeDeployOrder
		,src.BK_Template
		,src.TemplateType
		,src.ScriptLanguageCode
		,src.ScriptLanguage
		,src.mta_createdate
		,src.MarkerType
		,src.Pre
		,src.Post
	FROM GeneratorMarkers src
	)
SELECT HNR = DENSE_RANK() OVER (
		ORDER BY CAST(src.ObjectTypeDeployOrder AS int) ASC
			,src.bk ASC
		)
	,NR = ROW_NUMBER() OVER (
		PARTITION BY src.bk ORDER BY src.bk ASC
		)
	,src.BK
	,src.BK_Dataset
	,src.BK_Template
	,src.Code
	,src.Marker
	,src.MarkerValue
	,src.TemplateType
	,src.ScriptLanguageCode
	,src.ScriptLanguage
	,src.mta_CreateDate
	,src.Script
	,src.TGT_ObjectName
	,src.ObjectType
	,src.ObjectTypeDeployOrder
	,src.MarkerType
	,src.Pre
	,src.Post
	,RecType = CAST(sl.RecType AS int)
INTO #OrderedMarkers
FROM AllMarkers src
JOIN bld.vw_DeployScriptsSmartLoad sl ON sl.BK = src.BK_Dataset
	AND CAST(sl.RecType AS int) > - 1
WHERE 1 = 1

CREATE CLUSTERED INDEX IDX_C_ID_OrderedMarkers ON #OrderedMarkers (
	HNR
	,NR
	,BK
	,Code
	);

PRINT '--   Build DeployScripts: The Metro Magic ... Replace the markers in the templates ' + CONVERT(varchar(20), getdate(), 121)

-- Here comes even more fun... fill in the marker value into the Template markers
DECLARE @Script varchar(MAX)
	,@PreScript varchar(MAX)
	,@PostScript varchar(MAX)
	,@BK_Object varchar(MAX)
	,@Code varchar(MAX)
	,@BK_Dataset varchar(MAX)
	,@ObjectType varchar(MAX)
	,@ObjectTypeDeployOrder varchar(MAX)
	,@BK_Template varchar(MAX)
	,@Marker varchar(MAX)
	,@MarkerValue varchar(MAX)
	,@TGT_ObjectName varchar(MAX)
	,@RecType varchar(MAX)
	,@TemplateName varchar(MAX)
	,@TemplateType varchar(MAX)
	,@ScriptLanguageCode varchar(MAX)
	,@ScriptLanguage varchar(MAX)
--	@nl AS VARCHAR(max) = CHAR(13) + CHAR(10),	 -- To do: implement this in de Script replacement. The generated code wil be more readible.
--	@GO AS VARCHAR(max) = CHAR(13) + CHAR(10)+';'+CHAR(13) + CHAR(10)+'GO'+CHAR(13) + CHAR(10)+';'+CHAR(13) + CHAR(10) --- Makes it more Synapse Proof
-- Prepare the Loop (the total Selection list)
DECLARE @MainCounter int
	,@MaxId int

SELECT @MainCounter = min(HNR)
	,@MaxId = max(HNR)
FROM #OrderedMarkers

-- Start the Main Loop (By Object, By Template)
WHILE (
		@MainCounter IS NOT null
		AND @MainCounter <= @MaxId
		)
BEGIN
	-- Prepare the Loop in the Loop ( this one runs per DatasetId, per TemplateId and replaces all the markers )
	DECLARE @PreMarkerCounterObj int
	DECLARE @MarkerCounterObj int
	DECLARE @PostMarkerCounterObj int
	DECLARE @MaxObjId int

	SELECT @MarkerCounterObj = min(NR)
		,@MaxObjId = max(NR)
		,@BK_Dataset = om.BK_Dataset
		,@BK_Object = om.BK
		,@Code = om.Code
		,@TGT_ObjectName = om.TGT_ObjectName
		,@PreScript = om.Script
		,@BK_Template = om.BK_Template
		,@TemplateType = om.TemplateType
		,@ScriptLanguageCode = om.ScriptLanguageCode
		,@ScriptLanguage = om.ScriptLanguage
		,@ObjectType = om.ObjectType
		,@ObjectTypeDeployOrder = om.ObjectTypeDeployOrder
		,@RecType = om.RecType
	FROM #OrderedMarkers om
	WHERE om.HNR = @MainCounter
	GROUP BY om.BK
		,om.BK_Dataset
		,om.Code
		,om.TGT_ObjectName
		,om.Script
		,om.BK_Template
		,om.TemplateType
		,om.ScriptLanguageCode
		,om.ScriptLanguage
		,om.ObjectType
		,om.ObjectTypeDeployOrder
		,om.RecType

	SET @PreMarkerCounterObj = @MarkerCounterObj
	SET @PostMarkerCounterObj = @MarkerCounterObj

	-- Replace System Markers which are defined als [Pre]=1
	WHILE (
			@PreMarkerCounterObj IS NOT null
			AND @PreMarkerCounterObj <= @MaxObjId
			)
	BEGIN
		SELECT @PreScript = replace(CAST(@PreScript AS varchar(MAX)), CAST(om.marker AS varchar(MAX)), CAST(om.MarkerValue AS varchar(MAX)))
		FROM #OrderedMarkers om
		WHERE 1 = 1
			AND om.MarkerType = 'System'
			AND CAST(om.Pre AS int) = 1
			AND om.HNR = @MainCounter

		SET @PreMarkerCounterObj = @PreMarkerCounterObj + 1
	END

	SET @Script = @PreScript

	WHILE (
			@MarkerCounterObj IS NOT null
			AND @MarkerCounterObj <= @MaxObjId
			)
	BEGIN
		SELECT @Script = replace(CAST(@Script AS varchar(MAX)), CAST(om.marker AS varchar(MAX)), CAST(om.MarkerValue AS varchar(MAX)))
			,@TGT_ObjectName = replace(CAST(@TGT_ObjectName AS varchar(MAX)), CAST(om.marker AS varchar(MAX)), CAST(om.MarkerValue AS varchar(MAX)))
		FROM #OrderedMarkers om
		WHERE 1 = 1
			AND om.MarkerType != 'System'
			AND om.HNR = @MainCounter

		SET @MarkerCounterObj = @MarkerCounterObj + 1
	END

	SET @PostScript = @Script

	WHILE (
			@PostMarkerCounterObj IS NOT null
			AND @PostMarkerCounterObj <= @MaxObjId
			)
	BEGIN
		SELECT @PostScript = replace(CAST(@PostScript AS varchar(MAX)), CAST(om.marker AS varchar(MAX)), CAST(om.MarkerValue AS varchar(MAX)))
		FROM #OrderedMarkers om
		WHERE 1 = 1
			AND CAST(om.Post AS int) = 1
			AND om.HNR = @MainCounter

		SET @PostMarkerCounterObj = @PostMarkerCounterObj + 1
	END

	--Set @Script = @PreScript
	PRINT '--' + @TGT_ObjectName

	--exec [rep].[Helper_LongPrint] @String = @PostScript

	--insert into #bld_Done (TGT_ObjectName, Script,mta_CreateDate )
	--select @TGT_ObjectName as TGT_ObjectName, @PostScript as Script , @CurrentDate
	INSERT INTO [bld].[DeployScripts] (
		[BK]
		,[Code]
		,[BK_Template]
		,[BK_Dataset]
		,[TGT_ObjectName]
		,[ObjectType]
		,[ObjectTypeDeployOrder]
		,[TemplateType]
		,ScriptLanguageCode
		,ScriptLanguage
		,[TemplateSource]
		,[TemplateName]
		,[TemplateScript]
		,[mta_Createdate]
		,[mta_RecType]
		,[mta_BK]
		,[mta_BKH]
		,[mta_RH]
		,[mta_Source]
		)
	VALUES (
		@BK_Object -- BK
		,@Code -- Code
		,@BK_Template -- BK_Template
		,@BK_Dataset -- BK_Dataset
		,@TGT_ObjectName -- TGT_ObjectName
		,@ObjectType -- ObjectType
		,@ObjectTypeDeployOrder -- ObjectTypeDeployOrder
		,@TemplateType -- TemplateType
		,@ScriptLanguageCode
		,@ScriptLanguage
		,'' -- TemplateSource
		,'' -- TemplateName
		,@PostScript -- Script
		,@CurrentDate -- mta_Createdate
		,@RecType -- mta_RecType
		,@BK_Object + '|' + @BK_Template -- mta_BK
		,CONVERT(char(64), (Hashbytes('sha2_512', upper(@BK_Object + '|' + @BK_Template))), 2) -- mta_BKH
		,CONVERT(char(64), (Hashbytes('sha2_512', upper(@TGT_ObjectName + '|' + @ObjectType + '|' + @ObjectTypeDeployOrder + '|' + @PostScript))), 2) -- mta_RH
		,'rep.[300_bld_CreateDeployScripts]' -- mta_Source
		)

	SET @MainCounter = @MainCounter + 1
END

--select * from #bld_Done
-- delete DeployScripts if not active anymore:
INSERT INTO [bld].[DeployScripts] (
	[BK]
	,[Code]
	,[BK_Template]
	,[BK_Dataset]
	,[TGT_ObjectName]
	,[ObjectType]
	,[ObjectTypeDeployOrder]
	,[TemplateType]
	,[TemplateSource]
	,[TemplateName]
	,[TemplateScript]
	,[mta_Createdate]
	,[mta_RecType]
	,[mta_BK]
	,[mta_BKH]
	,[mta_RH]
	,[mta_Source]
	)
SELECT src.[BK]
	,src.[Code]
	,src.[BK_Template]
	,src.[BK_Dataset]
	,src.[TGT_ObjectName]
	,src.[ObjectType]
	,src.[ObjectTypeDeployOrder]
	,src.[TemplateType]
	,src.[TemplateSource]
	,src.[TemplateName]
	,src.[TemplateScript]
	,@CurrentDate
	,sl.RecType
	,src.[mta_BK]
	,src.[mta_BKH]
	,src.[mta_RH]
	,src.[mta_Source]
FROM bld.vw_DeployScriptsSmartLoad sl
JOIN bld.vw_DeployScripts src ON sl.bk = src.BK_Dataset
WHERE CAST(sl.RecType AS int) = - 1