


CREATE VIEW [bld].[tr_900_DeployScripts_010_MetroProcedure] AS

/*
Description:
    This view is intended to create the structure for the `bld.DeployScripts` table. It defines the columns and their data types but does not contain any actual data. This structure is used to store deployment scripts for Metro procedures.

Columns:
    - BK: The business key of the deployment script.
    - CODE: The code of the deployment script.
    - BK_TEMPLATE: The business key of the template.
    - BK_DATASET: The business key of the dataset.
    - TGT_OBJECTNAME: The target object name.
    - OBJECTTYPE: The type of the object.
    - OBJECTTYPEDEPLOYORDER: The deploy order of the object type.
    - TEMPLATETYPE: The type of the template.
    - SCRIPTLANGUAGECODE: The code of the script language.
    - SCRIPTLANGUAGE: The description of the script language.
    - TEMPLATESOURCE: The source of the template.
    - TEMPLATENAME: The name of the template.
    - TEMPLATESCRIPT: The script of the template.
    - TEMPLATEVERSION: The version of the template.
    - TODEPLOY: Indicates if the script is to be deployed.

Example Usage:
    SELECT * FROM [bld].[tr_900_DeployScripts_010_MetroProcedure]

Logic:
    1. Defines the structure for the `bld.DeployScripts` table.
    2. Specifies the columns and their data types.

Source Data:
    - This view does not pull data from any source views. It is intended to define the structure for the `bld.DeployScripts` table.

Changelog:
Date        Time        Author              Description
20220804    00:00       K. Vermeij          Initial version
*/
SELECT TOP 0
	  BK						= ''
	, CODE						= ''
	, BK_TEMPLATE				= ''
	, BK_DATASET				= ''
	, TGT_OBJECTNAME			= ''
	, OBJECTTYPE				= ''
	, OBJECTTYPEDEPLOYORDER		= ''
	, TEMPLATETYPE				= ''
	, SCRIPTLANGUAGECODE		= ''
	, SCRIPTLANGUAGE			= ''
	, TEMPLATESOURCE			= ''
	, TEMPLATENAME				= ''
	, TEMPLATESCRIPT			= ''
	, TEMPLATEVERSION			= ''
	, TODEPLOY					= ''
	

  /*
  @Script					varchar(max),
	@PreScript				varchar(max),
	@PostScript				varchar(max),
	@BK_Object				varchar(max),
	@Code					varchar(max),
	@BK_Dataset				varchar(max),
	@ObjectType				varchar(max),
	@ObjectTypeDeployOrder	varchar(max),
	@BK_Template			varchar(max),
	@Marker					varchar(max),
	@MarkerValue			varchar(max),
	@TGT_ObjectName			varchar(max),
	

	@TemplateName	varchar(max),
	@TemplateType	 varchar(max),
  */