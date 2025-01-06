









CREATE view [bld].[tr_655_DWHRefTemplates_010_default] as
With Templates as (
select 
			BK_Template		= t.BK
		  , t.BK
		  , T.Code
		  , TemplateType	= 'Create'
		  , TemplateSource	= rt_Target.[Name]
		  , TemplateOrder	= rt_ObjectType.SortOrder
		  , t.BK_RefType_ObjectType
		  , TemplateScript	= T.Script
		  , TemplateVersion	= t.TemplateVersion
		  , RowNum			= Row_Number() over (order by cast(rt_ObjectType.SortOrder as int) asc)
from bld.vw_Template t
join bld.vw_RefType rt_Target		on t.BK_RefType_TemplateType	= rt_Target.BK
join bld.vw_RefType rt_ObjectType	on t.BK_RefType_ObjectType		= rt_ObjectType.BK
where rt_Target.bk = 'TT|DWHR|DWH_Ref'

)
Select
	BK
	, Code
	, BK_Template
	, BK_Dataset				= ''
	, TemplateType
	, TemplateSource
	, BK_RefType_ObjectType
	, TemplateScript			= TemplateScript
	, TemplateVersion
	, RowNum

From Templates
Where 1=1