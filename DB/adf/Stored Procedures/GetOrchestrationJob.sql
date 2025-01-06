
CREATE PROCEDURE [adf].[GetOrchestrationJob]

	@ProjectId NVARCHAR(900),
	@FlowId NVARCHAR(900),
	@JobId NVARCHAR(900)

AS 

BEGIN

	IF EXISTS (	SELECT 	[JobDependencies].* 
				FROM 	[adf].[GetMissingJobDependencies] AS JobDependencies
				WHERE 	[JobDependencies].[FlowId] = @FlowId 
						AND [JobDependencies].[JobId] = @JobId)
		
		BEGIN
		RAISERROR(N'Dependencies not met', 16, 1)
		END

SELECT	[Projects].[ProjectName],
		[Flows].[FlowName],
		[Flows].[FlowId],
		[Jobs].[JobId],
		[Jobs].[JobName],
		[Jobs].[JobDescription],
		[Jobs].[JobType],
		[Parameters].[JobParameters],
		[Jobs].[JobGroup],
		[Jobs].[JobOrder],
		[Jobs].[LastRunDuration],
		CAST(	FORMAT([Jobs].[LastRunStart], 'yyyy-MM-dd HH:mm:ss') AS VARCHAR(19) ) AS [LastRunStart],
		[Jobs].[LastRunStatus],
		CAST(	FORMAT([Jobs].[CheckPoint], 'yyyy-MM-dd HH:mm:ss') AS VARCHAR(19) ) AS [CheckPoint]

FROM	[adf].[Jobs] AS Jobs

INNER JOIN [adf].[Flows] AS Flows
	ON [Jobs].[FlowId] = [Flows].[FlowId]

INNER JOIN [adf].[Projects] AS Projects
	ON [Flows].[ProjectId] = [Projects].[ProjectId]

LEFT JOIN	(	SELECT 	* 
				FROM 	[adf].[GetAllJobParametersJSON]
			) AS Parameters
	ON [Jobs].[JobId] = [Parameters].[JobId]

WHERE	[Projects].[ProjectId] = @ProjectId
		AND [Flows].[FlowId] = @FlowId
		AND [Jobs].[JobId] = @JobId
		AND [Flows].[FlowGroup] >= 0
		AND [Jobs].[JobGroup] >= 0
END