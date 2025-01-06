



CREATE view [bld].[tr_300_TestRules_010_Datasets] as 

/* 
=== Comments =========================================

Description:
	builds up a test rules definition set 
	
Changelog:
Date		time		Author					Description
20230907	0012		K. Vermeij				Initial
20231031	1521		K.Siva				    Added new columns to the get_datasets,get_schemas,get_datasources
=======================================================
*/

  with all_testrules as (
  select 
	  BK_TestDefinition				= td.bk
	, code							= td.code
	, test							= td.test
	, ADFPipeline					= td.ADFPipeline
	, getattributes					= td.getattributes
	, BK_RefType_ObjectType_Target	= tr.BK_RefType_ObjectType_Target
	, BK_Datasource					= tr.BK_Datasource
	, BK_Schema						= tr.BK_Schema
	, BK_Dataset					= coalesce(tr.BK_DatasetSrc,tr.BK_datasetTrn)
	, BK_DatasetSrcAttribute		= tr.BK_DatasetSrcAttribute
	, ExpectedValue					= coalesce(tr.ExpectedValue,'')
	, TresholdValue					= coalesce(tr.TresholdValue,'')
	, tr.active
	
	, tr.BK_RefType_RepositoryStatus
  from rep.vw_TestDefinition td
  join rep.vw_TestRule tr	 on tr.BK_TestDefinition					= td.BK
  )
  , get_datasets as   (
	  select BK = concat(src.BK_TestDefinition,'|dataset|',d.BK,'|'+isnull( a.AttributeName,''))
		, src.Test
		, src.ADFPipeline
		, src.BK_RefType_RepositoryStatus
		, src.getattributes
		, bk_dataset = d.bk
		, ObjectType			= src.BK_RefType_ObjectType_Target
		, SpecificAttribute		= sa.AttributeName
		, AttributeName			= isnull( a.AttributeName,'')
		, src.ExpectedValue
		, src.TresholdValue
	  from all_testrules src
	  join bld.vw_dataset	d	on src.BK_Dataset							= d.BK		
										and src.BK_RefType_ObjectType_Target	= d.BK_RefType_ObjectType
										and src.BK_Schema						= d.BK_Schema
	left join bld.vw_Attribute a	on  src.getattributes =1 and a.BK_Dataset = d.BK
	left join bld.vw_Attribute sa	on  src.BK_DatasetSrcAttribute = sa.BK
									
	)									
, get_schemas as (
	select BK = concat(src.BK_TestDefinition,'|schema|',d.BK,'|'+isnull( a.AttributeName,''))
		, src.Test
		, src.ADFPipeline
		, src.BK_RefType_RepositoryStatus
		, src.getattributes
		, bk_dataset			= d.bk
		, ObjectType			= src.BK_RefType_ObjectType_Target
		, SpecificAttribute		= sa.AttributeName
		, AttributeName			= isnull( a.AttributeName,'')
		, src.ExpectedValue
		, src.TresholdValue
	  from all_testrules src
	 join bld.vw_dataset	d on d.BK_Schema						= src.BK_Schema
									and src.BK_Dataset is null
									and src.BK_RefType_ObjectType_Target = d.BK_RefType_ObjectType
	left join bld.vw_Attribute a	on  src.getattributes =1 and a.BK_Dataset = d.BK
	left join bld.vw_Attribute sa	on  src.BK_DatasetSrcAttribute = sa.BK
	left join get_datasets gd on d.bk = gd.bk_dataset and gd.test = src.test
	where gd.bk is null

					)
, get_datasources as (
	select BK = concat(src.BK_TestDefinition,'|source|',d.BK,'|'+isnull( a.AttributeName,''))
		, src.Test
		, src.ADFPipeline
		, src.BK_RefType_RepositoryStatus
		, src.getattributes
		, bk_dataset = d.bk
		, ObjectType			= src.BK_RefType_ObjectType_Target
		, SpecificAttribute		= sa.AttributeName
		, AttributeName			= isnull( a.AttributeName,'')
		, src.ExpectedValue
		, src.TresholdValue
	  from all_testrules src
	 join bld.vw_dataset	d on d.BK_DataSource						= src.BK_DataSource
								and src.BK_Dataset is null
									and src.BK_RefType_ObjectType_Target = d.BK_RefType_ObjectType
	 left join bld.vw_Attribute a	on  src.getattributes =1 and a.BK_Dataset = d.BK
	 left join bld.vw_Attribute sa	on  src.BK_DatasetSrcAttribute = sa.BK
	left join get_datasets gd on d.bk = gd.bk_dataset and gd.test = src.test
	left join get_schemas  gs on d.bk = gs.bk_dataset and gs.test = src.test
	where gd.bk is null and gs.bk is null
)
, all_datasets as (				
				select * from get_datasets
				union all
				select * from get_schemas
				union all
				select * from get_datasources
				)

, final as (
select 
	  BK							= src.bk
	, BK_Dataset					= src.BK_Dataset
	, BK_RefType_RepositoryStatus	= src.BK_RefType_RepositoryStatus
	, TestDefintion					= src.Test
	, ADFPipeline					= src.ADFPipeline
	, GetAttributes					= coalesce(src.GetAttributes,'')
	, TresholdValue					= src.TresholdValue
	, SpecificAttribute				= coalesce(src.SpecificAttribute,'')
	, AttributeName					= src.AttributeName
	, ExpectedValue					= concat(fp.filesystem,'\', fp.folder,'\', fp.FileMask)
from all_datasets src
join bld.vw_FileProperties fp		on fp.bk=  src.BK_Dataset
where src.test  = 'File not found'


union all									

select 
	  BK							= src.bk
	, BK_Dataset					= src.BK_Dataset
	, BK_RefType_RepositoryStatus	= src.BK_RefType_RepositoryStatus
	, TestDefintion					= src.Test
	, ADFPipeline					= src.ADFPipeline
	, GetAttributes					= coalesce(src.GetAttributes,'')
	, TresholdValue					= src.TresholdValue
	, SpecificAttribute				= coalesce(src.SpecificAttribute,'')
	, AttributeName					= src.AttributeName
	, ExpectedValue					= coalesce(fp.ExpectedFileSize, src.ExpectedValue, '0')
from all_datasets src
join bld.vw_FileProperties fp		on fp.bk=  src.BK_Dataset
where src.test  = 'File size less'


union all									

select 
	  BK							= src.bk
	, BK_Dataset					= src.BK_Dataset
	, BK_RefType_RepositoryStatus	= src.BK_RefType_RepositoryStatus
	, TestDefintion					= src.Test
	, ADFPipeline					= src.ADFPipeline
	, GetAttributes					= coalesce(src.GetAttributes,'')
	, TresholdValue					= src.TresholdValue
	, SpecificAttribute				= coalesce(src.SpecificAttribute,'')
	, AttributeName					= src.AttributeName
	, ExpectedValue					= coalesce(src.ExpectedValue,src.SpecificAttribute,'')
from all_datasets src
where src.test  = 'Date Mismatch in File'

union all									

select 
	  BK							= src.bk
	, BK_Dataset					= src.BK_Dataset
	, BK_RefType_RepositoryStatus	= src.BK_RefType_RepositoryStatus
	, TestDefintion					= src.Test
	, ADFPipeline					= src.ADFPipeline
	, GetAttributes					= coalesce(src.GetAttributes,'')
	, TresholdValue					= src.TresholdValue
	, SpecificAttribute				= coalesce(src.SpecificAttribute,'')
	, AttributeName					= src.AttributeName
	, ExpectedValue					= coalesce(src.ExpectedValue,'')
from all_datasets src
where src.test  = 'column Mismatch 1st'

)
select Code=bk, * from final
where 1=1
--and bk_dataset = 'SA_DWH|src_file||Billing|CareContracts|'
--and BK_Dataset = 'SA_DWH|src_file||Grafana|LWAP|'