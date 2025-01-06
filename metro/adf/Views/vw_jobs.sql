CREATE view adf.vw_jobs as 

SELECT 
	[jobid]						= src.[JobId],
	[jobname]					= src.[JobName],
	[jobdescription]			= src.[JobDescription],
	[flowid]					= src.[FlowId],
	[jobtype]					= src.[JobType],
	[jobgroup]					= src.[JobGroup],
	[joborder]					= src.[JobOrder],
	[lastrunduration]			= src.[LastRunDuration],
	[lastrunstart]				= src.[LastRunStart],
	[lastrunstatus]				= src.[LastRunStatus],
	[checkpoint]				= src.[CheckPoint],
	environment					= env.Environment
  FROM [adf].[Jobs] src
Cross join [adf].[vw_SDTAP]  env