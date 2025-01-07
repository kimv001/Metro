









CREATE VIEW [bld].[tr_655_DWHRefTemplates_010_default] AS
WITH Templates AS (
SELECT 
			Bk_template		= T.Bk
		  , T.Bk
		  , T.Code
		  , Templatetype	= 'Create'
		  , Templatesource	= Rt_target.[Name]
		  , Templateorder	= Rt_objecttype.Sortorder
		  , T.Bk_reftype_objecttype
		  , Templatescript	= T.Script
		  , Templateversion	= T.Templateversion
		  , Rownum			= ROW_NUMBER() OVER (ORDER BY CAST(Rt_objecttype.Sortorder AS int) ASC)
FROM Bld.Vw_template T
JOIN Bld.Vw_reftype Rt_target		ON T.Bk_reftype_templatetype	= Rt_target.Bk
JOIN Bld.Vw_reftype Rt_objecttype	ON T.Bk_reftype_objecttype		= Rt_objecttype.Bk
WHERE Rt_target.Bk = 'TT|DWHR|DWH_Ref'

)
SELECT
	Bk
	, Code
	, Bk_template
	, Bk_dataset				= ''
	, Templatetype
	, Templatesource
	, Bk_reftype_objecttype
	, Templatescript			= Templatescript
	, Templateversion
	, Rownum

FROM Templates
WHERE 1=1