﻿
	CREATE PROC [bld].[load_600_Template_010_Default] AS
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-21 08:32:56
	
	exec [bld].[load_600_Template_010_Default]*/

	
	DECLARE @RoutineName	varchar(8000)	= 'load_600_Template_010_Default'
	DECLARE @StartDateTime	datetime2		=  getutcdate()
	DECLARE @EndDateTime	datetime2		
	DECLARE @Duration		bigint



	-- Create a helper temp table
	IF OBJECT_ID('tempdb..#600_Template_010_Default') IS NOT NULL 
	DROP TABLE #600_Template_010_Default ;
	PRINT '-- create temp table:'
	SELECT
	  mta_BK		= src.[BK]
	, mta_BKH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(CAST(src.[BK] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Code] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateDecription] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ObjectType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ObjectTypeDeployOrder] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Script] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ScriptLanguageCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ScriptLanguage] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ObjectName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_TemplateType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_ObjectType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_ObjectType_BasedOn] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_ScriptLanguage] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateVersion] AS varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_600_Template_010_Default]'
	, mta_RecType	= CASE 
												WHEN tgt.[BK] IS null THEN 1
												WHEN
												    tgt.[mta_RH]
												    !=  CONVERT(
												        char(64),
												        (
												            Hashbytes(
												                'sha2_512',
												                upper(
												                    ISNULL(CAST(src.[BK] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Code] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateDecription] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ObjectType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ObjectTypeDeployOrder] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Script] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ScriptLanguageCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ScriptLanguage] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ObjectName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_TemplateType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_ObjectType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_ObjectType_BasedOn] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_ScriptLanguage] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateVersion] AS varchar(8000)),'-')
												                )
												            )
												        ),
												        2
												    )
						THEN 0
						ELSE -99 END
	
	INTO #600_Template_010_Default
	FROM [bld].[tr_600_Template_010_Default] src
	LEFT JOIN [bld].[vw_Template] tgt ON src.[BK] = tgt.[BK]
	
	
	
	CREATE CLUSTERED INDEX [IX_tr_600_Template_010_Default] ON #600_Template_010_Default( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	PRINT '-- new records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Template]
	( 
		[BK] ,
		[Code] ,
		[TemplateName] ,
		[TemplateType] ,
		[TemplateDecription] ,
		[ObjectType] ,
		[ObjectTypeDeployOrder] ,
		[Script] ,
		[ScriptLanguageCode] ,
		[ScriptLanguage] ,
		[ObjectName] ,
		[BK_RefType_TemplateType] ,
		[BK_RefType_ObjectType] ,
		[BK_RefType_ObjectType_BasedOn] ,
		[BK_RefType_ScriptLanguage] ,
		[TemplateVersion] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[TemplateName] ,
		src.[TemplateType] ,
		src.[TemplateDecription] ,
		src.[ObjectType] ,
		src.[ObjectTypeDeployOrder] ,
		src.[Script] ,
		src.[ScriptLanguageCode] ,
		src.[ScriptLanguage] ,
		src.[ObjectName] ,
		src.[BK_RefType_TemplateType] ,
		src.[BK_RefType_ObjectType] ,
		src.[BK_RefType_ObjectType_BasedOn] ,
		src.[BK_RefType_ScriptLanguage] ,
		src.[TemplateVersion] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_600_Template_010_Default] src
	JOIN #600_Template_010_Default h ON h.[mta_BK] = src.[BK]
	LEFT JOIN [bld].[vw_Template] tgt ON h.[mta_BKH] = tgt.[mta_BKH] 
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 1 AND tgt.[mta_BKH] IS null
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Template]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- changed records:'
	SET @StartDateTime = getdate()
	
		INSERT INTO [bld].[Template]
	( 
		[BK] ,
		[Code] ,
		[TemplateName] ,
		[TemplateType] ,
		[TemplateDecription] ,
		[ObjectType] ,
		[ObjectTypeDeployOrder] ,
		[Script] ,
		[ScriptLanguageCode] ,
		[ScriptLanguage] ,
		[ObjectName] ,
		[BK_RefType_TemplateType] ,
		[BK_RefType_ObjectType] ,
		[BK_RefType_ObjectType_BasedOn] ,
		[BK_RefType_ScriptLanguage] ,
		[TemplateVersion] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[TemplateName] ,
		src.[TemplateType] ,
		src.[TemplateDecription] ,
		src.[ObjectType] ,
		src.[ObjectTypeDeployOrder] ,
		src.[Script] ,
		src.[ScriptLanguageCode] ,
		src.[ScriptLanguage] ,
		src.[ObjectName] ,
		src.[BK_RefType_TemplateType] ,
		src.[BK_RefType_ObjectType] ,
		src.[BK_RefType_ObjectType_BasedOn] ,
		src.[BK_RefType_ScriptLanguage] ,
		src.[TemplateVersion] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_600_Template_010_Default] src
	JOIN #600_Template_010_Default h ON h.[mta_BK] = src.[BK]
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 0

	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Template]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- deleted records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Template]
	
	( 
	
		[BK] ,
		[Code] ,
		[TemplateName] ,
		[TemplateType] ,
		[TemplateDecription] ,
		[ObjectType] ,
		[ObjectTypeDeployOrder] ,
		[Script] ,
		[ScriptLanguageCode] ,
		[ScriptLanguage] ,
		[ObjectName] ,
		[BK_RefType_TemplateType] ,
		[BK_RefType_ObjectType] ,
		[BK_RefType_ObjectType_BasedOn] ,
		[BK_RefType_ScriptLanguage] ,
		[TemplateVersion] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[TemplateName] ,
		src.[TemplateType] ,
		src.[TemplateDecription] ,
		src.[ObjectType] ,
		src.[ObjectTypeDeployOrder] ,
		src.[Script] ,
		src.[ScriptLanguageCode] ,
		src.[ScriptLanguage] ,
		src.[ObjectName] ,
		src.[BK_RefType_TemplateType] ,
		src.[BK_RefType_ObjectType] ,
		src.[BK_RefType_ObjectType_BasedOn] ,
		src.[BK_RefType_ScriptLanguage] ,
		src.[TemplateVersion] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	FROM  [bld].[vw_Template] src
	LEFT JOIN #600_Template_010_Default h ON h.[mta_BKH] = src.[mta_BKH] AND h.[mta_Source] = src.[mta_Source]
	WHERE 1=1 AND h.[mta_BKH] IS null AND  src.mta_Source = '[bld].[tr_600_Template_010_Default]'
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Template]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	IF OBJECT_ID('tempdb..#600_Template_010_Default') IS NOT NULL 
DROP TABLE #600_Template_010_Default;
	
	SET @EndDateTime =  getutcdate()
	SET @Duration = datediff(SS,@StartDateTime, @EndDateTime)
	PRINT 'Load "load_600_Template_010_Default" took ' +CAST(@Duration AS varchar(10))+ ' second(s)'