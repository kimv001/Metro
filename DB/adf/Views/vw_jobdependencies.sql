create view adf.vw_jobdependencies as 

select 
	[dependingjobid]			= src.[DependingJobId],
    [prerequisitejobid]			= src.[PrerequisiteJobId],
    [jobdependencytype]			= src.[JobDependencyType],
    [jobdependecydescription]	= src.[JobDependecyDescription],
	environment					= env.Environment
from [adf].[JobDependencies]   src
Cross join [adf].[vw_SDTAP]  env