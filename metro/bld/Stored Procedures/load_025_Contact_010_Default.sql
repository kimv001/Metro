﻿
	CREATE PROC [bld].[load_025_Contact_010_Default] AS
	/*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:26
	
	exec [bld].[load_025_Contact_010_Default]*/

	
	DECLARE @RoutineName	varchar(8000)	= 'load_025_Contact_010_Default'
	DECLARE @StartDateTime	datetime2		=  getutcdate()
	DECLARE @EndDateTime	datetime2		
	DECLARE @Duration		bigint



	-- Create a helper temp table
	IF OBJECT_ID('tempdb..#025_Contact_010_Default') IS NOT NULL 
	DROP TABLE #025_Contact_010_Default ;
	PRINT '-- create temp table:'
	SELECT
	  mta_BK		= src.[BK]
	, mta_BKH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(src.BK) )),2)
	, mta_RH		= CONVERT(char(64),(Hashbytes('sha2_512',upper(
								ISNULL(CAST(src.[bk] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[code] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[bk_contactgroup] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[contactgroup] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[contactrole] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[main_contact] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[alert_contact] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[contactperson_name] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[contactperson_department] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[contacperson_phonenumber] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[contactperson_mailadress] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[contactperson_active] AS varchar(8000)),'-')
								+'|'
								+ISNULL(CAST(src.[rn_contact] AS varchar(8000)),'-') 
							))),2)
	, mta_Source	= '[bld].[tr_025_Contact_010_Default]'
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
												                    ISNULL(CAST(src.[bk] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[code] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[bk_contactgroup] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[contactgroup] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[contactrole] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[main_contact] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[alert_contact] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[contactperson_name] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[contactperson_department] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[contacperson_phonenumber] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[contactperson_mailadress] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[contactperson_active] AS varchar(8000)),'-')
												                    +'|'
												                    +ISNULL(CAST(src.[rn_contact] AS varchar(8000)),'-')
												                )
												            )
												        ),
												        2
												    )
						THEN 0
						ELSE -99 END
	
	INTO #025_Contact_010_Default
	FROM [bld].[tr_025_Contact_010_Default] src
	LEFT JOIN [bld].[vw_Contact] tgt ON src.[BK] = tgt.[BK]
	
	
	
	CREATE CLUSTERED INDEX [IX_tr_025_Contact_010_Default] ON #025_Contact_010_Default( [mta_BKH] ASC,[mta_RH] ASC)
	
	
	--------------------- start loading data
	
	PRINT '-- new records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Contact]
	( 
		[bk] ,
		[code] ,
		[bk_contactgroup] ,
		[contactgroup] ,
		[contactrole] ,
		[main_contact] ,
		[alert_contact] ,
		[contactperson_name] ,
		[contactperson_department] ,
		[contacperson_phonenumber] ,
		[contactperson_mailadress] ,
		[contactperson_active] ,
		[rn_contact] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[bk] ,
		src.[code] ,
		src.[bk_contactgroup] ,
		src.[contactgroup] ,
		src.[contactrole] ,
		src.[main_contact] ,
		src.[alert_contact] ,
		src.[contactperson_name] ,
		src.[contactperson_department] ,
		src.[contacperson_phonenumber] ,
		src.[contactperson_mailadress] ,
		src.[contactperson_active] ,
		src.[rn_contact] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_025_Contact_010_Default] src
	JOIN #025_Contact_010_Default h ON h.[mta_BK] = src.[BK]
	LEFT JOIN [bld].[vw_Contact] tgt ON h.[mta_BKH] = tgt.[mta_BKH] 
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 1 AND tgt.[mta_BKH] IS null
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
							@LogAction		= 'INSERT - NEW', 
							@LogNote		= 'New Records',
							@LogProcedure	= @RoutineName,
							@LogSQL			= 'Insert Into [bld].[Contact]',
							@LogRowCount	= @@ROWCOUNT,
							@Log_TimeStart  = @StartDateTime,
							@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- changed records:'
	SET @StartDateTime = getdate()
	
		INSERT INTO [bld].[Contact]
	( 
		[bk] ,
		[code] ,
		[bk_contactgroup] ,
		[contactgroup] ,
		[contactrole] ,
		[main_contact] ,
		[alert_contact] ,
		[contactperson_name] ,
		[contactperson_department] ,
		[contacperson_phonenumber] ,
		[contactperson_mailadress] ,
		[contactperson_active] ,
		[rn_contact] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[bk] ,
		src.[code] ,
		src.[bk_contactgroup] ,
		src.[contactgroup] ,
		src.[contactrole] ,
		src.[main_contact] ,
		src.[alert_contact] ,
		src.[contactperson_name] ,
		src.[contactperson_department] ,
		src.[contacperson_phonenumber] ,
		src.[contactperson_mailadress] ,
		src.[contactperson_active] ,
		src.[rn_contact] 
		, h.[mta_BK], h.[mta_BKH], h.[mta_RH], h.[mta_Source], h.[mta_RecType]
	FROM  [bld].[tr_025_Contact_010_Default] src
	JOIN #025_Contact_010_Default h ON h.[mta_BK] = src.[BK]
	WHERE 1=1 AND CAST(h.mta_RecType AS int) = 0

	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - CHG', 
												@LogNote		= 'Changed Records',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Contact]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime;
	
	PRINT '-- deleted records:'
	
	SET @StartDateTime = getdate()
	
	INSERT INTO [bld].[Contact]
	
	( 
	
		[bk] ,
		[code] ,
		[bk_contactgroup] ,
		[contactgroup] ,
		[contactrole] ,
		[main_contact] ,
		[alert_contact] ,
		[contactperson_name] ,
		[contactperson_department] ,
		[contacperson_phonenumber] ,
		[contactperson_mailadress] ,
		[contactperson_active] ,
		[rn_contact] 
		, [mta_BK], [mta_BKH], [mta_RH], [mta_Source], [mta_RecType]) 
	SELECT 
		src.[bk] ,
		src.[code] ,
		src.[bk_contactgroup] ,
		src.[contactgroup] ,
		src.[contactrole] ,
		src.[main_contact] ,
		src.[alert_contact] ,
		src.[contactperson_name] ,
		src.[contactperson_department] ,
		src.[contacperson_phonenumber] ,
		src.[contactperson_mailadress] ,
		src.[contactperson_active] ,
		src.[rn_contact] 
		, src.[mta_BK], src.[mta_BKH], src.[mta_RH], src.[mta_Source], [mta_RecType] = -1
	FROM  [bld].[vw_Contact] src
	LEFT JOIN #025_Contact_010_Default h ON h.[mta_BKH] = src.[mta_BKH] AND h.[mta_Source] = src.[mta_Source]
	WHERE 1=1 AND h.[mta_BKH] IS null AND  src.mta_Source = '[bld].[tr_025_Contact_010_Default]'
	
	
	SET @EndDateTime = getutcdate()
	EXEC [aud].[proc_Log_Procedure]  
												@LogAction		= 'INSERT - DEL', 
												@LogNote		= 'Changed Deleted',
												@LogProcedure	= @RoutineName,
												@LogSQL			= 'Insert Into [bld].[Contact]',
												@LogRowCount	= @@ROWCOUNT,
												@Log_TimeStart  = @StartDateTime,
												@Log_TimeEnd    = @EndDateTime
												;
	
	-- Clean up ...
	IF OBJECT_ID('tempdb..#025_Contact_010_Default') IS NOT NULL 
DROP TABLE #025_Contact_010_Default;
	
	SET @EndDateTime =  getutcdate()
	SET @Duration = datediff(SS,@StartDateTime, @EndDateTime)
	PRINT 'Load "load_025_Contact_010_Default" took ' +CAST(@Duration AS varchar(10))+ ' second(s)'