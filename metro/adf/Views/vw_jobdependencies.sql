
CREATE VIEW adf.vw_jobdependencies AS
SELECT [dependingjobid] = src.[dependingjobid],

       [prerequisitejobid] = src.[prerequisitejobid],

       [jobdependencytype] = src.[jobdependencytype],

       [jobdependecydescription] = src.[jobdependecydescription],

       environment = env.environment

  FROM [adf].[jobdependencies] src

 CROSS JOIN [adf].[vw_sdtap] env
