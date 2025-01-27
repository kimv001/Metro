

CREATE VIEW [bld].[tr_050_Schema_010_Default] AS
/* 
=== Comments =========================================

Description:
    This view provides a list of schemas and their associated metadata from various source views. It includes information about the schema, data source, linked service, and other related attributes. This view is used to get all unique properties of a schema.

Columns:
    - BK: The business key of the schema.
    - Code: The code of the schema.
    - Name: The name of the schema.
    - BK_Schema: The business key of the schema.
    - BK_Layer: The business key of the layer.
    - BK_DataSource: The business key of the data source.
    - BK_LinkedService: The business key of the linked service.
    - SchemaCode: The code of the schema.
    - SchemaName: The name of the schema.
    - DataSourceCode: The code of the data source.
    - DataSourceName: The name of the data source.
    - BK_DataSourceType: The business key of the data source type.
    - DataSourceTypeCode: The code of the data source type.
    - DataSourceTypeName: The name of the data source type.
    - LayerCode: The code of the layer.
    - LayerName: The name of the layer.
    - LayerOrder: The order of the layer.
    - ProcessOrderLayer: The process order of the layer.
    - ProcessParallel: Indicates if the process is parallel.
    - isDWH: Indicates if the schema is part of the data warehouse.
    - isSRC: Indicates if the schema is a source.
    - isTGT: Indicates if the schema is a target.
    - IsREP: Indicates if the schema is a repository.
    - CreateDummies: Indicates if dummy data should be created.
    - LinkedServiceCode: The code of the linked service.
    - LinkedServiceName: The name of the linked service.

Example Usage:
    SELECT * FROM [bld].[tr_050_Schema_010_Default]

Logic:
    1. Selects schema data from the base view.
    2. Joins with the reference type view to get data source type information.
    3. Joins with the linked service view to get linked service information.
    4. Filters and selects the required columns.

Source Data:
    - [rep].[vw_RefType]: Contains reference types used in the data warehouse.
    - [rep].[vw_LinkedService]: Contains information about linked services required for connecting to source or target systems.
    - [rep].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [rep].[vw_DataSource]: Contains information about data sources.
    - [rep].[vw_Layer]: Defines the purpose of a data source schema (source, DWH, target system).
	
Changelog:
Date		time		Author					Description
20230326	1200		K. Vermeij				Initial
=======================================================
*/


WITH base AS (
SELECT 
	BK						= S.[BK]
	, CODE					= S.[Code]
	, [Name]				= S.[Name]
	, BK_SCHEMA				= S.[BK]
	, BK_LAYER				= S.[BK_Layer]
	, BK_DATASOURCE			= S.[BK_DataSource]
	, BK_LINKEDSERVICE		= DS.[BK_LinkedService]
	, SCHEMACODE			= S.[Code]
	, SCHEMANAME			= S.[Name]
	, DATASOURCECODE		= DS.[Code]
	, DATASOURCENAME		= DS.[Name]
	, BK_DATASOURCETYPE		= DST.[BK]
	, DATASOURCETYPECODE	= DST.[Code]
	, DATASOURCETYPENAME	= DST.[Name]
	, LAYERCODE				= L.[Code]
	, LAYERNAME				= L.[Name]
	, LAYERORDER			= isnull(CAST(L.[LayerOrder] AS int),0) + (isnull(CAST([process_order_in_layer] AS int), 0)*10)
	, PROCESSORDERLAYER		= S.[process_order_in_layer]
	, PROCESSPARALLEL		= S.[process_parallel]
	, ISDWH					= L.[isDWH]
	, ISSRC					= L.[isSRC]
	, ISTGT					= L.[isTGT]
	, ISREP					= DS.[IsRep]
	, CREATEDUMMIES			= S.[CreateDummies]
	, LINKEDSERVICECODE		= LS.[Code]
	, LINKEDSERVICENAME		= LS.[Name]
	, S.BK_TEMPLATE_CREATE
	, S.BK_TEMPLATE_LOAD
	, S.BK_REFTYPE_TOCHAR
FROM REP.VW_SCHEMA			S	
JOIN REP.VW_LAYER			L	ON L.BK			= S.BK_LAYER
JOIN REP.VW_DATASOURCE		DS	ON DS.BK		= S.BK_DATASOURCE
JOIN BLD.VW_REFTYPE			DST	ON DST.BK		= DS.BK_REFTYPE_DATASOURCETYPE
JOIN REP.VW_LINKEDSERVICE	LS	ON LS.BK		= DS.BK_LINKEDSERVICE
)
-- Select rows from a Table or View 'TableOrViewName' in schema 'SchemaName'
SELECT 
[BK] ,
            [Code],
            [Name],
            [BK_Schema],
            [BK_Layer],
            [BK_DataSource],
            [BK_LinkedService],
            [SchemaCode],
            [SchemaName],
            [DataSourceCode],
            [DataSourceName],
            [BK_DataSourceType],
            [DataSourceTypeCode],
            [DataSourceTypeName],
            [LayerCode],
            [LayerName],
            [LayerOrder],
            [ProcessOrderLayer],
            [ProcessParallel],
            [isDWH],
            [isSRC],
            [isTGT],
            [IsREP],
            [CreateDummies],
            [LinkedServiceCode],
            [LinkedServiceName],
            [BK_Template_Create],
            [BK_Template_Load],
            [BK_RefType_ToChar]
		 FROM base
