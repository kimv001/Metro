CREATE VIEW [adf].[GetMissingJobDependencies]

AS

SELECT	[Projects].[ProjectName],
		[Flows].[FlowName],
		[Jobs].*,
		[JobDependencies].[PrerequisiteJobId],
		[PrerequisiteJobs].[JobName] AS [PrerequisiteJobName],
		[PrerequisiteJobs].[LastRunStatus] AS [PrerequisiteJobStatus],
		[PrerequisiteJobs].[LastRunStart] AS [PrerequisiteJobLastRunStart]

FROM	[adf].[Jobs] AS Jobs

INNER JOIN [adf].[Flows] AS Flows
	ON [Jobs].[FlowId] = [Flows].[FlowId]

INNER JOIN [adf].[Projects] AS Projects
	ON [Flows].[ProjectId] = [Projects].[ProjectId]

LEFT JOIN [adf].[JobDependencies] AS JobDependencies
	ON [Jobs].[JobId] = [JobDependencies].[DependingJobId]

INNER JOIN [adf].[Jobs] AS PrerequisiteJobs
    ON [JobDependencies].[PrerequisiteJobId] = [PrerequisiteJobs].[JobId]

WHERE	([PrerequisiteJobs].[LastRunStatus] <> 'Successful'
		 OR 
		 [PrerequisiteJobs].[LastRunStatus] IS NULL)