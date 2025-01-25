

CREATE VIEW [bld].[tr_050_Schema_010_Default] AS
/* 
=== Comments =========================================

Description:
	Get all unique properties of a Schema
	
Changelog:
Date		time		Author					Description
20230326	1200		K. Vermeij				Initial
=======================================================
*/


with base as (
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
            [BK_RefType_ToChar],
            [mta_RecType],
            [mta_IsDeleted]
		 FROM base
