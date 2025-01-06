create view adf.vw_TGT_from_SRC_schedules as
With 
schedule_all as (
	select 
		TGT_new = concat('schedule : ',s.BK)
		, s.ExcludeFromAllLevel
		, s.ExcludeFromAllOther
		, ts.*
	from bld.vw_Schedules s
	join [adf].[vw_TGT_from_SRC_base] ts on s.TargetToLoad = ts.TGT
	where s.ScheduleType = 'DWH' -- All
)
, 
schedule_other as (
	select 
		TGT_new = concat('schedule : ',s.BK)
		, s.ExcludeFromAllLevel
		, s.ExcludeFromAllOther
		, ts.*
	from bld.vw_Schedules s
	join [adf].[vw_TGT_from_SRC_base] ts on s.TargetToLoad = ts.TGT
	where s.ScheduleType != 'DWH' 
)
, 
final_schedules as  (
-- all
	select 
		s_a.* 
	from schedule_all s_a
	left join schedule_other s_o on s_a.SRC_Dataset = s_o.SRC_Dataset and s_a.Environment = s_o.Environment and s_o.ExcludeFromAllLevel = 1 
	where s_o.TGT_new is  null

union all

-- other
	select 
		s_a.* 
	from schedule_other s_a
	left join schedule_other s_o on s_a.TGT!= s_o.TGT and  s_a.SRC_Dataset = s_o.SRC_Dataset and s_a.Environment = s_o.Environment and s_o.ExcludeFromAllOther = 1 
	where s_o.TGT_new is  null

)
select 
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
from final_schedules
--where TGT != 'All' and Environment = 'prd'