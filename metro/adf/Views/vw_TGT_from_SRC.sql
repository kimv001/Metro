CREATE view [adf].[vw_TGT_from_SRC] as
with base as (
select
	TGT 
	, SRC_BK_DataSet
	, SRC_Dataset
	, SRC_ShortName
	, SRC_Group
	, SRC_Schema
	, SRC_Layer
	, [Source]
	, SRC_DatasetType
	, TGT_DatasetType
	, generation_number
	, DependencyType
	, RepositoryStatusName
	, RepositoryStatusCode
	, Environment
from [adf].[vw_TGT_from_SRC_base]

union all 

select
	TGT 
	, SRC_BK_DataSet
	, SRC_Dataset
	, SRC_ShortName
	, SRC_Group
	, SRC_Schema
	, SRC_Layer
	, [Source]
	, SRC_DatasetType
	, TGT_DatasetType
	, generation_number
	, DependencyType
	, RepositoryStatusName
	, RepositoryStatusCode
	, Environment
from [adf].[vw_TGT_from_SRC_schedules]
), final as (
select
	
	TGT							= cast(src.TGT					as varchar(1000))
	, SRC_BK_DataSet			= cast(src.SRC_BK_DataSet		as varchar(255))
	, SRC_Dataset				= cast(src.SRC_Dataset			as varchar(255))
	, SRC_ShortName				= cast(src.SRC_ShortName		as varchar(255))
	, SRC_Group					= cast(src.SRC_Group			as varchar(255))
	, SRC_Schema				= cast(src.SRC_Schema			as varchar(255))
	, SRC_Layer					= cast(src.SRC_Layer			as varchar(255))
	, [Source]					= cast(src.[Source]				as varchar(1000))
	, SRC_DatasetType			= cast(src.SRC_DatasetType		as varchar(255))
	, TGT_DatasetType			= cast(src.TGT_DatasetType		as varchar(255))
	, generation_number_old			= cast(src.generation_number	as bigint)
	, generation_number				= cast(
									case 
										when s.ProcessParallel = 1 then concat(d.FlowOrder,'00000') 
										else concat(d.FlowOrder,  right('00000'+cast(src.generation_number as varchar),5))
									end
									as bigint)

	, ProcessParallel			= cast(s.ProcessParallel		as varchar(255))
	, DependencyType			= cast(src.DependencyType		as varchar(255))
	, RepositoryStatusName		= cast(src.RepositoryStatusName	as varchar(255))
	, RepositoryStatusCode		= cast(src.RepositoryStatusCode	as varchar(255))
	, Environment				= cast(src.Environment			as varchar(255))
from base src
left join bld.vw_dataset	d on src.SRC_BK_DataSet = d.BK
left join bld.vw_schema		s on d.bk_schema = s.bk


)
select * from final
where 1=1
--and Environment = 'prd'
--and TGT = '[fct].[IB_ODF_monthly]'
--and TGT = '[fct].[IB_WEAS]'
--and TGT = '[dim].[Common_CustomerProduct]'
--and TGT = ' Percentiel-WAP-pub]'
--order by cast(d.FlowOrder as int) desc
--order by JobOrder desc
--order by JobOrder desc