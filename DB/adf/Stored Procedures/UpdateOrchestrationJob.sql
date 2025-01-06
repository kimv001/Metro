CREATE PROCEDURE [adf].[UpdateOrchestrationJob]
	
	@FlowRunGUID 		NVARCHAR(36) = '-1',
	@JobId 				NVARCHAR(900) = '-1',
	@JobRunGUID			NVARCHAR(36) = '-1',
	@LastRunDuration 	INT = -1,
    @LastRunStart 		DATETIME2 = '1900-01-01 00:00:00',
	@LastRunEnd 		DATETIME2 = '9999-12-31 23:59:99',
    @LastRunStatus 		NVARCHAR(10) = 'Undefined',
    @CheckPoint 		DATETIME2 = NULL,
	@JobMetrics 		NVARCHAR(MAX) = NULL,
	@JobFullMessage 	NVARCHAR(MAX) = NULL 

AS
	-- Update job info
	UPDATE		[adf].[Jobs]
		
	SET			[LastRunDuration] = @LastRunDuration,
				[LastRunStart] = @LastRunStart,
				[LastRunStatus] = @LastRunStatus,
				[CheckPoint] = @CheckPoint

	WHERE		[JobId] = @JobId

	-- Insert monitoring record
	INSERT INTO	[aud].[JobRuns] 

	SELECT		[Flows].[FlowId],
				@FlowRunGUID AS [FlowRunGUID],
				[Jobs].[JobId],
				[Jobs].[JobName],
				[Jobs].[JobDescription],
				[Jobs].[JobType],
				@JobRunGUID AS [JobRunGUID],
				@LastRunStart AS [RunStart],
				@LastRunEnd AS [RunEnd],
				@LastRunDuration AS [RunDuration],
				@LastRunStatus AS [RunStatus],
				@CheckPoint AS [CheckPoint],
				ISNULL(JSON_VALUE(@JobMetrics, '$.RowsInserted'), -1) AS [RowsInserted],
				ISNULL(JSON_VALUE(@JobMetrics, '$.RowsUpdated'), -1) AS [RowsUpdated],
				ISNULL(JSON_VALUE(@JobMetrics, '$.RowsDeleted'), -1) AS [RowsDeleted],
				GETDATE() AS [LogDateTime],
				@JobFullMessage AS [LogFullMessage]

	FROM		[adf].[Jobs] as Jobs

	INNER JOIN	[adf].[Flows] as Flows
		ON [Jobs].[FlowId] = [Flows].[FlowId]
	
	INNER JOIN	[adf].[Projects] as Projects
		ON [Flows].[ProjectId] = [Projects].[ProjectId]
	
	WHERE		[Jobs].[JobId] = @JobId