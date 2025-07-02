CREATE PROCEDURE [rep].[100_Publish_DeployScriptsToScreen] @TGT_ObjectName varchar(8000) = ''
	,@LayerName varchar(8000) = ''
	,@SchemaName varchar(8000) = ''
	,@GroupName varchar(8000) = ''
	,@ShortName varchar(8000) = ''
	,@DeployDatasets bit = 0
	,@DeployMappings bit = 1
	,@ObjectType varchar(100) = ''
	,@IgnoreErrors int = 2 -- 0 just show the scripts, 1 stop on all builderrors, 2 stop on builderrors on selection
AS
/*
Developed by:			metro

-- =============================================
-- Stored Procedure: [rep].[100_Publish_DeployScriptsToScreen]
-- Author:           K. Vermeij / Metro
-- Description:      Display filtered deploy scripts, build errors, and procedure previews
-- Version:          Refactored for logical output order (scripts → errors → procedures)
-- =============================================

Parameters:
    @TGT_ObjectName    VARCHAR(255) = ''		-- Target object name to filter the deployment scripts.
    @LayerName         VARCHAR(255) = ''		-- Layer name to filter the deployment scripts.
    @SchemaName        VARCHAR(255) = ''		-- Schema name to filter the deployment scripts.
    @GroupName         VARCHAR(255) = ''		-- Group name to filter the deployment scripts.
    @ShortName         VARCHAR(255) = ''		-- Short name to filter the deployment scripts.
    @DeployDatasets    BIT			= 1			-- Flag to indicate whether to deploy datasets.
    @DeployMappings    BIT			= 1			-- Flag to indicate whether to deploy mappings.
    @ObjectType        VARCHAR(255) = 'table'	-- Object type to filter the deployment scripts. Possible values: 'table', 'view', 'procedure'. When left blank, all object types will be generated.
    @IgnoreErrors      INT			= 0         -- Flag to indicate whether to ignore errors.

Example Usage:
    exec [rep].[100_Publish_DeployScriptsToScreen]
          @TGT_ObjectName   = ''
        , @LayerName        = ''
        , @SchemaName       = ''
        , @GroupName        = 'common'
        , @ShortName        = 'customer_current'
        , @DeployDatasets   = 1
        , @DeployMappings   = 1
        , @ObjectType       = ''
        , @IgnoreErrors     = 0

exec  [rep].[100_Publish_DeployScriptsToScreen]   
			  @TGT_ObjectName	= '' , @LayerName		= ''
			, @SchemaName		= ''		, @GroupName		= ''		, @ShortName		= 'Customer_Current'
			, @DeployDatasets	= 1			, @DeployMappings	= 1			, @ObjectType		= ''							, @IgnoreErrors		= 2

exec  [rep].[100_Publish_DeployScriptsToScreen]   
			  @TGT_ObjectName	= '' , @LayerName		= ''
			, @SchemaName		= 'cds'		, @GroupName		= 'fixed'		, @ShortName		= ''
			, @DeployDatasets	= 1			, @DeployMappings	= 1			, @ObjectType		= ''							, @IgnoreErrors		= 2


Procedure Logic:
    1. Selects deployment scripts from the base table based on the provided filtering criteria.
    2. Orders the selected scripts by group name, short name, and deploy order.
    3. Inserts the ordered scripts into a temporary table (#DeployScripts).
    4. Retrieves the minimum and maximum row numbers from the temporary table.
    5. Iterates through the rows in the temporary table and processes each script.

AST:
Procedure: [rep].[100_Publish_DeployScriptsToScreen]
  Parameters:
    - @TGT_ObjectName: VARCHAR(255) = ''
    - @LayerName: VARCHAR(255) = ''
    - @SchemaName: VARCHAR(255) = ''
    - @GroupName: VARCHAR(255) = ''
    - @ShortName: VARCHAR(255) = ''
    - @DeployDatasets: BIT = 1
    - @DeployMappings: BIT = 1
    - @ObjectType: VARCHAR(255) = 'table'
    - @IgnoreErrors: BIT = 0
  Variables:
    - @LogProcName: VARCHAR(255)
    - @LogSQL: VARCHAR(MAX)
    - @CounterNr: INT
    - @MaxNr: INT
  Logic:
    - Initialize variables
    - Select deployment scripts based on filtering criteria
    - Order selected scripts by group name, short name, and deploy order
    - Insert ordered scripts into temporary table #DeployScripts
    - Retrieve minimum and maximum row numbers from temporary table
    - Iterate through rows in temporary table and process each script

Change log:
Date                    Author              Description
20220916 20:15          K. Vermeij          Initial version
20230406 10:45          K. Vermeij          Added filter ToDeploy = 1
20230609 08:58          K. Vermeij          Builderrors are shown before the scripts are shown. With the new parameter @IgnoreErrors
                                            you can choose:
                                            0 - stop generating scripts if there are errors in your selection for generating
                                            1 - stop generating scripts if there are errors in the total build
                                            2 - show the errors... but still generate the scripts
20250609 2015			K. Vermeij			Added run scripts for deployed stored procedures at the end of the output.
*/
BEGIN
    SET ANSI_WARNINGS OFF;
    SET NOCOUNT ON;

    DECLARE @LogProcName VARCHAR(255) = '100_Publish_DeployScriptsToScreen';
    DECLARE @DeployVersion VARCHAR(MAX) = '<!<DeployVersionNum>>';
    DECLARE @CounterNr INT, @MaxNr INT;
    DECLARE @sql VARCHAR(MAX), @Msg VARCHAR(8000);
    DECLARE @TGT_ObjectName_Internal VARCHAR(8000);

    IF OBJECT_ID('tempdb..#bld_errors') IS NOT NULL DROP TABLE #bld_errors;
    SELECT bc.*, ROW_NUMBER() OVER (PARTITION BY bc.buildcheckid ORDER BY bc.buildcheckid ASC) AS RowNum
    INTO #bld_errors
    FROM [bld].[vw_BuildCheck] bc
    INNER JOIN bld.vw_Dataset d ON d.BK = bc.code
    WHERE @IgnoreErrors IN (0, 1, 2)
      AND (
            @IgnoreErrors = 2 OR @IgnoreErrors = 1 OR (
                @IgnoreErrors = 0 AND
                (@TGT_ObjectName = '' OR @TGT_ObjectName = d.DatasetName) AND
                (@LayerName = '' OR @LayerName = d.LayerName) AND
                (@SchemaName = '' OR @SchemaName = d.SchemaName) AND
                (@GroupName = '' OR @GroupName = d.BK_Group) AND
                (@ShortName = '' OR @ShortName = d.ShortName)
            )
        );

    IF OBJECT_ID('tempdb..#DeployScripts') IS NOT NULL DROP TABLE #DeployScripts;
    WITH base AS (
        SELECT
            DENSE_RANK() OVER (PARTITION BY d.Code ORDER BY d.ShortName, d.BK_Group, CAST(src.ObjectTypeDeployOrder AS INT) + CAST(d.FlowOrder AS INT)) AS DeployOrder,
            src.TemplateScript AS DeployScript,
            src.TGT_ObjectName, src.ObjectType, src.TemplateType, src.TemplateName,
            d.BK AS BK_Dataset, d.SchemaName, d.LayerName, d.BK_Group AS GroupName, d.ShortName, d.Code,
            src.ScriptLanguageCode, src.ScriptLanguage
        FROM bld.vw_DeployScripts src
        INNER JOIN bld.vw_Dataset d ON d.BK = src.BK_Dataset
        INNER JOIN bld.vw_Schema s ON s.BK = d.BK_Schema
        WHERE ISNULL(d.ToDeploy, 1) = 1
          AND ((@DeployDatasets = 1 AND src.TemplateType = 'Dataset') OR src.TemplateType = 'Mapping')
          AND ((@DeployMappings = 1 AND src.TemplateType = 'Mapping') OR src.TemplateType = 'Dataset')
          AND (@ObjectType = '' OR @ObjectType = src.ObjectType)
    )
    SELECT *, ROW_NUMBER() OVER (ORDER BY GroupName, ShortName, DeployOrder) AS RowNum
    INTO #DeployScripts
    FROM base
    WHERE (@TGT_ObjectName = '' OR @TGT_ObjectName = TGT_ObjectName)
      AND (@LayerName = '' OR @LayerName = LayerName)
      AND (@SchemaName = '' OR @SchemaName = SchemaName)
      AND (@GroupName = '' OR @GroupName = GroupName)
      AND (@ShortName = '' OR @ShortName = ShortName);

    -- === MAIN DEPLOY SCRIPT OUTPUT ===
    PRINT '/**********************************************************'
    PRINT ' * 🚀 Deployment Script Output'
    PRINT ' **********************************************************/'

    SELECT @CounterNr = MIN(RowNum), @MaxNr = MAX(RowNum) FROM #DeployScripts;

    IF @CounterNr IS NULL
    BEGIN
        PRINT '-- No deployment scripts found for selection --';
    END
    ELSE
    BEGIN
        WHILE (@CounterNr IS NOT NULL AND @CounterNr <= @MaxNr)
        BEGIN
            SELECT @TGT_ObjectName_Internal = TGT_ObjectName,
                   @sql = REPLACE(DeployScript, '<!<DeployVersionNum>>', @DeployVersion)
            FROM #DeployScripts WHERE RowNum = @CounterNr;

            EXEC [rep].[Helper_LongPrint] @string = @sql;

            SET @Msg = 'Create Deploy Scripts  ' + @TGT_ObjectName_Internal;
            EXEC [aud].[proc_Log_Procedure] @LogAction = 'Create', @LogNote = @Msg,
                @LogProcedure = @LogProcName, @LogSQL = @sql, @LogRowCount = 1;

            SET @CounterNr = @CounterNr + 1;
        END
    END
	PRINT 'PRINT ''OK'''
    -- === SHOW BUILD ERRORS AFTER SCRIPTS ===
    PRINT '/**********************************************************'
    PRINT ' * ⚠️ Build Errors'
    PRINT ' **********************************************************/'

    SELECT @CounterNr = MIN(RowNum), @MaxNr = MAX(RowNum) FROM #bld_errors;

    IF @CounterNr IS NULL
    BEGIN
        PRINT '-- No build errors found --';
    END
    ELSE
    BEGIN
        WHILE (@CounterNr IS NOT NULL AND @CounterNr <= @MaxNr)
        BEGIN
            DECLARE @bld_msg VARCHAR(MAX);
            SELECT @bld_msg = '-- Dataset: ' + BK + ' Message: ' + CheckMessage + CHAR(10)
            FROM #bld_errors WHERE RowNum = @CounterNr;

            PRINT @bld_msg;

            SET @CounterNr = @CounterNr + 1;
        END

        IF @IgnoreErrors < 2 RETURN;
    END

    -- === STORED PROCEDURE EXAMPLES ===
    PRINT '/**********************************************************'
    PRINT ' * 🛠️ Generated Stored Procedures'
    PRINT ' **********************************************************/'

    IF OBJECT_ID('tempdb..#ProcedureScripts') IS NOT NULL DROP TABLE #ProcedureScripts;
    SELECT 
        TGT_ObjectName,
        REPLACE(DeployScript, '<!<DeployVersionNum>>', @DeployVersion) AS DeployScript,
        QUOTENAME(SchemaName) + '.[' + GroupName + '_' + ShortName + ']' AS TGT_TableName,
        ROW_NUMBER() OVER (ORDER BY TGT_ObjectName) AS RowNum
    INTO #ProcedureScripts
    FROM #DeployScripts
    WHERE ObjectType = 'Procedure';

    DECLARE @RowNum INT = 1, @MaxRowNum INT, @proc_name VARCHAR(8000), @proc_sql VARCHAR(MAX);
    DECLARE @exec_proc VARCHAR(8000), @select_topx VARCHAR(8000);
    SELECT @MaxRowNum = MAX(RowNum) FROM #ProcedureScripts;

    IF @MaxRowNum IS NULL
    BEGIN
        PRINT '-- No stored procedures found --';
    END
    ELSE
    BEGIN
        PRINT '/*';
        WHILE @RowNum <= @MaxRowNum
        BEGIN
            SELECT @proc_name = TGT_ObjectName,
                   @proc_sql = DeployScript,
                   @exec_proc = 'exec ' + TGT_ObjectName + ' @PipelineRunID = ''-1'', @PipelineTriggerID = ''-1'', @SchedulePipelineRunID = ''-1'';',
                   @select_topx = 'SELECT TOP 5 * FROM ' + TGT_TableName + ';'
            FROM #ProcedureScripts WHERE RowNum = @RowNum;

            PRINT '-- ' + @proc_name;
            EXEC [rep].[Helper_LongPrint] @string = @exec_proc;
            EXEC [rep].[Helper_LongPrint] @string = @select_topx;

            SET @RowNum = @RowNum + 1;
        END
        PRINT '*/';
    END

    -- Cleanup
    IF OBJECT_ID('tempdb..#DeployScripts') IS NOT NULL DROP TABLE #DeployScripts;
    IF OBJECT_ID('tempdb..#ProcedureScripts') IS NOT NULL DROP TABLE #ProcedureScripts;
    IF OBJECT_ID('tempdb..#bld_errors') IS NOT NULL DROP TABLE #bld_errors;
END