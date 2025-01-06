



CREATE view [bld].[tr_600_Template_010_Default] as

SELECT 
	  t.BK
	, t.Code
	, TemplateName			= t.[Name]
	, TemplateType			= tt.[Name]
	, TemplateDecription	= t.[Description]
	, ObjectType			= rt.[Name]
	, ObjectTypeDeployOrder	= rt.SortOrder
	, Script				= t.Script
	, ScriptLanguageCode	= t.ScriptLanguage	
	, ScriptLanguage		= sl.[Description]
	
	, ObjectName			= t.ObjectName
	
	
	-- Other
	, t.BK_RefType_TemplateType
	, t.BK_RefType_ObjectType
	, t.BK_RefType_ObjectType_BasedOn
	, t.BK_RefType_ScriptLanguage
	, t.TemplateVersion

  FROM rep.vw_Template t
  -- objecttype
  left join rep.vw_RefType rt on rt.bk	 = t.BK_RefType_ObjectType
  -- templatetype
  left join rep.vw_RefType	tt on tt.bk	 = t.BK_RefType_TemplateType
  -- scriptlanguage
  left join rep.vw_RefType	sl on sl.bk	 = t.BK_RefType_ScriptLanguage