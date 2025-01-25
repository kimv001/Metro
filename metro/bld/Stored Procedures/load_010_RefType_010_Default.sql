﻿
	CREATE PROC [bld].[load_010_RefType_010_Default] AS
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-21 08:32:54
	
	exec [bld].[load_010_RefType_010_Default]*/

	
	DECLARE @RoutineName	varchar(8000)	= 'load_010_RefType_010_Default'
	DECLARE @StartDateTime	datetime2		=  getutcdate()
	DECLARE @EndDateTime	datetime2		
	DECLARE @Duration		bigint



	-- Create a helper temp table
	IF OBJECT_ID('tempdb..#010_RefType_010_Default') IS NOT NULL 
	DROP TABLE #010_RefType_010_Default ;
	PRINT '-- create temp table:'
	SELECT
	  mta_BK		= src.[BK]
	, mta_BKH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(CAST(src.[BK] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Code] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Name] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Description] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[RefType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[RefTypeAbbr] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[SortOrder] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LinkedReftype] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_LinkedRefType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LinkedRefTypeCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LinkedRefTypeName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LinkedRefTypeDecription] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DefaultValue] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isDefault] AS varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_010_RefType_010_Default]'
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
												                    +ISNULL(CAST(src.[Name] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Description] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[RefType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[RefTypeAbbr] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[SortOrder] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LinkedReftype] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_LinkedRefType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LinkedRefTypeCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LinkedRefTypeName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LinkedRefTypeDecription] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DefaultValue] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isDefault] AS varchar(8000)),'-')
												                )
												            )
												        ),
												        2
												    )
						THEN 0
						ELSE -99 END
	
	INTO #010_RefType_010_Default
	FROM [bld].[tr_010_RefType_010_Default] src
	LEFT JOIN [bld].[vw_RefType] tgt ON src.[BK] = tgt.[BK]
	
	
	
	CREATE CLUSTERED INDEX [IX_tr_010_RefType_010_Default] ON #010_RefType_010_Default( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	PRINT '-- new records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[RefType]
	( 
		[BK] ,
		[Code] ,
		[Name] ,
		[Description] ,
		[RefType] ,
		[RefTypeAbbr] ,
		[SortOrder] ,
		[LinkedReftype] ,
		[BK_LinkedRefType] ,
		[LinkedRefTypeCode] ,
		[LinkedRefTypeName] ,
		[LinkedRefTypeDecription] ,
		[DefaultValue] ,
		[isDefault] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[Description] ,
		src.[RefType] ,
		src.[RefTypeAbbr] ,
		src.[SortOrder] ,
		src.[LinkedReftype] ,
		src.[BK_LinkedRefType] ,
		src.[LinkedRefTypeCode] ,
		src.[LinkedRefTypeName] ,
		src.[LinkedRefTypeDecription] ,
		src.[DefaultValue] ,
		src.[isDefault] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_010_RefType_010_Default] src
	JOIN #010_RefType_010_Default h ON h.[mta_BK] = src.[BK]
	LEFT JOIN [bld].[vw_RefType] tgt ON h.[mta_BKH] = tgt.[mta_BKH] 
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 1 AND tgt.[mta_BKH] IS null
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[RefType]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- changed records:'
	SET @StartDateTime = getdate()
	
		INSERT INTO [bld].[RefType]
	( 
		[BK] ,
		[Code] ,
		[Name] ,
		[Description] ,
		[RefType] ,
		[RefTypeAbbr] ,
		[SortOrder] ,
		[LinkedReftype] ,
		[BK_LinkedRefType] ,
		[LinkedRefTypeCode] ,
		[LinkedRefTypeName] ,
		[LinkedRefTypeDecription] ,
		[DefaultValue] ,
		[isDefault] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[Description] ,
		src.[RefType] ,
		src.[RefTypeAbbr] ,
		src.[SortOrder] ,
		src.[LinkedReftype] ,
		src.[BK_LinkedRefType] ,
		src.[LinkedRefTypeCode] ,
		src.[LinkedRefTypeName] ,
		src.[LinkedRefTypeDecription] ,
		src.[DefaultValue] ,
		src.[isDefault] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_010_RefType_010_Default] src
	JOIN #010_RefType_010_Default h ON h.[mta_BK] = src.[BK]
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 0

	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[RefType]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- deleted records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[RefType]
	
	( 
	
		[BK] ,
		[Code] ,
		[Name] ,
		[Description] ,
		[RefType] ,
		[RefTypeAbbr] ,
		[SortOrder] ,
		[LinkedReftype] ,
		[BK_LinkedRefType] ,
		[LinkedRefTypeCode] ,
		[LinkedRefTypeName] ,
		[LinkedRefTypeDecription] ,
		[DefaultValue] ,
		[isDefault] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[Description] ,
		src.[RefType] ,
		src.[RefTypeAbbr] ,
		src.[SortOrder] ,
		src.[LinkedReftype] ,
		src.[BK_LinkedRefType] ,
		src.[LinkedRefTypeCode] ,
		src.[LinkedRefTypeName] ,
		src.[LinkedRefTypeDecription] ,
		src.[DefaultValue] ,
		src.[isDefault] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	FROM  [bld].[vw_RefType] src
	LEFT JOIN #010_RefType_010_Default h ON h.[mta_BKH] = src.[mta_BKH] AND h.[mta_Source] = src.[mta_Source]
	WHERE 1=1 AND h.[mta_BKH] IS null AND  src.mta_Source = '[bld].[tr_010_RefType_010_Default]'
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[RefType]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	IF OBJECT_ID('tempdb..#010_RefType_010_Default') IS NOT NULL 
DROP TABLE #010_RefType_010_Default;
	
	SET @EndDateTime =  getutcdate()
	SET @Duration = datediff(SS,@StartDateTime, @EndDateTime)
	PRINT 'Load "load_010_RefType_010_Default" took ' +CAST(@Duration AS varchar(10))+ ' second(s)'