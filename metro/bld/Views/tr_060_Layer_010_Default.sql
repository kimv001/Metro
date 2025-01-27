CREATE  VIEW [bld].[tr_060_Layer_010_Default] AS 
/*
Description:
    This view provides a list of layers and their associated metadata from the [rep].[vw_Layer] view. 
	It includes information about the layer name, description, and various flags indicating the type and purpose of the layer.

Columns:
    - BK: The business key of the layer.
    - Code: The code of the layer.
    - Layer_Name: The name of the layer.
    - Layer_Description: The description of the layer.
    - isDWHHelper: Indicates if the layer is a data warehouse helper.
    - isREP: Indicates if the layer is a repository.
    - isAudit: Indicates if the layer is for auditing.
    - isSRC: Indicates if the layer is a source.
    - isDWH: Indicates if the layer is part of the data warehouse.
    - isTGT: Indicates if the layer is a target.
    - Layer_Process_Order: The process order of the layer.

Example Usage:
    SELECT * FROM [bld].[tr_060_Layer_010_Default]

Logic:
    1. Selects layer data from the [rep].[vw_Layer] view.
    2. Filters and selects the required columns.

Source Data:
    - [rep].[vw_Layer]: Defines the purpose of a data source schema (source, DWH, target system).

Changelog:
Date        Time        Author              Description
20230326    12:00       K. Vermeij          Initial version
*/

SELECT 
	bk, 
	code,
	layer_name				= l.[name],
	layer_desciption		= isnull(l.[Description],'<no description available ...>'),
	isdwhhelper				= l.isdwhhelper,
	isrep					= l.isrep,
	isaudit					= l.isaudit,
	issrc					= l.issrc,
	isdwh					= l.isdwh,
	istgt					= l.istgt,
	layer_process_order		= l.layerorder
FROM rep.vw_layer l