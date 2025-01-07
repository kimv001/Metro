﻿
	CREATE PROC [bld].[load_900_DeployScripts_010_MetroProcedure] AS
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:28
	
	exec [bld].[load_900_DeployScripts_010_MetroProcedure]*/

	
	DECLARE @RoutineName	varchar(8000)	= 'load_900_DeployScripts_010_MetroProcedure'
	DECLARE @StartDateTime	datetime2		=  getutcdate()
	DECLARE @EndDateTime	datetime2		
	DECLARE @Duration		bigint



	-- Create a helper temp table
	IF OBJECT_ID('tempdb..#900_DeployScripts_010_MetroProcedure') IS NOT NULL 
	DROP TABLE #900_DeployScripts_010_MetroProcedure ;
	PRINT '-- create temp table:'
	SELECT
	  mta_BK		= src.[BK]
	, mta_BKH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(CAST(src.[BK] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Code] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Template] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Dataset] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TGT_ObjectName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ObjectType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ObjectTypeDeployOrder] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ScriptLanguageCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ScriptLanguage] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateSource] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateScript] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TemplateVersion] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ToDeploy] AS varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_900_DeployScripts_010_MetroProcedure]'
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
												                    +ISNULL(CAST(src.[BK_Template] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Dataset] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TGT_ObjectName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ObjectType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ObjectTypeDeployOrder] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ScriptLanguageCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ScriptLanguage] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateSource] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateScript] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TemplateVersion] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ToDeploy] AS varchar(8000)),'-')
												                )
												            )
												        ),
												        2
												    )
						THEN 0
						ELSE -99 END
	
	INTO #900_DeployScripts_010_MetroProcedure
	FROM [bld].[tr_900_DeployScripts_010_MetroProcedure] src
	LEFT JOIN [bld].[vw_DeployScripts] tgt ON src.[BK] = tgt.[BK]
	
	
	
	CREATE CLUSTERED INDEX [IX_tr_900_DeployScripts_010_MetroProcedure] ON #900_DeployScripts_010_MetroProcedure( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	PRINT '-- new records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[DeployScripts]
	( 
		[BK] ,
		[Code] ,
		[BK_Template] ,
		[BK_Dataset] ,
		[TGT_ObjectName] ,
		[ObjectType] ,
		[ObjectTypeDeployOrder] ,
		[TemplateType] ,
		[ScriptLanguageCode] ,
		[ScriptLanguage] ,
		[TemplateSource] ,
		[TemplateName] ,
		[TemplateScript] ,
		[TemplateVersion] ,
		[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[BK_Template] ,
		src.[BK_Dataset] ,
		src.[TGT_ObjectName] ,
		src.[ObjectType] ,
		src.[ObjectTypeDeployOrder] ,
		src.[TemplateType] ,
		src.[ScriptLanguageCode] ,
		src.[ScriptLanguage] ,
		src.[TemplateSource] ,
		src.[TemplateName] ,
		src.[TemplateScript] ,
		src.[TemplateVersion] ,
		src.[ToDeploy] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_900_DeployScripts_010_MetroProcedure] src
	JOIN #900_DeployScripts_010_MetroProcedure h ON h.[mta_BK] = src.[BK]
	LEFT JOIN [bld].[vw_DeployScripts] tgt ON h.[mta_BKH] = tgt.[mta_BKH] 
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 1 AND tgt.[mta_BKH] IS null
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[DeployScripts]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- changed records:'
	SET @StartDateTime = getdate()
	
		INSERT INTO [bld].[DeployScripts]
	( 
		[BK] ,
		[Code] ,
		[BK_Template] ,
		[BK_Dataset] ,
		[TGT_ObjectName] ,
		[ObjectType] ,
		[ObjectTypeDeployOrder] ,
		[TemplateType] ,
		[ScriptLanguageCode] ,
		[ScriptLanguage] ,
		[TemplateSource] ,
		[TemplateName] ,
		[TemplateScript] ,
		[TemplateVersion] ,
		[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[BK_Template] ,
		src.[BK_Dataset] ,
		src.[TGT_ObjectName] ,
		src.[ObjectType] ,
		src.[ObjectTypeDeployOrder] ,
		src.[TemplateType] ,
		src.[ScriptLanguageCode] ,
		src.[ScriptLanguage] ,
		src.[TemplateSource] ,
		src.[TemplateName] ,
		src.[TemplateScript] ,
		src.[TemplateVersion] ,
		src.[ToDeploy] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_900_DeployScripts_010_MetroProcedure] src
	JOIN #900_DeployScripts_010_MetroProcedure h ON h.[mta_BK] = src.[BK]
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 0

	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[DeployScripts]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- deleted records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[DeployScripts]
	
	( 
	
		[BK] ,
		[Code] ,
		[BK_Template] ,
		[BK_Dataset] ,
		[TGT_ObjectName] ,
		[ObjectType] ,
		[ObjectTypeDeployOrder] ,
		[TemplateType] ,
		[ScriptLanguageCode] ,
		[ScriptLanguage] ,
		[TemplateSource] ,
		[TemplateName] ,
		[TemplateScript] ,
		[TemplateVersion] ,
		[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[BK_Template] ,
		src.[BK_Dataset] ,
		src.[TGT_ObjectName] ,
		src.[ObjectType] ,
		src.[ObjectTypeDeployOrder] ,
		src.[TemplateType] ,
		src.[ScriptLanguageCode] ,
		src.[ScriptLanguage] ,
		src.[TemplateSource] ,
		src.[TemplateName] ,
		src.[TemplateScript] ,
		src.[TemplateVersion] ,
		src.[ToDeploy] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	FROM  [bld].[vw_DeployScripts] src
	LEFT JOIN #900_DeployScripts_010_MetroProcedure h ON h.[mta_BKH] = src.[mta_BKH] AND h.[mta_Source] = src.[mta_Source]
	WHERE 1=1 AND h.[mta_BKH] IS null AND  src.mta_Source = '[bld].[tr_900_DeployScripts_010_MetroProcedure]'
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[DeployScripts]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	IF OBJECT_ID('tempdb..#900_DeployScripts_010_MetroProcedure') IS NOT NULL 
DROP TABLE #900_DeployScripts_010_MetroProcedure;
	
	SET @EndDateTime =  getutcdate()
	SET @Duration = datediff(SS,@StartDateTime, @EndDateTime)
	PRINT 'Load "load_900_DeployScripts_010_MetroProcedure" took ' +CAST(@Duration AS varchar(10))+ ' second(s)'