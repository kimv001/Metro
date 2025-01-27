





CREATE VIEW [bld].[tr_200_Attribute_010_DatasetSrcAttributes] AS 
/* 
=== Comments =========================================

Description:
    Get all attributes for Source Datasets.

Columns:
    - BK: The business key of the attribute.
    - Code: The code of the attribute.
    - Name: The name of the attribute.
    - DatasetSrc: The source dataset.
    - AttributeName: The name of the attribute.
    - BK_DatasetSrc: The business key of the source dataset.
    - Description: The description of the attribute.
    - Active: Indicates if the attribute is active.
    - DistributionHashKey: The distribution hash key of the attribute.
    - Expression: The expression used for the attribute.
    - DWHName: The data warehouse name of the attribute.
    - NotInRH: Indicates if the attribute is not in the reference hub.
    - BusinessKey: Indicates if the attribute is a business key.
    - DefaultValue: The default value of the attribute.
    - SrcName: The source name of the attribute.
    - BK_RefType_DataType: The business key of the reference type data type.
    - Isnullable: Indicates if the attribute is nullable.
    - OrdinalPosition: The ordinal position of the attribute.
    - MaximumLength: The maximum length of the attribute.
    - Precision: The precision of the attribute.
    - Scale: The scale of the attribute.
    - Collation: The collation of the attribute.

Example Usage:
    SELECT * FROM [bld].[tr_200_Attribute_010_DatasetSrcAttributes]

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
=======================================================
*/

WITH prep AS (

SELECT  [BK]
      ,[Code]
      ,[Name]
      ,[DatasetSrc]
      ,[AttributeName]
      ,[BK_DatasetSrc]
      ,[Description]
      ,[Active]
      ,[DistributionHashKey]
      ,[Expression]
      ,[DWHName]
      ,[NotInRH]
      ,[BusinessKey]
	  ,[DefaultValue]
      ,[SrcName]
      ,[BK_RefType_DataType]
      ,try_cast(replace([Isnullable],' ','') AS int) AS [Isnullable]
      ,try_cast(replace([OrdinalPosition],' ','')  AS int) AS [OrdinalPosition]
      --,try_cast(replace([MaximumLength],' ','')  as int) as [MaximumLength]
	  , [MaximumLength]
      ,try_cast(replace([Precision],' ','') AS int) AS [Precision]
      ,try_cast(replace([Scale],' ','') AS int) AS [Scale]
      ,[Collation]
      ,[mta_RowNum]
      ,[mta_BK]
      ,[mta_BKH]
      ,[mta_RH]
      ,[mta_Source]
      ,[mta_Loaddate]
  FROM [rep].[vw_DatasetSrcAttribute]
  )
  , base AS (
	SELECT  
		  BK										= concat(d.[BK],'|',src.[AttributeName])
		, [Code]									= src.[BK_DatasetSrc]
		, [Name]									= d.DatasetName+'.['+src.[AttributeName]+']'
		, [BK_Dataset]								= d.BK
		, [Dataset]									= d.DatasetName
		, src.[AttributeName]
		, src.[Description]
		, src.[Expression]
		, src.[DistributionHashKey]
		, [NotInRH]									= ISNULL(src.[NotInRH],0)
		, [BusinessKey]								= CAST(
															isnull(
																	iif(
																		ltrim(rtrim(src.[BusinessKey])) = '',null,ltrim(rtrim(src.[BusinessKey])) )
																,0) 
																AS varchar(3))
		, src.[SrcName]
		, src.[BK_RefType_DataType]

		, DataType									= dtm.DataTypeMapped

		, FixedSchemaDataType						= CAST(dtm.FixedSchemaDataType AS varchar(1))
		, OrgMappedDataType							= dtm.OrgMappedDataType
		, [Isnullable]								= CAST(ISNULL(iif(dtm.FixedSchemaDataType=1,1, src.[Isnullable]),1) AS varchar(1))
		, [OrdinalPosition]							= CAST(ROW_NUMBER() OVER (PARTITION BY d.BK ORDER BY CAST(ltrim(rtrim(src.[OrdinalPosition])) AS int) ASC) AS varchar(3))
		, [MaximumLength]							= CAST( CASE 
																WHEN dtm.FixedSchemaDataType='1'  
																	THEN  
																		CASE 
																			WHEN  ISNULL(iif(ltrim(rtrim(src.[NotInRH]))='','0',src.[NotInRH]) ,0)='1'																THEN 'max'

																			WHEN /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.DataTypeMapped = 'varchar'		THEN '8000'
																			--When /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.DataTypeMapped = 'nvarchar'	Then '4000'
																			ELSE '4000'
																		END 
																ELSE 
																	CASE 
																		WHEN src.MaximumLength = '-1' AND ISNULL(src.[NotInRH],0)='1'			THEN 'max'
																		WHEN src.MaximumLength = '-1' AND dtm.DataTypeMapped = 'varchar'		THEN '8000'
																		WHEN src.MaximumLength = '-1' AND dtm.DataTypeMapped = 'nvarchar'		THEN '4000'
																		ELSE ISNULL(src.MaximumLength,'')	
																	END
																END
														AS varchar(10))
		, [Precision]								= iif(dtm.FixedSchemaDataType=1,'',isnull(src.[Precision],''))
		, [Scale]									= iif(dtm.FixedSchemaDataType=1,'',isnull(src.[Scale],''))
		, src.[Collation]
		, [DefaultValue]							= COALESCE(src.[DefaultValue], dtm.DefaultValue)
		, src.[Active]
		, FlowOrder									= d.FlowOrder
		, d.[BK_RefType_ObjectType]
		, d.BK_RefType_RepositoryStatus	
	


			FROM prep src
	JOIN bld.vw_Dataset					d	ON d.code		= src.BK_DatasetSrc
	JOIN [bld].[vw_DataTypesBySchema]	dtm	ON d.BK_Schema	= dtm.BK_Schema AND src.BK_RefType_DataType = dtm.DataTypeInRep
	WHERE 1=1


		)


SELECT 
	  [BK]								= src.[BK]
	, [Code]							= src.[Code]
	, [Name]							= src.[Name]
	, [BK_Dataset]						= src.[BK_Dataset]
	, [Dataset]							= src.[Dataset]
	, [AttributeName]					= src.[AttributeName]
	, [Description]						= src.[Description]
	, [Expression]						= CAST(src.[Expression] AS varchar(MAX))
	, [DistributionHashKey]				= src.[DistributionHashKey]
	, [NotInRH]							= src.[NotInRH]
	, [BusinessKey]						= src.[BusinessKey]
	, [isMta]							= 0
	, [SrcName]							= src.[SrcName]
	, [BK_RefType_DataType]				= src.[BK_RefType_DataType]
	, [DataType]						= src.[DataType]
	, [FixedSchemaDataType]				= src.[FixedSchemaDataType]
	, [OrgMappedDataType]				= src.[OrgMappedDataType]
	, [Isnullable]						= src.[Isnullable]
	, [OrdinalPosition]					= src.[OrdinalPosition]
	, [MaximumLength]					= src.[MaximumLength]
	, [Precision]						= src.[Precision]
	, [Scale]							= src.[Scale]
	, [Collation]						= src.[Collation]
	, [Active]							= src.[Active]
	, [FlowOrder]						= src.[FlowOrder]  
	, [BK_RefType_ObjectType]			= src.[BK_RefType_ObjectType]
	, [BK_RefType_RepositoryStatus]		= src.[BK_RefType_RepositoryStatus]
	, [SCDDate]							= CAST('' AS varchar(255))
	, [DefaultValue]						= src.[DefaultValue]
	, [DDL_Type1]							= CASE 
												WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
												WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
												WHEN
												    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
												    THEN Quotename(src.[DataType])
											END
	, [DDL_Type2]							=  CASE 
												WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
												WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
												WHEN
												    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
												    THEN Quotename(src.[DataType])
											END
											+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')
	, [DDL_Type3]							=  'as '+ 
											CASE 
												WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
												WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',[Precision],',', [Scale],')')
												WHEN
												    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
												    THEN Quotename(src.[DataType])
											END
	, [DDL_Type4]							=  'as '+ 
											CASE 
												WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename([DataType]),'(',src.[MaximumLength],')')
												WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
												WHEN
												    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
												    THEN Quotename(src.[DataType])
											END
											+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')


FROM 	base src