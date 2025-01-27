CREATE VIEW [bld].[tr_075_Flow_010_Default] AS 
/*
Description:
    This view provides a list of flows and their associated metadata from various source views. 
	It includes information about the flow, flow layer steps, schemas, and templates used for loading and creating data.

Columns:
    - BK: The business key of the flow layer step.
    - Code: The code of the flow layer step.
    - BK_Flow: The business key of the flow.
    - Flow_Name: The name of the flow.
    - Flow_Description: The description of the flow.
    - Flow_Layer_Step_Name: The name of the flow layer step.
    - Flow_Layer_Step_Description: The description of the flow layer step.
    - Flow_Layer_Step_Order: The order of the flow layer step.
    - BK_Layer: The business key of the layer.
    - BK_Schema: The business key of the schema.
    - ReadFromView: Indicates if the source dataset should be read from a view instead of a table.
    - BK_Template_Load: The business key of the load template.
    - BK_Template_Create: The business key of the create template.

Example Usage:
    SELECT * FROM [bld].[tr_075_Flow_010_Default]

Logic:
    1. Selects flow data from the [rep].[vw_Flow] view.
    2. Joins with the [rep].[vw_FlowLayer] view to get flow layer step data.
    3. Left joins with the [rep].[vw_Layer] view to get layer data.
    4. Left joins with the [rep].[vw_Schema] view to get schema data.
    5. Left joins with the [rep].[vw_Template] view to get template data.

Source Data:
    - [rep].[vw_Flow]: Defines the flows used in the data warehouse.
    - [rep].[vw_FlowLayer]: Defines the actual flow steps (load pattern).
    - [rep].[vw_Layer]: Defines the purpose of a data source schema (source, DWH, target system).
    - [rep].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [rep].[vw_Template]: Defines create and load statements generically, generating all project code from these templates to improve code quality.

Changelog:
Date        Time        Author              Description
20230326    12:00       K. Vermeij          Initial version
*/
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