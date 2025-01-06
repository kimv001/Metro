
CREATE VIEW adf.vw_jobparameters AS
SELECT jobparameterid = src.[jobparameterid],

       jobparametername = src.[jobparametername],

       jobparametervalue = src.[jobparametervalue],

       jobparameterdescription = src.[jobparameterdescription],

       jobid = src.[jobid],

       environment = env.environment

  FROM [adf].[jobparameters] src

 CROSS JOIN [adf].[vw_sdtap] env