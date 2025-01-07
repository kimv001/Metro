CREATE PROCEDURE [adf].[UpdateOrchestrationFlow]
	
	@ProjectName		NVARCHAR (900) = '-1',
	@FlowName			NVARCHAR (900) = '-1',
	@FlowRunGUID 		NVARCHAR (36) = '-1',
	@LastRunDuration 	INT = -1,
    @LastRunStart		DATETIME2 = '1900-01-01 00:00:00',
	@LastRunEnd 		DATETIME2 = '9999-12-31 23:59:99',
    @LastRunStatus 		NVARCHAR (10) = 'Undefined'

AS
	-- Insert monitoring record
	INSERT INTO	[aud].[FlowRuns] 

	SELECT		[Projects].[ProjectId],
				[Flows].[FlowId],
				[Flows].[FlowName],
				@FlowRunGUID AS [FlowRunGUID],
				@LastRunStart AS [RunStart],
				@LastRunEnd AS [RunEnd],
				@LastRunDuration AS [RunDuration],
				@LastRunStatus AS [RunStatus],
				GETDATE() AS [LogDateTime]

	FROM		[adf].[Flows] AS Flows
	
	INNER JOIN	[adf].[Projects] AS Projects
		ON [Flows].[ProjectId] = [Projects].[ProjectId]
	
	WHERE		[Flows].[FlowName] = @FlowName
				AND [Projects].[ProjectName] = @ProjectName