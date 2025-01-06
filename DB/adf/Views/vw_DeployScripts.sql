

CREATE view adf.vw_DeployScripts as
SELECT 
	  src.BK
	, src.Code
	, src.BK_Template
	, src.BK_Dataset
	, src.TGT_ObjectName
	, src.ObjectType
	, src.ObjectTypeDeployOrder
	, src.TemplateType
	, src.ScriptLanguageCode
	, src.ScriptLanguage
	, src.TemplateSource
	, src.TemplateName
	, src.TemplateScript

	, RepositoryStatusName	= env.RepositoryStatus
	, RepositoryStatusCode	= env.RepositoryStatusCode
	, Environment			= env.Environment
  FROM bld.vw_DeployScripts src
  Cross join adf.vw_SDTAP  env