





create view [adf].[vw_TGT_from_SRC_schedules_old] as
With 
schedule_all as (
	select 
		TGT_new = concat('schedule : ',s.BK)
		, s.ExcludeFromAllLevel
		, s.ExcludeFromAllOther
		, s.ProcessSourceDependencies
		, ts.*
		, rn = row_number() over (partition by s.bk, ts.[SRC_BK_DataSet], ts.Environment order by [generation_number] asc)
	from bld.vw_Schedules s
	join [adf].[vw_TGT_from_SRC_base] ts on s.TargetToLoad = ts.TGT
	where s.ScheduleType = 'DWH' -- All
	and s.ProcessSourceDependencies = 1
)

, 
schedule_single_target as (
	select 
	
		TGT_new = concat('schedule : ',s.BK)
		, s.ExcludeFromAllLevel
		, s.ExcludeFromAllOther
		, s.ProcessSourceDependencies
		, ts.*
		, rn = row_number() over (partition by  s.bk, ts.[SRC_BK_DataSet], ts.Environment order by [generation_number] asc)
		-- select *
	from bld.vw_Schedules s
	join [adf].[vw_TGT_from_SRC_base] ts on s.TargetToLoad= ts.tgt
											and
											(
											(s.scheduletype = ts.dependencytype and s.TargetToLoad =   ts.src_dataset ) 
											or (s.scheduletype = ts.dependencytype	and s.TargetToLoad =   ts.src_group ) 
											or (s.scheduletype = ts.dependencytype 	and s.TargetToLoad =   ts.src_schema ) 
											or (s.scheduletype = ts.dependencytype 	and s.TargetToLoad =   concat(ts.src_layer,'-',ts.src_group) ) 
											or (s.scheduletype = ts.dependencytype	and s.TargetToLoad =   concat(ts.src_shortname,'-',ts.src_group,'-',ts.src_layer) ) 
											)
	where 1=1
	and s.ScheduleType != 'DWH' 
	--and s.ProcessSourceDependencies = 0 
	--and s.TargetToLoad= ts.tgt --!= 'fixed'
	--and ts.Environment = 'prd'

	--select * from  [adf].[vw_TGT_from_SRC_base]
	

)

, 
schedule_other as (
	select 
		TGT_new = concat('schedule : ',s.BK)
		, s.ExcludeFromAllLevel
		, s.ExcludeFromAllOther
		, s.ProcessSourceDependencies
		, ts.*
		, rn = row_number() over (partition by s.bk, ts.[SRC_BK_DataSet], ts.Environment order by [generation_number] asc)
	from bld.vw_Schedules s
	join [adf].[vw_TGT_from_SRC_base] ts on s.TargetToLoad = ts.TGT
	where s.ScheduleType != 'DWH' 
	--and s.ProcessSourceDependencies = 1 
	
)
, final_schedules as  (

-- all but no records with exclude from all
	select  
		s_a.* 
		, 'all' as schedules_type
	from schedule_all s_a
	left join schedule_other s_o on s_a.SRC_Dataset = s_o.SRC_Dataset and s_a.Environment = s_o.Environment and s_o.ExcludeFromAllLevel = 1 and s_o.ProcessSourceDependencies = 1
	where 1=1
	 and s_o.TGT_new is  null
	

union all

-- other
	select 
		s_a.* 
		, 'other' as schedules_type
	from schedule_other s_a
	join schedule_other s_o on s_a.TGT!= s_o.TGT and  s_a.SRC_Dataset = s_o.SRC_Dataset and s_a.Environment = s_o.Environment and s_o.ExcludeFromAllOther = 1 and s_o.ProcessSourceDependencies = 1
	left join schedule_other s_o_o on   s_o_o.SRC_Dataset = s_o.SRC_Dataset and s_o_o.Environment = s_o.Environment and s_o_o.ExcludeFromAllOther = 1 and s_o.ProcessSourceDependencies = 0
	where 1=1 
	and s_o.TGT_new is  null
	and s_o_o.SRC_Dataset is null
	--and s_o_o.tgt_new is null
	and s_a.[ProcessSourceDependencies] = 1
	

	union all

-- nochild dependencies
	select distinct 
		s_a.* 
		, 'no child' as schedules_type
		--, s_o.*
	from schedule_single_target s_a
	left join schedule_single_target st_o on s_a.TGT!= st_o.TGT and  s_a.SRC_Dataset = st_o.SRC_Dataset and s_a.Environment = st_o.Environment and st_o.ExcludeFromAllOther = 1 --and isnull(s_o.ExcludeFromAllOther,1) = 1
	--left join schedule_other s_o on s_a.TGT!= s_o.TGT and  s_a.SRC_Dataset = s_o.SRC_Dataset and s_a.Environment = s_o.Environment and s_o.ExcludeFromAllOther = 1
	--left join schedule_other s_o_o on s_a.TGT!= s_o_o.TGT and  s_a.SRC_Dataset = s_o_o.SRC_Dataset and s_a.Environment = s_o_o.Environment and s_o_o.ExcludeFromAllOther = 1
	where 1=1
	and st_o.TGT_new is  null
	--and s_o.TGT_new is  null
	
	--and (s_o.TGT_new is  null or s_o_o.tgt_new is  null)
	--and s_a.[ProcessSourceDependencies] = 1
	

)
select distinct

	TGT = TGT_new
	--, TGT_old = TGT
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
	, rn
	--, schedules_type

from final_schedules
where 1=1
and rn=1
--and TGT = 'All'
and Environment = 'prd'
--and (src_dataset = '[rpt].[Weas_AuraQuanticEua]' or src_dataset = '[rpt].[Zsmart_AanNemer]' or  src_dataset = '[rpt].[Weas_AannemerCcc]' or SRC_Dataset = '[dim].[Wholesale_Customer_History]' or SRC_Dataset like '%Fixed_InstalledBase_MDF_monthly%' or src_dataset = '[fct].[WBA_Publicatielijst]' or src_group = 'dirigent')
--and src_group = 'Wholesale'
--and SRC_Dataset = '[cds].[Fixed_InstalledBase_MDF]'
--and  tgt like '%Fixed_InstalledBase_ManagementLetter%'
 --and tgt like '%Fixed_InstalledBase_MDF_monthly%'
 --and SRC_Dataset like '%Fixed_InstalledBase_MDF_monthly%'

-- select * from  [adf].[vw_TGT_from_SRC_schedules] 
-- where 1=1
--and tgt_new = 'schedule : Process fixed tables from cds to fct|DAY0730||||Fixed||||Fixed'
--and  TGT_new like '%fixed%'
--and Environment = 'prd'
--order by  generation_number