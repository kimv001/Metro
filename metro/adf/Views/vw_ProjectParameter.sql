CREATE VIEW adf.vw_ProjectParameter AS 

SELECT 
	[projectparameterid]			= src.[ProjectParameterId],
	[projectparametername]			= src.[ProjectParameterName],
	[projectparametervalue]			= src.[ProjectParameterValue],
	[projectparameterjobtype]		= src.[ProjectParameterJobType],
	[projectparameterdescription]	= src.[ProjectParameterDescription],
	[projectid]						= src.[ProjectId],
	environment						= env.Environment
  FROM [adf].[ProjectParameters] src
CROSS JOIN [adf].[vw_SDTAP]  env