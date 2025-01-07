CREATE VIEW adf.vw_jobdependencies AS 

SELECT 
	[dependingjobid]			= src.[DependingJobId],
    [prerequisitejobid]			= src.[PrerequisiteJobId],
    [jobdependencytype]			= src.[JobDependencyType],
    [jobdependecydescription]	= src.[JobDependecyDescription],
	environment					= env.Environment
FROM [adf].[JobDependencies]   src
CROSS JOIN [adf].[vw_SDTAP]  env