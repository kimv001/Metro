CREATE VIEW adf.vw_projects AS 

SELECT  
	 projectid			= src.[ProjectId],
     projectname		= src.[ProjectName],
     projectdescription	= src.[ProjectDescription],
	 environment		= env.Environment
FROM [adf].[Projects] src
CROSS JOIN [adf].[vw_SDTAP]  env