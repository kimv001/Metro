
CREATE VIEW [bld].[tr_200_Attribute_020_DatasetTrnAttributes] AS 

/* 
=== Comments =========================================

Description:
    Get all attributes for Transformation view Datasets.

Columns:
    - BK: The business key of the attribute.
    - Code: The code of the attribute.
    - Name: The name of the attribute.
    - BK_DatasetTrn: The business key of the transformation dataset.
    - DatasetTrn: The transformation dataset.
    - AttributeName: The name of the attribute.
    - Description: The description of the attribute.
    - Active: Indicates if the attribute is active.
    - DistributionHashKey: The distribution hash key of the attribute.
    - Expression: The expression used for the attribute.
    - NotInRH: Indicates if the attribute is not in the reference hub.
    - BusinessKey: Indicates if the attribute is a business key.
    - SrcName: The source name of the attribute.
    - BK_RefType_DataType: The business key of the reference type data type.
    - Isnullable: Indicates if the attribute is nullable.
    - OrdinalPosition: The ordinal position of the attribute.
    - MaximumLength: The maximum length of the attribute.
    - Precision: The precision of the attribute.
    - Scale: The scale of the attribute.

Example Usage:
    SELECT * FROM [bld].[tr_200_Attribute_020_DatasetTrnAttributes]

Logic:
    1. Selects attribute definitions from the [rep].[vw_Attribute] view.
    2. Prepares the base attribute information.
    3. Joins with other relevant views to get additional attribute attributes.

Source Data:
    - [rep].[vw_Attribute]: Contains attribute definitions for datasets.
    - [rep].[vw_Schema]: Defines the schema for datasets, acting as a layer between the dataset and data source.
    - [rep].[vw_DataSource]: Contains information about data sources.
    - [rep].[vw_Group]: Grouping sets of datasets, mandatory for defining source and transformation datasets.
    - [rep].[vw_Segment]: Organizational grouping of publication tables.
    - [rep].[vw_Bucket]: Defines buckets for organizing datasets.


	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230301	0845		K. Vermeij				Made a case statement if maximum length = '-1'
20230301	1230		K. Vermeij				Replace the attributename with alias view name
=======================================================
*/

WITH prep AS (
SELECT 
	[BK]
      ,[Code]
      ,[Name]
      ,[BK_DatasetTrn]
      ,[DatasetTrn]
      ,[AttributeName]
      ,[Description]
      ,[Active]
      ,[DistributionHashKey]
      ,[Expression]
      ,[NotInRH]
      ,[BusinessKey]
      ,[SrcName]
      ,[BK_RefType_DataType]
      ,try_cast(replace([Isnullable],' ','') AS int) AS [Isnullable]
      ,try_cast(replace([OrdinalPosition],' ','')  AS int) AS [OrdinalPosition]
      ,try_cast(replace([MaximumLength],' ','')  AS int) AS [MaximumLength]
      ,try_cast(replace([Precision],' ','') AS int) AS [Precision]
      ,try_cast(replace([Scale],' ','') AS int) AS [Scale]
      ,[Collation]
	  ,[SCDDate]	
	  ,[DefaultValue]
      ,[mta_RowNum]
      ,[mta_BK]
      ,[mta_BKH]
      ,[mta_RH]
      ,[mta_Source]
      ,[mta_Loaddate] 
FROM [rep].[vw_DatasetTrnAttribute] src
)

, base AS (
	SELECT  
		  BK										= concat(d.[BK],'|',iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhTargetShortName) ,src.[AttributeName]))
		, [Code]									= d.[Code]
		, [Name]									= d.DatasetName
		+'.['
		+iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhTargetShortName) ,src.[AttributeName])
		+']'
		, [BK_Dataset]								= d.BK
		, [Dataset]									= d.DatasetName
		, [AttributeName]							= iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhTargetShortName) ,src.[AttributeName])
		, src.[Description]
		, src.[Expression]
		, src.[DistributionHashKey]
		, [NotInRH]									= ISNULL(src.[NotInRH],0)
		, [BusinessKey]								= CAST(isnull(src.[BusinessKey],0) AS int)
		, src.[SrcName]
		, src.[BK_RefType_DataType]
		, DataType									= dtm.DataTypeMapped

		, FixedSchemaDataType						= CAST(dtm.FixedSchemaDataType AS varchar(1))
		, OrgMappedDataType							= dtm.OrgMappedDataType
		, [Isnullable]								= CAST(ISNULL(iif(dtm.FixedSchemaDataType=1,1, src.[Isnullable]),1) AS varchar(1))
		, [OrdinalPosition]							= CAST(ROW_NUMBER() OVER (PARTITION BY d.BK ORDER BY CAST(src.[OrdinalPosition] AS int) ASC) AS varchar(3))
		, [MaximumLength]							= CAST( CASE 
																WHEN dtm.FixedSchemaDataType=1 
																	THEN 
																		CASE 
																			WHEN (src.MaximumLength = -1 OR src.MaximumLength > 255) AND ISNULL(src.[NotInRH],0)='1'	THEN 'max'

																			WHEN (src.MaximumLength = -1 OR src.MaximumLength > 255) AND dtm.DataTypeMapped = 'varchar'		THEN '8000'
																			WHEN (src.MaximumLength = -1 OR src.MaximumLength > 255) AND dtm.DataTypeMapped = 'nvarchar'	THEN '4000'
																			ELSE '255'
																		END 
																ELSE 
																	CASE 
																		WHEN src.MaximumLength = -1 AND ISNULL(src.[NotInRH],0)='1'			THEN 'max'
																		WHEN src.MaximumLength = -1 AND dtm.DataTypeMapped = 'varchar'		THEN '8000'
																		WHEN src.MaximumLength = -1 AND dtm.DataTypeMapped = 'nvarchar'		THEN '4000'
																		ELSE ISNULL(src.MaximumLength,'')	
																	END
																END
														AS varchar(10))
		, [Precision]								= iif(dtm.FixedSchemaDataType=1,'',isnull(src.[Precision],''))
		, [Scale]									= iif(dtm.FixedSchemaDataType=1,'',isnull(src.[Scale],''))
		, src.[Collation]
		, src.[SCDDate]	
		, [DefaultValue]							= COALESCE(src.[DefaultValue], dtm.DefaultValue)
		, src.[Active]
		, FlowOrder									= d.FlowOrder
		, d.[BK_RefType_ObjectType]
		, d.BK_RefType_RepositoryStatus
	


	FROM prep src
	JOIN bld.vw_Dataset					d	ON d.code		= src.BK_DatasetTrn
	JOIN [bld].[vw_DataTypesBySchema]	dtm	ON d.BK_Schema	= dtm.BK_Schema AND src.BK_RefType_DataType = dtm.DataTypeInRep
	WHERE 1=1


		)


SELECT 
	  src.[BK]
	, src.[Code]
	, src.[Name]
	, src.[BK_Dataset]
	, src.[Dataset]
	, src.[AttributeName]
	, src.[Description]
	, src.[Expression]
	, src.[DistributionHashKey]
	, src.[NotInRH]
	, src.[BusinessKey]
	, isMta					= 0
	, src.[SrcName]
	, src.[BK_RefType_DataType]
	, src.[DataType]
	, src.[FixedSchemaDataType]
	, src.[OrgMappedDataType]
	, src.[Isnullable]
	, src.[OrdinalPosition]
	, src.[MaximumLength]
	, src.[Precision]
	, src.[Scale]
	, src.[Collation]
	, src.[Active]
	, src.[FlowOrder]  
	, src.[BK_RefType_ObjectType]
	, src.BK_RefType_RepositoryStatus
	, src.[SCDDate]	
	, src.[DefaultValue]
	, DDL_Type1				= CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
	, DDL_Type2				=  CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
								+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')
	, DDL_Type3				=  'AS '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',[Precision],',', [Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
	, DDL_Type4				=  'AS '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename([DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
								+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')

FROM 	base src
  WHERE 1=1
--and src.bk_dataset = 'DWH|fct||monitor|sourcefilesdelivered|'
  --and code = 'DWH|dim|trvs|Common|Date|'

  --and bk_dataset = 'DWH|dim|vw|Common|StartDate|'
  --and bk_dataset = 'DWH|dim|vw|Common|EndDate|'