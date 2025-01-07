CREATE VIEW [bld].[tr_075_Flow_010_Default] AS 

SELECT
	BK							= FL.BK,
	CODE						= FL.CODE,
	BK_FLOW						= F.BK,
	FLOW_NAME					= F.[Name],
	FLOW_DESCRIPTION			= isnull(F.[Description],'<no description available ...>'),
	FLOW_LAYER_STEP_NAME		= FL.[Name],
	FLOW_LAYER_STEP_DESCRIPTION	= isnull(FL.[Description],'<no description available ...>'),
	FLOW_LAYER_STEP_ORDER		= FL.SORTORDER,
	BK_LAYER					= L.BK,
	BK_SCHEMA					= S.BK,
	
	-- helper to determine if there is a view on the source dataset that should be used instead of the table
	READFROMVIEW				= FL.READFROMVIEW,
	BK_TEMPLATE_LOAD			= FL.BK_TEMPLATE_LOAD,
	--Load_Template_Name			= tl.[Name],
	--Load_Template_Description	= tl.[Description],
	--Load_Template				= tl.Script
	BK_TEMPLATE_CREATE			= FL.BK_TEMPLATE_CREATE

FROM REP.VW_FLOW			F
JOIN REP.VW_FLOWLAYER		FL		ON FL.BK_FLOW			= F.BK 
LEFT JOIN REP.VW_LAYER		L		ON FL.BK_LAYER			= L.BK
LEFT JOIN REP.VW_SCHEMA		S		ON FL.BK_SCHEMA			= S.BK
LEFT JOIN REP.VW_TEMPLATE	TL		ON FL.BK_TEMPLATE_LOAD	= TL.BK