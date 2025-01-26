CREATE PROCEDURE [rep].[100_Publish_DeployScriptsToScreen] @TGT_ObjectName varchar(8000) = ''
	,@LayerName varchar(8000) = ''
	,@SchemaName varchar(8000) = ''
	,@GroupName varchar(8000) = ''
	,@ShortName varchar(8000) = ''
	,@DeployDatasets bit = 0
	,@DeployMappings bit = 1
	,@ObjectType varchar(100) = ''
	,@IgnoreErrors int = 0 -- 2 just show the scripts, 1 stop on all builderrors, 0 stop on builderrors on selection
AS
/*
Developed by:			metro
Description:
    This stored procedure generates and displays deployment scripts for specified objects based on various filtering criteria.

Parameters:
    @TGT_ObjectName    VARCHAR(255) = ''  -- Target object name to filter the deployment scripts.
    @LayerName         VARCHAR(255) = ''  -- Layer name to filter the deployment scripts.
    @SchemaName        VARCHAR(255) = ''  -- Schema name to filter the deployment scripts.
    @GroupName         VARCHAR(255) = ''  -- Group name to filter the deployment scripts.
    @ShortName         VARCHAR(255) = ''  -- Short name to filter the deployment scripts.
    @DeployDatasets    BIT = 1            -- Flag to indicate whether to deploy datasets.
    @DeployMappings    BIT = 1            -- Flag to indicate whether to deploy mappings.
    @ObjectType        VARCHAR(255) = 'table' -- Object type to filter the deployment scripts. Possible values: 'table', 'view', 'procedure'. When left blank, all object types will be generated.
    @IgnoreErrors      BIT = 0            -- Flag to indicate whether to ignore errors.

Example Usage:
    exec [rep].[100_Publish_DeployScriptsToScreen]
          @TGT_ObjectName    = ''
        , @LayerName        = ''
        , @SchemaName       = 'stg'
        , @GroupName        = 'adventureworks'
        , @ShortName        = ''
        , @DeployDatasets   = 1
        , @DeployMappings   = 1
        , @ObjectType       = 'table'
        , @IgnoreErrors     = 0

Procedure Logic:
    1. Selects deployment scripts from the base table based on the provided filtering criteria.
    2. Orders the selected scripts by group name, short name, and deploy order.
    3. Inserts the ordered scripts into a temporary table (#DeployScripts).
    4. Retrieves the minimum and maximum row numbers from the temporary table.
    5. Iterates through the rows in the temporary table and processes each script.

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
SET ANSI_WARNINGS OFF;
SET NOCOUNT ON;

DECLARE @LogProcName varchar(255) = '100_Publish_DeployScriptsToScreen'
DECLARE @LogSQL varchar(MAX) = ''
DECLARE @SrcSchema varchar(255) = 'rep'
DECLARE @SrcDataset varchar(255) = ''
DECLARE @TgtSchema varchar(255) = 'rep'
DECLARE @TgtDataset varchar(255) = ''
DECLARE @Msg varchar(8000)
-- Convert(varchar(20),Format(cast(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as datetime), 'yyyyMMddHHmmss'),121)
DECLARE @DeployVersion varchar(MAX) = '<!<DeployVersionNum>>'
	-- variables for the loops
DECLARE @CounterNr int
DECLARE @MaxNr int
DECLARE @StopCounterNr int
DECLARE @sql varchar(MAX)
DECLARE @bld_msg varchar(MAX)

IF object_id('tempdb..#bld_errors') IS NOT null
	DROP TABLE #bld_errors

SELECT bc.*
	,rownum = ROW_NUMBER() OVER (
		PARTITION BY bc.buildcheckid ORDER BY bc.buildcheckid ASC
		)
INTO #bld_errors
FROM [bld].[vw_BuildCheck] bc
INNER JOIN bld.vw_Dataset d ON d.BK = bc.BK
WHERE 1 = 1
	AND (
		@IgnoreErrors = 2
		OR @IgnoreErrors = 1
		OR (
			@IgnoreErrors = 0
			AND (
				@TGT_ObjectName = ''
				OR @TGT_ObjectName = d.[DatasetName]
				)
			AND (
				@LayerName = ''
				OR @LayerName = d.LayerName
				)
			AND (
				@SchemaName = ''
				OR @SchemaName = d.SchemaName
				)
			AND (
				@GroupName = ''
				OR @GroupName = d.BK_Group
				)
			AND (
				@ShortName = ''
				OR @ShortName = d.ShortName
				)
			)
		)

SELECT @counternr = min(rownum)
	,@MaxNr = max(rownum)
--, @StopCounterNr= min(rownum)
FROM #bld_errors bc

IF @CounterNr > 0
	PRINT '/*' + char(10) + 'Build errors found:' + char(10)

WHILE (
		@counternr IS NOT null
		AND @counternr <= @MaxNr
		)
BEGIN
	SELECT @bld_msg = 'Dataset: ' + src.BK + ' Message:' + src.CheckMessage + char(10)
	FROM #bld_errors src
	WHERE 1 = 1
		AND src.RowNum = @counternr

	PRINT (@bld_msg)

	IF @CounterNr = @MaxNr
		PRINT char(10) + '*/' + char(10)

	SET @counternr = @counternr + 1
END

IF @IgnoreErrors < 2
	AND @counternr IS NOT null
BEGIN
	-- NEED TO STOP STORED PROCEDURE EXECUTION
	RETURN
END

IF OBJECT_ID('tempdb..#DeployScripts') IS NOT null
	DROP TABLE #DeployScripts;

WITH base
AS (
	SELECT
		DeployOrder = DENSE_RANK() OVER (
			PARTITION BY d.Code ORDER BY d.ShortName
				,d.BK_Group
				,CAST(src.ObjectTypeDeployOrder AS int) + CAST(d.FlowOrder AS int) ASC
			) 
		,DeployScript = src.TemplateScript
		,TGT_ObjectName = src.TGT_ObjectName
		,ObjectType = src.ObjectType
		,TemplateType = src.TemplateType
		,TemplateName = src.TemplateName
		,BK_Dataset = d.bk
		,SchemaName = d.SchemaName
		,LayerName = d.LayerName
		,GroupName = d.BK_Group
		,ShortName = d.ShortName
		,Code = d.Code
		,src.ScriptLanguageCode
		,src.ScriptLanguage
	FROM bld.vw_DeployScripts src
	INNER JOIN bld.vw_Dataset d ON d.BK = src.BK_Dataset
	INNER JOIN bld.vw_Schema s ON s.bk = d.BK_Schema
	WHERE 1 = 1
		AND isnull(d.ToDeploy, 1) = 1
		AND (
			(
				@DeployDatasets = 1
				AND src.TemplateType = 'Dataset'
				)
			OR src.TemplateType = 'Mapping'
			)
		AND (
			(
				@DeployMappings = 1
				AND src.TemplateType = 'Mapping'
				)
			OR src.TemplateType = 'Dataset'
			)
		AND (
			@ObjectType = src.ObjectType
			OR @ObjectType = ''
			)
	)
SELECT *
	,RowNum = ROW_NUMBER() OVER (
		ORDER BY groupname
			,shortname
			,DeployOrder
		)
INTO #DeployScripts
FROM base
WHERE 1 = 1
	AND (
		@TGT_ObjectName = ''
		OR @TGT_ObjectName = TGT_ObjectName
		)
	AND (
		@LayerName = ''
		OR @LayerName = LayerName
		)
	AND (
		@SchemaName = ''
		OR @SchemaName = SchemaName
		)
	AND (
		@GroupName = ''
		OR @GroupName = GroupName
		)
	AND (
		@ShortName = ''
		OR @ShortName = ShortName
		)
ORDER BY groupname
	,shortname
	,DeployOrder

SELECT @CounterNr = min(RowNum)
	,@MaxNr = max(RowNum)
FROM #DeployScripts

WHILE (
		@CounterNr IS NOT null
		AND @CounterNr <= @MaxNr
		)
BEGIN
	SELECT @TGT_ObjectName = src.TGT_ObjectName
		,@sql = replace(src.DeployScript, '<!<DeployVersionNum>>', @DeployVersion)
	FROM #DeployScripts src
	WHERE 1 = 1
		AND src.RowNum = @CounterNr

	EXEC [rep].[Helper_LongPrint] @string = @sql

	--Print	(@sql)
	--Exec	(@sql1)
	SET @Msg = 'Create Deploy Scripts  ' + @TGT_ObjectName

	EXEC [aud].[proc_Log_Procedure] @LogAction = 'Create'
		,@LogNote = @Msg
		,@LogProcedure = @LogProcName
		,@LogSQL = @sql
		,@LogRowCount = 1

	SET @CounterNr = @CounterNr + 1
END

SET @LogSQL = 'exec ' + @TgtSchema + '.' + @LogProcName

EXEC [aud].[proc_Log_Procedure] @LogAction = 'INFO'
	,@LogNote = 'Publish deploy scripts to screen done'
	,@LogProcedure = @LogProcName
	,@LogSQL = @LogSQL
	,@LogRowCount = @MaxNr

-- cleaning
IF OBJECT_ID('tempdb..#DeployScripts') IS NOT null
	DROP TABLE #DeployScripts