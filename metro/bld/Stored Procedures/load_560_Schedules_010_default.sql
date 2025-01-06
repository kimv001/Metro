﻿
	create proc [bld].[load_560_Schedules_010_default] as
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:28
	
	exec [bld].[load_560_Schedules_010_default]*/

	
	Declare @RoutineName	varchar(8000)	= 'load_560_Schedules_010_default'
	Declare @StartDateTime	datetime2		=  getutcdate()
	Declare @EndDateTime	datetime2		
	Declare @Duration		bigint



	-- Create a helper temp table
	If OBJECT_ID('tempdb..#560_Schedules_010_default') IS NOT NULL 
	Drop Table #560_Schedules_010_default ;
	Print '-- create temp table:'
	Select
	  mta_BK		= src.[BK]
	, mta_BKH		= Convert(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= Convert(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(Cast(src.[BK] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[schedules_group] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[dependend_on_schedules_group] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Code] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Schedule] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[TargetToLoad] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ScheduleType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ExcludeFromAllLevel] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ExcludeFromAllOther] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ProcessSourceDependencies] as varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_560_Schedules_010_default]'
	, mta_RecType	= case 
												when tgt.[BK] is null then 1
												when tgt.[mta_RH] !=  Convert(char(64),(Hashbytes('sha2_512',upper(ISNULL(Cast(src.[BK] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[schedules_group] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[dependend_on_schedules_group] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[Code] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[BK_Schedule] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[TargetToLoad] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ScheduleType] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ExcludeFromAllLevel] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ExcludeFromAllOther] as varchar(8000)),'-') +'|'+ISNULL(Cast(src.[ProcessSourceDependencies] as varchar(8000)),'-') ))),2)
						then 0
						else -99 end
	
	Into #560_Schedules_010_default
	From [bld].[tr_560_Schedules_010_default] src
	Left join [bld].[vw_Schedules] tgt on src.[BK] = tgt.[BK]
	
	
	
	Create Clustered INDEX [IX_tr_560_Schedules_010_default] ON #560_Schedules_010_default( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	Print '-- new records:'
	
	set @StartDateTime = getdate()
	
	Insert Into [bld].[Schedules]
	( 
		[BK] ,[schedules_group] ,[dependend_on_schedules_group] ,[Code] ,[BK_Schedule] ,[TargetToLoad] ,[ScheduleType] ,[ExcludeFromAllLevel] ,[ExcludeFromAllOther] ,[ProcessSourceDependencies] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[schedules_group] ,src.[dependend_on_schedules_group] ,src.[Code] ,src.[BK_Schedule] ,src.[TargetToLoad] ,src.[ScheduleType] ,src.[ExcludeFromAllLevel] ,src.[ExcludeFromAllOther] ,src.[ProcessSourceDependencies] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	From  [bld].[tr_560_Schedules_010_default] src
	Join #560_Schedules_010_default h on h.[mta_BK] = src.[BK]
	Left Join [bld].[vw_Schedules] tgt on h.[mta_BKH] = tgt.[mta_BKH] 
	Where 1=1 and cast(h.mta_RecType as int) = 1 and tgt.[mta_BKH] is null
	
	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Schedules]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	Print '-- changed records:'
	set @StartDateTime = getdate()
	
		Insert Into [bld].[Schedules]
	( 
		[BK] ,[schedules_group] ,[dependend_on_schedules_group] ,[Code] ,[BK_Schedule] ,[TargetToLoad] ,[ScheduleType] ,[ExcludeFromAllLevel] ,[ExcludeFromAllOther] ,[ProcessSourceDependencies] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[schedules_group] ,src.[dependend_on_schedules_group] ,src.[Code] ,src.[BK_Schedule] ,src.[TargetToLoad] ,src.[ScheduleType] ,src.[ExcludeFromAllLevel] ,src.[ExcludeFromAllOther] ,src.[ProcessSourceDependencies] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	From  [bld].[tr_560_Schedules_010_default] src
	Join #560_Schedules_010_default h on h.[mta_BK] = src.[BK]
	Where 1=1 and cast(h.mta_RecType as int) = 0

	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Schedules]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	Print '-- deleted records:'
	
	set @StartDateTime = getdate()
	
	Insert Into [bld].[Schedules]
	
	( 
	
		[BK] ,[schedules_group] ,[dependend_on_schedules_group] ,[Code] ,[BK_Schedule] ,[TargetToLoad] ,[ScheduleType] ,[ExcludeFromAllLevel] ,[ExcludeFromAllOther] ,[ProcessSourceDependencies] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	select 
		src.[BK] ,src.[schedules_group] ,src.[dependend_on_schedules_group] ,src.[Code] ,src.[BK_Schedule] ,src.[TargetToLoad] ,src.[ScheduleType] ,src.[ExcludeFromAllLevel] ,src.[ExcludeFromAllOther] ,src.[ProcessSourceDependencies] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	From  [bld].[vw_Schedules] src
	Left Join #560_Schedules_010_default h on h.[mta_BKH] = src.[mta_BKH] and h.[mta_Source] = src.[mta_Source]
	Where 1=1 and h.[mta_BKH] is null and  src.mta_Source = '[bld].[tr_560_Schedules_010_default]'
	
	
	set @EndDateTime = getutcdate()
	exec [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Schedules]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	If OBJECT_ID('tempdb..#560_Schedules_010_default') IS NOT NULL 
Drop Table #560_Schedules_010_default;
	
	set @EndDateTime =  getutcdate()
	set @Duration = datediff(ss,@StartDateTime, @EndDateTime)
	print 'Load "load_560_Schedules_010_default" took ' +cast(@Duration as varchar(10))+ ' second(s)'