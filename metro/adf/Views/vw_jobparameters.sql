create view adf.vw_jobparameters as 

SELECT  
	jobparameterid				= src.[JobParameterId],
    jobparametername			= src.[JobParameterName],
    jobparametervalue			= src.[JobParameterValue],
    jobparameterdescription		= src.[JobParameterDescription],
    jobid						= src.[JobId],
	environment					= env.Environment
  FROM [adf].[JobParameters]    src
Cross join [adf].[vw_SDTAP]  env