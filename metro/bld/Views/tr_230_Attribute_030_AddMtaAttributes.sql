









CREATE view [bld].[tr_230_Attribute_030_AddMtaAttributes] as 
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
	Select 
		  BK_Dataset					= d.BK
		, DatasetName					= d.DatasetName
		, Code							= d.Code
		, BK_Schema						= d.BK_Schema
		, FlowOrder						= d.FlowOrder
		, BK_RefType_ObjectType			= d.BK_RefType_ObjectType
		, BK_RefType_RepositoryStatus	= d.BK_RefType_RepositoryStatus
		, max_ordinal					= max(cast(a.OrdinalPosition AS INT))
	From bld.vw_Attribute	a
	join bld.vw_Dataset		d	on d.BK			= a.BK_Dataset
	Where A.isMta = 0 and d.isDWH = 1
	Group by 
		  d.BK
		, d.Code
		, d.BK_Schema
		, d.FlowOrder
		, d.DatasetName
		, d.[BK_RefType_ObjectType]
		, d.BK_RefType_RepositoryStatus
		
	)
--, DataTypeMapping as (

SELECT
		 BK											= concat(o.BK_dataset,'|', ma.[Name])
		, [Code]									= o.[Code]
		, [Name]									= o.DatasetName+'.['+ma.[Name]+']'
		, [BK_Dataset]								= o.BK_dataset
		, [Dataset]									= o.DatasetName
		, [AttributeName]							= ma.[Name]
		, [Description]								= isnull(ma.[Description],'')
		, [Expression]								= ''
		, [DistributionHashKey]						= ''
		, [NotInRH]									= 1
		, [BusinessKey]								= 0
		, [isMta]									= 1
		, [SrcName]									= ma.[Name]
		, [BK_RefType_DataType]						= ma.BK_RefType_DataType
		, DataType									= ma.BK_RefType_DataType

		, FixedSchemaDataType						= 0
		, OrgMappedDataType							= ma.BK_RefType_DataType
		, [Isnullable]								= ma.Isnullable
		, [OrdinalPosition]							= o.max_ordinal + ma.OrdinalPosition
		, [MaximumLength]							= isnull(ma.MaximumLength,'')
		, [Precision]								= isnull(ma.[Precision],'')
		, [Scale]									= isnull(ma.[Scale],'')
		, [Collation]								= ''
		, DefaultValue								= ma.[Default]
		, [Active]									= ma.Active
		, FlowOrder									= o.FlowOrder
		, [BK_RefType_ObjectType]						= o.[BK_RefType_ObjectType]
		, BK_RefType_RepositoryStatus				= o.BK_RefType_RepositoryStatus
		, DDL_Type1				= CASE 
									WHEN (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[Precision],',', ma.[Scale],')')
									WHEN (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(ma.[BK_RefType_DataType])
								END
		, DDL_Type2				=  CASE 
									WHEN (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[Precision],',', ma.[Scale],')')
									WHEN (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(ma.[BK_RefType_DataType])
								END
								+  IIF(ma.IsNullable=1, ' NULL ', ' NOT NULL ')
		, DDL_Type3				=  'AS '+ 
								CASE 
									WHEN (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',[Precision],',', [Scale],')')
									WHEN (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(ma.[BK_RefType_DataType])
								END
		, DDL_Type4				=  'AS '+ 
								CASE 
									WHEN (ma.[BK_RefType_DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[MaximumLength],')')
									WHEN (ma.[BK_RefType_DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(ma.[BK_RefType_DataType]),'(',ma.[Precision],',', ma.[Scale],')')
									WHEN (ma.[BK_RefType_DataType] IN ('date','datetime','datetime2', 'time','smallint', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(ma.[BK_RefType_DataType])
								END
								+  IIF(ma.IsNullable=1, ' NULL ', ' NOT NULL ')
		, mta_RecType		= diff.RecType
FROM max_ordinal O
JOIN rep.vw_MtaAttribute MA ON MA.BK_RefType_ObjectType = o.[BK_RefType_ObjectType]
	AND ma.BK_Schema = o.BK_Schema
 left join [bld].[vw_AttributeSmartLoad] Diff on o.Code = Diff.Code