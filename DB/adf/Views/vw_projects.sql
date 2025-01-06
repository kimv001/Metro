create view adf.vw_projects as 

select  
	 projectid			= src.[ProjectId],
     projectname		= src.[ProjectName],
     projectdescription	= src.[ProjectDescription],
	 environment		= env.Environment
from [adf].[Projects] src
Cross join [adf].[vw_SDTAP]  env