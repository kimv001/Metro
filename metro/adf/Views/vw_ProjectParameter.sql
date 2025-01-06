
CREATE VIEW adf.vw_projectparameter AS
SELECT [projectparameterid] = src.[projectparameterid],

       [projectparametername] = src.[projectparametername],

       [projectparametervalue] = src.[projectparametervalue],

       [projectparameterjobtype] = src.[projectparameterjobtype],

       [projectparameterdescription] = src.[projectparameterdescription],

       [projectid] = src.[projectid],

       environment = env.environment

  FROM [adf].[projectparameters] src

 CROSS JOIN [adf].[vw_sdtap] env