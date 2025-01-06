
CREATE VIEW adf.vw_projects AS
SELECT projectid = src.[projectid],

       projectname = src.[projectname],

       projectdescription = src.[projectdescription],

       environment = env.environment

  FROM [adf].[projects] src

 CROSS JOIN [adf].[vw_sdtap] env