CREATE VIEW adf.vw_jobparameters AS 

SELECT  
	jobparameterid				= src.[JobParameterId],
    jobparametername			= src.[JobParameterName],
    jobparametervalue			= src.[JobParameterValue],
    jobparameterdescription		= src.[JobParameterDescription],
    jobid						= src.[JobId],
	environment					= env.Environment
  FROM [adf].[JobParameters]    src
CROSS JOIN [adf].[vw_SDTAP]  env