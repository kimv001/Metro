







CREATE view [bld].[tr_200_Attribute_020_DatasetTrnAttributes] as 

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

with prep as (
select 
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
      ,try_cast(replace([Isnullable],' ','') as int) as [Isnullable]
      ,try_cast(replace([OrdinalPosition],' ','')  as int) as [OrdinalPosition]
      ,try_cast(replace([MaximumLength],' ','')  as int) as [MaximumLength]
      ,try_cast(replace([Precision],' ','') as int) as [Precision]
      ,try_cast(replace([Scale],' ','') as int) as [Scale]
      ,[Collation]
	  ,[DefaultValue]
      ,[mta_RowNum]
      ,[mta_BK]
      ,[mta_BKH]
      ,[mta_RH]
      ,[mta_Source]
      ,[mta_Loaddate] 
from [rep].[vw_DatasetTrnAttribute] src
)

, base as (
	SELECT  
		  BK										= concat(d.[BK],'|',iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhTargetShortName) ,src.[AttributeName]))
		, [Code]									= d.[Code]
		, [Name]									= d.DatasetName+'.['+iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhTargetShortName) ,src.[AttributeName])+']'
		, [BK_Dataset]								= d.BK
		, [Dataset]									= d.DatasetName
		, [AttributeName]							= iif( d.[ReplaceAttributeNames]='1', replace(src.[AttributeName], d.shortname, d.dwhTargetShortName) ,src.[AttributeName])
		, src.[Description]
		, src.[Expression]
		, src.[DistributionHashKey]
		, [NotInRH]									= ISNULL(src.[NotInRH],0)
		, [BusinessKey]								= cast(isnull(src.[BusinessKey],0) as int)
		, src.[SrcName]
		, src.[BK_RefType_DataType]
		, DataType									= dtm.DataTypeMapped

		, FixedSchemaDataType						= Cast(dtm.FixedSchemaDataType as varchar(1))
		, OrgMappedDataType							= dtm.OrgMappedDataType
		, [Isnullable]								= Cast(ISNULL(iif(dtm.FixedSchemaDataType=1,1, src.[Isnullable]),1) as varchar(1))
		, [OrdinalPosition]							= Cast(Row_Number() Over (Partition By d.BK order by cast(src.[OrdinalPosition] as int) asc) as varchar(3))
		, [MaximumLength]							= Cast( Case 
																When dtm.FixedSchemaDataType=1 
																	Then 
																		Case 
																			When (src.MaximumLength = -1 OR src.MaximumLength > 255) and ISNULL(src.[NotInRH],0)='1'	Then 'max'

																			When (src.MaximumLength = -1 OR src.MaximumLength > 255) and dtm.DataTypeMapped = 'varchar'		Then '8000'
																			When (src.MaximumLength = -1 OR src.MaximumLength > 255) and dtm.DataTypeMapped = 'nvarchar'	Then '4000'
																			Else '255'
																		End 
																Else 
																	Case 
																		when src.MaximumLength = -1 and ISNULL(src.[NotInRH],0)='1'			Then 'max'
																		when src.MaximumLength = -1 and dtm.DataTypeMapped = 'varchar'		Then '8000'
																		when src.MaximumLength = -1 and dtm.DataTypeMapped = 'nvarchar'		Then '4000'
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
	Join bld.vw_Dataset					d	on d.code		= src.BK_DatasetTrn
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
	, src.[DefaultValue]
	, DDL_Type1				= CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
	, DDL_Type2				=  CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
								+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')
	, DDL_Type3				=  'AS '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename(src.[DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',[Precision],',', [Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float', 'int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
	, DDL_Type4				=  'AS '+ 
								CASE 
									WHEN (src.[DataType] IN ('nchar', 'nvarchar', 'char', 'varchar', 'varbinary'))	THEN CONCAT(Quotename([DataType]),'(',src.[MaximumLength],')')
									WHEN (src.[DataType] IN ('numeric', 'decimal')) THEN  CONCAT(Quotename(src.[DataType]),'(',src.[Precision],',', src.[Scale],')')
									WHEN (src.[DataType] IN ('date','datetime','datetime2', 'time','smallint', 'float','int','bigint', 'tinyint', 'uniqueidentifier', 'xml', 'bit')) THEN Quotename(src.[DataType])
								END
								+  IIF(src.IsNullable=1, ' NULL ', ' NOT NULL ')

from 	base src
  where 1=1
--and src.bk_dataset = 'DWH|fct||monitor|sourcefilesdelivered|'
  --and code = 'DWH|dim|trvs|Common|Date|'

  --and bk_dataset = 'DWH|dim|vw|Common|StartDate|'
  --and bk_dataset = 'DWH|dim|vw|Common|EndDate|'