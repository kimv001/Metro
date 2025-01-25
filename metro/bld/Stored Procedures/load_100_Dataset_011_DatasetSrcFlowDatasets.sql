﻿
	CREATE PROC [bld].[load_100_Dataset_011_DatasetSrcFlowDatasets] AS
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-21 08:32:55
	
	exec [bld].[load_100_Dataset_011_DatasetSrcFlowDatasets]*/

	
	DECLARE @RoutineName	varchar(8000)	= 'load_100_Dataset_011_DatasetSrcFlowDatasets'
	DECLARE @StartDateTime	datetime2		=  getutcdate()
	DECLARE @EndDateTime	datetime2		
	DECLARE @Duration		bigint



	-- Create a helper temp table
	IF OBJECT_ID('tempdb..#100_Dataset_011_DatasetSrcFlowDatasets') IS NOT NULL 
	DROP TABLE #100_Dataset_011_DatasetSrcFlowDatasets ;
	PRINT '-- create temp table:'
	SELECT
	  mta_BK		= src.[BK]
	, mta_BKH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(CAST(src.[BK] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Code] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DatasetName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[SchemaName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[LayerName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DataSource] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_DataSource] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_LinkedService] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Layer] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Schema] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Group] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Shortname] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[SRC_ShortName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[SRC_ObjectType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[dwhTargetShortName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[PreFix] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[PostFix] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Description] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_ContactGroup] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[bk_ContactGroup_Data_Logistics] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Data_Logistics_Info] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[bk_ContactGroup_Data_Supplier] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[Data_Supplier_Info] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Flow] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[FlowOrder] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[FlowOrderDesc] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[TimeStamp] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BusinessDate] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[RecordSrcDate] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[DistinctValues] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[WhereFilter] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[PartitionStatement] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_ObjectType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[FullLoad] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[InsertOnly] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BigData] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Template_Load] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_Template_Create] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[CustomStagingView] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[BK_RefType_RepositoryStatus] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[IsSystem] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isDWH] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isSRC] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isTGT] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[isRep] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[FirstDefaultDWHView] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[createdummies] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ObjectType] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[RepositoryStatusName] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[RepositoryStatusCode] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[view_defintion_contains_business_logic] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[view_defintion] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[ToDeploy] AS varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets]'
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
												                    +ISNULL(CAST(src.[DatasetName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[SchemaName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[LayerName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DataSource] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_DataSource] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_LinkedService] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Layer] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Schema] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Group] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Shortname] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[SRC_ShortName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[SRC_ObjectType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[dwhTargetShortName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[PreFix] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[PostFix] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Description] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_ContactGroup] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[bk_ContactGroup_Data_Logistics] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Data_Logistics_Info] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[bk_ContactGroup_Data_Supplier] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[Data_Supplier_Info] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Flow] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[FlowOrder] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[FlowOrderDesc] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[TimeStamp] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BusinessDate] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[RecordSrcDate] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[DistinctValues] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[WhereFilter] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[PartitionStatement] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_ObjectType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[FullLoad] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[InsertOnly] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BigData] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Template_Load] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_Template_Create] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[CustomStagingView] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[BK_RefType_RepositoryStatus] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[IsSystem] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isDWH] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isSRC] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isTGT] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[isRep] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[FirstDefaultDWHView] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[createdummies] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ObjectType] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[RepositoryStatusName] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[RepositoryStatusCode] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[view_defintion_contains_business_logic] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[view_defintion] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[ToDeploy] AS varchar(8000)),'-')
												                )
												            )
												        ),
												        2
												    )
						THEN 0
						ELSE -99 END
	
	INTO #100_Dataset_011_DatasetSrcFlowDatasets
	FROM [bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets] src
	LEFT JOIN [bld].[vw_Dataset] tgt ON src.[BK] = tgt.[BK]
	
	
	
	CREATE CLUSTERED INDEX [IX_tr_100_Dataset_011_DatasetSrcFlowDatasets] ON #100_Dataset_011_DatasetSrcFlowDatasets( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	PRINT '-- new records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Dataset]
	( 
		[BK] ,
		[Code] ,
		[DatasetName] ,
		[SchemaName] ,
		[LayerName] ,
		[DataSource] ,
		[BK_DataSource] ,
		[BK_LinkedService] ,
		[BK_Layer] ,
		[BK_Schema] ,
		[BK_Group] ,
		[Shortname] ,
		[SRC_ShortName] ,
		[SRC_ObjectType] ,
		[dwhTargetShortName] ,
		[PreFix] ,
		[PostFix] ,
		[Description] ,
		[BK_ContactGroup] ,
		[bk_ContactGroup_Data_Logistics] ,
		[Data_Logistics_Info] ,
		[bk_ContactGroup_Data_Supplier] ,
		[Data_Supplier_Info] ,
		[BK_Flow] ,
		[FlowOrder] ,
		[FlowOrderDesc] ,
		[TimeStamp] ,
		[BusinessDate] ,
		[RecordSrcDate] ,
		[DistinctValues] ,
		[WhereFilter] ,
		[PartitionStatement] ,
		[BK_RefType_ObjectType] ,
		[FullLoad] ,
		[InsertOnly] ,
		[BigData] ,
		[BK_Template_Load] ,
		[BK_Template_Create] ,
		[CustomStagingView] ,
		[BK_RefType_RepositoryStatus] ,
		[IsSystem] ,
		[isDWH] ,
		[isSRC] ,
		[isTGT] ,
		[isRep] ,
		[FirstDefaultDWHView] ,
		[createdummies] ,
		[ObjectType] ,
		[RepositoryStatusName] ,
		[RepositoryStatusCode] ,
		[view_defintion_contains_business_logic] ,
		[view_defintion] ,
		[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[DatasetName] ,
		src.[SchemaName] ,
		src.[LayerName] ,
		src.[DataSource] ,
		src.[BK_DataSource] ,
		src.[BK_LinkedService] ,
		src.[BK_Layer] ,
		src.[BK_Schema] ,
		src.[BK_Group] ,
		src.[Shortname] ,
		src.[SRC_ShortName] ,
		src.[SRC_ObjectType] ,
		src.[dwhTargetShortName] ,
		src.[PreFix] ,
		src.[PostFix] ,
		src.[Description] ,
		src.[BK_ContactGroup] ,
		src.[bk_ContactGroup_Data_Logistics] ,
		src.[Data_Logistics_Info] ,
		src.[bk_ContactGroup_Data_Supplier] ,
		src.[Data_Supplier_Info] ,
		src.[BK_Flow] ,
		src.[FlowOrder] ,
		src.[FlowOrderDesc] ,
		src.[TimeStamp] ,
		src.[BusinessDate] ,
		src.[RecordSrcDate] ,
		src.[DistinctValues] ,
		src.[WhereFilter] ,
		src.[PartitionStatement] ,
		src.[BK_RefType_ObjectType] ,
		src.[FullLoad] ,
		src.[InsertOnly] ,
		src.[BigData] ,
		src.[BK_Template_Load] ,
		src.[BK_Template_Create] ,
		src.[CustomStagingView] ,
		src.[BK_RefType_RepositoryStatus] ,
		src.[IsSystem] ,
		src.[isDWH] ,
		src.[isSRC] ,
		src.[isTGT] ,
		src.[isRep] ,
		src.[FirstDefaultDWHView] ,
		src.[createdummies] ,
		src.[ObjectType] ,
		src.[RepositoryStatusName] ,
		src.[RepositoryStatusCode] ,
		src.[view_defintion_contains_business_logic] ,
		src.[view_defintion] ,
		src.[ToDeploy] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets] src
	JOIN #100_Dataset_011_DatasetSrcFlowDatasets h ON h.[mta_BK] = src.[BK]
	LEFT JOIN [bld].[vw_Dataset] tgt ON h.[mta_BKH] = tgt.[mta_BKH] 
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 1 AND tgt.[mta_BKH] IS null
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Dataset]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- changed records:'
	SET @StartDateTime = getdate()
	
		INSERT INTO [bld].[Dataset]
	( 
		[BK] ,
		[Code] ,
		[DatasetName] ,
		[SchemaName] ,
		[LayerName] ,
		[DataSource] ,
		[BK_DataSource] ,
		[BK_LinkedService] ,
		[BK_Layer] ,
		[BK_Schema] ,
		[BK_Group] ,
		[Shortname] ,
		[SRC_ShortName] ,
		[SRC_ObjectType] ,
		[dwhTargetShortName] ,
		[PreFix] ,
		[PostFix] ,
		[Description] ,
		[BK_ContactGroup] ,
		[bk_ContactGroup_Data_Logistics] ,
		[Data_Logistics_Info] ,
		[bk_ContactGroup_Data_Supplier] ,
		[Data_Supplier_Info] ,
		[BK_Flow] ,
		[FlowOrder] ,
		[FlowOrderDesc] ,
		[TimeStamp] ,
		[BusinessDate] ,
		[RecordSrcDate] ,
		[DistinctValues] ,
		[WhereFilter] ,
		[PartitionStatement] ,
		[BK_RefType_ObjectType] ,
		[FullLoad] ,
		[InsertOnly] ,
		[BigData] ,
		[BK_Template_Load] ,
		[BK_Template_Create] ,
		[CustomStagingView] ,
		[BK_RefType_RepositoryStatus] ,
		[IsSystem] ,
		[isDWH] ,
		[isSRC] ,
		[isTGT] ,
		[isRep] ,
		[FirstDefaultDWHView] ,
		[createdummies] ,
		[ObjectType] ,
		[RepositoryStatusName] ,
		[RepositoryStatusCode] ,
		[view_defintion_contains_business_logic] ,
		[view_defintion] ,
		[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[DatasetName] ,
		src.[SchemaName] ,
		src.[LayerName] ,
		src.[DataSource] ,
		src.[BK_DataSource] ,
		src.[BK_LinkedService] ,
		src.[BK_Layer] ,
		src.[BK_Schema] ,
		src.[BK_Group] ,
		src.[Shortname] ,
		src.[SRC_ShortName] ,
		src.[SRC_ObjectType] ,
		src.[dwhTargetShortName] ,
		src.[PreFix] ,
		src.[PostFix] ,
		src.[Description] ,
		src.[BK_ContactGroup] ,
		src.[bk_ContactGroup_Data_Logistics] ,
		src.[Data_Logistics_Info] ,
		src.[bk_ContactGroup_Data_Supplier] ,
		src.[Data_Supplier_Info] ,
		src.[BK_Flow] ,
		src.[FlowOrder] ,
		src.[FlowOrderDesc] ,
		src.[TimeStamp] ,
		src.[BusinessDate] ,
		src.[RecordSrcDate] ,
		src.[DistinctValues] ,
		src.[WhereFilter] ,
		src.[PartitionStatement] ,
		src.[BK_RefType_ObjectType] ,
		src.[FullLoad] ,
		src.[InsertOnly] ,
		src.[BigData] ,
		src.[BK_Template_Load] ,
		src.[BK_Template_Create] ,
		src.[CustomStagingView] ,
		src.[BK_RefType_RepositoryStatus] ,
		src.[IsSystem] ,
		src.[isDWH] ,
		src.[isSRC] ,
		src.[isTGT] ,
		src.[isRep] ,
		src.[FirstDefaultDWHView] ,
		src.[createdummies] ,
		src.[ObjectType] ,
		src.[RepositoryStatusName] ,
		src.[RepositoryStatusCode] ,
		src.[view_defintion_contains_business_logic] ,
		src.[view_defintion] ,
		src.[ToDeploy] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets] src
	JOIN #100_Dataset_011_DatasetSrcFlowDatasets h ON h.[mta_BK] = src.[BK]
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 0

	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Dataset]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- deleted records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Dataset]
	
	( 
	
		[BK] ,
		[Code] ,
		[DatasetName] ,
		[SchemaName] ,
		[LayerName] ,
		[DataSource] ,
		[BK_DataSource] ,
		[BK_LinkedService] ,
		[BK_Layer] ,
		[BK_Schema] ,
		[BK_Group] ,
		[Shortname] ,
		[SRC_ShortName] ,
		[SRC_ObjectType] ,
		[dwhTargetShortName] ,
		[PreFix] ,
		[PostFix] ,
		[Description] ,
		[BK_ContactGroup] ,
		[bk_ContactGroup_Data_Logistics] ,
		[Data_Logistics_Info] ,
		[bk_ContactGroup_Data_Supplier] ,
		[Data_Supplier_Info] ,
		[BK_Flow] ,
		[FlowOrder] ,
		[FlowOrderDesc] ,
		[TimeStamp] ,
		[BusinessDate] ,
		[RecordSrcDate] ,
		[DistinctValues] ,
		[WhereFilter] ,
		[PartitionStatement] ,
		[BK_RefType_ObjectType] ,
		[FullLoad] ,
		[InsertOnly] ,
		[BigData] ,
		[BK_Template_Load] ,
		[BK_Template_Create] ,
		[CustomStagingView] ,
		[BK_RefType_RepositoryStatus] ,
		[IsSystem] ,
		[isDWH] ,
		[isSRC] ,
		[isTGT] ,
		[isRep] ,
		[FirstDefaultDWHView] ,
		[createdummies] ,
		[ObjectType] ,
		[RepositoryStatusName] ,
		[RepositoryStatusCode] ,
		[view_defintion_contains_business_logic] ,
		[view_defintion] ,
		[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[BK] ,
		src.[Code] ,
		src.[DatasetName] ,
		src.[SchemaName] ,
		src.[LayerName] ,
		src.[DataSource] ,
		src.[BK_DataSource] ,
		src.[BK_LinkedService] ,
		src.[BK_Layer] ,
		src.[BK_Schema] ,
		src.[BK_Group] ,
		src.[Shortname] ,
		src.[SRC_ShortName] ,
		src.[SRC_ObjectType] ,
		src.[dwhTargetShortName] ,
		src.[PreFix] ,
		src.[PostFix] ,
		src.[Description] ,
		src.[BK_ContactGroup] ,
		src.[bk_ContactGroup_Data_Logistics] ,
		src.[Data_Logistics_Info] ,
		src.[bk_ContactGroup_Data_Supplier] ,
		src.[Data_Supplier_Info] ,
		src.[BK_Flow] ,
		src.[FlowOrder] ,
		src.[FlowOrderDesc] ,
		src.[TimeStamp] ,
		src.[BusinessDate] ,
		src.[RecordSrcDate] ,
		src.[DistinctValues] ,
		src.[WhereFilter] ,
		src.[PartitionStatement] ,
		src.[BK_RefType_ObjectType] ,
		src.[FullLoad] ,
		src.[InsertOnly] ,
		src.[BigData] ,
		src.[BK_Template_Load] ,
		src.[BK_Template_Create] ,
		src.[CustomStagingView] ,
		src.[BK_RefType_RepositoryStatus] ,
		src.[IsSystem] ,
		src.[isDWH] ,
		src.[isSRC] ,
		src.[isTGT] ,
		src.[isRep] ,
		src.[FirstDefaultDWHView] ,
		src.[createdummies] ,
		src.[ObjectType] ,
		src.[RepositoryStatusName] ,
		src.[RepositoryStatusCode] ,
		src.[view_defintion_contains_business_logic] ,
		src.[view_defintion] ,
		src.[ToDeploy] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	FROM  [bld].[vw_Dataset] src
	LEFT JOIN #100_Dataset_011_DatasetSrcFlowDatasets h ON h.[mta_BKH] = src.[mta_BKH] AND h.[mta_Source] = src.[mta_Source]
	WHERE 1=1 AND h.[mta_BKH] IS null AND  src.mta_Source = '[bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets]'
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Dataset]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	IF OBJECT_ID('tempdb..#100_Dataset_011_DatasetSrcFlowDatasets') IS NOT NULL 
DROP TABLE #100_Dataset_011_DatasetSrcFlowDatasets;
	
	SET @EndDateTime =  getutcdate()
	SET @Duration = datediff(SS,@StartDateTime, @EndDateTime)
	PRINT 'Load "load_100_Dataset_011_DatasetSrcFlowDatasets" took ' +CAST(@Duration AS varchar(10))+ ' second(s)'