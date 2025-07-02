 
 
create procedure [stg].[Proc_LoadTable_MDS_RapportageKlant]  
		  @filename [nvarchar](512)
		, @PipelineRunID [varchar](255)
		, @PipelineTriggerID [varchar](255)
 , @SchedulePipelineRunID [varchar](255)
		as 
/*
templatename:  			Load Staging from StorageAccount
templatedescription:	"Copy Into" is the best Synapse statement to load tekst files from a storage account into the database.
The procedure can load all files from a folder (corresponding the filemask) or a specific file.
The file trigger in ADF will execute this procedure for
templateversion:		1.4
deployversion:			<!<DeployVersionNum>>
Debug Helpers:
	
	Exec [stg].[Proc_LoadTable_MDS_RapportageKlant] @PipelineRunID = '-1',@PipelineTriggerID = '-1',@SchedulePipelineRunID = '-1'
 
	Select Top 10 * from [mdm].[RapportageKlant]
	Select Top 10 * from [stg].[MDS_RapportageKlant]
	
	Select mta_BK From [mdm].[RapportageKlant] Group by mta_BK Having Count ('')>1
	Select mta_BK From [stg].[MDS_RapportageKlant] Group by mta_BK Having Count ('')>1
 
	Truncate Table [stg].[MDS_RapportageKlant];
 
Examples:
	-- Load 1 specific File
	exec [stg].[Proc_LoadTable_MDS_RapportageKlant] @filename = '', @PipelineRunID = '-1',  @PipelineTriggerID = '-1',   @SchedulePipelineRunID = '-1'
	-- Load multiple files with a filemask
	[stg].[Proc_LoadTable_MDS_RapportageKlant] @filename = '', @PipelineRunID = '-1',  @PipelineTriggerID = '-1', @SchedulePipelineRunID = '-1'
 
	-- If you want to, just Execute the persistant staging Procedure afterwards
	exec [pst].[Proc_LoadTable_MDS_RapportageKlant]  @PipelineRunID = '-1',  @PipelineTriggerID = '-1', @SchedulePipelineRunID = '-1'
*/
 
-- Default Variables v2.0
declare		@Env 					varchar(4)		= case when right(cast(SERVERPROPERTY( 'ServerName' ) as varchar),3)='ROD' then 'PROD' else Right(Cast(SERVERPROPERTY( 'ServerName' ) as varchar),3) end
declare		@CurrentDateTime		datetime2		= cast (GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time' as datetime2) 
declare		@mta_LoadDate 			varchar(255)	= cast(@CurrentDateTime as varchar(255))
declare		@CurrentDateTimeF		varchar(255)	= format(@CurrentDateTime, 'yyyyMMdd_HHmmss')
declare 	@mta_Valid				varchar(1) 		= '0'
declare		@FileProcessor			varchar(500)	
declare		@Filecounter			int
declare		@SourceTable			varchar(255)	= '[mdm].[RapportageKlant]'
declare		@SourceDataset			varchar(255)	= '[mdm].[RapportageKlant]'
declare		@mta_source				varchar(255)	= '[mdm].[RapportageKlant]'
declare		@TargetTable			varchar(255)	= '[stg].[MDS_RapportageKlant]'
declare		@Groupname				varchar(255)	= 'MDS'
declare		@Shortname				varchar(255)	= 'RapportageKlant'
declare		@RecordSourceDate		varchar(255)	= 'null'
declare		@FullLoad				int				= 1				-- if 1 then Full Load, if 0 then Incremental load
declare		@NrFullLoadPeriods		int				= 0
declare		@InsertOnly				int				= 0				-- if 0 then insert new and changed records, if 1 insert new records
declare		@InsertNocheck			int				= 0				-- if 0 then insert new and changed records, if 1 insert new records
declare		@TimeStamp_expression	varchar(255)	= case when 'null' = 'null' then null else 'null' end
declare		@TimeStamp_group		varchar(255)	= case when 'null' = 'null' then null else 'null' end
declare		@Use_TimeStamp			int				= case when isnull(@TimeStamp_expression,'')='' or @TimeStamp_expression like '%tgt_TimestampExpression%' then 0 else 1 end
declare		@IsAlreadyRunningDB		int				= 0				-- Used to check if another proces is already processing the targettable
declare		@IsAlreadyRunningAudit	int				= 0				-- Used to check if all other audit trails for the targettable are closed
declare		@IsSRCRunningDB			int				= 0				-- Used to check if another proces is already processing the targettable
declare		@IsSRCRunningAudit		int				= 0				-- Used to check if all other audit trails for the targettable are closed
declare		@ProcessMessage			varchar(8000)	= 'OK'			-- default everythinh is ok
declare		@ErrorMessage			varchar(8000)	= ''			-- To build a custom errormessage
declare		@ErrorCode   			int            
declare		@ErrorSeverity			int        
declare		@ErrorProcName			varchar(100)     
declare		@ErrorLineNumber	    int 							-- not usable in Azure Synapse
declare		@sql 					varchar(max)	= ''
declare		@starttime				datetime2		= @CurrentDateTime
declare		@endtime				datetime2		= @CurrentDateTime
declare		@DurationSec			int
declare		@DurationMin			int
declare		@DedupSource			bit				= 1
declare		@RunId					nvarchar(500)	= ''
 
 
if @PipelineRunID is null or @PipelineRunID = '-1'
	begin
		set @RunId					= concat('Manual execution  [stg].[Proc_LoadTable_MDS_RapportageKlant]  on ', @CurrentDateTimeF, ' by ', SUSER_SNAME() );
		set @PipelineRunID 			= @RunId;
		set @PipelineTriggerID 		= @RunId;
		set @SchedulePipelineRunID 	= @RunId;
	end
 
-- activate below for debugging purposes:
-- declare		@pipelinerunid 			varchar(255)	= '-1'
-- declare		@pipelinetriggerid		varchar(255)	= '-1'
-- declare		@SchedulePipelineRunID	varchar(255)    = '-1'
-- declare 		@filename 				nvarchar(512)	= '*.*'
 
print '@Env: '					+ @Env
print '@pipelinerunid: '		+ @pipelinerunid
print '@CurrentDateTime: '		+ cast(@CurrentDateTime as varchar(255))
print '@mta_LoadDate: '			+ @mta_LoadDate
print '@TimeStamp_expression: '	+ isnull(cast(@TimeStamp_expression as varchar(1000)),'')
print '@Use_TimeStamp: '		+ cast(@Use_TimeStamp as varchar(1))
 
-- Template Variables
declare @startpos int					= cast(case when LEN('Marker not defined in the repository...') >2 then '0' else'Marker not defined in the repository...' end as int)
declare @length int						= cast(case when LEN('Marker not defined in the repository...')	>2 then '0' else'Marker not defined in the repository...' end as int)
declare @dateinfilename varchar(max)		= Substring(@filename,@startpos,@length)
declare @Storage varchar(max)			= 'https://saws'+@Env+'.dfs.core.windows.net' 
 
-- file load procedure is kind of special, a default parameter is set to the actual filename
set @SourceDataset = @filename
 
 
--------------------------------------------------------------------------
-- begin Marker 'Create Audit Entry'									--
 
Print 'Create Audit Entry'
 
Exec [aud].[Proc_log_CreateAuditEntry] 
				@Dataset 				= @TargetTable, 
				@SourceDataset 			= @SourceDataset,
				@PipelineRunID 			= @PipelineRunID,
				@PipelineTriggerID 		= @PipelineTriggerID,
				@SchedulePipelineRunID	= @SchedulePipelineRunID
 
-- end Marker 'Create Audit Entry'										--
--------------------------------------------------------------------------;
 
begin try
 
-- ADF does the truncate
-- truncate table [stg].[MDS_RapportageKlant];
;
 
set @sql = 
	'copy into [stg].[MDS_RapportageKlant] 
			(     
				  [ID],
			[MUID],
			[VersionName],
			[VersionNumber],
			[Version_ID],
			[VersionFlag],
			[Name],
			[Code],
			[ChangeTrackingMask],
			[SalesCloudId],
			[Taal],
			[MijnOmgeving],
			[MoBreedBand],
			[MoEvpn],
			[MoMdfLev],
			[MoMdfServ],
			[MoSmallBand],
			[MoWbaGlasLev],
			[MoWbaGlasServ],
			[MoWbaKoperLev],
			[MoWbaKoperServ],
			[MoWebform],
			[MoWeasGlas],
			[MoWeasKoper],
			[MoWbaCup],
			[MoWmp],
			[GoudenKlantRapportage],
			[GdWeas],
			[GdDwdm],
			[GdiLL2Mb],
			[GdSdhiLL],
			[GdDf],
			[GdMtn],
			[EnterDateTime],
			[EnterUserName],
			[EnterVersionNumber],
			[LastChgDateTime],
			[LastChgUserName],
			[LastChgVersionNumber],
			[ValidationStatus]  
				, [mta_LoadDate] default '''+@mta_LoadDate+'''
				, [mta_Source] default '''+@filename+'''
				, [mta_DateInFileName] default '''+@dateinfilename+'''
				, [mta_PipelineRunID] default '''+@PipelineRunID+'''
				, [mta_PipelineTriggerID] default '''+@PipelineTriggerID+'''
				, [mta_Valid] default '+@mta_Valid+'
			) 
		from '''+@Storage+'///'+ @filename  + ''' 
		with 
			(
				file_type				= ''''
				,maxerrors				= 0
				,fieldterminator		= ''''
				,credential				= (IDENTITY = ''Managed Identity'') 
				,encoding				= ''''
				,firstrow				= 
				,fieldquote				= ''''
				
			)
		OPTION (LABEL = ''ETL - [stg].[MDS_RapportageKlant] - INSERT - NEW RECORDS'')'
 
;
print (@sql)
 
exec (@sql )
;
exec [aud].[Proc_log_DatabaseRequest]  @TargetTable = @TargetTable , @PipelineRunID = @PipelineRunID ,@PipelineTriggerID = @PipelineTriggerID;
				
--------------------------------------------------------------------------
-- begin Marker UpdateStatistics_TGT_Dataset'							--
print 'begin updating stats ...'
print ''
 
	update statistics [stg].[MDS_RapportageKlant];
 
print '...end updating stats'
print ''
-- end Marker 'UpdateStatistics_TGT_Dataset'							--
--------------------------------------------------------------------------
end try
 
begin catch
	--------------------------------------------------------------------------
-- begin Marker 'BuildErrorMessage'										--
	
	set @ErrorMessage 	= 	'- ErrorMessage:	' + isnull(ERROR_MESSAGE(),'N/A')   					+char(10)+
							'- ErrorCode:		' + isnull(cast(ERROR_NUMBER() as varchar(255)),'N/A')  +char(10)+
							'- ErrorSeverity:	' + isnull(cast(ERROR_SEVERITY()  as varchar(255)),'N/A')
	
-- end Marker 'BuildErrorMessage'										--
--------------------------------------------------------------------------
	--------------------------------------------------------------------------
-- begin Marker 'CloseAuditEntryInError'								--
 
	Print 'Close Audit Entry in Error'
	Exec [aud].[Proc_log_CloseAuditEntry] 
					@Dataset 				= @TargetTable,
					@PipelineRunID 			= @PipelineRunID,
					@PipelineTriggerID 		= @PipelineTriggerID,
					@ProcessMessage 		= @ErrorMessage,
					@ProcessError 			= '1'
 
-- end Marker 'CloseAuditEntryInError'									--
--------------------------------------------------------------------------
end catch;  
;
--------------------------------------------------------------------------
-- begin Marker 'CloseAuditEntry'										--
 
Print 'Close Audit Entry'
Exec [aud].[Proc_log_CloseAuditEntry] 
				@Dataset 				= @TargetTable,
				@PipelineRunID 			= @PipelineRunID,
				@PipelineTriggerID 		= @PipelineTriggerID,
				@ProcessMessage 		= @ProcessMessage,
				@ProcessError 			= '0'
 
-- end Marker 'CloseAuditEntry'											--
--------------------------------------------------------------------------;