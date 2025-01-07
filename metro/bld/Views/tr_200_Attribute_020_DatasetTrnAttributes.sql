







CREATE VIEW [bld].[tr_200_Attribute_020_DatasetTrnAttributes] AS 

/* 
=== Comments =========================================

Description:
	Get all attributes for Transformation view Datasets 


	
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
		  bk										= concat(d.[BK],'|',iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhtargetshortname) ,src.[AttributeName]))
		, [Code]									= d.[Code]
		, [Name]									= d.datasetname
		+'.['
		+iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhtargetshortname) ,src.[AttributeName])
		+']'
		, [BK_Dataset]								= d.bk
		, [Dataset]									= d.datasetname
		, [AttributeName]							= iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhtargetshortname) ,src.[AttributeName])
		, src.[Description]
		, src.[Expression]
		, src.[DistributionHashKey]
		, [NotInRH]									= ISNULL(src.[NotInRH],0)
		, [BusinessKey]								= CAST(isnull(src.[BusinessKey],0) AS int)
		, src.[SrcName]
		, src.[BK_RefType_DataType]
		, datatype									= dtm.datatypemapped

		, fixedschemadatatype						= CAST(dtm.fixedschemadatatype AS varchar(1))
		, orgmappeddatatype							= dtm.orgmappeddatatype
		, [Isnullable]								= CAST(ISNULL(iif(dtm.fixedschemadatatype=1,1, src.[Isnullable]),1) AS varchar(1))
		, [OrdinalPosition]							= CAST(ROW_NUMBER() OVER (PARTITION BY d.bk ORDER BY CAST(src.[OrdinalPosition] AS int) ASC) AS varchar(3))
		, [MaximumLength]							= CAST( CASE 
																WHEN dtm.fixedschemadatatype=1 
																	THEN 
																		CASE 
																			WHEN (src.maximumlength = -1 OR src.maximumlength > 255) AND ISNULL(src.[NotInRH],0)='1'	THEN 'max'

																			WHEN (src.maximumlength = -1 OR src.maximumlength > 255) AND dtm.datatypemapped = 'varchar'		THEN '8000'
																			WHEN (src.maximumlength = -1 OR src.maximumlength > 255) AND dtm.datatypemapped = 'nvarchar'	THEN '4000'
																			ELSE '255'
																		END 
																ELSE 
																	CASE 
																		WHEN src.maximumlength = -1 AND ISNULL(src.[NotInRH],0)='1'			THEN 'max'
																		WHEN src.maximumlength = -1 AND dtm.datatypemapped = 'varchar'		THEN '8000'
																		WHEN src.maximumlength = -1 AND dtm.datatypemapped = 'nvarchar'		THEN '4000'
																		ELSE ISNULL(src.maximumlength,'')	
																	END
																END
														AS varchar(10))
		, [Precision]								= iif(dtm.fixedschemadatatype=1,'',isnull(src.[Precision],''))
		, [Scale]									= iif(dtm.fixedschemadatatype=1,'',isnull(src.[Scale],''))
		, src.[Collation]
		, [DefaultValue]							= COALESCE(src.[DefaultValue], dtm.defaultvalue)
		, src.[Active]
		, floworder									= d.floworder
		, d.[BK_RefType_ObjectType]
		, d.bk_reftype_repositorystatus
	


	FROM prep src
	JOIN bld.vw_dataset					d	ON d.code		= src.bk_datasettrn
	JOIN [bld].[vw_DataTypesBySchema]	dtm	ON d.bk_schema	= dtm.bk_schema AND src.bk_reftype_datatype = dtm.datatypeinrep
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
	, ismta					= 0
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
	, src.bk_reftype_repositorystatus	
	, src.[DefaultValue]
	, ddl_type1				= CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
	, ddl_type2				=  CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
								+  IIF(src.isnullable=1, ' NULL ', ' NOT NULL ')
	, ddl_type3				=  'AS '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',[Precision],',', [Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
	, ddl_type4				=  'AS '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename([DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
								+  IIF(src.isnullable=1, ' NULL ', ' NOT NULL ')

FROM 	base src
  WHERE 1=1
--and src.bk_dataset = 'DWH|fct||monitor|sourcefilesdelivered|'
  --and code = 'DWH|dim|trvs|Common|Date|'

  --and bk_dataset = 'DWH|dim|vw|Common|StartDate|'
  --and bk_dataset = 'DWH|dim|vw|Common|EndDate|'