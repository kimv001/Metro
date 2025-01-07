CREATE VIEW adf.vw_TGT_from_SRC_schedules AS
WITH 
schedule_all AS (
	SELECT 
		TGT_new = concat('schedule : ',s.BK)
		, s.ExcludeFromAllLevel
		, s.ExcludeFromAllOther
		, ts.*
	FROM bld.vw_Schedules s
	JOIN [adf].[vw_TGT_from_SRC_base] ts ON s.TargetToLoad = ts.TGT
	WHERE s.ScheduleType = 'DWH' -- All
)
, 
schedule_other AS (
	SELECT 
		TGT_new = concat('schedule : ',s.BK)
		, s.ExcludeFromAllLevel
		, s.ExcludeFromAllOther
		, ts.*
	FROM bld.vw_Schedules s
	JOIN [adf].[vw_TGT_from_SRC_base] ts ON s.TargetToLoad = ts.TGT
	WHERE s.ScheduleType != 'DWH' 
)
, 
final_schedules AS  (
-- all
	SELECT 
		s_a.* 
	FROM schedule_all s_a
	LEFT JOIN schedule_other s_o ON s_a.SRC_Dataset = s_o.SRC_Dataset AND s_a.Environment = s_o.Environment AND s_o.ExcludeFromAllLevel = 1 
	WHERE s_o.TGT_new IS  null

UNION ALL

-- other
	SELECT 
		s_a.* 
	FROM schedule_other s_a
	LEFT JOIN schedule_other s_o ON s_a.TGT!= s_o.TGT AND  s_a.SRC_Dataset = s_o.SRC_Dataset AND s_a.Environment = s_o.Environment AND s_o.ExcludeFromAllOther = 1 
	WHERE s_o.TGT_new IS  null

)
SELECT 
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
FROM final_schedules
--where TGT != 'All' and Environment = 'prd'