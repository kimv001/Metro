﻿
	CREATE PROC [bld].[load_200_Attribute_010_DatasetSrcAttributes] AS
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:27
	
	exec [bld].[load_200_Attribute_010_DatasetSrcAttributes]*/

	
	DECLARE @RoutineName	varchar(8000)	= 'load_200_Attribute_010_DatasetSrcAttributes'
	DECLARE @StartDateTime	datetime2		=  getutcdate()
	DECLARE @EndDateTime	datetime2		
	DECLARE @Duration		bigint



	-- Create a helper temp table
	IF OBJECT_ID('tempdb..#200_Attribute_010_DatasetSrcAttributes') IS NOT NULL 
	DROP TABLE #200_Attribute_010_DatasetSrcAttributes ;
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
								+ISNULL(CAST(src.[BK_Dataset] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Dataset] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[AttributeName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Description] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Expression] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DistributionHashKey] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[NotInRH] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BusinessKey] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isMta] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[SrcName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_DataType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DataType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[FixedSchemaDataType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[OrgMappedDataType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Isnullable] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[OrdinalPosition] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[MaximumLength] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Precision] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Scale] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Collation] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Active] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[FlowOrder] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_ObjectType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_RepositoryStatus] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DefaultValue] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DDL_Type1] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DDL_Type2] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DDL_Type3] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DDL_Type4] AS varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_200_Attribute_010_DatasetSrcAttributes]'
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
												                    +ISNULL(CAST(src.[BK_Dataset] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Dataset] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[AttributeName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Description] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Expression] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DistributionHashKey] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[NotInRH] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BusinessKey] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isMta] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[SrcName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_DataType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DataType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[FixedSchemaDataType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[OrgMappedDataType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Isnullable] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[OrdinalPosition] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[MaximumLength] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Precision] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Scale] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Collation] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Active] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[FlowOrder] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_ObjectType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_RepositoryStatus] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DefaultValue] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DDL_Type1] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DDL_Type2] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DDL_Type3] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DDL_Type4] AS varchar(8000)),'-')
												                )
												            )
												        ),
												        2
												    )
						THEN 0
						ELSE -99 END
	
	INTO #200_Attribute_010_DatasetSrcAttributes
	FROM [bld].[tr_200_Attribute_010_DatasetSrcAttributes] src
	LEFT JOIN [bld].[vw_Attribute] tgt ON src.[BK] = tgt.[BK]
	
	
	
	CREATE CLUSTERED INDEX [IX_tr_200_Attribute_010_DatasetSrcAttributes] ON #200_Attribute_010_DatasetSrcAttributes( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	PRINT '-- new records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Attribute]
	( 
		[BK] ,
		[Code] ,
		[Name] ,
		[BK_Dataset] ,
		[Dataset] ,
		[AttributeName] ,
		[Description] ,
		[Expression] ,
		[DistributionHashKey] ,
		[NotInRH] ,
		[BusinessKey] ,
		[isMta] ,
		[SrcName] ,
		[BK_RefType_DataType] ,
		[DataType] ,
		[FixedSchemaDataType] ,
		[OrgMappedDataType] ,
		[Isnullable] ,
		[OrdinalPosition] ,
		[MaximumLength] ,
		[Precision] ,
		[Scale] ,
		[Collation] ,
		[Active] ,
		[FlowOrder] ,
		[BK_RefType_ObjectType] ,
		[BK_RefType_RepositoryStatus] ,
		[DefaultValue] ,
		[DDL_Type1] ,
		[DDL_Type2] ,
		[DDL_Type3] ,
		[DDL_Type4] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[BK_Dataset] ,
		src.[Dataset] ,
		src.[AttributeName] ,
		src.[Description] ,
		src.[Expression] ,
		src.[DistributionHashKey] ,
		src.[NotInRH] ,
		src.[BusinessKey] ,
		src.[isMta] ,
		src.[SrcName] ,
		src.[BK_RefType_DataType] ,
		src.[DataType] ,
		src.[FixedSchemaDataType] ,
		src.[OrgMappedDataType] ,
		src.[Isnullable] ,
		src.[OrdinalPosition] ,
		src.[MaximumLength] ,
		src.[Precision] ,
		src.[Scale] ,
		src.[Collation] ,
		src.[Active] ,
		src.[FlowOrder] ,
		src.[BK_RefType_ObjectType] ,
		src.[BK_RefType_RepositoryStatus] ,
		src.[DefaultValue] ,
		src.[DDL_Type1] ,
		src.[DDL_Type2] ,
		src.[DDL_Type3] ,
		src.[DDL_Type4] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_200_Attribute_010_DatasetSrcAttributes] src
	JOIN #200_Attribute_010_DatasetSrcAttributes h ON h.[mta_BK] = src.[BK]
	LEFT JOIN [bld].[vw_Attribute] tgt ON h.[mta_BKH] = tgt.[mta_BKH] 
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 1 AND tgt.[mta_BKH] IS null
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Attribute]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- changed records:'
	SET @StartDateTime = getdate()
	
		INSERT INTO [bld].[Attribute]
	( 
		[BK] ,
		[Code] ,
		[Name] ,
		[BK_Dataset] ,
		[Dataset] ,
		[AttributeName] ,
		[Description] ,
		[Expression] ,
		[DistributionHashKey] ,
		[NotInRH] ,
		[BusinessKey] ,
		[isMta] ,
		[SrcName] ,
		[BK_RefType_DataType] ,
		[DataType] ,
		[FixedSchemaDataType] ,
		[OrgMappedDataType] ,
		[Isnullable] ,
		[OrdinalPosition] ,
		[MaximumLength] ,
		[Precision] ,
		[Scale] ,
		[Collation] ,
		[Active] ,
		[FlowOrder] ,
		[BK_RefType_ObjectType] ,
		[BK_RefType_RepositoryStatus] ,
		[DefaultValue] ,
		[DDL_Type1] ,
		[DDL_Type2] ,
		[DDL_Type3] ,
		[DDL_Type4] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[BK_Dataset] ,
		src.[Dataset] ,
		src.[AttributeName] ,
		src.[Description] ,
		src.[Expression] ,
		src.[DistributionHashKey] ,
		src.[NotInRH] ,
		src.[BusinessKey] ,
		src.[isMta] ,
		src.[SrcName] ,
		src.[BK_RefType_DataType] ,
		src.[DataType] ,
		src.[FixedSchemaDataType] ,
		src.[OrgMappedDataType] ,
		src.[Isnullable] ,
		src.[OrdinalPosition] ,
		src.[MaximumLength] ,
		src.[Precision] ,
		src.[Scale] ,
		src.[Collation] ,
		src.[Active] ,
		src.[FlowOrder] ,
		src.[BK_RefType_ObjectType] ,
		src.[BK_RefType_RepositoryStatus] ,
		src.[DefaultValue] ,
		src.[DDL_Type1] ,
		src.[DDL_Type2] ,
		src.[DDL_Type3] ,
		src.[DDL_Type4] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_200_Attribute_010_DatasetSrcAttributes] src
	JOIN #200_Attribute_010_DatasetSrcAttributes h ON h.[mta_BK] = src.[BK]
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 0

	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Attribute]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- deleted records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Attribute]
	
	( 
	
		[BK] ,
		[Code] ,
		[Name] ,
		[BK_Dataset] ,
		[Dataset] ,
		[AttributeName] ,
		[Description] ,
		[Expression] ,
		[DistributionHashKey] ,
		[NotInRH] ,
		[BusinessKey] ,
		[isMta] ,
		[SrcName] ,
		[BK_RefType_DataType] ,
		[DataType] ,
		[FixedSchemaDataType] ,
		[OrgMappedDataType] ,
		[Isnullable] ,
		[OrdinalPosition] ,
		[MaximumLength] ,
		[Precision] ,
		[Scale] ,
		[Collation] ,
		[Active] ,
		[FlowOrder] ,
		[BK_RefType_ObjectType] ,
		[BK_RefType_RepositoryStatus] ,
		[DefaultValue] ,
		[DDL_Type1] ,
		[DDL_Type2] ,
		[DDL_Type3] ,
		[DDL_Type4] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[Name] ,
		src.[BK_Dataset] ,
		src.[Dataset] ,
		src.[AttributeName] ,
		src.[Description] ,
		src.[Expression] ,
		src.[DistributionHashKey] ,
		src.[NotInRH] ,
		src.[BusinessKey] ,
		src.[isMta] ,
		src.[SrcName] ,
		src.[BK_RefType_DataType] ,
		src.[DataType] ,
		src.[FixedSchemaDataType] ,
		src.[OrgMappedDataType] ,
		src.[Isnullable] ,
		src.[OrdinalPosition] ,
		src.[MaximumLength] ,
		src.[Precision] ,
		src.[Scale] ,
		src.[Collation] ,
		src.[Active] ,
		src.[FlowOrder] ,
		src.[BK_RefType_ObjectType] ,
		src.[BK_RefType_RepositoryStatus] ,
		src.[DefaultValue] ,
		src.[DDL_Type1] ,
		src.[DDL_Type2] ,
		src.[DDL_Type3] ,
		src.[DDL_Type4] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	FROM  [bld].[vw_Attribute] src
	LEFT JOIN #200_Attribute_010_DatasetSrcAttributes h ON h.[mta_BKH] = src.[mta_BKH] AND h.[mta_Source] = src.[mta_Source]
	WHERE 1=1 AND h.[mta_BKH] IS null AND  src.mta_Source = '[bld].[tr_200_Attribute_010_DatasetSrcAttributes]'
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Attribute]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	IF OBJECT_ID('tempdb..#200_Attribute_010_DatasetSrcAttributes') IS NOT NULL 
DROP TABLE #200_Attribute_010_DatasetSrcAttributes;
	
	SET @EndDateTime =  getutcdate()
	SET @Duration = datediff(SS,@StartDateTime, @EndDateTime)
	PRINT 'Load "load_200_Attribute_010_DatasetSrcAttributes" took ' +CAST(@Duration AS varchar(10))+ ' second(s)'