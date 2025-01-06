
CREATE PROCEDURE [adf].[GetOrchestrationFlow]	

	@ProjectName NVARCHAR(280),
	@FlowName NVARCHAR(280) = NULL

AS 

IF ((@FlowName IS NULL) OR (LOWER(@FlowName) = 'null'))
	
	BEGIN
		SELECT	
 				[Projects].[ProjectId],
        		[Projects].[ProjectName],
				[Flows].[FlowId],
				[Flows].[FlowName],
				[Jobs].[JobId],
				[Jobs].[JobName],
				[Jobs].[JobDescription],
				[Jobs].[JobType],
				[Jobs].[JobGroup],
				[Jobs].[JobOrder],
				[Jobs].[LastRunDuration],
				[Jobs].[LastRunStart],
				[Jobs].[LastRunStatus],
				[Jobs].[CheckPoint]

		FROM	[adf].[Jobs] AS Jobs

		INNER JOIN [adf].[Flows] AS Flows
			ON [Jobs].[FlowId] = [Flows].[FlowId]

		INNER JOIN [adf].[Projects] AS Projects
			ON [Flows].[ProjectId] = [Projects].[ProjectId]

		WHERE	[Projects].[ProjectName] = @ProjectName
				AND [Flows].[FlowGroup] >= 0
				AND [Jobs].[JobGroup] >= 0

		ORDER BY
				[FlowGroup] ASC, [FlowOrder] ASC, [JobGroup] ASC, [JobOrder] ASC
	END

ELSE

	BEGIN
		SELECT	
        		[Projects].[ProjectId],
				[Projects].[ProjectName],
				[Flows].[FlowId],
				[Flows].[FlowName],
				[Jobs].[JobId],
				[Jobs].[JobName],
				[Jobs].[JobDescription],
				[Jobs].[JobType],
				[Jobs].[JobGroup],
				[Jobs].[JobOrder],
				[Jobs].[LastRunDuration],
				[Jobs].[LastRunStart],
				[Jobs].[LastRunStatus],
				[Jobs].[CheckPoint]

		FROM	[adf].[Jobs] AS Jobs

		INNER JOIN [adf].[Flows] AS Flows
			ON [Jobs].[FlowId] = [Flows].[FlowId]

		INNER JOIN [adf].[Projects] AS Projects
			ON [Flows].[ProjectId] = [Projects].[ProjectId]

		WHERE	[Projects].[ProjectName] = @ProjectName
				AND [Flows].[FlowName] = @FlowName
				AND [Flows].[FlowGroup] >= 0
				AND [Jobs].[JobGroup] >= 0

		ORDER BY
				[FlowGroup] ASC, [FlowOrder] ASC, [JobGroup] ASC, [JobOrder] ASC
	END