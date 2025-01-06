create view adf.vw_ProjectParameter as 

SELECT 
	[projectparameterid]			= src.[ProjectParameterId],
	[projectparametername]			= src.[ProjectParameterName],
	[projectparametervalue]			= src.[ProjectParameterValue],
	[projectparameterjobtype]		= src.[ProjectParameterJobType],
	[projectparameterdescription]	= src.[ProjectParameterDescription],
	[projectid]						= src.[ProjectId],
	environment						= env.Environment
  FROM [adf].[ProjectParameters] src
Cross join [adf].[vw_SDTAP]  env