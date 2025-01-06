﻿
	create proc [bld].[load_100_Dataset_010_DatasetSrc] as
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:27
	
	exec [bld].[load_100_Dataset_010_DatasetSrc]*/

	
	Declare @RoutineName	varchar(8000)	= 'load_100_Dataset_010_DatasetSrc'
	Declare @StartDateTime	datetime2		=  getutcdate()
	Declare @EndDateTime	datetime2		
	Declare @Duration		bigint



	-- Create a helper temp table
	If OBJECT_ID('tempdb..#100_Dataset_010_DatasetSrc') IS NOT NULL 
	Drop Table #100_Dataset_010_DatasetSrc ;
	Print '-- create temp table:'
	Select
	  mta_BK		= src.[BK]
	, mta_BKH		= Convert(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= Convert(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(Cast(src.[BK] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Code] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DatasetName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SchemaName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DataSource] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Schema] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Group] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Segment] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Bucket] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ShortName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SRC_ShortName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[dwhTargetShortName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ReplaceAttributeNames] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Prefix] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[PostFix] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Description] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_ContactGroup] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[bk_ContactGroup_Data_Logistics] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Data_Logistics_Info] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[bk_ContactGroup_Data_Supplier] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Data_Supplier_Info] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Flow] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[TimeStamp] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BusinessDate] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[RecordSrcDate] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[WhereFilter] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SCD] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DistinctValues] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[PartitionStatement] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_RefType_ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FullLoad] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[InsertOnly] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[InsertNoCheck] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BigData] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Template_Load] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Template_Create] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[CustomStagingView] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_RefType_RepositoryStatus] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[IsSystem] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[LayerName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_LinkedService] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[LinkedServiceName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_DataSource] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Layer] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[CreateDummies] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FlowOrder] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FlowOrderDesc] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FirstDefaultDWHView] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DatasetType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SRC_ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[TGT_ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[RepositoryStatusName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[RepositoryStatusCode] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isDWH] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isSRC] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isTGT] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isRep] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[view_defintion_contains_business_logic] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[view_defintion] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ToDeploy] as varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_100_Dataset_010_DatasetSrc]'
	, mta_RecType	= case 
												when tgt.[BK] is null then 1
												when tgt.[mta_RH] !=  Convert(char(64),(Hashbytes('sha2_512',upper(ISNULL(Cast(src.[BK] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Code] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DatasetName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SchemaName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DataSource] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Schema] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Group] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Segment] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Bucket] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ShortName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SRC_ShortName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[dwhTargetShortName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ReplaceAttributeNames] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Prefix] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[PostFix] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Description] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_ContactGroup] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[bk_ContactGroup_Data_Logistics] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Data_Logistics_Info] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[bk_ContactGroup_Data_Supplier] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Data_Supplier_Info] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Flow] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[TimeStamp] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BusinessDate] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[RecordSrcDate] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[WhereFilter] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SCD] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DistinctValues] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[PartitionStatement] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_RefType_ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FullLoad] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[InsertOnly] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[InsertNoCheck] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BigData] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Template_Load] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Template_Create] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[CustomStagingView] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_RefType_RepositoryStatus] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[IsSystem] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[LayerName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_LinkedService] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[LinkedServiceName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_DataSource] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Layer] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[CreateDummies] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FlowOrder] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FlowOrderDesc] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[FirstDefaultDWHView] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[DatasetType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[SRC_ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[TGT_ObjectType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[RepositoryStatusName] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[RepositoryStatusCode] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isDWH] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isSRC] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isTGT] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[isRep] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[view_defintion_contains_business_logic] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[view_defintion] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ToDeploy] as varchar(8000)),'-') ))),2)
						then 0
						else -99 end
	
	Into #100_Dataset_010_DatasetSrc
	From [bld].[tr_100_Dataset_010_DatasetSrc] src
	Left join [bld].[vw_Dataset] tgt on src.[BK] = tgt.[BK]
	
	
	
	Create Clustered INDEX [IX_tr_100_Dataset_010_DatasetSrc] ON #100_Dataset_010_DatasetSrc( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	Print '-- new records:'
	
	set @StartDateTime = getdate()
	
	Insert Into [bld].[Dataset]
	( 
		[BK] ,[Code] ,[DatasetName] ,[SchemaName] ,[DataSource] ,[BK_Schema] ,[BK_Group] ,[BK_Segment] ,[BK_Bucket] ,[ShortName] ,[SRC_ShortName] ,[dwhTargetShortName] ,[ReplaceAttributeNames] ,[Prefix] ,[PostFix] ,[Description] ,[BK_ContactGroup] ,[bk_ContactGroup_Data_Logistics] ,[Data_Logistics_Info] ,[bk_ContactGroup_Data_Supplier] ,[Data_Supplier_Info] ,[BK_Flow] ,[TimeStamp] ,[BusinessDate] ,[RecordSrcDate] ,[WhereFilter] ,[SCD] ,[DistinctValues] ,[PartitionStatement] ,[BK_RefType_ObjectType] ,[FullLoad] ,[InsertOnly] ,[InsertNoCheck] ,[BigData] ,[BK_Template_Load] ,[BK_Template_Create] ,[CustomStagingView] ,[BK_RefType_RepositoryStatus] ,[IsSystem] ,[LayerName] ,[BK_LinkedService] ,[LinkedServiceName] ,[BK_DataSource] ,[BK_Layer] ,[CreateDummies] ,[FlowOrder] ,[FlowOrderDesc] ,[FirstDefaultDWHView] ,[DatasetType] ,[ObjectType] ,[SRC_ObjectType] ,[TGT_ObjectType] ,[RepositoryStatusName] ,[RepositoryStatusCode] ,[isDWH] ,[isSRC] ,[isTGT] ,[isRep] ,[view_defintion_contains_business_logic] ,[view_defintion] ,[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[Code] ,src.[DatasetName] ,src.[SchemaName] ,src.[DataSource] ,src.[BK_Schema] ,src.[BK_Group] ,src.[BK_Segment] ,src.[BK_Bucket] ,src.[ShortName] ,src.[SRC_ShortName] ,src.[dwhTargetShortName] ,src.[ReplaceAttributeNames] ,src.[Prefix] ,src.[PostFix] ,src.[Description] ,src.[BK_ContactGroup] ,src.[bk_ContactGroup_Data_Logistics] ,src.[Data_Logistics_Info] ,src.[bk_ContactGroup_Data_Supplier] ,src.[Data_Supplier_Info] ,src.[BK_Flow] ,src.[TimeStamp] ,src.[BusinessDate] ,src.[RecordSrcDate] ,src.[WhereFilter] ,src.[SCD] ,src.[DistinctValues] ,src.[PartitionStatement] ,src.[BK_RefType_ObjectType] ,src.[FullLoad] ,src.[InsertOnly] ,src.[InsertNoCheck] ,src.[BigData] ,src.[BK_Template_Load] ,src.[BK_Template_Create] ,src.[CustomStagingView] ,src.[BK_RefType_RepositoryStatus] ,src.[IsSystem] ,src.[LayerName] ,src.[BK_LinkedService] ,src.[LinkedServiceName] ,src.[BK_DataSource] ,src.[BK_Layer] ,src.[CreateDummies] ,src.[FlowOrder] ,src.[FlowOrderDesc] ,src.[FirstDefaultDWHView] ,src.[DatasetType] ,src.[ObjectType] ,src.[SRC_ObjectType] ,src.[TGT_ObjectType] ,src.[RepositoryStatusName] ,src.[RepositoryStatusCode] ,src.[isDWH] ,src.[isSRC] ,src.[isTGT] ,src.[isRep] ,src.[view_defintion_contains_business_logic] ,src.[view_defintion] ,src.[ToDeploy] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	From  [bld].[tr_100_Dataset_010_DatasetSrc] src
	Join #100_Dataset_010_DatasetSrc h on h.[mta_BK] = src.[BK]
	Left Join [bld].[vw_Dataset] tgt on h.[mta_BKH] = tgt.[mta_BKH] 
	Where 1=1 and cast(h.mta_RecType as int) = 1 and tgt.[mta_BKH] is null
	
	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Dataset]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	Print '-- changed records:'
	set @StartDateTime = getdate()
	
		Insert Into [bld].[Dataset]
	( 
		[BK] ,[Code] ,[DatasetName] ,[SchemaName] ,[DataSource] ,[BK_Schema] ,[BK_Group] ,[BK_Segment] ,[BK_Bucket] ,[ShortName] ,[SRC_ShortName] ,[dwhTargetShortName] ,[ReplaceAttributeNames] ,[Prefix] ,[PostFix] ,[Description] ,[BK_ContactGroup] ,[bk_ContactGroup_Data_Logistics] ,[Data_Logistics_Info] ,[bk_ContactGroup_Data_Supplier] ,[Data_Supplier_Info] ,[BK_Flow] ,[TimeStamp] ,[BusinessDate] ,[RecordSrcDate] ,[WhereFilter] ,[SCD] ,[DistinctValues] ,[PartitionStatement] ,[BK_RefType_ObjectType] ,[FullLoad] ,[InsertOnly] ,[InsertNoCheck] ,[BigData] ,[BK_Template_Load] ,[BK_Template_Create] ,[CustomStagingView] ,[BK_RefType_RepositoryStatus] ,[IsSystem] ,[LayerName] ,[BK_LinkedService] ,[LinkedServiceName] ,[BK_DataSource] ,[BK_Layer] ,[CreateDummies] ,[FlowOrder] ,[FlowOrderDesc] ,[FirstDefaultDWHView] ,[DatasetType] ,[ObjectType] ,[SRC_ObjectType] ,[TGT_ObjectType] ,[RepositoryStatusName] ,[RepositoryStatusCode] ,[isDWH] ,[isSRC] ,[isTGT] ,[isRep] ,[view_defintion_contains_business_logic] ,[view_defintion] ,[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[Code] ,src.[DatasetName] ,src.[SchemaName] ,src.[DataSource] ,src.[BK_Schema] ,src.[BK_Group] ,src.[BK_Segment] ,src.[BK_Bucket] ,src.[ShortName] ,src.[SRC_ShortName] ,src.[dwhTargetShortName] ,src.[ReplaceAttributeNames] ,src.[Prefix] ,src.[PostFix] ,src.[Description] ,src.[BK_ContactGroup] ,src.[bk_ContactGroup_Data_Logistics] ,src.[Data_Logistics_Info] ,src.[bk_ContactGroup_Data_Supplier] ,src.[Data_Supplier_Info] ,src.[BK_Flow] ,src.[TimeStamp] ,src.[BusinessDate] ,src.[RecordSrcDate] ,src.[WhereFilter] ,src.[SCD] ,src.[DistinctValues] ,src.[PartitionStatement] ,src.[BK_RefType_ObjectType] ,src.[FullLoad] ,src.[InsertOnly] ,src.[InsertNoCheck] ,src.[BigData] ,src.[BK_Template_Load] ,src.[BK_Template_Create] ,src.[CustomStagingView] ,src.[BK_RefType_RepositoryStatus] ,src.[IsSystem] ,src.[LayerName] ,src.[BK_LinkedService] ,src.[LinkedServiceName] ,src.[BK_DataSource] ,src.[BK_Layer] ,src.[CreateDummies] ,src.[FlowOrder] ,src.[FlowOrderDesc] ,src.[FirstDefaultDWHView] ,src.[DatasetType] ,src.[ObjectType] ,src.[SRC_ObjectType] ,src.[TGT_ObjectType] ,src.[RepositoryStatusName] ,src.[RepositoryStatusCode] ,src.[isDWH] ,src.[isSRC] ,src.[isTGT] ,src.[isRep] ,src.[view_defintion_contains_business_logic] ,src.[view_defintion] ,src.[ToDeploy] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	From  [bld].[tr_100_Dataset_010_DatasetSrc] src
	Join #100_Dataset_010_DatasetSrc h on h.[mta_BK] = src.[BK]
	Where 1=1 and cast(h.mta_RecType as int) = 0

	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Dataset]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	Print '-- deleted records:'
	
	set @StartDateTime = getdate()
	
	Insert Into [bld].[Dataset]
	
	( 
	
		[BK] ,[Code] ,[DatasetName] ,[SchemaName] ,[DataSource] ,[BK_Schema] ,[BK_Group] ,[BK_Segment] ,[BK_Bucket] ,[ShortName] ,[SRC_ShortName] ,[dwhTargetShortName] ,[ReplaceAttributeNames] ,[Prefix] ,[PostFix] ,[Description] ,[BK_ContactGroup] ,[bk_ContactGroup_Data_Logistics] ,[Data_Logistics_Info] ,[bk_ContactGroup_Data_Supplier] ,[Data_Supplier_Info] ,[BK_Flow] ,[TimeStamp] ,[BusinessDate] ,[RecordSrcDate] ,[WhereFilter] ,[SCD] ,[DistinctValues] ,[PartitionStatement] ,[BK_RefType_ObjectType] ,[FullLoad] ,[InsertOnly] ,[InsertNoCheck] ,[BigData] ,[BK_Template_Load] ,[BK_Template_Create] ,[CustomStagingView] ,[BK_RefType_RepositoryStatus] ,[IsSystem] ,[LayerName] ,[BK_LinkedService] ,[LinkedServiceName] ,[BK_DataSource] ,[BK_Layer] ,[CreateDummies] ,[FlowOrder] ,[FlowOrderDesc] ,[FirstDefaultDWHView] ,[DatasetType] ,[ObjectType] ,[SRC_ObjectType] ,[TGT_ObjectType] ,[RepositoryStatusName] ,[RepositoryStatusCode] ,[isDWH] ,[isSRC] ,[isTGT] ,[isRep] ,[view_defintion_contains_business_logic] ,[view_defintion] ,[ToDeploy] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[Code] ,src.[DatasetName] ,src.[SchemaName] ,src.[DataSource] ,src.[BK_Schema] ,src.[BK_Group] ,src.[BK_Segment] ,src.[BK_Bucket] ,src.[ShortName] ,src.[SRC_ShortName] ,src.[dwhTargetShortName] ,src.[ReplaceAttributeNames] ,src.[Prefix] ,src.[PostFix] ,src.[Description] ,src.[BK_ContactGroup] ,src.[bk_ContactGroup_Data_Logistics] ,src.[Data_Logistics_Info] ,src.[bk_ContactGroup_Data_Supplier] ,src.[Data_Supplier_Info] ,src.[BK_Flow] ,src.[TimeStamp] ,src.[BusinessDate] ,src.[RecordSrcDate] ,src.[WhereFilter] ,src.[SCD] ,src.[DistinctValues] ,src.[PartitionStatement] ,src.[BK_RefType_ObjectType] ,src.[FullLoad] ,src.[InsertOnly] ,src.[InsertNoCheck] ,src.[BigData] ,src.[BK_Template_Load] ,src.[BK_Template_Create] ,src.[CustomStagingView] ,src.[BK_RefType_RepositoryStatus] ,src.[IsSystem] ,src.[LayerName] ,src.[BK_LinkedService] ,src.[LinkedServiceName] ,src.[BK_DataSource] ,src.[BK_Layer] ,src.[CreateDummies] ,src.[FlowOrder] ,src.[FlowOrderDesc] ,src.[FirstDefaultDWHView] ,src.[DatasetType] ,src.[ObjectType] ,src.[SRC_ObjectType] ,src.[TGT_ObjectType] ,src.[RepositoryStatusName] ,src.[RepositoryStatusCode] ,src.[isDWH] ,src.[isSRC] ,src.[isTGT] ,src.[isRep] ,src.[view_defintion_contains_business_logic] ,src.[view_defintion] ,src.[ToDeploy] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	From  [bld].[vw_Dataset] src
	Left Join #100_Dataset_010_DatasetSrc h on h.[mta_BKH] = src.[mta_BKH] and h.[mta_Source] = src.[mta_Source]
	Where 1=1 and h.[mta_BKH] is null and  src.mta_Source = '[bld].[tr_100_Dataset_010_DatasetSrc]'
	
	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Dataset]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	If OBJECT_ID('tempdb..#100_Dataset_010_DatasetSrc') IS NOT NULL 
Drop Table #100_Dataset_010_DatasetSrc;
	
	set @EndDateTime =  getutcdate()
	set @Duration = datediff(ss,@StartDateTime, @EndDateTime)
	print 'Load "load_100_Dataset_010_DatasetSrc" took ' +cast(@Duration as varchar(10))+ ' second(s)'