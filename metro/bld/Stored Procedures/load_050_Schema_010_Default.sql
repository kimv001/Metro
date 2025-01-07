﻿
	CREATE PROC [bld].[load_050_Schema_010_Default] AS
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:26
	
	exec [bld].[load_050_Schema_010_Default]*/

	
	DECLARE @RoutineName	varchar(8000)	= 'load_050_Schema_010_Default'
	DECLARE @StartDateTime	datetime2		=  getutcdate()
	DECLARE @EndDateTime	datetime2		
	DECLARE @Duration		bigint



	-- Create a helper temp table
	IF OBJECT_ID('tempdb..#050_Schema_010_Default') IS NOT NULL 
	DROP TABLE #050_Schema_010_Default ;
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
								+ISNULL(CAST(src.[BK_Schema] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Layer] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_DataSource] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_LinkedService] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[SchemaCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[SchemaName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DataSourceCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DataSourceName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_DataSourceType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DataSourceTypeCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DataSourceTypeName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LayerCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LayerName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LayerOrder] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ProcessOrderLayer] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ProcessParallel] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isDWH] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isSRC] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isTGT] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[IsRep] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[CreateDummies] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LinkedServiceCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LinkedServiceName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Template_Create] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Template_Load] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_ToChar] AS varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_050_Schema_010_Default]'
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
												                    +ISNULL(CAST(src.[BK_Schema] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Layer] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_DataSource] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_LinkedService] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[SchemaCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[SchemaName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DataSourceCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DataSourceName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_DataSourceType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DataSourceTypeCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DataSourceTypeName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LayerCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LayerName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LayerOrder] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ProcessOrderLayer] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ProcessParallel] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isDWH] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isSRC] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isTGT] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[IsRep] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[CreateDummies] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LinkedServiceCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LinkedServiceName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Template_Create] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Template_Load] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_ToChar] AS varchar(8000)),'-')
												                )
												            )
												        ),
												        2
												    )
						THEN 0
						ELSE -99 END
	
	INTO #050_Schema_010_Default
	FROM [bld].[tr_050_Schema_010_Default] src
	LEFT JOIN [bld].[vw_Schema] tgt ON src.[BK] = tgt.[BK]
	
	
	
	CREATE CLUSTERED INDEX [IX_tr_050_Schema_010_Default] ON #050_Schema_010_Default( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	PRINT '-- new records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Schema]
	( 
		[BK] ,
		[Code] ,
		[Name] ,
		[BK_Schema] ,
		[BK_Layer] ,
		[BK_DataSource] ,
		[BK_LinkedService] ,
		[SchemaCode] ,
		[SchemaName] ,
		[DataSourceCode] ,
		[DataSourceName] ,
		[BK_DataSourceType] ,
		[DataSourceTypeCode] ,
		[DataSourceTypeName] ,
		[LayerCode] ,
		[LayerName] ,
		[LayerOrder] ,
		[ProcessOrderLayer] ,
		[ProcessParallel] ,
		[isDWH] ,
		[isSRC] ,
		[isTGT] ,
		[IsRep] ,
		[CreateDummies] ,
		[LinkedServiceCode] ,
		[LinkedServiceName] ,
		[BK_Template_Create] ,
		[BK_Template_Load] ,
		[BK_RefType_ToChar] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[BK_Schema] ,
		src.[BK_Layer] ,
		src.[BK_DataSource] ,
		src.[BK_LinkedService] ,
		src.[SchemaCode] ,
		src.[SchemaName] ,
		src.[DataSourceCode] ,
		src.[DataSourceName] ,
		src.[BK_DataSourceType] ,
		src.[DataSourceTypeCode] ,
		src.[DataSourceTypeName] ,
		src.[LayerCode] ,
		src.[LayerName] ,
		src.[LayerOrder] ,
		src.[ProcessOrderLayer] ,
		src.[ProcessParallel] ,
		src.[isDWH] ,
		src.[isSRC] ,
		src.[isTGT] ,
		src.[IsRep] ,
		src.[CreateDummies] ,
		src.[LinkedServiceCode] ,
		src.[LinkedServiceName] ,
		src.[BK_Template_Create] ,
		src.[BK_Template_Load] ,
		src.[BK_RefType_ToChar] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_050_Schema_010_Default] src
	JOIN #050_Schema_010_Default h ON h.[mta_BK] = src.[BK]
	LEFT JOIN [bld].[vw_Schema] tgt ON h.[mta_BKH] = tgt.[mta_BKH] 
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 1 AND tgt.[mta_BKH] IS null
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Schema]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- changed records:'
	SET @StartDateTime = getdate()
	
		INSERT INTO [bld].[Schema]
	( 
		[BK] ,
		[Code] ,
		[Name] ,
		[BK_Schema] ,
		[BK_Layer] ,
		[BK_DataSource] ,
		[BK_LinkedService] ,
		[SchemaCode] ,
		[SchemaName] ,
		[DataSourceCode] ,
		[DataSourceName] ,
		[BK_DataSourceType] ,
		[DataSourceTypeCode] ,
		[DataSourceTypeName] ,
		[LayerCode] ,
		[LayerName] ,
		[LayerOrder] ,
		[ProcessOrderLayer] ,
		[ProcessParallel] ,
		[isDWH] ,
		[isSRC] ,
		[isTGT] ,
		[IsRep] ,
		[CreateDummies] ,
		[LinkedServiceCode] ,
		[LinkedServiceName] ,
		[BK_Template_Create] ,
		[BK_Template_Load] ,
		[BK_RefType_ToChar] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[BK_Schema] ,
		src.[BK_Layer] ,
		src.[BK_DataSource] ,
		src.[BK_LinkedService] ,
		src.[SchemaCode] ,
		src.[SchemaName] ,
		src.[DataSourceCode] ,
		src.[DataSourceName] ,
		src.[BK_DataSourceType] ,
		src.[DataSourceTypeCode] ,
		src.[DataSourceTypeName] ,
		src.[LayerCode] ,
		src.[LayerName] ,
		src.[LayerOrder] ,
		src.[ProcessOrderLayer] ,
		src.[ProcessParallel] ,
		src.[isDWH] ,
		src.[isSRC] ,
		src.[isTGT] ,
		src.[IsRep] ,
		src.[CreateDummies] ,
		src.[LinkedServiceCode] ,
		src.[LinkedServiceName] ,
		src.[BK_Template_Create] ,
		src.[BK_Template_Load] ,
		src.[BK_RefType_ToChar] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_050_Schema_010_Default] src
	JOIN #050_Schema_010_Default h ON h.[mta_BK] = src.[BK]
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 0

	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Schema]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- deleted records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Schema]
	
	( 
	
		[BK] ,
		[Code] ,
		[Name] ,
		[BK_Schema] ,
		[BK_Layer] ,
		[BK_DataSource] ,
		[BK_LinkedService] ,
		[SchemaCode] ,
		[SchemaName] ,
		[DataSourceCode] ,
		[DataSourceName] ,
		[BK_DataSourceType] ,
		[DataSourceTypeCode] ,
		[DataSourceTypeName] ,
		[LayerCode] ,
		[LayerName] ,
		[LayerOrder] ,
		[ProcessOrderLayer] ,
		[ProcessParallel] ,
		[isDWH] ,
		[isSRC] ,
		[isTGT] ,
		[IsRep] ,
		[CreateDummies] ,
		[LinkedServiceCode] ,
		[LinkedServiceName] ,
		[BK_Template_Create] ,
		[BK_Template_Load] ,
		[BK_RefType_ToChar] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[BK_Schema] ,
		src.[BK_Layer] ,
		src.[BK_DataSource] ,
		src.[BK_LinkedService] ,
		src.[SchemaCode] ,
		src.[SchemaName] ,
		src.[DataSourceCode] ,
		src.[DataSourceName] ,
		src.[BK_DataSourceType] ,
		src.[DataSourceTypeCode] ,
		src.[DataSourceTypeName] ,
		src.[LayerCode] ,
		src.[LayerName] ,
		src.[LayerOrder] ,
		src.[ProcessOrderLayer] ,
		src.[ProcessParallel] ,
		src.[isDWH] ,
		src.[isSRC] ,
		src.[isTGT] ,
		src.[IsRep] ,
		src.[CreateDummies] ,
		src.[LinkedServiceCode] ,
		src.[LinkedServiceName] ,
		src.[BK_Template_Create] ,
		src.[BK_Template_Load] ,
		src.[BK_RefType_ToChar] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	FROM  [bld].[vw_Schema] src
	LEFT JOIN #050_Schema_010_Default h ON h.[mta_BKH] = src.[mta_BKH] AND h.[mta_Source] = src.[mta_Source]
	WHERE 1=1 AND h.[mta_BKH] IS null AND  src.mta_Source = '[bld].[tr_050_Schema_010_Default]'
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Schema]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	IF OBJECT_ID('tempdb..#050_Schema_010_Default') IS NOT NULL 
DROP TABLE #050_Schema_010_Default;
	
	SET @EndDateTime =  getutcdate()
	SET @Duration = datediff(SS,@StartDateTime, @EndDateTime)
	PRINT 'Load "load_050_Schema_010_Default" took ' +CAST(@Duration AS varchar(10))+ ' second(s)'