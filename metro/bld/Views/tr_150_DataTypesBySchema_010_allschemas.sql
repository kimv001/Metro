





CREATE view [bld].[tr_150_DataTypesBySchema_010_allschemas] as 
/* 
=== Comments =========================================

Description:
	Get DataType per Schema (per DataSourceType)
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20241101	1300		K. Vermeij				Added [DefaultValue]
=======================================================
*/


with FixedSchemaDataType as (

/* get fixed datatypes for scehma's, like "staging" */

	Select  
		  BK_Schema				= ss.BK
		, DataTypeMapped		= dtm.DataTypeByDataSource
	From bld.vw_schema				ss
	join bld.[vw_RefType]			sdt on sdt.bk				= ss.[BK_RefType_ToChar]
	join bld.vw_RefType				dst	on dst.BK				= ss.BK_DataSourceType
	join rep.vw_DataTypeMapping		dtm on dtm.BK_RefType_DST	= dst.bk					and sdt.code = dtm.code
	join bld.vw_RefType				dt	on dt.bk				= dtm.BK_RefType_DataType 
  where sdt.reftype = 'SchemaDataType'

  )
, GenericDataSourcetype as (
	-- select the default DataSourceType. This will be used if no datasource Type is mapped in [DataTypeMapping]
	Select  
		BK_RefType_DataSourceType	= r.BK
	From bld.[vw_RefType] r
	Where r.RefTypeAbbr = 'DST' and cast(r.[isDefault] as int) = 1
)

, DataTypeMapping as (

	-- get all datatypes by DataSourceType

	Select 
		  BK_Schema					= ss.BK
		, DataTypeMapped			= Coalesce(fd.DataTypeMapped,dtm.DataTypeByDataSource, gdtm.DataTypeByDataSource)
		, DataTypeInRep				= Coalesce(dt.Code,gdtm.DataTypeByDataSource)
		, FixedSchemaDataType		= iif(fd.BK_Schema is null, 0, 1)
		, OrgMappedDataType			= Coalesce(dtm.DataTypeByDataSource,gdtm.DataTypeByDataSource)
		, DefaultValue				= coalesce(dt.defaultValue, gdt.DefaultValue)
	From bld.vw_schema					ss
	join rep.vw_DataSource				ds		on ds.bk				= ss.BK_DataSource



	--
	join bld.vw_RefType					dst		on dst.BK				= ds.BK_RefType_DataSourceType
	left join rep.vw_DataTypeMapping	dtm		on dtm.BK_RefType_DST	= dst.bk
	left join bld.vw_RefType			dt		on dt.bk				= dtm.BK_RefType_DataType

	-- DataSourceType zonder specifieke datatypemapping (generic)
	join GenericDataSourcetype			gdst	on 1=1
	left join rep.vw_DataTypeMapping	gdtm	on gdtm.BK_RefType_DST	= gdst.BK_RefType_DataSourceType and dtm.BK_RefType_DST is null
	left join bld.vw_RefType			gdt		on gdt.bk				= gdtm.BK_RefType_DataType


	-- Some schema's get a fixed datatype like staging
	left join FixedSchemaDataType		fd		on ss.bk				= fd.BK_Schema 

)
select distinct
	BK	=  src.BK_Schema+'|'+ DataTypeMapped+'|'+DataTypeInRep
	, Code = src.BK_Schema
	, src.BK_Schema
	, src.DataTypeMapped
	, src.DataTypeInRep
	, src.FixedSchemaDataType
	, src.OrgMappedDataType
	, src.DefaultValue

from DataTypeMapping src