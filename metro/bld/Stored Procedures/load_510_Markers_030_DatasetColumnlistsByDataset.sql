﻿
	create proc [bld].[load_510_Markers_030_DatasetColumnlistsByDataset] as
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:28
	makes use of Smartload!
	exec [bld].[load_510_Markers_030_DatasetColumnlistsByDataset]*/

	
	Declare @RoutineName	varchar(8000)	= 'load_510_Markers_030_DatasetColumnlistsByDataset'
	Declare @StartDateTime	datetime2		=  getutcdate()
	Declare @EndDateTime	datetime2		
	Declare @Duration		bigint



	-- Create a helper temp table
	If OBJECT_ID('tempdb..#510_Markers_030_DatasetColumnlistsByDataset') IS NOT NULL 
	Drop Table #510_Markers_030_DatasetColumnlistsByDataset ;
	Print '-- create temp table:'
	Select
	  mta_BK		= src.[BK]
	, mta_BKH		= Convert(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= Convert(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(Cast(src.[BK] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Dataset] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Code] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[MarkerType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[MarkerDescription] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Marker] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[MarkerValue] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Pre] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Post] as varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_510_Markers_030_DatasetColumnlistsByDataset]'
	, mta_RecType	= diff.RecType
	Into #510_Markers_030_DatasetColumnlistsByDataset
	From [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset] src
	Left join [bld].[vw_Markers] tgt on src.[BK] = tgt.[BK]
	join [bld].[vw_MarkersSmartLoad] diff on diff.code =  src.code
	where 1=1  and  cast(diff.RecType as int) > -99
	
	Create Clustered INDEX [IX_tr_510_Markers_030_DatasetColumnlistsByDataset] ON #510_Markers_030_DatasetColumnlistsByDataset( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	Print '-- new records:'
	
	set @StartDateTime = getdate()
	
	Insert Into [bld].[Markers]
	( 
		[BK] ,[BK_Dataset] ,[Code] ,[MarkerType] ,[MarkerDescription] ,[Marker] ,[MarkerValue] ,[Pre] ,[Post] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[BK_Dataset] ,src.[Code] ,src.[MarkerType] ,src.[MarkerDescription] ,src.[Marker] ,src.[MarkerValue] ,src.[Pre] ,src.[Post] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	From  [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset] src
	Join #510_Markers_030_DatasetColumnlistsByDataset h on h.[mta_BK] = src.[BK]
	Left Join [bld].[vw_Markers] tgt on h.[mta_BKH] = tgt.[mta_BKH] 
	Where 1=1 and cast(h.mta_RecType as int) = 1 and tgt.[mta_BKH] is null
	
	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Markers]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	Print '-- changed records:'
	set @StartDateTime = getdate()
	
		Insert Into [bld].[Markers]
	( 
		[BK] ,[BK_Dataset] ,[Code] ,[MarkerType] ,[MarkerDescription] ,[Marker] ,[MarkerValue] ,[Pre] ,[Post] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[BK_Dataset] ,src.[Code] ,src.[MarkerType] ,src.[MarkerDescription] ,src.[Marker] ,src.[MarkerValue] ,src.[Pre] ,src.[Post] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	From  [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset] src
	Join #510_Markers_030_DatasetColumnlistsByDataset h on h.[mta_BK] = src.[BK]
	Where 1=1 and cast(h.mta_RecType as int) = 0

	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Markers]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	Print '-- deleted records:'
	
	set @StartDateTime = getdate()
	
	Insert Into [bld].[Markers]
	
	( 
	
		[BK] ,[BK_Dataset] ,[Code] ,[MarkerType] ,[MarkerDescription] ,[Marker] ,[MarkerValue] ,[Pre] ,[Post] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[BK_Dataset] ,src.[Code] ,src.[MarkerType] ,src.[MarkerDescription] ,src.[Marker] ,src.[MarkerValue] ,src.[Pre] ,src.[Post] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	From  [bld].[vw_Markers] src
	Left Join #510_Markers_030_DatasetColumnlistsByDataset h on h.[mta_BKH] = src.[mta_BKH] and h.[mta_Source] = src.[mta_Source]
	Where 1=1 and h.[mta_BKH] is null and  src.mta_Source = '[bld].[tr_510_Markers_030_DatasetColumnlistsByDataset]'
	and  h.mta_RecType =-1
	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Markers]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	If OBJECT_ID('tempdb..#510_Markers_030_DatasetColumnlistsByDataset') IS NOT NULL 
Drop Table #510_Markers_030_DatasetColumnlistsByDataset;
	
	set @EndDateTime =  getutcdate()
	set @Duration = datediff(ss,@StartDateTime, @EndDateTime)
	print 'Load "load_510_Markers_030_DatasetColumnlistsByDataset" took ' +cast(@Duration as varchar(10))+ ' second(s)'