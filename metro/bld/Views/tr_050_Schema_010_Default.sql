

CREATE view [bld].[tr_050_Schema_010_Default] as
/* 
=== Comments =========================================

Description:
	Get all unique properties of a Schema
	
Changelog:
Date		time		Author					Description
20230326	1200		K. Vermeij				Initial
=======================================================
*/



select 
	BK						= s.[BK]
	, Code					= s.[Code]
	, [Name]				= s.[Name]
	, BK_Schema				= s.[BK]
	, BK_Layer				= s.[BK_Layer]
	, BK_DataSource			= s.[BK_DataSource]
	, BK_LinkedService		= ds.[BK_LinkedService]
	, SchemaCode			= s.[Code]
	, SchemaName			= s.[Name]
	, DataSourceCode		= ds.[Code]
	, DataSourceName		= ds.[Name]
	, BK_DataSourceType		= dst.[BK]
	, DataSourceTypeCode	= dst.[Code]
	, DataSourceTypeName	= dst.[Name]
	, LayerCode				= l.[Code]
	, LayerName				= l.[Name]
	, LayerOrder			= isnull(cast(l.[LayerOrder] as int),0) + (isnull(cast([process_order_in_layer] as int), 0)*10)
	, ProcessOrderLayer		= s.[process_order_in_layer]
	, ProcessParallel		= s.[process_parallel]
	, isDWH					= l.[isDWH]
	, isSRC					= l.[isSRC]
	, isTGT					= l.[isTGT]
	, IsRep					= ds.[IsRep]
	, CreateDummies			= s.[CreateDummies]

	, LinkedServiceCode		= ls.[Code]
	, LinkedServiceName		= ls.[Name]

	, s.BK_Template_Create
	, s.BK_Template_Load
	, s.BK_RefType_ToChar

from rep.vw_Schema			s	
join rep.vw_Layer			l	on l.BK			= s.BK_Layer
join rep.vw_DataSource		ds	on ds.BK		= s.BK_DataSource
join bld.vw_RefType			dst	on dst.BK		= ds.BK_RefType_DataSourceType
join rep.vw_LinkedService	ls	on ls.BK		= ds.BK_LinkedService