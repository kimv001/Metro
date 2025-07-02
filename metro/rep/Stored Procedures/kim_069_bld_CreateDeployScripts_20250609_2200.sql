

CREATE PROCEDURE [rep].[kim_069_bld_CreateDeployScripts_20250609_2200] AS
/*
Description:
    This stored procedure creates deployment scripts by checking for errors in the repository definition and generating the necessary scripts if no errors are found.

Parameters:
    None

Example Usage:
    exec [rep].[069_bld_CreateDeployScripts]

Procedure Logic:
    1. Logs the start of the procedure.
    2. Disables ANSI warnings and sets NOCOUNT ON.
    3. Checks for errors in the repository definition using the view [bld].[vw_BuildCheck].
    4. If errors are found, prints the number of errors and selects the error details.
    5. If no errors are found, prints a message indicating no errors.
    6. Initializes the current date and prepares for script generation.
    7. Drops the temporary table #OrderedMarkers if it exists.
    8. Generates deployment scripts using the defined templates and markers.

AST:
Procedure: [rep].[069_bld_CreateDeployScripts]
  Parameters:
    - None
  Variables:
    - @CheckErrorsCount: INT
    - @CurrentDate: DATETIME2
    - @CurrentDateVarchar: VARCHAR(16)
  Logic:
    - Log the start of the procedure
    - Disable ANSI warnings and set NOCOUNT ON
    - Check for errors in the repository definition
      - If errors are found
        - Print the number of errors
        - Select error details
      - If no errors are found
        - Print a message indicating no errors
    - Initialize the current date
    - Drop temporary table #OrderedMarkers if it exists
    - Generate deployment scripts using templates and markers

Mermaid Diagram:
graph TD
    A[Start] --> B[Log the start of the procedure]
    B --> C[Disable ANSI warnings and set NOCOUNT ON]
    C --> D[Check for errors in the repository definition]
    D --> E{Errors found?}
    E --> F[Print the number of errors]
    F --> G[Select error details]
    E --> H[Print a message indicating no errors]
    D --> I[Initialize the current date]
    I --> J{Drop temporary table #OrderedMarkers if it exists}
    J --> K[Generate deployment scripts using templates and markers]
    K --> L[End]

Change log:
Date                    Author              Description
20220915 00:00          K. Vermeij          Initial version
*/

-- Step 1: Logging start
EXEC [aud].[proc_Log_Procedure] 
    @LogAction = 'INFO',
    @LogNote = 'Build DeployScripts',
    @LogProcedure = 'rep.[069_bld_CreateDeployScripts]',
    @LogSQL = 'Insert Into [bld].[DeployScripts]',
    @LogRowCount = NULL;

-- Step 2: Setup
SET ANSI_WARNINGS OFF;
SET NOCOUNT ON;

DECLARE @CheckErrorsCount INT;

SELECT @CheckErrorsCount = COUNT(*) FROM bld.vw_BuildCheck;

IF @CheckErrorsCount > 0
BEGIN
    PRINT '-- ' + CAST(@CheckErrorsCount AS VARCHAR(5)) + ' errors found in repository definition, see Result set';
    SELECT * FROM bld.vw_BuildCheck;
END
ELSE
BEGIN
    PRINT '-- No errors found in repository definition';
    PRINT '--';
END

-- Step 3: Timestamp
DECLARE @CurrentDate DATETIME2 = SYSUTCDATETIME() AT TIME ZONE 'UTC' AT TIME ZONE 'W. Europe Standard Time';
DECLARE @CurrentDateVarchar VARCHAR(16) = CONVERT(VARCHAR(16), @CurrentDate, 120);

-- Step 4: Cleanup temp table
IF OBJECT_ID('tempdb..#OrderedMarkers') IS NOT NULL
    DROP TABLE #OrderedMarkers;

-- Step 5: Generate markers
WITH GeneratorMarkersPost AS (
    SELECT t.BK AS BK_Template, '<!<TemplateName>>' AS Marker, CAST(t.TemplateName AS VARCHAR(MAX)) AS MarkerValue FROM bld.vw_Template t
    UNION ALL SELECT t.BK, '<!<TemplateDesc>>', ISNULL(t.TemplateDecription, 'No description available') FROM bld.vw_Template t
    UNION ALL SELECT t.BK, '<!<TemplateVersionNum>>', CAST(t.TemplateVersion AS VARCHAR(MAX)) FROM bld.vw_Template t
    UNION ALL SELECT t.BK, '<!<CurrentUser>>', ORIGINAL_LOGIN() FROM bld.vw_Template t
    UNION ALL SELECT t.BK, '<!<GeneratedAt>>', @CurrentDateVarchar FROM bld.vw_Template t
),
GeneratorMarkers AS (
    SELECT DISTINCT
        dt.BK, dt.Code, dt.BK_Dataset,
        gm.Marker, gm.MarkerValue,
        CAST(t.Script AS VARCHAR(MAX)) AS Script,
        CAST(t.ObjectName AS VARCHAR(MAX)) AS TGT_ObjectName,
        t.ObjectType, t.ObjectTypeDeployOrder, t.BK AS BK_Template,
        t.TemplateType, t.ScriptLanguageCode, t.ScriptLanguage,
        '1900-01-01' AS mta_CreateDate,
        'System' AS MarkerType, 0 AS Pre, 1 AS Post
    FROM bld.vw_DatasetTemplates dt
    JOIN bld.vw_Template t ON t.BK = dt.BK_Template
    JOIN GeneratorMarkersPost gm ON gm.BK_Template = t.BK
),
AllMarkers AS (
    SELECT 
        dt.BK, m.Code, m.BK_Dataset,
        CAST(m.Marker AS VARCHAR(MAX)) AS Marker,
        CAST(ISNULL(m.MarkerValue, '') AS VARCHAR(MAX)) AS MarkerValue,
        CAST(t.Script AS VARCHAR(MAX)) AS Script,
        CAST(t.ObjectName AS VARCHAR(MAX)) AS TGT_ObjectName,
        t.ObjectType, t.ObjectTypeDeployOrder, t.BK AS BK_Template,
        t.TemplateType, t.ScriptLanguageCode, t.ScriptLanguage,
        m.mta_CreateDate, m.MarkerType, m.Pre, m.Post
    FROM bld.vw_DatasetTemplates dt
    LEFT JOIN bld.vw_Markers m ON m.BK_Dataset = dt.BK_Dataset
    LEFT JOIN bld.vw_Template t ON t.BK = dt.BK_Template
    UNION ALL
    SELECT * FROM GeneratorMarkers
)
SELECT 
    DENSE_RANK() OVER (ORDER BY CAST(am.ObjectTypeDeployOrder AS INT), am.BK) AS HNR,
    ROW_NUMBER() OVER (PARTITION BY am.BK ORDER BY am.BK) AS NR,
    am.*,
    ISNULL(sl.RecType, 1) AS RecType
INTO #OrderedMarkers
FROM AllMarkers am
JOIN bld.vw_DeployScriptsSmartLoad sl ON sl.BK = am.BK_Dataset
WHERE ISNULL(sl.RecType, 1) > -1;

CREATE CLUSTERED INDEX IX_OrderedMarkers ON #OrderedMarkers (HNR, NR, BK, Code);

PRINT '-- Build DeployScripts: Replacing markers in templates --';

-- Step 6: Loop over objects
DECLARE @MainCounter INT, @MaxId INT;
SELECT @MainCounter = MIN(HNR), @MaxId = MAX(HNR) FROM #OrderedMarkers;

DECLARE
    @Script VARCHAR(MAX), @PreScript VARCHAR(MAX), @PostScript VARCHAR(MAX),
    @BK_Object VARCHAR(MAX), @Code VARCHAR(MAX), @BK_Dataset VARCHAR(MAX),
    @ObjectType VARCHAR(MAX), @ObjectTypeDeployOrder VARCHAR(MAX),
    @BK_Template VARCHAR(MAX), @Marker VARCHAR(MAX), @MarkerValue VARCHAR(MAX),
    @TGT_ObjectName VARCHAR(MAX), @RecType INT,
    @TemplateType VARCHAR(MAX), @ScriptLanguageCode VARCHAR(MAX), @ScriptLanguage VARCHAR(MAX),
    @MarkerCounter INT, @MaxMarker INT;

WHILE @MainCounter IS NOT NULL AND @MainCounter <= @MaxId
BEGIN
    SELECT TOP 1
        @BK_Object = BK, @Code = Code, @BK_Dataset = BK_Dataset,
        @TGT_ObjectName = TGT_ObjectName, @BK_Template = BK_Template,
        @PreScript = Script, @TemplateType = TemplateType,
        @ScriptLanguageCode = ScriptLanguageCode, @ScriptLanguage = ScriptLanguage,
        @ObjectType = ObjectType, @ObjectTypeDeployOrder = ObjectTypeDeployOrder,
        @RecType = RecType
    FROM #OrderedMarkers
    WHERE HNR = @MainCounter;

    SET @Script = @PreScript;

    -- Replace markers
    SELECT @Script = REPLACE(@Script, Marker, MarkerValue)
    FROM #OrderedMarkers
    WHERE HNR = @MainCounter;

    PRINT '-- ' + @TGT_ObjectName;

    -- Insert into DeployScripts
    INSERT INTO [bld].[DeployScripts] (
        BK, Code, BK_Template, BK_Dataset, TGT_ObjectName,
        ObjectType, ObjectTypeDeployOrder, TemplateType,
        ScriptLanguageCode, ScriptLanguage,
        TemplateSource, TemplateName, TemplateScript,
        mta_Createdate, mta_RecType, mta_BK, mta_BKH, mta_RH, mta_Source
    )
    VALUES (
        @BK_Object, @Code, @BK_Template, @BK_Dataset, @TGT_ObjectName,
        @ObjectType, @ObjectTypeDeployOrder, @TemplateType,
        @ScriptLanguageCode, @ScriptLanguage,
        '', '', @Script, @CurrentDate, @RecType,
        @BK_Object + '|' + @BK_Template,
        CONVERT(CHAR(64), HASHBYTES('SHA2_512', UPPER(@BK_Object + '|' + @BK_Template)), 2),
        CONVERT(CHAR(64), HASHBYTES('SHA2_512', UPPER(@TGT_ObjectName + '|' + @ObjectType + '|' + @ObjectTypeDeployOrder + '|' + @Script)), 2),
        'rep.[069_bld_CreateDeployScripts]'
    );

    SET @MainCounter = @MainCounter + 1;
END