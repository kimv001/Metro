









CREATE VIEW [bld].[tr_230_Attribute_030_AddMtaAttributes] AS 
/* 
=== Comments =========================================

Description:
	creates mta_attributes for all datasets
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Add column [mta_rectype] to Activate SmartLoad
20230326	1315		K. Vermeij				removed join with layer
=======================================================
*/
WITH max_ordinal
AS (
	SELECT 
		  bk_dataset					= d.bk
		, datasetname					= d.datasetname
		, code							= d.code
		, bk_schema						= d.bk_schema
		, floworder						= d.floworder
		, bk_reftype_objecttype			= d.bk_reftype_objecttype
		, bk_reftype_repositorystatus	= d.bk_reftype_repositorystatus
		, max_ordinal					= max(CAST(a.ordinalposition AS INT))
	FROM bld.vw_attribute	a
	JOIN bld.vw_dataset		d	ON d.bk			= a.bk_dataset
	WHERE a.ismta = 0 AND d.isdwh = 1
	GROUP BY 
		  d.bk
		, d.code
		, d.bk_schema
		, d.floworder
		, d.datasetname
		, d.[BK_RefType_ObjectType]
		, d.bk_reftype_repositorystatus
		
	)
--, DataTypeMapping as (

SELECT
		 bk											= concat(o.bk_dataset,'|', ma.[Name])
		, [Code]									= o.[Code]
		, [Name]									= o.datasetname+'.['+ma.[Name]+']'
		, [BK_Dataset]								= o.bk_dataset
		, [Dataset]									= o.datasetname
		, [AttributeName]							= ma.[Name]
		, [Description]								= isnull(ma.[Description],'')
		, [Expression]								= ''
		, [DistributionHashKey]						= ''
		, [NotInRH]									= 1
		, [BusinessKey]								= 0
		, [isMta]									= 1
		, [SrcName]									= ma.[Name]
		, [BK_RefType_DataType]						= ma.bk_reftype_datatype
		, datatype									= ma.bk_reftype_datatype

		, fixedschemadatatype						= 0
		, orgmappeddatatype							= ma.bk_reftype_datatype
		, [Isnullable]								= ma.isnullable
		, [OrdinalPosition]							= o.max_ordinal + ma.ordinalposition
		, [MaximumLength]							= isnull(ma.maximumlength,'')
		, [Precision]								= isnull(ma.[Precision],'')
		, [Scale]									= isnull(ma.[Scale],'')
		, [Collation]								= ''
		, defaultvalue								= ma.[Default]
		, [Active]									= ma.active
		, floworder									= o.floworder
		, [BK_RefType_ObjectType]						= o.[BK_RefType_ObjectType]
		, bk_reftype_repositorystatus				= o.bk_reftype_repositorystatus
		, ddl_type1				= CASE 
									WHEN
									    (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))
									    THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[Precision],',', ma.[Scale],')')
									WHEN
									    (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(ma.[BK_RefType_DataType])
								END
		, ddl_type2				=  CASE 
									WHEN
									    (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))
									    THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[Precision],',', ma.[Scale],')')
									WHEN
									    (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(ma.[BK_RefType_DataType])
								END
								+  IIF(ma.isnullable=1, ' NULL ', ' NOT NULL ')
		, ddl_type3				=  'AS '+ 
								CASE 
									WHEN
									    (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))
									    THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',[Precision],',', [Scale],')')
									WHEN
									    (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(ma.[BK_RefType_DataType])
								END
		, ddl_type4				=  'AS '+ 
								CASE 
									WHEN
									    (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))
									    THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[Precision],',', ma.[Scale],')')
									WHEN
									    (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(ma.[BK_RefType_DataType])
								END
								+  IIF(ma.isnullable=1, ' NULL ', ' NOT NULL ')
		, mta_rectype		= diff.rectype
FROM max_ordinal o
JOIN rep.vw_mtaattribute ma ON ma.bk_reftype_objecttype = o.[BK_RefType_ObjectType]
	AND ma.bk_schema = o.bk_schema
 LEFT JOIN [bld].[vw_AttributeSmartLoad] diff ON o.code = diff.code