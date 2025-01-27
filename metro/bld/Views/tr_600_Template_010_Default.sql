



CREATE VIEW [bld].[tr_600_Template_010_Default] AS
/*
Description:
    This view builds up the default template definitions. It provides detailed information about templates, including their types, object types, and script languages. This data is crucial for generating neat and structured code.

Columns:
    - BK: The business key of the template.
    - CODE: The code of the template.
    - TEMPLATENAME: The name of the template.
    - TEMPLATETYPE: The type of the template.
    - TEMPLATEDECRIPTION: The description of the template.
    - OBJECTTYPE: The type of the object.
    - OBJECTTYPEDEPLOYORDER: The deploy order of the object type.
    - SCRIPT: The script of the template.
    - SCRIPTLANGUAGECODE: The code of the script language.
    - SCRIPTLANGUAGE: The description of the script language.
    - OBJECTNAME: The name of the object.
    - BK_REFTYPE_TEMPLATETYPE: The business key of the template type reference.
    - BK_REFTYPE_OBJECTTYPE: The business key of the object type reference.
    - BK_REFTYPE_OBJECTTYPE_BASEDON: The business key of the object type based on reference.
    - BK_REFTYPE_SCRIPTLANGUAGE: The business key of the script language reference.
    - TEMPLATEVERSION: The version of the template.

Example Usage:
    SELECT * FROM [bld].[tr_600_Template_010_Default]

Logic:
    1. Selects template definitions from the [rep].[vw_Template] view.
    2. Joins with the [rep].[vw_RefType] view to get additional template attributes.

Source Data:
    - [rep].[vw_Template]: Contains template definitions.
    - [rep].[vw_RefType]: Contains reference types used in the data warehouse.

Changelog:
Date        Time        Author              Description
20220804    00:00       K. Vermeij          Initial version
*/
SELECT 
	  t.bk
	, t.code
	, templatename			= t.[Name]
	, templatetype			= tt.[Name]
	, templatedecription	= t.[Description]
	, objecttype			= rt.[Name]
	, objecttypedeployorder	= rt.sortorder
	, script				= t.script
	, scriptlanguagecode	= t.scriptlanguage	
	, scriptlanguage		= sl.[Description]
	
	, objectname			= t.objectname
	
	
	-- Other
	, t.bk_reftype_templatetype
	, t.bk_reftype_objecttype
	, t.bk_reftype_objecttype_basedon
	, t.bk_reftype_scriptlanguage
	, t.templateversion

  FROM rep.vw_template t
  -- objecttype
  LEFT JOIN rep.vw_reftype rt ON rt.bk	 = t.bk_reftype_objecttype
  -- templatetype
  LEFT JOIN rep.vw_reftype	tt ON tt.bk	 = t.bk_reftype_templatetype
  -- scriptlanguage
  LEFT JOIN rep.vw_reftype	sl ON sl.bk	 = t.bk_reftype_scriptlanguage