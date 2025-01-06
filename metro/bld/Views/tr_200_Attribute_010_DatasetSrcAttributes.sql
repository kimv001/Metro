




CREATE view [bld].[tr_200_Attribute_010_DatasetSrcAttributes] as 
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

with prep as (

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
      ,try_cast(replace([Isnullable],' ','') as int) as [Isnullable]
      ,try_cast(replace([OrdinalPosition],' ','')  as int) as [OrdinalPosition]
      --,try_cast(replace([MaximumLength],' ','')  as int) as [MaximumLength]
	  , [MaximumLength]
      ,try_cast(replace([Precision],' ','') as int) as [Precision]
      ,try_cast(replace([Scale],' ','') as int) as [Scale]
      ,[Collation]
      ,[mta_RowNum]
      ,[mta_BK]
      ,[mta_BKH]
      ,[mta_RH]
      ,[mta_Source]
      ,[mta_Loaddate]
  FROM [rep].[vw_DatasetSrcAttribute]
  )
  , base as (
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
		, [BusinessKey]								= cast(
															isnull(
																	iif(
																		ltrim(rtrim(src.[BusinessKey])) = '',null,ltrim(rtrim(src.[BusinessKey])) )
																,0) 
																as varchar(3))
		, src.[SrcName]
		, src.[BK_RefType_DataType]

		, DataType									= dtm.DataTypeMapped

		, FixedSchemaDataType						= Cast(dtm.FixedSchemaDataType as varchar(1))
		, OrgMappedDataType							= dtm.OrgMappedDataType
		, [Isnullable]								= Cast(ISNULL(iif(dtm.FixedSchemaDataType=1,1, src.[Isnullable]),1) as varchar(1))
		, [OrdinalPosition]							= Cast(Row_Number() Over (Partition By d.BK order by cast(ltrim(rtrim(src.[OrdinalPosition])) as int) asc) as varchar(3))
		, [MaximumLength]							= Cast( Case 
																When dtm.FixedSchemaDataType='1'  
																	Then  
																		Case 
																			When  ISNULL(iif(ltrim(rtrim(src.[NotInRH]))='','0',src.[NotInRH]) ,0)='1'																Then 'max'

																			When /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.DataTypeMapped = 'varchar'		Then '8000'
																			--When /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.DataTypeMapped = 'nvarchar'	Then '4000'
																			Else '4000'
																		End 
																Else 
																	Case 
																		when src.MaximumLength = '-1' and ISNULL(src.[NotInRH],0)='1'			Then 'max'
																		when src.MaximumLength = '-1' and dtm.DataTypeMapped = 'varchar'		Then '8000'
																		when src.MaximumLength = '-1' and dtm.DataTypeMapped = 'nvarchar'		Then '4000'
																		else ISNULL(src.MaximumLength,'')	
																	End
																End
														as varchar(10))
		, [Precision]								= iif(dtm.FixedSchemaDataType=1,'',isnull(src.[Precision],''))
		, [Scale]									= iif(dtm.FixedSchemaDataType=1,'',isnull(src.[Scale],''))
		, src.[Collation]
		, [DefaultValue]							= coalesce(src.[DefaultValue], dtm.DefaultValue)
		, src.[Active]
		, FlowOrder									= d.FlowOrder
		, d.[BK_RefType_ObjectType]
		, d.BK_RefType_RepositoryStatus	
	


			FROM prep src
	Join bld.vw_Dataset					d	on d.code		= src.BK_DatasetSrc
	join [bld].[vw_DataTypesBySchema]	dtm	on d.BK_Schema	= dtm.BK_Schema and src.BK_RefType_DataType = dtm.DataTypeInRep
	where 1=1


		)


SELECT 
	  src.[BK]
	, src.[Code]
	, src.[Name]
	, src.[BK_Dataset]
	, src.[Dataset]
	, src.[AttributeName]
	, src.[Description]
	, [Expression]			= cast(src.[Expression] as varchar(max))
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
	, DefaultValue			= src.[DefaultValue]
	, DDL_Type1				= CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
	, DDL_Type2				=  CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
								+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')
	, DDL_Type3				=  'as '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',[Precision],',', [Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
	, DDL_Type4				=  'as '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename([DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
								+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')


from 	base src
--where dataset = '[stg].[SF_Netcodec]'
--where bk = 'DWH|pst||AuraPortal|ClaseProcesoPtr15General||3_ETNN_EXT_BssEneId'	