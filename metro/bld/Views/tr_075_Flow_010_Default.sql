CREATE VIEW [bld].[tr_075_Flow_010_Default] AS 

SELECT
	BK							= fl.BK,
	Code						= fl.code,
	BK_Flow						= f.bk,
	Flow_Name					= f.[Name],
	Flow_Description			= isnull(f.[Description],'<no description available ...>'),
	Flow_Layer_Step_Name		= fl.[Name],
	Flow_Layer_Step_Description	= isnull(fl.[Description],'<no description available ...>'),
	Flow_Layer_Step_Order		= fl.SortOrder,
	BK_Layer					= l.BK,
	BK_Schema					= s.BK,
	
	-- helper to determine if there is a view on the source dataset that should be used instead of the table
	ReadFromView				= fl.ReadFromView,
	BK_Template_Load			= fl.BK_Template_Load,
	--Load_Template_Name			= tl.[Name],
	--Load_Template_Description	= tl.[Description],
	--Load_Template				= tl.Script
	BK_Template_Create			= fl.BK_Template_Create

FROM rep.vw_Flow			f
JOIN rep.vw_FlowLayer		fl		ON fl.BK_Flow			= f.BK 
LEFT JOIN rep.vw_Layer		l		ON fl.BK_Layer			= l.bk
LEFT JOIN rep.vw_Schema		s		ON fl.BK_Schema			= s.bk
LEFT JOIN rep.vw_template	tl		ON fl.BK_Template_Load	= tl.bk