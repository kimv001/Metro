









CREATE VIEW [bld].[tr_655_DWHRefTemplates_010_default] AS
/*
Description:
    This view builds up the default template definitions for Data Warehouse Reference (DWH Ref) objects. It provides detailed information about which templates need to be filled in for which data warehouse reference objects.

Columns:
    - BK_TEMPLATE: The business key of the template.
    - BK: The business key of the template.
    - CODE: The code of the template.
    - BK_DATASET: The business key of the dataset (empty for DWH Ref templates).
    - TEMPLATETYPE: The type of the template (e.g., Create).
    - TEMPLATESOURCE: The source of the template (e.g., DWH Ref).
    - BK_REFTYPE_OBJECTTYPE: The business key of the object type reference.
    - TEMPLATESCRIPT: The script of the template.
    - TEMPLATEVERSION: The version of the template.
    - ROWNUM: The row number for ordering.

Example Usage:
    SELECT * FROM [bld].[tr_655_DWHRefTemplates_010_default]

Logic:
    1. Selects template definitions for DWH Ref objects.
    2. Joins with reference types to get additional template attributes.
    3. Orders the templates by object type sort order.

Source Data:
    - [bld].[vw_Template]: Contains template definitions.
    - [bld].[vw_RefType]: Contains reference types used in the data warehouse.

Changelog:
Date        Time        Author              Description
20220804    0000        K. Vermeij          Initial version
*/
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