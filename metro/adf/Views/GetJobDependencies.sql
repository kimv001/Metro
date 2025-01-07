CREATE VIEW [adf].[GetJobDependencies]

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

INNER JOIN [adf].[JobDependencies] AS JobDependencies
	ON [Jobs].[JobId] = [JobDependencies].[DependingJobId]

LEFT JOIN [adf].[Jobs] AS PrerequisiteJobs
    ON [JobDependencies].[PrerequisiteJobId] = [PrerequisiteJobs].[JobId]