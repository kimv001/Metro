




CREATE VIEW [bld].[tr_200_Attribute_010_DatasetSrcAttributes] AS 
/* 
=== Comments =========================================

Description:
	Get all attributes for Source Datasets 


	
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
		  bk										= concat(d.[BK],'|',src.[AttributeName])
		, [Code]									= src.[BK_DatasetSrc]
		, [Name]									= d.datasetname+'.['+src.[AttributeName]+']'
		, [BK_Dataset]								= d.bk
		, [Dataset]									= d.datasetname
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

		, datatype									= dtm.datatypemapped

		, fixedschemadatatype						= CAST(dtm.fixedschemadatatype AS varchar(1))
		, orgmappeddatatype							= dtm.orgmappeddatatype
		, [Isnullable]								= CAST(ISNULL(iif(dtm.fixedschemadatatype=1,1, src.[Isnullable]),1) AS varchar(1))
		, [OrdinalPosition]							= CAST(ROW_NUMBER() OVER (PARTITION BY d.bk ORDER BY CAST(ltrim(rtrim(src.[OrdinalPosition])) AS int) ASC) AS varchar(3))
		, [MaximumLength]							= CAST( CASE 
																WHEN dtm.fixedschemadatatype='1'  
																	THEN  
																		CASE 
																			WHEN  ISNULL(iif(ltrim(rtrim(src.[NotInRH]))='','0',src.[NotInRH]) ,0)='1'																THEN 'max'

																			WHEN /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.datatypemapped = 'varchar'		THEN '8000'
																			--When /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.DataTypeMapped = 'nvarchar'	Then '4000'
																			ELSE '4000'
																		END 
																ELSE 
																	CASE 
																		WHEN src.maximumlength = '-1' AND ISNULL(src.[NotInRH],0)='1'			THEN 'max'
																		WHEN src.maximumlength = '-1' AND dtm.datatypemapped = 'varchar'		THEN '8000'
																		WHEN src.maximumlength = '-1' AND dtm.datatypemapped = 'nvarchar'		THEN '4000'
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
	JOIN bld.vw_dataset					d	ON d.code		= src.bk_datasetsrc
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
	, [Expression]			= CAST(src.[Expression] AS varchar(MAX))
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
	, defaultvalue			= src.[DefaultValue]
	, ddl_type1				= CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
	, ddl_type2				=  CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
								+  IIF(src.isnullable=1, ' NULL ', ' NOT NULL ')
	, ddl_type3				=  'as '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',[Precision],',', [Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
	, ddl_type4				=  'as '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename([DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN
									    (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit'))
									    THEN Quotename(src.[DataType])
								END
								+  IIF(src.isnullable=1, ' NULL ', ' NOT NULL ')


FROM 	base src
--where dataset = '[stg].[SF_Netcodec]'
--where bk = 'DWH|pst||AuraPortal|ClaseProcesoPtr15General||3_ETNN_EXT_BssEneId'	